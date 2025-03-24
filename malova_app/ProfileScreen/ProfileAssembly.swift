//
//  ProfileAssembly.swift
//  malova_app
//
//  Created by Малова Олеся on 28.02.2025.
//

import UIKit

enum ProfileAssembly {
    static func build() -> UIViewController {
        let router: ProfileRouter = ProfileRouter()
        let presenter: ProfilePresenter = ProfilePresenter()
        let interactor: ProfileInteractor = ProfileInteractor(presenter: presenter)
        let viewController: ProfileViewController = ProfileViewController(
            router: router,
            interactor: interactor
        )
        
        router.view = viewController
        presenter.view = viewController
        
        return viewController
    }
}
