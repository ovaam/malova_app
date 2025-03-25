//
//  PlanTestRouter.swift
//  malova_app
//
//  Created by Малова Олеся on 25.03.2025.
//

import UIKit

protocol PlanTestRoutingLogic {
    func routeToMain()
    func routeToPlanTest()
}

final class PlanTestRouter: PlanTestRoutingLogic {
    weak var view: UIViewController?
    
    func routeToMain() {
        let nextVC = MainAssembly.build()
        view?.navigationController?.pushViewController(nextVC, animated: true)
    }
    
    func routeToPlanTest() {
        let nextVC = PlanTestAssembly.build()
        view?.navigationController?.pushViewController(nextVC, animated: true)
    }
}
