//
//  AdminChatPresenter.swift
//  malova_app
//
//  Created by Малова Олеся on 05.03.2025.
//

import UIKit

protocol AdminChatPresentationLogic {
    typealias Model = AdminChatModel
    func presentStart(_ response: Model.Start.Response)
    // func present(_ response: Model..Response)
}

final class AdminChatPresenter: AdminChatPresentationLogic {
    // MARK: - Constants
    private enum Constants {
        
    }
    
    weak var view: AdminChatDisplayLogic?
    
    // MARK: - PresentationLogic
    func presentStart(_ response: Model.Start.Response) {
        view?.displayStart(Model.Start.ViewModel())
    }
}
