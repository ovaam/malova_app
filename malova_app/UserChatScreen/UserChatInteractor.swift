//
//  ChatInteractor.swift
//  malova_app
//
//  Created by Малова Олеся on 05.03.2025.
//

import UIKit

protocol ChatBusinessLogic {
    typealias Model = ChatModel
    func loadStart(_ request: Model.Start.Request)
    // func load(_ request: Model..Request)
}


final class ChatInteractor: ChatBusinessLogic {
    // MARK: - Fields
    private let presenter: ChatPresentationLogic
    
    // MARK: - Lifecycle
    init(presenter: ChatPresentationLogic) {
        self.presenter = presenter
    }
    
    // MARK: - BusinessLogic
    func loadStart(_ request: Model.Start.Request) {
        presenter.presentStart(Model.Start.Response())
    }
}
