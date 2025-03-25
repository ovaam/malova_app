//
//  MainRouter.swift
//  malova_app
//
//  Created by Малова Олеся on 28.02.2025.
//

import UIKit

protocol MainRoutingLogic {
    func routeToProfile()
    func routeToProcedures()
    func routeToAppointment()
    func routeToFaceScan()
    func routeToAboutClinic()
    func routeToSettings()
}

final class MainRouter: MainRoutingLogic {
    weak var view: UIViewController?
    
    func routeToProfile() {
        let nextVC = ProfileAssembly.build()
        view?.navigationController?.pushViewController(nextVC, animated: true)
    }
    
    func routeToProcedures() {
        let nextVC = ProceduresAssembly.build()
        view?.navigationController?.pushViewController(nextVC, animated: true)
    }
    
    func routeToAppointment() {
        let nextVC = UserChatAssembly.build()
        view?.navigationController?.pushViewController(nextVC, animated: true)
    }
    
    func routeToFaceScan() {
//        if PlanTestViewController.isTestCompleted() {
//            let nextVC = FinalPlanViewController()
//            view?.navigationController?.pushViewController(nextVC, animated: true)
//        } else {
//            let nextVC = PlanTestAssembly.build()
//            view?.navigationController?.pushViewController(nextVC, animated: true)
//        }
        let nextVC = PlanTestAssembly.build()
        view?.navigationController?.pushViewController(nextVC, animated: true)
    }
    
    func routeToAboutClinic() {
        
    }
    
    func routeToSettings() {
        
    }
}
