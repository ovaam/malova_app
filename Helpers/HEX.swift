//
//  HEX.swift
//  clinic
//
//  Created by Малова Олеся on 04.02.2025.
//

import UIKit

extension UIColor {
    static var maxHex = 255.0
    static var sixteen = 16
    static var eight = 8
    
    convenience init?(hex: String) {
        var hexSanitized = hex.trimmingCharacters(in: .whitespacesAndNewlines)
        hexSanitized = hexSanitized.replacingOccurrences(of: "#", with: "")
        let lenght = hexSanitized.count
        
        var rgb: UInt64 = 0
        var r: CGFloat = 0.0
        var g: CGFloat = 0.0
        var b: CGFloat = 0.0
        let a: CGFloat = 1.0
        
        guard Scanner(string: hexSanitized).scanHexInt64(&rgb) else {return nil}
        
        if lenght == 6 {
            r = CGFloat((rgb & 0xFF0000) >> Self.sixteen) / Self.maxHex
            g = CGFloat((rgb & 0x00FF00) >> Self.eight) / Self.maxHex
            b = CGFloat(rgb & 0x0000FF) / Self.maxHex
        } else {
            return nil
        }
        
        self.init(red: r, green: g, blue: b, alpha: a)
    }
}
