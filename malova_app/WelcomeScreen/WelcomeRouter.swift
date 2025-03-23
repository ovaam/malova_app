//
//  WelcomeRouter.swift
//  clinic
//
//  Created by Малова Олеся on 24.01.2025.
//
import UIKit

protocol WelcomeRoutingLogic {
    func routeToSingIn()
    func routeToMain()
    func routeToAdminChatList()
}

final class WelcomeRouter: WelcomeRoutingLogic {
    weak var view: UIViewController?
    
    func routeToSingIn() {
        let nextVC = SingInAssembly.build()
        view?.navigationController?.pushViewController(nextVC, animated: true)
    }
    
    func routeToMain() {
        let nextVC = MainAssembly.build()
        view?.navigationController?.pushViewController(nextVC, animated: true)
    }
    
    func routeToAdminChatList() {
        let nextVC = AdminChatListAssembly.build()
        view?.navigationController?.pushViewController(nextVC, animated: true)
    }
}

