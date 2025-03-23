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
    func routeToChat(chat: Chat)
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
    
    func routeToChat(chat: Chat) {
        let chatVC = AdminChatAssembly.build(chat: chat)
        view?.navigationController?.pushViewController(chatVC, animated: true)
    }
}
