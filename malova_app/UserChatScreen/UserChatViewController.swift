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
    typealias Model = UserChatModel
    func displayStart(_ viewModel: Model.Start.ViewModel)
    // func display(_ viewModel: Model..ViewModel)
}

protocol UserChatAnalitics: AnyObject {
    typealias Model = UserChatModel
    func logStart(_ info: Model.Start.Info)
    // func log(_ viewModel: Model..Info)
}


final class UserChatViewController: UIViewController,
                                    UserChatDisplayLogic {
    // MARK: - Constants
    private enum Constants {
        static let fatalError: String = "init(coder:) has not been implemented"
        
        static let backgroundColor: UIColor = UIColor(hex: "EAEAEA") ?? UIColor()
        
        static let cellIdentifier: String = "MessageCell"
        
        static let tableViewHeight: Double = 80
        
        static let inputContainerHeight: Double = 80
        
        static let messageTextPlaceholder: String = "Введите сообщение..."
        static let messageTextLeft: Double = 16
        static let messageTextRight: Double = 100
        static let messageTextTop: Double = 8
        static let messageTextBottom: Double = 8
        
        static let sendButtonText: String = "Отправить"
        static let sendButtonBackgroundColor: UIColor = UIColor(hex: "647269") ?? UIColor()
        static let sendButtonTitleColor: UIColor = .white
        static let sendButtonCornerRaduis: Double = 8
        static let sendButtonRight: Double = 16
        static let sendButtonTop: Double = 8
        static let sendButtonBottom: Double = 8
        static let sendButtonWidth: Double = 80
        
        static let goBackButtonImage: UIImage = UIImage(systemName: "chevron.left") ?? UIImage()
        static let goBackButtonTintColor: UIColor = .black
        static let goBackButtonTop: Double = 16
        static let goBackButtonLeft: Double = 16
        
        static let viewAdminTitleBackgroundColor: UIColor = UIColor(hex: "DEE3E0") ?? UIColor()
        static let viewAdminTitleHeight: Double = 130
        
        static let adminTitleFont: UIFont = UIFont(name: "HelveticaNeue-Medium", size: 24) ?? UIFont()
        static let adminTitleTextColor: UIColor = .black
        static let adminTitleText: String = "Чат с администратором"
        static let adminTitleTop: Double = 16
        
        static let adminId: String = "fmNA1kJrmGUpuaaCuHaOTAVvPJ82" // реальный ID администратора (ovaam231323@mail.ru passwd: 231323)
        static let collectionNameChat: String = "chats"
        static let collectionNameMessages: String = "messages"
    }
    
    // MARK: - Fields
    private let router: UserChatRoutingLogic
    private let interactor: UserChatBusinessLogic
    
    private let db = Firestore.firestore()
    private var messages: [Message] = []
    private var chatId: String?
    private var inputContainerBottomConstraint: NSLayoutConstraint?
    
    private let goBackButton: UIButton = UIButton()
    private let tableView: UITableView = UITableView()
    private let messageTextField: UITextField = UITextField()
    private let adminTitle: UILabel = UILabel()
    private let viewAdminTitle: UIView = UIView()
    private let sendButton: UIButton = UIButton(type: .system)
    private let inputContainer: UIView = UIView()
    
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
        view.backgroundColor = Constants.backgroundColor
        interactor.loadStart(Model.Start.Request())
        
        setupUI()
        createOrLoadChat()
        
        // Скрываем клавиартуру при нажатии на экран
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
        setupAdminTitle()
        setupMessageInput()
        setupTableView()
        setupGoBackButton()
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
        sendButton.layer.cornerRadius = Constants.sendButtonCornerRaduis
        
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
    
    // MARK: - Create or Load Chat
    private func createOrLoadChat() {
        guard let userId = Auth.auth().currentUser?.uid else { return }
        let adminId = Constants.adminId
        chatId = "\(userId)_\(adminId)"
        
        // Проверяем, существует ли чат
        db.collection(Constants.collectionNameChat).document(chatId!).getDocument { snapshot, error in
            if let error = error {
                print("Ошибка загрузки чата: \(error.localizedDescription)")
                return
            }
            
            if snapshot?.exists == false {
                // Создаем новый чат, если он не существует
                self.db.collection(Constants.collectionNameChat).document(self.chatId!).setData([:]) { error in
                    if let error = error {
                        print("Ошибка создания чата: \(error.localizedDescription)")
                    } else {
                        self.loadMessages()
                    }
                }
            } else {
                self.loadMessages()
            }
        }
    }

    // MARK: - Load Messages
    private func loadMessages() {
        guard let chatId = chatId else { return }
        
        db.collection("chats").document(chatId).collection("messages")
            .order(by: "timestamp")
            .addSnapshotListener { snapshot, error in
                if let error = error {
                    print("Ошибка загрузки сообщений: \(error.localizedDescription)")
                    return
                }
                
                // Очищаем массив сообщений перед добавлением новых
                self.messages.removeAll()
                
                self.messages = snapshot?.documents.compactMap { document in
                    let data = document.data()
                    guard let senderId = data["senderId"] as? String,
                          let text = data["text"] as? String,
                          let timestamp = data["timestamp"] as? Timestamp else { return nil }
                    return Message(senderId: senderId, text: text, timestamp: timestamp.dateValue())
                } ?? []
                
                self.tableView.reloadData()
                self.scrollToBottom(animated: false)
            }
    }
    
    private func scrollToBottom(animated: Bool = true) {
        if messages.count > 0 {
            let indexPath = IndexPath(row: messages.count - 1, section: 0)
            tableView.scrollToRow(at: indexPath, at: .bottom, animated: animated)
        }
    }
    
    // MARK: - Actions
    @objc private func sendMessage() {
        guard let chatId = chatId,
              let text = messageTextField.text, !text.isEmpty,
              let senderId = Auth.auth().currentUser?.uid else { return }
        
        // Отключаем кнопку на время отправки
        sendButton.isEnabled = false
        
        let messageData: [String: Any] = [
            "senderId": senderId,
            "text": text,
            "timestamp": Timestamp(date: Date())
        ]
        
        db.collection("chats").document(chatId).collection("messages").addDocument(data: messageData) { error in
            // Включаем кнопку после завершения отправки
            self.sendButton.isEnabled = true
            
            if let error = error {
                print("Ошибка отправки сообщения: \(error.localizedDescription)")
            } else {
                self.messageTextField.text = ""
                
                // Добавляем новое сообщение в конец массива
                let newMessage = Message(senderId: senderId, text: text, timestamp: Date())
                
                // Проверяем, нет ли уже такого сообщения в массиве
                if !self.messages.contains(where: { $0.text == newMessage.text && $0.senderId == newMessage.senderId }) {
                    self.messages.append(newMessage)
                }
                
                // Обновляем таблицу и прокручиваем вниз
                self.tableView.reloadData()
                self.scrollToBottom(animated: true)
            }
        }
    }
    
    @objc private func hideKeyboard() {
        view.endEditing(true)
    }
    
    @objc
    private func backButtonTapped() {
        router.routeToMain()
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
        
    }
}

// MARK: - UITableViewDelegate, UITableViewDataSource
extension UserChatViewController: UITableViewDelegate, UITableViewDataSource {
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

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }

    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return Constants.tableViewHeight
    }
}
