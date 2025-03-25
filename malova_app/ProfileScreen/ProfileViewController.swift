//
//  ProfileViewController.swift
//  malova_app
//
//  Created by Малова Олеся on 22.02.2025.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore

protocol ProfileDisplayLogic: AnyObject {
    typealias Model = ProfileModel
    func displayStart(_ viewModel: Model.Start.ViewModel)
    // func display(_ viewModel: Model..ViewModel)
}

protocol ProfileAnalitics: AnyObject {
    typealias Model = ProfileModel
    func logStart(_ info: Model.Start.Info)
    // func log(_ viewModel: Model..Info)
}


final class ProfileViewController: UIViewController,
                            ProfileDisplayLogic {
    // MARK: - Constants
    private enum Constants {
        static let fatalError: String = "init(coder:) has not been implemented"
    }
    
    // MARK: - Fields
    private let router: ProfileRoutingLogic
    private let interactor: ProfileBusinessLogic
    
    private let fullNameLabel: UILabel = UILabel()
    private let emailLabel: UILabel = UILabel()
    private let ageLabel: UILabel = UILabel()
    private let genderLabel: UILabel = UILabel()
    private let goBackButton: UIButton = UIButton()
//    private let logoutButton: UIButton = UIButton(type: .system)
    private let settingsButton: UIButton = UIButton()
    
    private let questionButton: UIButton = UIButton(type: .system)
    
    private let viewModel = ProfileViewModel()
    
    // MARK: - LifeCycle
    init(
        router: ProfileRoutingLogic,
        interactor: ProfileBusinessLogic
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
        view.setBackgroundPhoto(to: view, image: UIImage(named: "ProfileImage") ?? UIImage())
        setupUI()
        loadUserData()
    }
    
    // MARK: - Configuration
    private func setupUI() {
        view.backgroundColor = .white
        setupGoBackButton()
        setupFullNameLabel()
        setupEmailLabel()
        setupGenderLabel()
        setupAgeLabel()
        setupQuestionButton()
        //setupLogoutButton()
        setupSettingsButton()
    }
    
    private func setupGoBackButton() {
        goBackButton.setImage(UIImage(systemName: "chevron.left"), for: .normal)
        goBackButton.tintColor = .black
        
        view.addSubview(goBackButton)
        
        goBackButton.pinTop(to: view.safeAreaLayoutGuide.topAnchor, 16)
        goBackButton.pinLeft(to: view.leadingAnchor, 16)
        
        goBackButton.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
    }
    
//    private func setupLogoutButton() {
//        logoutButton.setTitle("Выйти", for: .normal)
//        logoutButton.titleLabel?.font = UIFont(name: "HelveticaNeue-Medium", size: 18)
//        logoutButton.tintColor = .red
//        logoutButton.addTarget(self, action: #selector(logoutButtonTapped), for: .touchUpInside)
//        
//        view.addSubview(logoutButton)
//        
//        logoutButton.translatesAutoresizingMaskIntoConstraints = false
//        logoutButton.pinTop(to: genderLabel.bottomAnchor, 280)
//        logoutButton.pinCenterX(to: view.centerXAnchor)
//    }
    
    private func setupFullNameLabel() {
        fullNameLabel.font = UIFont(name: "HelveticaNeue-Medium", size: 18)
        fullNameLabel.textAlignment = .center
        
        view.addSubview(fullNameLabel)
        
        fullNameLabel.pinTop(to: view.topAnchor, 255)
        fullNameLabel.pinLeft(to: view.leadingAnchor, 110)
        fullNameLabel.pinRight(to: view.trailingAnchor, 30)
    }
    
    private func setupEmailLabel() {
        emailLabel.font = UIFont(name: "HelveticaNeue-Medium", size: 18)
        emailLabel.textAlignment = .center
        
        view.addSubview(emailLabel)
        
        emailLabel.pinTop(to: fullNameLabel.bottomAnchor, 45)
        emailLabel.pinLeft(to: view.leadingAnchor, 110)
        emailLabel.pinRight(to: view.trailingAnchor, 30)
    }
    
    private func setupGenderLabel() {
        genderLabel.font = UIFont(name: "HelveticaNeue-Medium", size: 18)
        genderLabel.textAlignment = .center
        
        view.addSubview(genderLabel)
        
        genderLabel.pinTop(to: emailLabel.bottomAnchor, 45)
        genderLabel.pinLeft(to: view.leadingAnchor, 110)
        genderLabel.pinRight(to: view.trailingAnchor, 30)
    }
    
    private func setupAgeLabel() {
        ageLabel.font = UIFont(name: "HelveticaNeue-Medium", size: 18)
        ageLabel.textAlignment = .center
        
        view.addSubview(ageLabel)
        
        ageLabel.pinTop(to: genderLabel.bottomAnchor, 45)
        ageLabel.pinLeft(to: view.leadingAnchor, 110)
        ageLabel.pinRight(to: view.trailingAnchor, 30)
    }
    
    private func setupQuestionButton() {
        questionButton.setImage(UIImage(systemName: "questionmark.circle"), for: .normal)
        questionButton.tintColor = .black
      
        view.addSubview(questionButton)
        
        questionButton.pinTop(to: view.safeAreaLayoutGuide.topAnchor, 20)
        questionButton.pinRight(to: view.trailingAnchor, 20)
        questionButton.setWidth(40)
        questionButton.setHeight(40)
        
        questionButton.addTarget(self, action: #selector(openHelpScreen), for: .touchUpInside)
    }
    
    private func setupSettingsButton() {
        settingsButton.setImage(UIImage(systemName: "gearshape"), for: .normal)
        settingsButton.tintColor = .black
        
        view.addSubview(settingsButton)
        
        settingsButton.pinCenterX(to: view.centerXAnchor)
        settingsButton.pinBottom(to: view.bottomAnchor, 180)
        
        settingsButton.addTarget(self, action: #selector(openSettingsScreen), for: .touchUpInside)
    }
        
    // MARK: - Load User Data
    private func loadUserData() {
        viewModel.fetchUserData { [weak self] user in
            guard let self = self else { return }
            
            if let user = user {
                print("Данные пользователя загружены: \(user)")
                DispatchQueue.main.async {
                    self.fullNameLabel.text = "\(user.fullName)"
                    self.emailLabel.text = "\(user.email)"
                    self.genderLabel.text = "\(user.gender)"
                    self.ageLabel.text = "\(user.age)"
                }
            } else {
                print("Данные пользователя не найдены")
            }
        }
    }
    
    // MARK: - Actions
    @objc private func backButtonTapped() {
        router.routeToMain()
    }
    
    @objc private func openHelpScreen() {
        
    }
    
    @objc private func openSettingsScreen() {
        router.routeToSettings()
    }
    
    // MARK: - DisplayLogic
    func displayStart(_ viewModel: Model.Start.ViewModel) {
        
    }
}
