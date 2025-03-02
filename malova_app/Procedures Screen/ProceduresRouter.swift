//
//  ProceduresRouter.swift
//  malova_app
//
//  Created by Малова Олеся on 02.03.2025.
//

import UIKit

protocol ProceduresRoutingLogic {
    func routeToMain()
}

final class ProceduresRouter: ProceduresRoutingLogic {
    weak var view: UIViewController?
    
    func routeToMain() {
        let nextVC = MainAssembly.build()
        view?.navigationController?.pushViewController(nextVC, animated: true)
    }
}
