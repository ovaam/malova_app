//
//  MainViewController.swift
//  clinic
//
//  Created by Малова Олеся on 02.02.2025.
//

import UIKit

protocol MainDisplayLogic: AnyObject {
    typealias Model = MainModel
    func displayStart(_ viewModel: Model.Start.ViewModel)
    // func display(_ viewModel: Model..ViewModel)
}

protocol MainAnalitics: AnyObject {
    typealias Model = MainModel
    func logStart(_ info: Model.Start.Info)
    // func log(_ viewModel: Model..Info)
}

// TODO: изменить бэкграунд фото, чтобы лучше было качество может найти замену,убрать свапанье экранов
final class MainViewController: UIViewController,
                            MainDisplayLogic {
    // MARK: - Constants
    private enum Constants {
        static let fatalError: String = "init(coder:) has not been implemented"
        
        static let buttonColor: UIColor = UIColor(hex: "DEE3E0") ?? UIColor()
        static let image: UIImage = UIImage(named: "MainImage") ?? UIImage()
        static let appointmentTitle: String = "записаться на услугу"
        static let titleButtonColor: UIColor = .black
        static let scanTitle: String = "отсканировать свое лицо"
        static let procedureTitle: String = "список всех процедур"
        
        static let appointmentButtonTop: Double = 190
        static let appointmentButtonRight: Double = 90
        
        static let scanButtonTop: Double = 40
        static let scanButtonLeft: Double = 80
        
        static let procedureButtonTop: Double = 400
        static let procedureButtonRight: Double = 100
        
        static let buttonWight: Double = 450
        static let buttonHeight: Double = 50
        static let buttonCornerRadius: Double = 20
    }
    
    // MARK: - Fields
    private let router: MainRoutingLogic
    private let interactor: MainBusinessLogic
    private let mainImage: UIImage = Constants.image
    private let appointmentButton: UIButton = UIButton()
    private let scanButton: UIButton = UIButton()
    private let procedureButton: UIButton = UIButton()
    private let profileButton: UIButton = UIButton()
    
    // MARK: - LifeCycle
    init(
        router: MainRoutingLogic,
        interactor: MainBusinessLogic
    ) {
        self.router = router
        self.interactor = interactor
        super.init(nibName: nil, bundle: nil)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError(Constants.fatalError)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        interactor.loadStart(Model.Start.Request())
        
        view.setBackgroundPhoto(to: view, image: mainImage)
        setAppointmentButton()
        setupScanButton()
        setupProcedureButton()
        setupProfileButton()
    }
    
    // MARK: - Configuration
    private func setAppointmentButton() {
        appointmentButton.setTitle(Constants.appointmentTitle, for: .normal)
        appointmentButton.setTitleColor(Constants.titleButtonColor, for: .normal)
        appointmentButton.backgroundColor = Constants.buttonColor
        appointmentButton.layer.cornerRadius = Constants.buttonCornerRadius
        
        view.addSubview(appointmentButton)
        
        appointmentButton.pinTop(to: view.topAnchor, Constants.appointmentButtonTop)
        appointmentButton.pinRight(to: view.trailingAnchor, Constants.appointmentButtonRight)
        appointmentButton.setWidth(Constants.buttonWight)
        appointmentButton.setHeight(Constants.buttonHeight)
        
        appointmentButton.addTarget(self, action: #selector(appointmentButtonTapped), for: .touchUpInside)
    }
    
    private func setupScanButton() {
        scanButton.setTitle(Constants.scanTitle, for: .normal)
        scanButton.setTitleColor(Constants.titleButtonColor, for: .normal)
        scanButton.backgroundColor = Constants.buttonColor
        scanButton.layer.cornerRadius = Constants.buttonCornerRadius
        
        view.addSubview(scanButton)
        
        scanButton.pinTop(to: appointmentButton.bottomAnchor, Constants.scanButtonTop)
        scanButton.pinLeft(to: view.leadingAnchor, Constants.scanButtonLeft)
        scanButton.setWidth(Constants.buttonWight)
        scanButton.setHeight(Constants.buttonHeight)
        
        scanButton.addTarget(self, action: #selector(scanButtonTapped), for: .touchUpInside)
    }
    
    private func setupProcedureButton() {
        procedureButton.setTitle(Constants.procedureTitle, for: .normal)
        procedureButton.setTitleColor(Constants.titleButtonColor, for: .normal)
        procedureButton.backgroundColor = Constants.buttonColor
        procedureButton.layer.cornerRadius = Constants.buttonCornerRadius
        
        view.addSubview(procedureButton)
        
        procedureButton.pinTop(to: scanButton.bottomAnchor, Constants.procedureButtonTop)
        procedureButton.pinRight(to: view.trailingAnchor, Constants.procedureButtonRight)
        procedureButton.setWidth(Constants.buttonWight)
        procedureButton.setHeight(Constants.buttonHeight)
        
        procedureButton.addTarget(self, action: #selector(procedureButtonTapped), for: .touchUpInside)
    }
    
    private func setupProfileButton() {
        profileButton.setImage(UIImage(named: "avatar"), for: .normal) // Иконка профиля
        //profileButton.tintColor = UIColor(hex: "647269") // Цвет иконки
        profileButton.backgroundColor = UIColor(hex: "647269")
        profileButton.addTarget(self, action: #selector(openProfile), for: .touchUpInside)
        
        // Добавление кнопки на экран
        view.addSubview(profileButton)
        profileButton.translatesAutoresizingMaskIntoConstraints = false
        
        // Констрейнты для размещения в правом верхнем углу
        NSLayoutConstraint.activate([
            profileButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            profileButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            //profileButton.widthAnchor.constraint(equalToConstant: 100), // Ширина кнопки
            //profileButton.heightAnchor.constraint(equalToConstant: 100) // Высота кнопки
        ])
        
        profileButton.setHeight(60)
        profileButton.setWidth(60)
        
        // Делаем кнопку квадратной
        profileButton.layer.cornerRadius = 20 // Закругление углов
        profileButton.layer.masksToBounds = true
    }
    
    // MARK: - Actions
    @objc func appointmentButtonTapped() {
        router.routeToAppointment()
    }
    
    @objc func scanButtonTapped() {
        router.routeToFaceScan()
    }
    
    @objc func procedureButtonTapped() {
        router.routeToProcedures()
    }
    
    @objc private func openProfile() {
        router.routeToProfile()
    }
    
    // MARK: - DisplayLogic
    func displayStart(_ viewModel: Model.Start.ViewModel) {
        
    }
}
