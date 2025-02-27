//
//  LogInAssembly.swift
//  malova_app
//
//  Created by Малова Олеся on 28.02.2025.
//

import UIKit

enum LogInAssembly {
    static func build() -> UIViewController {
        let router: LogInRouter = LogInRouter()
        let presenter: LogInPresenter = LogInPresenter()
        let interactor: LogInInteractor = LogInInteractor(presenter: presenter)
        let viewController: LogInViewController = LogInViewController(
            router: router,
            interactor: interactor
        )
        
        router.view = viewController
        presenter.view = viewController
        
        return viewController
    }
}
