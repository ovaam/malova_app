//
//  LogInPresenter.swift
//  malova_app
//
//  Created by Малова Олеся on 04.02.2025.
//

import UIKit

protocol LogInPresentationLogic {
    typealias Model = LogInModel
    func presentStart(_ response: Model.Start.Response)
    // func present(_ response: Model..Response)
}

final class LogInPresenter: LogInPresentationLogic {
    // MARK: - Constants
    private enum Constants {
        
    }
    
    weak var view: LogInDisplayLogic?
    
    // MARK: - PresentationLogic
    func presentStart(_ response: Model.Start.Response) {
        view?.displayStart(Model.Start.ViewModel())
    }
}
