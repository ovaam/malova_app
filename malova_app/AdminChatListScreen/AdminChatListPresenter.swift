//
//  AdminChatListPresenter.swift
//  malova_app
//
//  Created by Малова Олеся on 05.03.2025.
//

import UIKit

protocol AdminChatListPresentationLogic {
    typealias Model = AdminChatListModel
    func presentStart(_ response: Model.Start.Response)
    // func present(_ response: Model..Response)
}

final class AdminChatListPresenter: AdminChatListPresentationLogic {
    // MARK: - Constants
    private enum Constants {
        
    }
    
    weak var view: AdminChatListDisplayLogic?
    
    // MARK: - PresentationLogic
    func presentStart(_ response: Model.Start.Response) {
        view?.displayStart(Model.Start.ViewModel())
    }
}
