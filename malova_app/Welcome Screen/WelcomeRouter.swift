//
//  WelcomeRouter.swift
//  clinic
//
//  Created by Малова Олеся on 24.01.2025.
//
import UIKit

protocol WelcomeRoutingLogic {
    func routeToSingIn()
}

final class WelcomeRouter: WelcomeRoutingLogic {
    weak var view: UIViewController?
    
    func routeToSingIn() {
        let nextVC = SingInViewController()
        view?.navigationController?.pushViewController(nextVC, animated: true)
    }
}

