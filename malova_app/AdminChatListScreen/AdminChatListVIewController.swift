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


final class AdminChatListViewController: UIViewController, AdminChatListDisplayLogic {
    // MARK: - Constants
    private enum Constants {
        static let fatalError: String = "init(coder:) has not been implemented"
        
        static let whiteColor: UIColor = .white
        static let blackColor: UIColor = .black
        static let backgroundColor: UIColor = UIColor(hex: "EAEAEA") ?? UIColor()
        static let logoutButtonBackground: UIColor = UIColor(hex: "647269") ?? UIColor()
        
        static let titleText: String = "Чаты"
        static let backButtonImageName: String = "chevron.left"
        static let cellIdentifier: String = "cell"
        
        static let backButtonTopOffset: CGFloat = 16
        static let backButtonLeftOffset: CGFloat = 16
        
        static let chatsLoadError: String = "Ошибка загрузки чатов:"
        static let userLoadError: String = "Ошибка загрузки пользователя:"
        static let fullNameError: String = "Ошибка: поле fullName отсутствует у пользователя"
    }
    
    // MARK: - Fields
    private let router: AdminChatListRoutingLogic
    private let interactor: AdminChatListBusinessLogic
    
    private let db = Firestore.firestore()
    private var chats: [Chat] = []
    
    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: Constants.cellIdentifier)
        return tableView
    }()
    
    private let goBackButton: UIButton = UIButton()
    private let logoutButton: UIButton = UIButton()
    
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
        view.backgroundColor = Constants.backgroundColor
        interactor.loadStart(Model.Start.Request())
        //setupGoBackButton()
        setupLogoutButton()
        setupUI()
        loadChats()
    }
    
    // MARK: - Configuration
    private func setupUI() {
        //title = Constants.titleText
        
        // Добавляем таблицу
        view.addSubview(tableView)
        tableView.backgroundColor = Constants.backgroundColor
        tableView.pinTop(to: logoutButton.bottomAnchor)
        tableView.pinLeft(to: view.leadingAnchor)
        tableView.pinRight(to: view.trailingAnchor)
        tableView.pinBottom(to: view.bottomAnchor)
        
        // Настройка таблицы
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    private func setupGoBackButton() {
        goBackButton.setImage(UIImage(systemName: Constants.backButtonImageName), for: .normal)
        goBackButton.tintColor = Constants.blackColor
        
        view.addSubview(goBackButton)
        
        goBackButton.pinTop(to: view.safeAreaLayoutGuide.topAnchor, Constants.backButtonTopOffset)
        goBackButton.pinLeft(to: view.leadingAnchor, Constants.backButtonLeftOffset)
        
        goBackButton.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
    }
    
    private func setupLogoutButton() {
        logoutButton.setTitle("Выйти", for: .normal)
        logoutButton.titleLabel?.font = UIFont(name: "HelveticaNeue-Medium", size: 20)
        //logoutButton.tintColor = .red
        logoutButton.backgroundColor = Constants.logoutButtonBackground
        logoutButton.layer.cornerRadius = 15
        logoutButton.titleLabel?.textColor = .red
        logoutButton.addTarget(self, action: #selector(logoutButtonTapped), for: .touchUpInside)
        
        view.addSubview(logoutButton)
        
        logoutButton.pinTop(to: view.safeAreaLayoutGuide.topAnchor, 10)
        logoutButton.pinLeft(to: view.leadingAnchor, 10)
    }
    
    // MARK: - Load Chats
    private func loadChats() {
        db.collection("chats").getDocuments { snapshot, error in
            if let error = error {
                print("\(Constants.chatsLoadError) \(error.localizedDescription)")
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
                        print("\(Constants.userLoadError) \(userError.localizedDescription)")
                        dispatchGroup.leave()
                        return
                    }
                    
                    guard let userData = userSnapshot?.data(),
                          let fullName = userData["fullName"] as? String else {
                        print("\(Constants.fullNameError) \(userId)")
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
    private func openChat(chat: Chat) {
        router.routeToChat(chat: chat)
    }
    
    // MARK: - Actions
    @objc
    private func backButtonTapped() {
        router.routeToMain()
    }
    
    @objc
    private func logoutButtonTapped() {
        do {
            try Auth.auth().signOut()
            router.routeToWelcome()
        } catch let signOutError as NSError {
            print("Ошибка при выходе из аккаунта: \(signOutError.localizedDescription)")
        }
    }
    
    // MARK: - DisplayLogic
    func displayStart(_ viewModel: Model.Start.ViewModel) {
        // Обработка данных для отображения
    }
}

// MARK: - UITableViewDelegate, UITableViewDataSource
extension AdminChatListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return chats.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.cellIdentifier, for: indexPath)
        let chat = chats[indexPath.row]
        cell.textLabel?.text = chat.userFullName
        cell.backgroundColor = Constants.backgroundColor
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let chat = chats[indexPath.row]
        openChat(chat: chat)
    }
}
