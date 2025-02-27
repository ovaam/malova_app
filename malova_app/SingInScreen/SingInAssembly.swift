//
//  SingInAssembly.swift
//  malova_app
//
//  Created by Малова Олеся on 22.02.2025.
//

import UIKit

enum SingInAssembly {
    static func build() -> UIViewController {
        let router: SingInRouter = SingInRouter()
        let presenter: SingInPresenter = SingInPresenter()
        let interactor: SingInInteractor = SingInInteractor(presenter: presenter)
        let viewController: SingInViewController = SingInViewController(
            router: router,
            interactor: interactor
        )
        
        router.view = viewController
        presenter.view = viewController
        
        return viewController
    }
}
