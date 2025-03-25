//
//  PlanTestInteractor.swift
//  malova_app
//
//  Created by Малова Олеся on 25.03.2025.
//

import UIKit

protocol PlanTestBusinessLogic {
    typealias Model = PlanTestModel
    func loadStart(_ request: Model.Start.Request)
    // func load(_ request: Model..Request)
}


final class PlanTestInteractor: PlanTestBusinessLogic {
    // MARK: - Fields
    private let presenter: PlanTestPresentationLogic
    
    // MARK: - Lifecycle
    init(presenter: PlanTestPresentationLogic) {
        self.presenter = presenter
    }
    
    // MARK: - BusinessLogic
    func loadStart(_ request: Model.Start.Request) {
        presenter.presentStart(Model.Start.Response())
    }
}
