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


final class AdminChatViewController: UIViewController,
                                     AdminChatDisplayLogic {
    // MARK: - Constants
    private enum Constants {
        static let fatalError: String = "init(coder:) has not been implemented"
    }
    
    // MARK: - Fields
    private let router: AdminChatRoutingLogic
    private let interactor: AdminChatBusinessLogic
    private let chatId: String?
    
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
        chatId: String
    ) {
        self.router = router
        self.interactor = interactor
        self.chatId = chatId
        super.init(nibName: nil, bundle: nil)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError(Constants.fatalError)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(hex: "EAEAEA")
        interactor.loadStart(Model.Start.Request())
        setupUI()
        loadMessages()
        
        // Скрываем клавиартуру при нажатии на экран
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        view.addGestureRecognizer(tapGesture)
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
        tableView.backgroundColor = UIColor(hex: "EAEAEA")
        
        view.addSubview(tableView)
        tableView.backgroundColor = UIColor(hex: "EAEAEA")
        
        tableView.pinTop(to: viewAdminTitle.bottomAnchor)
        tableView.pinLeft(to: view.leadingAnchor)
        tableView.pinRight(to: view.trailingAnchor)
        tableView.pinBottom(to: inputContainer.topAnchor)
        
        // Регистрируем кастомную ячейку
        tableView.register(MessageCell.self, forCellReuseIdentifier: "AdminMessageCell")

        // Настройка таблицы
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.backgroundColor = UIColor(hex: "EAEAEA")

        // Настройка автоматической высоты ячеек
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 80 // Примерная высота ячейки
    }
    
    private func setupMessageInput() {
        inputContainer.backgroundColor = UIColor(hex: "EAEAEA")
        
        view.addSubview(inputContainer)
        
        inputContainer.pinLeft(to: view.leadingAnchor)
        inputContainer.pinRight(to: view.trailingAnchor)
        inputContainer.pinBottom(to: view.safeAreaLayoutGuide.bottomAnchor)
        inputContainer.setHeight(50)
        
        messageTextField.placeholder = "Введите сообщение..."
        messageTextField.borderStyle = .roundedRect

        inputContainer.addSubview(messageTextField)
        
        messageTextField.pinLeft(to: inputContainer.leadingAnchor, 16)
        messageTextField.pinTop(to: inputContainer.topAnchor, 8)
        messageTextField.pinBottom(to: inputContainer.bottomAnchor, 8)
        messageTextField.pinRight(to: inputContainer.trailingAnchor, 100)
        
        sendButton.setTitle("Отправить", for: .normal)
        sendButton.backgroundColor = UIColor(hex: "647269")
        sendButton.setTitleColor(.white, for: .normal)
        sendButton.layer.cornerRadius = 8
        
        inputContainer.addSubview(sendButton)
        
        sendButton.pinRight(to: inputContainer.trailingAnchor, 16)
        sendButton.pinTop(to: inputContainer.topAnchor, 8)
        sendButton.pinBottom(to: inputContainer.bottomAnchor, 8)
        sendButton.setWidth(80)

        sendButton.addTarget(self, action: #selector(sendMessage), for: .touchUpInside)
    }
    
    private func setupGoBackButton() {
        goBackButton.setImage(UIImage(systemName: "chevron.left"), for: .normal)
        goBackButton.tintColor = .black
        
        view.addSubview(goBackButton)
        
        goBackButton.pinTop(to: view.safeAreaLayoutGuide.topAnchor, 16)
        goBackButton.pinLeft(to: view.leadingAnchor, 16)
        
        goBackButton.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
    }
    
    private func setupAdminTitle() {
        viewAdminTitle.backgroundColor = UIColor(hex: "DEE3E0")
        
        view.addSubview(viewAdminTitle)
        
        viewAdminTitle.pinTop(to: view.topAnchor)
        viewAdminTitle.pinLeft(to: view.leadingAnchor)
        viewAdminTitle.pinRight(to: view.trailingAnchor)
        viewAdminTitle.setHeight(130)
        
        adminTitle.font = UIFont(name: "HelveticaNeue-Medium", size: 24)
        adminTitle.textColor = .black
        adminTitle.text = "Чат с пользователем"
        
        viewAdminTitle.addSubview(adminTitle)
        
        adminTitle.pinTop(to: viewAdminTitle.safeAreaLayoutGuide.topAnchor, 16)
        adminTitle.pinCenterX(to: viewAdminTitle.centerXAnchor)
    }
    
    private func loadMessages() {
        guard let chatId = chatId else { return }
        
        db.collection("chats").document(chatId).collection("messages")
            .order(by: "timestamp")
            .addSnapshotListener { snapshot, error in
                if let error = error {
                    print("Ошибка загрузки сообщений: \(error.localizedDescription)")
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
            print("Ошибка: администратор не аутентифицирован")
            showError(message: "Администратор не аутентифицирован")
            return
        }
        
        // Извлекаем senderId (ID администратора)
        let senderId = user.uid
        
        // Проверяем, что chatId и text не nil
        guard let chatId = chatId,
              let text = messageTextField.text, !text.isEmpty else {
            print("Ошибка: отсутствуют необходимые данные")
            showError(message: "Пожалуйста, введите сообщение")
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
                print("Ошибка отправки сообщения: \(error.localizedDescription)")
                self.showError(message: "Ошибка отправки сообщения")
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
    
    // MARK: - DisplayLogic
    func displayStart(_ viewModel: Model.Start.ViewModel) {
        
    }
}

// MARK: - UITableViewDelegate, UITableViewDataSource
extension AdminChatViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "AdminMessageCell", for: indexPath) as? MessageCell else {
            return UITableViewCell()
        }
        
        let message = messages[indexPath.row]
        print("Message: \(message.text)")
        let isCurrentUser = message.senderId == Auth.auth().currentUser?.uid
        cell.configure(with: message, isCurrentUser: isCurrentUser)
        
        return cell
    }
}
