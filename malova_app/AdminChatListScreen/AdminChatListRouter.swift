//
//  AdminChatListRouter.swift
//  malova_app
//
//  Created by Малова Олеся on 05.03.2025.
//

import UIKit

protocol AdminChatListRoutingLogic {
    func routeToMain()
    func routeToWelcome()
    func routeToChat(chatId: String)
}

final class AdminChatListRouter: AdminChatListRoutingLogic {
    weak var view: UIViewController?
    
    func routeToMain() {
        let nextVC = MainAssembly.build()
        view?.navigationController?.pushViewController(nextVC, animated: true)
    }
    
    func routeToWelcome() {
        let nextVC = WelcomeAssembly.build()
        view?.navigationController?.pushViewController(nextVC, animated: true)
    }
    
    func routeToChat(chatId: String) {
        let chatVC = AdminChatAssembly.build(chatId: chatId)
        view?.navigationController?.pushViewController(chatVC, animated: true)
    }
}
