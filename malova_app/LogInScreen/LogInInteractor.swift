//
//  LogInInteractor.swift
//  malova_app
//
//  Created by Малова Олеся on 04.02.2025.
//

import UIKit

protocol LogInBusinessLogic {
    typealias Model = LogInModel
    func loadStart(_ request: Model.Start.Request)
    // func load(_ request: Model..Request)
}


final class LogInInteractor: LogInBusinessLogic {
    // MARK: - Fields
    private let presenter: LogInPresentationLogic
    
    // MARK: - Lifecycle
    init(presenter: LogInPresentationLogic) {
        self.presenter = presenter
    }
    
    // MARK: - BusinessLogic
    func loadStart(_ request: Model.Start.Request) {
        presenter.presentStart(Model.Start.Response())
    }
}
