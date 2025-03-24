//
//  DetailAboutProcedureViewController.swift
//  malova_app
//
//  Created by Малова Олеся on 24.03.2025.
//

import UIKit

class DetailAboutProcedureViewController: UIViewController {
    
    var procedure: Procedure?
    
    private let containerView: UIView = UIView()
    private let titleLabel: UILabel = UILabel()
    private let infoLabel: UILabel = UILabel()
    private let closeButton: UIButton = UIButton(type: .system)
    private let addToCartButton: UIButton = UIButton(type: .system)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Настройка фона с размытием
        view.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        
        setupContainerView()
        setupLable()
        setupInfoLabel()
        setupCloseButton()
        setupAddToCartButton()
        
        if let procedure = procedure {
            infoLabel.text = """
            \(procedure.type)
            Название: \(procedure.name)
            Исполнитель: \(procedure.performer)
            Цена: \(procedure.price) руб.
            Время: \(procedure.duration)
            """
        }
    }
    
    private func setupContainerView() {
        containerView.backgroundColor = UIColor(hex: "647269")
        containerView.layer.cornerRadius = 12
        containerView.layer.masksToBounds = true
        
        view.addSubview(containerView)
        
        containerView.pinCenterX(to: view.centerXAnchor)
        containerView.pinCenterY(to: view.centerYAnchor)
        containerView.setWidth(300)
        containerView.setHeight(280)
    }
    
    private func setupLable() {
        titleLabel.textColor = .white
        titleLabel.text = "Информация о процедуре"
        titleLabel.font = UIFont.boldSystemFont(ofSize: 20)
        titleLabel.textAlignment = .center
        
        containerView.addSubview(titleLabel)
        
        titleLabel.pinTop(to: containerView.topAnchor, 16)
        titleLabel.pinLeft(to: containerView.leadingAnchor, 16)
        titleLabel.pinRight(to: containerView.trailingAnchor, 16)
    }
    
    private func setupInfoLabel() {
        infoLabel.textColor = .white
        infoLabel.numberOfLines = 0
        infoLabel.textAlignment = .center
        infoLabel.font = UIFont.systemFont(ofSize: 16)
        
        containerView.addSubview(infoLabel)
        
        infoLabel.pinTop(to: titleLabel.bottomAnchor, 16)
        infoLabel.pinLeft(to: containerView.leadingAnchor, 16)
        infoLabel.pinRight(to: containerView.trailingAnchor, 16)
    }
    
    private func setupCloseButton() {
        closeButton.tintColor = .black
        closeButton.setTitle("Закрыть", for: .normal)
        closeButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        
        containerView.addSubview(closeButton)
        
        closeButton.pinBottom(to: containerView.bottomAnchor, 16)
        //closeButton.pinCenterX(to: containerView.centerXAnchor)
        closeButton.pinLeft(to: containerView.leadingAnchor, 15)
        
        closeButton.addTarget(self, action: #selector(closeButtonTapped), for: .touchUpInside)
    }
    
    private func setupAddToCartButton() {
        addToCartButton.tintColor = .blue
        addToCartButton.setTitle("Добавить в корзину", for: .normal)
        addToCartButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        
        containerView.addSubview(addToCartButton)
        
        addToCartButton.pinBottom(to: containerView.bottomAnchor, 16)
        addToCartButton.pinRight(to: containerView.trailingAnchor, 10)
        
        addToCartButton.addTarget(self, action: #selector(addToCartButtonTapped), for: .touchUpInside)
    }
    
    @objc private func closeButtonTapped() {
        dismiss(animated: true, completion: nil)
    }
    
    @objc private func addToCartButtonTapped() {
        if let procedure = procedure {
            Cart.shared.addProcedure(procedure)
            dismiss(animated: true, completion: nil)
        }
    }
}

