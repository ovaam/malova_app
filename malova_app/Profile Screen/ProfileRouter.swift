//
//  ProfileRouter.swift
//  malova_app
//
//  Created by Малова Олеся on 28.02.2025.
//

import UIKit

protocol ProfileRoutingLogic {
    func routeToSettings()
    func routeToMain()
    func routeToAdminChatList()
    func routeToWelcomeScreen()
}

final class ProfileRouter: ProfileRoutingLogic {
    weak var view: UIViewController?
    
    func routeToSettings() {
        
    }
    
    func routeToMain() {
        let nextVC = MainAssembly.build()
        view?.navigationController?.pushViewController(nextVC, animated: true)
    }
    
    func routeToAdminChatList() {
        let nextVC = AdminChatListAssembly.build()
        view?.navigationController?.pushViewController(nextVC, animated: true)
    }
    
    func routeToWelcomeScreen() {
        let nextVC = WelcomeAssembly.build()
        view?.navigationController?.pushViewController(nextVC, animated: true)
    }
}
