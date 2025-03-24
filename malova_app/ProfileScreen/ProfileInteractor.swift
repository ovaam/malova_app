//
//  ProfileInteractor.swift
//  malova_app
//
//  Created by Малова Олеся on 28.02.2025.
//

import UIKit

protocol ProfileBusinessLogic {
    typealias Model = ProfileModel
    func loadStart(_ request: Model.Start.Request)
    // func load(_ request: Model..Request)
}


final class ProfileInteractor: ProfileBusinessLogic {
    // MARK: - Fields
    private let presenter: ProfilePresentationLogic
    
    // MARK: - Lifecycle
    init(presenter: ProfilePresentationLogic) {
        self.presenter = presenter
    }
    
    // MARK: - BusinessLogic
    func loadStart(_ request: Model.Start.Request) {
        presenter.presentStart(Model.Start.Response())
    }
}
