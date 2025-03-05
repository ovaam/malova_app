//
//  AdminChatListInteractor.swift
//  malova_app
//
//  Created by Малова Олеся on 05.03.2025.
//

import UIKit

protocol AdminChatListBusinessLogic {
    typealias Model = AdminChatListModel
    func loadStart(_ request: Model.Start.Request)
    // func load(_ request: Model..Request)
}


final class AdminChatListInteractor: AdminChatListBusinessLogic {
    // MARK: - Fields
    private let presenter: AdminChatListPresentationLogic
    
    // MARK: - Lifecycle
    init(presenter: AdminChatListPresentationLogic) {
        self.presenter = presenter
    }
    
    // MARK: - BusinessLogic
    func loadStart(_ request: Model.Start.Request) {
        presenter.presentStart(Model.Start.Response())
    }
}
