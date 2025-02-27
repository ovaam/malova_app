//
//  ProfilePresenter.swift
//  malova_app
//
//  Created by Малова Олеся on 28.02.2025.
//

import UIKit

protocol ProfilePresentationLogic {
    typealias Model = ProfileModel
    func presentStart(_ response: Model.Start.Response)
    // func present(_ response: Model..Response)
}

final class ProfilePresenter: ProfilePresentationLogic {
    // MARK: - Constants
    private enum Constants {
        
    }
    
    weak var view: ProfileDisplayLogic?
    
    // MARK: - PresentationLogic
    func presentStart(_ response: Model.Start.Response) {
        view?.displayStart(Model.Start.ViewModel())
    }
}
