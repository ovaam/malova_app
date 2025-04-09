//
//  LogInRouter.swift
//  malova_app
//
//  Created by Малова Олеся on 04.02.2025.
//

import UIKit

protocol LogInRoutingLogic {
    func routeToMain()
    func routeToSingIn()
}

final class LogInRouter: LogInRoutingLogic {
    weak var view: UIViewController?
    
    func routeToMain() {
        let nextVC = MainAssembly.build()
        view?.navigationController?.pushViewController(nextVC, animated: true)
    }
    
    func routeToSingIn() {
        let nextVC = SingInAssembly.build()
        view?.navigationController?.pushViewController(nextVC, animated: true)
    }
}
