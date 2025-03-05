//
//  ChatAssembly.swift
//  malova_app
//
//  Created by Малова Олеся on 05.03.2025.
//

import UIKit

enum UserChatAssembly {
    static func build() -> UIViewController {
        let router: UserChatRouter = UserChatRouter()
        let presenter: UserChatPresenter = UserChatPresenter()
        let interactor: UserChatInteractor = UserChatInteractor(presenter: presenter)
        let viewController: UserChatViewController = UserChatViewController(
            router: router,
            interactor: interactor
        )
        
        router.view = viewController
        presenter.view = viewController
        
        return viewController
    }
}
