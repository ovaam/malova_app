//
//  ProfileRouter.swift
//  malova_app
//
//  Created by Малова Олеся on 28.02.2025.
//

import UIKit

protocol ProfileRoutingLogic {
    func routeToSettings()
    func routeToMain()
}

final class ProfileRouter: ProfileRoutingLogic {
    weak var view: UIViewController?
    
    func routeToSettings() {
        
    }
    
    func routeToMain() {
        let nextVC = MainAssembly.build()
        view?.navigationController?.pushViewController(nextVC, animated: true)
    }
}
