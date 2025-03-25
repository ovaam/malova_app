//
//  PlanTestAssembly.swift
//  malova_app
//
//  Created by Малова Олеся on 25.03.2025.
//

import UIKit

enum PlanTestAssembly {
    static func build() -> UIViewController {
        let router: PlanTestRouter = PlanTestRouter()
        let presenter: PlanTestPresenter = PlanTestPresenter()
        let interactor: PlanTestInteractor = PlanTestInteractor(presenter: presenter)
        let viewController: PlanTestViewController = PlanTestViewController(
            router: router,
            interactor: interactor
        )
        
        router.view = viewController
        presenter.view = viewController
        
        return viewController
    }
}
