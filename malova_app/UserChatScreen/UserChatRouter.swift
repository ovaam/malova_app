//
//  ChatRouter.swift
//  malova_app
//
//  Created by Малова Олеся on 05.03.2025.
//

import UIKit

protocol ChatRoutingLogic {
    func routeTo()
}

final class ChatRouter: ChatRoutingLogic {
    weak var view: UIViewController?
    
    func routeTo() {
        
    }
}
