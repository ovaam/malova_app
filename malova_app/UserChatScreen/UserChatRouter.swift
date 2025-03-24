//
//  ChatRouter.swift
//  malova_app
//
//  Created by Малова Олеся on 05.03.2025.
//

import UIKit

protocol UserChatRoutingLogic {
    func routeToMain()
    func routeToCart()
}

final class UserChatRouter: UserChatRoutingLogic {
    weak var view: UIViewController?
    
    func routeToMain() {
        let nextVC = MainAssembly.build()
        view?.navigationController?.pushViewController(nextVC, animated: true)
    }
    
    func routeToCart() {
        let cartVC = CartViewController()
        
        cartVC.modalPresentationStyle = .overCurrentContext
        cartVC.modalTransitionStyle = .crossDissolve
        
        view?.present(cartVC, animated: true) {
            //self.updateAddCartButtonVisibility()
        }
    }
}
