//
//  SettingsAssembly.swift
//  malova_app
//
//  Created by Малова Олеся on 28.02.2025.
//

import UIKit

enum SettingsAssembly {
    static func build() -> UIViewController {
        let router: SettingsRouter = SettingsRouter()
        let presenter: SettingsPresenter = SettingsPresenter()
        let interactor: SettingsInteractor = SettingsInteractor(presenter: presenter)
        let viewController: SettingsViewController = SettingsViewController(
            router: router,
            interactor: interactor
        )
        
        router.view = viewController
        presenter.view = viewController
        
        return viewController
    }
}
