//
//  BackgroundPhoto.swift
//  clinic
//
//  Created by Малова Олеся on 31.01.2025.
//

import UIKit

extension UIView {
    func setBackgroundPhoto(to view: UIView, image: UIImage) {
        let backgroundImageView = UIImageView(frame: view.bounds)
        backgroundImageView.image = image
        backgroundImageView.contentMode = .scaleAspectFill
        
        view.addSubview(backgroundImageView)
    }
}
