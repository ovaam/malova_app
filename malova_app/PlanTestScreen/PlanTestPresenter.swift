//
//  PlanTestPresenter.swift
//  malova_app
//
//  Created by Малова Олеся on 25.03.2025.
//

import UIKit

protocol PlanTestPresentationLogic {
    typealias Model = PlanTestModel
    func presentStart(_ response: Model.Start.Response)
    // func present(_ response: Model..Response)
}

final class PlanTestPresenter: PlanTestPresentationLogic {
    // MARK: - Constants
    private enum Constants {
        
    }
    
    weak var view: PlanTestDisplayLogic?
    
    // MARK: - PresentationLogic
    func presentStart(_ response: Model.Start.Response) {
        view?.displayStart(Model.Start.ViewModel())
    }
}
