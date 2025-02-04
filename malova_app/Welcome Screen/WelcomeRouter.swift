//
//  WelcomeRouter.swift
//  clinic
//
//  Created by Малова Олеся on 24.01.2025.
//
import UIKit

protocol WelcomeRoutingLogic {
    func routeToNextScreen(currentVC: UIViewController)
}

class WelcomeRouter: UIViewController, WelcomeRoutingLogic {
    
    func routeToNextScreen(currentVC: UIViewController) {
        let nextVC = SingInViewController()
        navigationController?.pushViewController(nextVC, animated: true)
        //navigationController?.pushViewController(vc, animated: true)
        print("here it is")
    }
}

