//
//  AdminChatListAssembly.swift
//  malova_app
//
//  Created by Малова Олеся on 05.03.2025.
//

import UIKit

enum AdminChatListAssembly {
    static func build() -> UIViewController {
        let router: AdminChatListRouter = AdminChatListRouter()
        let presenter: AdminChatListPresenter = AdminChatListPresenter()
        let interactor: AdminChatListInteractor = AdminChatListInteractor(presenter: presenter)
        let viewController: AdminChatListViewController = AdminChatListViewController(
            router: router,
            interactor: interactor
        )
        
        router.view = viewController
        presenter.view = viewController
        
        return viewController
    }
}
