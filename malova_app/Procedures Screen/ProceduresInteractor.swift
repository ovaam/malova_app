//
//  ProceduresInteractor.swift
//  malova_app
//
//  Created by Малова Олеся on 02.03.2025.
//

import UIKit

protocol ProceduresBusinessLogic {
    typealias Model = ProceduresModel
    func loadStart(_ request: Model.Start.Request)
    // func load(_ request: Model..Request)
}


final class ProceduresInteractor: ProceduresBusinessLogic {
    // MARK: - Fields
    private let presenter: ProceduresPresentationLogic
    
    // MARK: - Lifecycle
    init(presenter: ProceduresPresentationLogic) {
        self.presenter = presenter
    }
    
    // MARK: - BusinessLogic
    func loadStart(_ request: Model.Start.Request) {
        presenter.presentStart(Model.Start.Response())
    }
}
