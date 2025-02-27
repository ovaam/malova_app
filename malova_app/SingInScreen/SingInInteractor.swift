//
//  SingInIntercator.swift
//  clinic
//
//  Created by Малова Олеся on 24.01.2025.
//

//protocol SingInBusinessLogic {
//    func login(username: String, password: String)
//}
//
//class SingInInteractor: SingInBusinessLogic {
//    
//    var presenter: SingInPresentationLogic?
//    var worker: SingInWorker?
//    
//    func login(username: String, password: String) {
//        // Perform the login logic, possibly making a network request.
//        if username == "user" && password == "password" {
//            presenter?.presentSingInSuccess()
//        } else {
//            presenter?.presentSingInFailure(error: "Invalid credentials")
//        }
//    }
//}

import UIKit

protocol SingInBusinessLogic {
    typealias Model = SingInModel
    func loadStart(_ request: Model.Start.Request)
    // func load(_ request: Model..Request)
}


final class SingInInteractor: SingInBusinessLogic {
    // MARK: - Fields
    private let presenter: SingInPresentationLogic
    
    // MARK: - Lifecycle
    init(presenter: SingInPresentationLogic) {
        self.presenter = presenter
    }
    
    // MARK: - BusinessLogic
    func loadStart(_ request: Model.Start.Request) {
        presenter.presentStart(Model.Start.Response())
    }
}
