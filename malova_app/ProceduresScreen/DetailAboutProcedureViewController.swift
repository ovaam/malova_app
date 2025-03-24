//
//  DetailAboutProcedureViewController.swift
//  malova_app
//
//  Created by Малова Олеся on 24.03.2025.
//

import UIKit

class DetailAboutProcedureViewController: UIViewController {
    // MARK: - Constants
    private enum Constants {
        static let backgroundColor: UIColor = UIColor.black.withAlphaComponent(0.5)
        static let containerColor: UIColor = UIColor(hex: "647269") ?? UIColor.darkGray
        static let textColor: UIColor = .white
        static let buttonTextColor: UIColor = .black
        static let addToCartButtonTextColor: UIColor = .darkGray
        
        static let titleFont: UIFont = UIFont.boldSystemFont(ofSize: 20)
        static let infoFont: UIFont = UIFont.systemFont(ofSize: 16)
        static let buttonFont: UIFont = UIFont.boldSystemFont(ofSize: 16)
        
        static let titleText: String = "Информация о процедуре"
        static let closeButtonText: String = "Закрыть"
        static let addToCartButtonText: String = "Добавить в корзину"
        
        static let containerWidth: Double = 300
        static let containerHeight: Double = 280
        static let containerCornerRadius: Double = 12
        
        static let titleTop: Double = 16
        static let titleLeft: Double = 16
        static let titleRight: Double = 16
        
        static let infoTop: Double = 16
        static let infoLeft: Double = 16
        static let infoRight: Double = 16
        
        static let buttonBottom: Double = 16
        static let closeButtonLeft: Double = 15
        static let addToCartButtonRight: Double = 10
    }
    
    // MARK: - Properties
    var procedure: Procedure?
    
    // MARK: - UI Elements
    private let containerView: UIView = UIView()
    private let titleLabel: UILabel = UILabel()
    private let infoLabel: UILabel = UILabel()
    private let closeButton: UIButton = UIButton(type: .system)
    private let addToCartButton: UIButton = UIButton(type: .system)
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = Constants.backgroundColor
        
        setupContainerView()
        setupLable()
        setupInfoLabel()
        setupCloseButton()
        setupAddToCartButton()
        
        updateProcedureInfo()
    }
    
    // MARK: - Setup Methods
    private func setupContainerView() {
        containerView.backgroundColor = Constants.containerColor
        containerView.layer.cornerRadius = Constants.containerCornerRadius
        containerView.layer.masksToBounds = true
        
        view.addSubview(containerView)
        
        containerView.pinCenterX(to: view.centerXAnchor)
        containerView.pinCenterY(to: view.centerYAnchor)
        containerView.setWidth(Constants.containerWidth)
        containerView.setHeight(Constants.containerHeight)
    }
    
    private func setupLable() {
        titleLabel.textColor = Constants.textColor
        titleLabel.text = Constants.titleText
        titleLabel.font = Constants.titleFont
        titleLabel.textAlignment = .center
        
        containerView.addSubview(titleLabel)
        
        titleLabel.pinTop(to: containerView.topAnchor, Constants.titleTop)
        titleLabel.pinLeft(to: containerView.leadingAnchor, Constants.titleLeft)
        titleLabel.pinRight(to: containerView.trailingAnchor, Constants.titleRight)
    }
    
    private func setupInfoLabel() {
        infoLabel.textColor = Constants.textColor
        infoLabel.numberOfLines = 0
        infoLabel.textAlignment = .center
        infoLabel.font = Constants.infoFont
        
        containerView.addSubview(infoLabel)
        
        infoLabel.pinTop(to: titleLabel.bottomAnchor, Constants.infoTop)
        infoLabel.pinLeft(to: containerView.leadingAnchor, Constants.infoLeft)
        infoLabel.pinRight(to: containerView.trailingAnchor, Constants.infoRight)
    }
    
    private func setupCloseButton() {
        closeButton.tintColor = Constants.buttonTextColor
        closeButton.setTitle(Constants.closeButtonText, for: .normal)
        closeButton.titleLabel?.font = Constants.buttonFont
        
        containerView.addSubview(closeButton)
        
        closeButton.pinBottom(to: containerView.bottomAnchor, Constants.buttonBottom)
        closeButton.pinLeft(to: containerView.leadingAnchor, Constants.closeButtonLeft)
        
        closeButton.addTarget(self, action: #selector(closeButtonTapped), for: .touchUpInside)
    }
    
    private func setupAddToCartButton() {
        addToCartButton.tintColor = Constants.addToCartButtonTextColor
        addToCartButton.setTitle(Constants.addToCartButtonText, for: .normal)
        addToCartButton.titleLabel?.font = Constants.buttonFont
        
        containerView.addSubview(addToCartButton)
        
        addToCartButton.pinBottom(to: containerView.bottomAnchor, Constants.buttonBottom)
        addToCartButton.pinRight(to: containerView.trailingAnchor, Constants.addToCartButtonRight)
        
        addToCartButton.addTarget(self, action: #selector(addToCartButtonTapped), for: .touchUpInside)
    }
    
    // MARK: - Private Methods
    private func updateProcedureInfo() {
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
    
    // MARK: - Actions
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
