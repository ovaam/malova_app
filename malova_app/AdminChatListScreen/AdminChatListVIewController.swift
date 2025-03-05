//
//  AdminChatListVIewController.swift
//  malova_app
//
//  Created by Малова Олеся on 05.03.2025.
//

import UIKit
import FirebaseFirestore
import FirebaseAuth

protocol AdminChatListDisplayLogic: AnyObject {
    typealias Model = AdminChatListModel
    func displayStart(_ viewModel: Model.Start.ViewModel)
    // func display(_ viewModel: Model..ViewModel)
}

protocol AdminChatListAnalitics: AnyObject {
    typealias Model = AdminChatListModel
    func logStart(_ info: Model.Start.Info)
    // func log(_ viewModel: Model..Info)
}


final class AdminChatListViewController: UIViewController,
                                         AdminChatListDisplayLogic {
    // MARK: - Constants
    private enum Constants {
        static let fatalError: String = "init(coder:) has not been implemented"
    }
    
    // MARK: - Fields
    private let router: AdminChatListRoutingLogic
    private let interactor: AdminChatListBusinessLogic
    
    private let db = Firestore.firestore()
        private var chats: [Chat] = []

    // MARK: - UI Elements
    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        return tableView
    }()

    
    // MARK: - LifeCycle
    init(
        router: AdminChatListRoutingLogic,
        interactor: AdminChatListBusinessLogic
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
        interactor.loadStart(Model.Start.Request())
        setupUI()
        loadChats()
    }
    
    // MARK: - Configuration
    private func setupUI() {
        view.backgroundColor = .white
        title = "Чаты"
        
        // Добавляем таблицу
        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.pinTop(to: view.safeAreaLayoutGuide.topAnchor)
        tableView.pinLeft(to: view.leadingAnchor)
        tableView.pinRight(to: view.trailingAnchor)
        tableView.pinBottom(to: view.bottomAnchor)
        
        // Настройка таблицы
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    // MARK: - Load Chats
    private func loadChats() {
        db.collection("chats").getDocuments { snapshot, error in
            if let error = error {
                print("Ошибка загрузки чатов: \(error.localizedDescription)")
                return
            }
            
            guard let documents = snapshot?.documents else { return }
            
            // Загружаем чаты и ФИО пользователей
            self.chats.removeAll()
            let dispatchGroup = DispatchGroup()
            
            for document in documents {
                let chatId = document.documentID
                let userId = chatId.components(separatedBy: "_").first ?? "" // Извлекаем userId из chatId
                
                dispatchGroup.enter()
                
                // Загружаем ФИО пользователя из коллекции users
                self.db.collection("users").document(userId).getDocument { userSnapshot, userError in
                    if let userError = userError {
                        print("Ошибка загрузки пользователя: \(userError.localizedDescription)")
                        dispatchGroup.leave()
                        return
                    }
                    
                    guard let userData = userSnapshot?.data(),
                          let fullName = userData["fullName"] as? String else {
                        print("Ошибка: поле fullName отсутствует у пользователя \(userId)")
                        dispatchGroup.leave()
                        return
                    }
                    
                    // Создаем объект чата с ФИО пользователя
                    let chat = Chat(chatId: chatId, userId: userId, userFullName: fullName)
                    self.chats.append(chat)
                    dispatchGroup.leave()
                }
            }
            
            // Обновляем таблицу после загрузки всех данных
            dispatchGroup.notify(queue: .main) {
                self.tableView.reloadData()
            }
        }
    }

        // MARK: - Open Chat
    private func openChat(chatId: String) {
        let chatVC = AdminChatAssembly.build(chatId: chatId)
        navigationController?.pushViewController(chatVC, animated: true)
    }
    
    // MARK: - Actions
    @objc
    private func wasTapped() {
        
    }
    
    // MARK: - DisplayLogic
    func displayStart(_ viewModel: Model.Start.ViewModel) {
        
    }
}

extension AdminChatListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return chats.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let chat = chats[indexPath.row]
        cell.textLabel?.text = chat.userFullName // Отображаем ФИО пользователя
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let chat = chats[indexPath.row]
        openChat(chatId: chat.chatId)
    }
}

