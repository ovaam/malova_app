//
//  AdminChatViewController.swift
//  malova_app
//
//  Created by Малова Олеся on 05.03.2025.
//

import UIKit
import FirebaseFirestore
import FirebaseAuth

protocol AdminChatDisplayLogic: AnyObject {
    typealias Model = AdminChatModel
    func displayStart(_ viewModel: Model.Start.ViewModel)
    // func display(_ viewModel: Model..ViewModel)
}

protocol AdminChatAnalitics: AnyObject {
    typealias Model = AdminChatModel
    func logStart(_ info: Model.Start.Info)
    // func log(_ viewModel: Model..Info)
}


final class AdminChatViewController: UIViewController, AdminChatDisplayLogic {
    // MARK: - Constants
    private enum Constants {
        static let fatalError: String = "init(coder:) has not been implemented"
        
        static let backgroundColor: UIColor = UIColor(hex: "EAEAEA") ?? UIColor()
        static let sendButtonBackgroundColor: UIColor = UIColor(hex: "647269") ?? UIColor()
        static let sendButtonTitleColor: UIColor = .white
        static let goBackButtonTintColor: UIColor = .black
        static let viewAdminTitleBackgroundColor: UIColor = UIColor(hex: "DEE3E0") ?? UIColor()
        static let adminTitleTextColor: UIColor = .black
        
        static let cellIdentifier: String = "AdminMessageCell"
        static let messageTextPlaceholder: String = "Введите сообщение..."
        static let sendButtonText: String = "Отправить"
        
        static let adminTitleFont: UIFont = UIFont(name: "HelveticaNeue-Medium", size: 24) ?? UIFont()
        
        static let goBackButtonImage: UIImage = UIImage(systemName: "chevron.left") ?? UIImage()
        
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
        static let viewAdminTitleHeight: Double = 130
        static let adminTitleTop: Double = 16
        
        static let authError: String = "Ошибка: администратор не аутентифицирован"
        static let messageSendError: String = "Ошибка отправки сообщения"
        static let messagesLoadError: String = "Ошибка загрузки сообщений"
        static let emptyMessageError: String = "Пожалуйста, введите сообщение"
    }
    
    // MARK: - Fields
    private let router: AdminChatRoutingLogic
    private let interactor: AdminChatBusinessLogic
    private let chat: Chat?
    private var inputContainerBottomConstraint: NSLayoutConstraint?
    
    private let db = Firestore.firestore()
    private var messages: [Message] = []

    // MARK: - UI Elements
    private let goBackButton: UIButton = UIButton()
    private let tableView: UITableView = UITableView()
    private let messageTextField: UITextField = UITextField()
    private let adminTitle: UILabel = UILabel()
    private let viewAdminTitle: UIView = UIView()
    private let sendButton: UIButton = UIButton(type: .system)
    private let inputContainer: UIView = UIView()
    
    // MARK: - LifeCycle
    init(
        router: AdminChatRoutingLogic,
        interactor: AdminChatBusinessLogic,
        chat: Chat
    ) {
        self.router = router
        self.interactor = interactor
        self.chat = chat
        super.init(nibName: nil, bundle: nil)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError(Constants.fatalError)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = Constants.backgroundColor
        interactor.loadStart(Model.Start.Request())
        setupUI()
        loadMessages()
        
        // Скрываем клавиатуру при нажатии на экран
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        view.addGestureRecognizer(tapGesture)
        
        // Подписываемся на уведомления о клавиатуре
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
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    // MARK: - Configuration
    private func setupUI() {
        setupAdminViewTitle()
        setupGoBackButton()
        setupAdminTitle()
        setupMessageInput()
        setupTableView()
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
        
        // Регистрируем кастомную ячейку
        tableView.register(MessageCell.self, forCellReuseIdentifier: Constants.cellIdentifier)

        // Настройка таблицы
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.backgroundColor = Constants.backgroundColor

        // Настройка автоматической высоты ячеек
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 80 // Примерная высота ячейки
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
    
    private func setupAdminViewTitle() {
        viewAdminTitle.backgroundColor = Constants.viewAdminTitleBackgroundColor
        
        view.addSubview(viewAdminTitle)
        
        viewAdminTitle.pinTop(to: view.topAnchor)
        viewAdminTitle.pinLeft(to: view.leadingAnchor)
        viewAdminTitle.pinRight(to: view.trailingAnchor)
    }
    
    private func setupAdminTitle() {
        adminTitle.font = Constants.adminTitleFont
        adminTitle.textColor = Constants.adminTitleTextColor
        adminTitle.text = chat?.userFullName
        adminTitle.textAlignment = .center
        adminTitle.numberOfLines = 0
        
        viewAdminTitle.addSubview(adminTitle)
        
        adminTitle.pinTop(to: viewAdminTitle.safeAreaLayoutGuide.topAnchor, Constants.adminTitleTop)
        adminTitle.pinLeft(to: goBackButton.trailingAnchor, 5)
        adminTitle.pinRight(to: viewAdminTitle.trailingAnchor, 15)
        
        viewAdminTitle.pinBottom(to: adminTitle.bottomAnchor, -10)
        
    }
    
    // MARK: - Load Messages
    private func loadMessages() {
        guard let chatId = chat?.chatId else { return }
        
        db.collection("chats").document(chatId).collection("messages")
            .order(by: "timestamp")
            .addSnapshotListener { snapshot, error in
                if let error = error {
                    print("\(Constants.messagesLoadError): \(error.localizedDescription)")
                    return
                }
                
                self.messages = snapshot?.documents.compactMap { document in
                    let data = document.data()
                    guard let senderId = data["senderId"] as? String,
                          let text = data["text"] as? String,
                          let timestamp = data["timestamp"] as? Timestamp else { return nil }
                    return Message(senderId: senderId, text: text, timestamp: timestamp.dateValue())
                } ?? []
                
                self.tableView.reloadData()
                self.scrollToBottom()
            }
    }
    
    private func scrollToBottom() {
        if messages.count > 0 {
            let indexPath = IndexPath(row: messages.count - 1, section: 0)
            tableView.scrollToRow(at: indexPath, at: .bottom, animated: true)
        }
    }
    
    private func showError(message: String) {
        let alert = UIAlertController(title: "Ошибка", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    // MARK: - Actions
    @objc private func sendMessage() {
        // Проверяем, аутентифицирован ли администратор
        guard let user = Auth.auth().currentUser else {
            print(Constants.authError)
            showError(message: Constants.authError)
            return
        }
        
        // Извлекаем senderId (ID администратора)
        let senderId = user.uid
        
        // Проверяем, что chatId и text не nil
        guard let chatId = chat?.chatId,
              let text = messageTextField.text, !text.isEmpty else {
            print(Constants.emptyMessageError)
            showError(message: Constants.emptyMessageError)
            return
        }
        
        // Создаем данные сообщения
        let messageData: [String: Any] = [
            "senderId": senderId,
            "text": text,
            "timestamp": Timestamp(date: Date())
        ]
        
        // Отправляем сообщение в Firestore
        db.collection("chats").document(chatId).collection("messages").addDocument(data: messageData) { error in
            if let error = error {
                print("\(Constants.messageSendError): \(error.localizedDescription)")
                self.showError(message: Constants.messageSendError)
            } else {
                self.messageTextField.text = "" // Очищаем поле ввода
            }
        }
    }
    
    @objc
    private func backButtonTapped() {
        router.routeToAdminChatList()
    }
    
    @objc private func hideKeyboard() {
        view.endEditing(true)
    }
    
    @objc private func keyboardWillShow(_ notification: Notification) {
        // Получаем информацию о клавиатуре
        guard let userInfo = notification.userInfo,
              let keyboardFrame = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect,
              let animationDuration = userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as? TimeInterval else {
            return
        }
        
        // Высота клавиатуры
        let keyboardHeight = keyboardFrame.height
        
        // Обновляем констрейнт inputContainer
        inputContainerBottomConstraint?.constant = -keyboardHeight + view.safeAreaInsets.bottom
        
        // Анимация изменения констрейнта
        UIView.animate(withDuration: animationDuration) {
            self.view.layoutIfNeeded()
        }
    }
    
    @objc private func keyboardWillHide(_ notification: Notification) {
        // Получаем информацию о клавиатуре
        guard let userInfo = notification.userInfo,
              let animationDuration = userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as? TimeInterval else {
            return
        }
        
        // Возвращаем констрейнт inputContainer в исходное положение
        inputContainerBottomConstraint?.constant = 0
        
        // Анимация изменения констрейнта
        UIView.animate(withDuration: animationDuration) {
            self.view.layoutIfNeeded()
        }
    }
    
    // MARK: - DisplayLogic
    func displayStart(_ viewModel: Model.Start.ViewModel) {
        // Обработка данных для отображения
    }
}

// MARK: - UITableViewDelegate, UITableViewDataSource
extension AdminChatViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: Constants.cellIdentifier, for: indexPath) as? MessageCell else {
            return UITableViewCell()
        }
        
        let message = messages[indexPath.row]
        print("Message: \(message.text)")
        let isCurrentUser = message.senderId == Auth.auth().currentUser?.uid
        cell.configure(with: message, isCurrentUser: isCurrentUser)
        
        return cell
    }
}
