//
//  AdminChatInteractor.swift
//  malova_app
//
//  Created by Малова Олеся on 05.03.2025.
//

import UIKit

protocol AdminChatBusinessLogic {
    typealias Model = AdminChatModel
    func loadStart(_ request: Model.Start.Request)
    // func load(_ request: Model..Request)
}


final class AdminChatInteractor: AdminChatBusinessLogic {
    // MARK: - Fields
    private let presenter: AdminChatPresentationLogic
    
    // MARK: - Lifecycle
    init(presenter: AdminChatPresentationLogic) {
        self.presenter = presenter
    }
    
    // MARK: - BusinessLogic
    func loadStart(_ request: Model.Start.Request) {
        presenter.presentStart(Model.Start.Response())
    }
}
