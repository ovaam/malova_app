//
//  ChatPresenter.swift
//  malova_app
//
//  Created by Малова Олеся on 05.03.2025.
//

import UIKit

protocol UserChatPresentationLogic {
    typealias Model = UserChatModel
    func presentStart(_ response: Model.Start.Response)
    // func present(_ response: Model..Response)
}

final class UserChatPresenter: UserChatPresentationLogic {
    // MARK: - Constants
    private enum Constants {
        
    }
    
    weak var view: UserChatDisplayLogic?
    
    // MARK: - PresentationLogic
    func presentStart(_ response: Model.Start.Response) {
        view?.displayStart(Model.Start.ViewModel())
    }
}
