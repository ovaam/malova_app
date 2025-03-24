//
//  ProceduresPresenter.swift
//  malova_app
//
//  Created by Малова Олеся on 02.03.2025.
//

import UIKit

protocol ProceduresPresentationLogic {
    func presentProcedures(response: ProceduresModel.LoadProcedures.Response)
    func presentFilteredProcedures(response: ProceduresModel.FilterProcedures.Response)
    func presentError(error: Error)
}

final class ProceduresPresenter: ProceduresPresentationLogic {
    weak var view: ProceduresDisplayLogic?
    
    // MARK: - PresentationLogic
    func presentProcedures(response: ProceduresModel.LoadProcedures.Response) {
        let viewModel = ProceduresModel.LoadProcedures.ViewModel(categories: response.categories)
        view?.displayProcedures(viewModel: viewModel)
    }
        
    func presentFilteredProcedures(response: ProceduresModel.FilterProcedures.Response) {
        let viewModel = ProceduresModel.FilterProcedures.ViewModel(filteredCategories: response.filteredCategories)
        view?.displayFilteredProcedures(viewModel: viewModel)
    }
        
    func presentError(error: Error) {
        view?.displayError(message: error.localizedDescription)
    }
}
