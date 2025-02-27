//
//  MainAssembly.swift
//  malova_app
//
//  Created by Малова Олеся on 28.02.2025.
//

import UIKit

enum MainAssembly {
    static func build() -> UIViewController {
        let router: MainRouter = MainRouter()
        let presenter: MainPresenter = MainPresenter()
        let interactor: MainInteractor = MainInteractor(presenter: presenter)
        let viewController: MainViewController = MainViewController(
            router: router,
            interactor: interactor
        )
        
        router.view = viewController
        presenter.view = viewController
        
        return viewController
    }
}
