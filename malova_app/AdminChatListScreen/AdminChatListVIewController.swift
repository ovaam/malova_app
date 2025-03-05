//
//  AdminChatListVIewController.swift
//  malova_app
//
//  Created by Малова Олеся on 05.03.2025.
//

import UIKit

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
            
            self.chats = snapshot?.documents.compactMap { document in
                let chatId = document.documentID
                return Chat(chatId: chatId)
            } ?? []
            
            self.tableView.reloadData()
        }
    }

        // MARK: - Open Chat
    private func openChat(chatId: String) {
        let chatVC = AdminChatAssembly.build()
        //chatVC.chatId = chatId
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

