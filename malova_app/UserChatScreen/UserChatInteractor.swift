//
//  ChatInteractor.swift
//  malova_app
//
//  Created by Малова Олеся on 05.03.2025.
//

import UIKit

protocol UserChatBusinessLogic {
    typealias Model = UserChatModel
    func loadStart(_ request: Model.Start.Request)
    // func load(_ request: Model..Request)
}


final class UserChatInteractor: UserChatBusinessLogic {
    // MARK: - Fields
    private let presenter: UserChatPresentationLogic
    
    // MARK: - Lifecycle
    init(presenter: UserChatPresentationLogic) {
        self.presenter = presenter
    }
    
    // MARK: - BusinessLogic
    func loadStart(_ request: Model.Start.Request) {
        presenter.presentStart(Model.Start.Response())
    }
}
