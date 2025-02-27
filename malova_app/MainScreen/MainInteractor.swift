//
//  MainInteractor.swift
//  malova_app
//
//  Created by Малова Олеся on 28.02.2025.
//

import UIKit

protocol MainBusinessLogic {
    typealias Model = MainModel
    func loadStart(_ request: Model.Start.Request)
    // func load(_ request: Model..Request)
}


final class MainInteractor: MainBusinessLogic {
    // MARK: - Fields
    private let presenter: MainPresentationLogic
    
    // MARK: - Lifecycle
    init(presenter: MainPresentationLogic) {
        self.presenter = presenter
    }
    
    // MARK: - BusinessLogic
    func loadStart(_ request: Model.Start.Request) {
        presenter.presentStart(Model.Start.Response())
    }
}
