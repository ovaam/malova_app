//
//  SettingsPresenter.swift
//  malova_app
//
//  Created by Малова Олеся on 28.02.2025.
//

import UIKit

protocol SettingsPresentationLogic {
    typealias Model = SettingsModel
    func presentStart(_ response: Model.Start.Response)
    // func present(_ response: Model..Response)
}

final class SettingsPresenter: SettingsPresentationLogic {
    // MARK: - Constants
    private enum Constants {
        
    }
    
    weak var view: SettingsDisplayLogic?
    
    // MARK: - PresentationLogic
    func presentStart(_ response: Model.Start.Response) {
        view?.displayStart(Model.Start.ViewModel())
    }
}
