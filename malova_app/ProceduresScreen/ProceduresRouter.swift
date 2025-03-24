//
//  ProceduresRouter.swift
//  malova_app
//
//  Created by Малова Олеся on 02.03.2025.
//

import UIKit

protocol ProceduresRoutingLogic {
    func routeToMain()
    func routeToCart()
    func routeToProcedureDetail(procedure: Procedure)
}

final class ProceduresRouter: ProceduresRoutingLogic {
    weak var view: UIViewController?
    
    func routeToMain() {
        let nextVC = MainAssembly.build()
        view?.navigationController?.pushViewController(nextVC, animated: true)
    }
    
    func routeToCart() {
        let cartVC = CartViewController()
        
        cartVC.modalPresentationStyle = .overCurrentContext
        cartVC.modalTransitionStyle = .crossDissolve
        
        view?.present(cartVC, animated: true, completion: nil)
    }
    
    func routeToProcedureDetail(procedure: Procedure) {
        let detailVC = DetailAboutProcedureViewController()
        detailVC.procedure = procedure
        detailVC.modalPresentationStyle = .overCurrentContext
        detailVC.modalTransitionStyle = .crossDissolve
        view?.present(detailVC, animated: true)
    }
}
