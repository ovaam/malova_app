//
//  ProceduresPresenter.swift
//  malova_app
//
//  Created by Малова Олеся on 02.03.2025.
//

import UIKit

protocol ProceduresPresentationLogic {
    typealias Model = ProceduresModel
    func presentStart(_ response: Model.Start.Response)
    // func present(_ response: Model..Response)
}

final class ProceduresPresenter: ProceduresPresentationLogic {
    // MARK: - Constants
    private enum Constants {
        
    }
    
    weak var view: ProceduresDisplayLogic?
    
    // MARK: - PresentationLogic
    func presentStart(_ response: Model.Start.Response) {
        view?.displayStart(Model.Start.ViewModel())
    }
}
