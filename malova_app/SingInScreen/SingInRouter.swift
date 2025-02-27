//
//  SingInRouter.swift
//  clinic
//
//  Created by Малова Олеся on 24.01.2025.
//
//import UIKit
//
//protocol SingInRoutingLogic {
//    func navigateToHome()
//    func navigateToRegistration()
//}
//
//protocol SingInDataPassing {
//    var dataStore: SingInDataStore? { get }
//}
//
//class SingInRouter: SingInRoutingLogic, SingInDataPassing {
//    
//    weak var viewController: UIViewController?
//    var dataStore: SingInDataStore?
//    
//    func navigateToHome() {
//        // Push to the home screen or next screen after successful login
//        //let mainVC = MainViewController()
//        //viewController?.navigationController?.pushViewController(homeVC, animated: true)
//    }
//    
//    func navigateToRegistration() {
//        // Navigate to registration screen
//        let loginVC = LogInViewController()
//        viewController?.navigationController?.pushViewController(loginVC, animated: true)
//    }
//}
import UIKit

protocol SingInRoutingLogic {
    func routeToMain()
    func routeToRegistration()
}

final class SingInRouter: SingInRoutingLogic {
    weak var view: UIViewController?
    
    func routeToMain() {
        let nextVC = MainAssembly.build()
        view?.navigationController?.pushViewController(nextVC, animated: true)
    }
    
    func routeToRegistration() {
        let nextVC = LogInAssembly.build()
        view?.navigationController?.pushViewController(nextVC, animated: true)
    }
}
