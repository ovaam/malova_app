//
//  SingInIntercator.swift
//  clinic
//
//  Created by Малова Олеся on 24.01.2025.
//

protocol SingInBusinessLogic {
    func login(username: String, password: String)
}

class SingInInteractor: SingInBusinessLogic {
    
    var presenter: SingInPresentationLogic?
    var worker: SingInWorker?
    
    func login(username: String, password: String) {
        // Perform the login logic, possibly making a network request.
        if username == "user" && password == "password" {
            presenter?.presentSingInSuccess()
        } else {
            presenter?.presentSingInFailure(error: "Invalid credentials")
        }
    }
}
