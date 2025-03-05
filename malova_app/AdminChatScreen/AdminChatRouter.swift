//
//  AdminChatRouter.swift
//  malova_app
//
//  Created by Малова Олеся on 05.03.2025.
//

import UIKit

protocol AdminChatRoutingLogic {
    func routeToAdminChatList()
}

final class AdminChatRouter: AdminChatRoutingLogic {
    weak var view: UIViewController?
    
    func routeToAdminChatList() {
        let nextVC = AdminChatListAssembly.build()
        view?.navigationController?.pushViewController(nextVC, animated: true)
    }
}
