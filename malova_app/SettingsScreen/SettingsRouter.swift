//
//  SettingsRouter.swift
//  malova_app
//
//  Created by Малова Олеся on 28.02.2025.
//

import UIKit

protocol SettingsRoutingLogic {
    func routeToProfile()
    func routeToWelcome()
}

final class SettingsRouter: SettingsRoutingLogic {
    weak var view: UIViewController?
    
    func routeToProfile() {
        let nextVC = ProfileAssembly.build()
        view?.navigationController?.pushViewController(nextVC, animated: true)
    }
    
    func routeToWelcome() {
        let nextVC = WelcomeAssembly.build()
        view?.navigationController?.pushViewController(nextVC, animated: true)
    }
}
