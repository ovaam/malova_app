//
//  SingInPresenter.swift
//  clinic
//
//  Created by Малова Олеся on 24.01.2025.
//

import Foundation

protocol SingInPresentationLogic {
    func presentSingInSuccess()
    func presentSingInFailure(error: String)
}

class SingInPresenter: SingInPresentationLogic {
    
    weak var viewController: SingInDisplayLogic?
    
    func presentSingInSuccess() {
        viewController?.displaySingInSuccess()
    }
    
    func presentSingInFailure(error: String) {
        viewController?.displaySingInFailure(error: error)
    }
}
