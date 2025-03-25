//
//  ChatViewController.swift
//  malova_app
//
//  Created by Малова Олеся on 05.03.2025.
//

import UIKit
import FirebaseFirestore
import FirebaseAuth

protocol UserChatDisplayLogic: AnyObject {
    func displayMessages(viewModel: UserChatModel.LoadMessages.ViewModel)
    func displayMessageSent()
    func displayChatCreated(viewModel: UserChatModel.CreateChat.ViewModel)
    func updateInputContainer(for keyboardHeight: CGFloat, duration: TimeInterval)
    func displayError(message: String)
    func resetInputContainer(duration: TimeInterval)
}


final class UserChatViewController: UIViewController, UserChatDisplayLogic {
    // MARK: - Constants
    private enum Constants {
        static let fatalError: String = "init(coder:) has not been implemented"
        
        static let backgroundColor: UIColor = UIColor(hex: "EAEAEA") ?? UIColor()
        static let sendButtonBackgroundColor: UIColor = UIColor(hex: "647269") ?? UIColor()
        static let sendButtonTitleColor: UIColor = .white
        static let goBackButtonTintColor: UIColor = .black
        static let viewAdminTitleBackgroundColor: UIColor = UIColor(hex: "DEE3E0") ?? UIColor()
        static let adminTitleTextColor: UIColor = .black
        static let addCartButtonColor: UIColor = UIColor(hex: "647269")?.withAlphaComponent(0.3) ?? UIColor()
        static let addCartButtonTextColor: UIColor = .white
        static let dateColor: UIColor = .lightGray
        
        static let cellIdentifier: String = "MessageCell"
        static let messageTextPlaceholder: String = "Введите сообщение..."
        static let sendButtonText: String = "Отправить"
        static let adminTitleText: String = "Чат с администратором"
        static let addCardButtonTitle: String = " записаться на выбранные процедуры "
        static let messageText: String = "Могу ли я записаться на следующие процедуры: "
        static let dateFormat: String = "d MMMM yyyy"
        
        static let adminTitleFont: UIFont = UIFont(name: "HelveticaNeue-Medium", size: 24) ?? UIFont()
        static let addCartButtonFont: UIFont = UIFont(name: "HelveticaNeue-Medium", size: 12) ?? UIFont()
        static let dateFormatFont: UIFont = UIFont.systemFont(ofSize: 14)
        
        static let goBackButtonImage: UIImage = UIImage(systemName: "chevron.left") ?? UIImage()
        static let cardButtonImage: UIImage = UIImage(named: "CartIcon") ?? UIImage()

        static let tableViewHeight: Double = 80
        static let inputContainerHeight: Double = 50
        static let messageTextLeft: Double = 16
        static let messageTextRight: Double = 100
        static let messageTextTop: Double = 8
        static let messageTextBottom: Double = 8
        static let sendButtonCornerRadius: Double = 8
        static let sendButtonRight: Double = 16
        static let sendButtonTop: Double = 8
        static let sendButtonBottom: Double = 8
        static let sendButtonWidth: Double = 80
        static let goBackButtonTop: Double = 16
        static let goBackButtonLeft: Double = 16
        static let viewAdminTitleHeight: Double = 150
        static let adminTitleTop: Double = 16
        static let cardButtonTop: Double = 5
        static let cardButtonRight: Double = 20
        static let cardButtonWidth: Double = 30
        static let cardButtonHeight: Double = 30
        static let addCartButtonCorner: Double = 10
        static let addCartButtonTop: Double = 10
        static let addCartButtonRight: Double = 20
        static let addCartButtonHeight: Double = 20
        
        static let adminId: String = "fmNA1kJrmGUpuaaCuHaOTAVvPJ82" // реальный ID администратора (ovaam231323@mail.ru passwd: 231323)
        static let collectionNameChat: String = "chats"
        static let collectionNameMessages: String = "messages"
        
        static let chatLoadError: String = "Ошибка загрузки чата:"
        static let chatCreateError: String = "Ошибка создания чата:"
        static let messagesLoadError: String = "Ошибка загрузки сообщений:"
        static let messageSendError: String = "Ошибка отправки сообщения:"
    }
    
    // MARK: - Fields
    private let router: UserChatRoutingLogic
    private let interactor: UserChatBusinessLogic
    
    private let db = Firestore.firestore()
    private var messages: [Message] = []
    private var chatId: String?
    private var inputContainerBottomConstraint: NSLayoutConstraint?
    private var messageGroups: [MessageGroup] = []
    private var cartObservation: NSKeyValueObservation?
    
    private let goBackButton: UIButton = UIButton()
    private let tableView: UITableView = UITableView(frame: .zero, style: .plain)
    private let messageTextField: UITextField = UITextField()
    private let adminTitle: UILabel = UILabel()
    private let viewAdminTitle: UIView = UIView()
    private let sendButton: UIButton = UIButton(type: .system)
    private let inputContainer: UIView = UIView()
    private let cartButton: UIButton = UIButton()
    private let addCartProceduresButton: UIButton = UIButton()
    
    // MARK: - LifeCycle
    init(
        router: UserChatRoutingLogic,
        interactor: UserChatBusinessLogic
    ) {
        self.router = router
        self.interactor = interactor
        super.init(nibName: nil, bundle: nil)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError(Constants.fatalError)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupKeyboardObservers()
        loadInitialData()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    // MARK: - Configuration
    private func setupUI() {
        view.backgroundColor = Constants.backgroundColor
        
        setupAdminTitle()
        setupMessageInput()
        setupTableView()
        setupGoBackButton()
        setupCartButton()
        setupAddCartProceduresButton()
    }
    
    private func setupTableView() {
        tableView.separatorStyle = .none
        tableView.backgroundColor = Constants.backgroundColor
        
        view.addSubview(tableView)
        tableView.backgroundColor = Constants.backgroundColor
        
        tableView.pinTop(to: viewAdminTitle.bottomAnchor)
        tableView.pinLeft(to: view.leadingAnchor)
        tableView.pinRight(to: view.trailingAnchor)
        tableView.pinBottom(to: inputContainer.topAnchor)
        
        tableView.register(MessageCell.self, forCellReuseIdentifier: Constants.cellIdentifier)

        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.backgroundColor = Constants.backgroundColor

        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = Constants.tableViewHeight
    }
    
    private func setupMessageInput() {
        inputContainer.backgroundColor = Constants.backgroundColor
        
        view.addSubview(inputContainer)
        
        // Сохраняем нижний констрейнт
        inputContainerBottomConstraint = inputContainer.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        inputContainerBottomConstraint?.isActive = true
        
        inputContainer.pinLeft(to: view.leadingAnchor)
        inputContainer.pinRight(to: view.trailingAnchor)
        inputContainer.pinBottom(to: view.safeAreaLayoutGuide.bottomAnchor)
        inputContainer.setHeight(Constants.inputContainerHeight)
        
        messageTextField.placeholder = Constants.messageTextPlaceholder
        messageTextField.borderStyle = .roundedRect

        inputContainer.addSubview(messageTextField)
        
        messageTextField.pinLeft(to: inputContainer.leadingAnchor, Constants.messageTextLeft)
        messageTextField.pinTop(to: inputContainer.topAnchor, Constants.messageTextTop)
        messageTextField.pinBottom(to: inputContainer.bottomAnchor, Constants.messageTextBottom)
        messageTextField.pinRight(to: inputContainer.trailingAnchor, Constants.messageTextRight)
        
        sendButton.setTitle(Constants.sendButtonText, for: .normal)
        sendButton.backgroundColor = Constants.sendButtonBackgroundColor
        sendButton.setTitleColor(Constants.sendButtonTitleColor, for: .normal)
        sendButton.layer.cornerRadius = Constants.sendButtonCornerRadius
        
        inputContainer.addSubview(sendButton)
        
        sendButton.pinRight(to: inputContainer.trailingAnchor, Constants.sendButtonRight)
        sendButton.pinTop(to: inputContainer.topAnchor, Constants.sendButtonTop)
        sendButton.pinBottom(to: inputContainer.bottomAnchor, Constants.sendButtonBottom)
        sendButton.setWidth(Constants.sendButtonWidth)

        sendButton.addTarget(self, action: #selector(sendMessage), for: .touchUpInside)
    }
    
    private func setupGoBackButton() {
        goBackButton.setImage(Constants.goBackButtonImage, for: .normal)
        goBackButton.tintColor = Constants.goBackButtonTintColor
        
        view.addSubview(goBackButton)
        
        goBackButton.pinTop(to: view.safeAreaLayoutGuide.topAnchor, Constants.goBackButtonTop)
        goBackButton.pinLeft(to: view.leadingAnchor, Constants.goBackButtonLeft)
        
        goBackButton.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
    }
    
    private func setupAdminTitle() {
        viewAdminTitle.backgroundColor = Constants.viewAdminTitleBackgroundColor
        
        view.addSubview(viewAdminTitle)
        
        viewAdminTitle.pinTop(to: view.topAnchor)
        viewAdminTitle.pinLeft(to: view.leadingAnchor)
        viewAdminTitle.pinRight(to: view.trailingAnchor)
        viewAdminTitle.setHeight(Constants.viewAdminTitleHeight)
        
        adminTitle.font = Constants.adminTitleFont
        adminTitle.textColor = Constants.adminTitleTextColor
        adminTitle.text = Constants.adminTitleText
        
        viewAdminTitle.addSubview(adminTitle)
        
        adminTitle.pinTop(to: viewAdminTitle.safeAreaLayoutGuide.topAnchor, Constants.adminTitleTop)
        adminTitle.pinCenterX(to: viewAdminTitle.centerXAnchor)
    }
    
    private func setupCartButton() {
        cartButton.setImage(Constants.cardButtonImage, for: .normal)
        
        view.addSubview(cartButton)
        
        cartButton.pinTop(to: adminTitle.bottomAnchor, Constants.cardButtonTop)
        cartButton.pinRight(to: view.trailingAnchor, Constants.cardButtonRight)
        cartButton.setWidth(Constants.cardButtonWidth)
        cartButton.setHeight(Constants.cardButtonHeight)
        
        cartButton.addTarget(self, action: #selector(cartButtonTapped), for: .touchUpInside)
    }
    
    private func setupAddCartProceduresButton() {
        addCartProceduresButton.setTitle(Constants.addCardButtonTitle, for: .normal)
        addCartProceduresButton.backgroundColor = Constants.addCartButtonColor
        addCartProceduresButton.layer.cornerRadius = Constants.addCartButtonCorner
        addCartProceduresButton.titleLabel?.textColor = Constants.addCartButtonTextColor
        addCartProceduresButton.titleLabel?.font = Constants.addCartButtonFont
        
        view.addSubview(addCartProceduresButton)
        
        addCartProceduresButton.pinTop(to: adminTitle.bottomAnchor, Constants.addCartButtonTop)
        addCartProceduresButton.pinRight(to: cartButton.leadingAnchor, Constants.addCartButtonRight)
        addCartProceduresButton.setHeight(Constants.addCartButtonHeight)
        
        addCartProceduresButton.addTarget(self, action: #selector(addCartProceduresButtonTapped), for: .touchUpInside)
    }
    
    private func setupKeyboardObservers() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillShow(_:)),
            name: UIResponder.keyboardWillShowNotification,
            object: nil
        )
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillHide(_:)),
            name: UIResponder.keyboardWillHideNotification,
            object: nil
        )
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        view.addGestureRecognizer(tapGesture)
    }
        
    private func loadInitialData() {
        guard let userId = Auth.auth().currentUser?.uid else { return }
        
        let request = UserChatModel.CreateChat.Request(
            userId: userId,
            adminId: Constants.adminId
        )
        interactor.createOrLoadChat(request: request)
    }
    
    private func scrollToBottom(animated: Bool = true) {
        let lastSection = messageGroups.count - 1
        guard lastSection >= 0 else { return }
      
        let numberOfRows = messageGroups[lastSection].messages.count
        
        guard numberOfRows > 0 else { return }
        
        let lastRow = numberOfRows - 1
        let indexPath = IndexPath(row: lastRow, section: lastSection)
        
        tableView.scrollToRow(at: indexPath, at: .bottom, animated: animated)
    }
    
    // MARK: - Actions
    @objc private func sendMessage() {
        guard let chatId = chatId,
              let text = messageTextField.text, !text.isEmpty,
              let senderId = Auth.auth().currentUser?.uid else { return }
        
        let request = UserChatModel.SendMessage.Request(
            chatId: chatId,
            text: text,
            senderId: senderId
        )
        interactor.sendMessage(request: request)
    }
    
    @objc private func hideKeyboard() {
        view.endEditing(true)
    }
    
    @objc private func backButtonTapped() {
        router.routeToMain()
    }
    
    @objc private func cartButtonTapped() {
        router.routeToCart()
    }
    
    @objc private func addCartProceduresButtonTapped() {
        guard !Cart.shared.procedures.isEmpty else { return }
        
        var messageText = Constants.messageText
        messageText += Cart.shared.procedures.map { $0.name }.joined(separator: ", ")
        
        messageTextField.text = messageText
        sendMessage()
        Cart.shared.clearCart()
    }
    
    @objc private func keyboardWillShow(_ notification: Notification) {
        guard let userInfo = notification.userInfo,
              let keyboardFrame = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect,
              let duration = userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as? TimeInterval else { return }
        
        updateInputContainer(for: keyboardFrame.height, duration: duration)
    }
        
    @objc private func keyboardWillHide(_ notification: Notification) {
        guard let userInfo = notification.userInfo,
              let duration = userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as? TimeInterval else { return }
        
        resetInputContainer(duration: duration)
    }
    
    // MARK: - DisplayLogic
    func displayMessages(viewModel: UserChatModel.LoadMessages.ViewModel) {
        messageGroups = viewModel.messageGroups
        tableView.reloadData()
        scrollToBottom()
    }
        
    func displayMessageSent() {
        messageTextField.text = ""
    }
        
    func displayChatCreated(viewModel: UserChatModel.CreateChat.ViewModel) {
        chatId = viewModel.chatId
        let request = UserChatModel.LoadMessages.Request(chatId: viewModel.chatId)
        interactor.loadMessages(request: request)
    }
        
    func displayError(message: String) {
        print(message)
    }
        
    func updateInputContainer(for keyboardHeight: CGFloat, duration: TimeInterval) {
        inputContainerBottomConstraint?.constant = -keyboardHeight + view.safeAreaInsets.bottom
        UIView.animate(withDuration: duration) {
            self.view.layoutIfNeeded()
        }
    }
        
    func resetInputContainer(duration: TimeInterval) {
        inputContainerBottomConstraint?.constant = 0
        UIView.animate(withDuration: duration) {
            self.view.layoutIfNeeded()
        }
    }
}

// MARK: - UITableViewDelegate, UITableViewDataSource
extension UserChatViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return messageGroups.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messageGroups[section].messages.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: Constants.cellIdentifier, for: indexPath) as? MessageCell else {
            return UITableViewCell()
        }
        
        let message = messageGroups[indexPath.section].messages[indexPath.row]
        let isCurrentUser = message.senderId == Auth.auth().currentUser?.uid
        cell.configure(with: message, isCurrentUser: isCurrentUser)
        
        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }

    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return Constants.tableViewHeight
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView()
        headerView.backgroundColor = .clear
        
        let dateLabel = UILabel()
        dateLabel.font = Constants.dateFormatFont
        dateLabel.textColor = Constants.dateColor
        dateLabel.textAlignment = .center
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = Constants.dateFormat
        dateLabel.text = dateFormatter.string(from: messageGroups[section].date)
        
        headerView.addSubview(dateLabel)
        
        dateLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            dateLabel.centerXAnchor.constraint(equalTo: headerView.centerXAnchor),
            dateLabel.centerYAnchor.constraint(equalTo: headerView.centerYAnchor)
        ])
        
        return headerView
    }
}
