//
//  ChatAssembly.swift
//  malova_app
//
//  Created by Малова Олеся on 05.03.2025.
//

import UIKit

enum ChatAssembly {
    static func build() -> UIViewController {
        let router: ChatRouter = ChatRouter()
        let presenter: ChatPresenter = ChatPresenter()
        let interactor: ChatInteractor = ChatInteractor(presenter: presenter)
        let viewController: ChatViewController = ChatViewController(
            router: router,
            interactor: interactor
        )
        
        router.view = viewController
        presenter.view = viewController
        
        return viewController
    }
}
