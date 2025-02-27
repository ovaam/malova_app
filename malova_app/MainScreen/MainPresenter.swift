//
//  MainPresenter.swift
//  malova_app
//
//  Created by Малова Олеся on 28.02.2025.
//

import UIKit

protocol MainPresentationLogic {
    typealias Model = MainModel
    func presentStart(_ response: Model.Start.Response)
    // func present(_ response: Model..Response)
}

final class MainPresenter: MainPresentationLogic {
    // MARK: - Constants
    private enum Constants {
        
    }
    
    weak var view: MainDisplayLogic?
    
    // MARK: - PresentationLogic
    func presentStart(_ response: Model.Start.Response) {
        view?.displayStart(Model.Start.ViewModel())
    }
}
