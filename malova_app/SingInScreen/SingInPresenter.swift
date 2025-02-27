//
//  SingInPresenter.swift
//  clinic
//
//  Created by Малова Олеся on 24.01.2025.
//

//import Foundation

//protocol SingInPresentationLogic {
//    func presentStart(_ response: Model.Start.Response)
//    //func presentSingInSuccess()
//    //func presentSingInFailure(error: String)
//}

//class SingInPresenter: SingInPresentationLogic {
//    
//    weak var viewController: SingInDisplayLogic?
//    
//    func presentSingInSuccess() {
//        viewController?.displaySingInSuccess()
//    }
//    
//    func presentSingInFailure(error: String) {
//        viewController?.displaySingInFailure(error: error)
//    }
//}
import UIKit

protocol SingInPresentationLogic {
    typealias Model = SingInModel
    func presentStart(_ response: Model.Start.Response)
    // func present(_ response: Model..Response)
}

final class SingInPresenter: SingInPresentationLogic {
    // MARK: - Constants
    private enum Constants {
        
    }
    
    weak var view: SingInDisplayLogic?
    
    // MARK: - PresentationLogic
    func presentStart(_ response: Model.Start.Response) {
        view?.displayStart(Model.Start.ViewModel())
    }
}
