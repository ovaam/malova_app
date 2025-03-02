//
//  ProceduresAssembly.swift
//  malova_app
//
//  Created by Малова Олеся on 02.03.2025.
//

import UIKit

enum ProceduresAssembly {
    static func build() -> UIViewController {
        let router: ProceduresRouter = ProceduresRouter()
        let presenter: ProceduresPresenter = ProceduresPresenter()
        let interactor: ProceduresInteractor = ProceduresInteractor(presenter: presenter)
        let viewController: ProceduresViewController = ProceduresViewController(
            router: router,
            interactor: interactor
        )
        
        router.view = viewController
        presenter.view = viewController
        
        return viewController
    }
}
