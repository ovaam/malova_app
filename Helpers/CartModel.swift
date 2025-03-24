//
//  CartModel.swift
//  malova_app
//
//  Created by Малова Олеся on 24.03.2025.
//
import UIKit

class Cart: NSObject {
    static let shared = Cart() // Тот самый случай с полезностью синглтона
    var procedures: [Procedure] = []
    
    func addProcedure(_ procedure: Procedure) {
        procedures.append(procedure)
    }
    
    func removeProcedure(at index: Int) {
        procedures.remove(at: index)
    }
    
    func clearCart() {
        procedures.removeAll()
    }
}
