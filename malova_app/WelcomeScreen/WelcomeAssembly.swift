//
//  Assembly.swift
//  malova_app
//
//  Created by Малова Олеся on 11.02.2025.
//

import UIKit

enum WelcomeAssembly {
    static func build() -> UIViewController {
        let router: WelcomeRouter = WelcomeRouter()
        let presenter: WelcomePresenter = WelcomePresenter()
        let interactor: WelcomeInteractor = WelcomeInteractor(presenter: presenter)
        let viewController: WelcomeViewController = WelcomeViewController(
            router: router,
            interactor: interactor
        )
        
        router.view = viewController
        presenter.view = viewController
        
        return viewController
    }
}
