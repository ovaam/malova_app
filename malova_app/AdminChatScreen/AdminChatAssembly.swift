//
//  AdminChatAssembly.swift
//  malova_app
//
//  Created by Малова Олеся on 05.03.2025.
//

import UIKit

enum AdminChatAssembly {
    static func build(chatId: String) -> UIViewController {
        let router: AdminChatRouter = AdminChatRouter()
        let presenter: AdminChatPresenter = AdminChatPresenter()
        let interactor: AdminChatInteractor = AdminChatInteractor(presenter: presenter)
        let viewController: AdminChatViewController = AdminChatViewController(
            router: router,
            interactor: interactor,
            chatId: chatId
        )
        
        router.view = viewController
        presenter.view = viewController
        
        return viewController
    }
}
