//
//  LogInViewController.swift
//  clinic
//
//  Created by Малова Олеся on 02.02.2025.
//


import UIKit

protocol LogInDisplayLogic: AnyObject {
    typealias Model = LogInModel
    func displayStart(_ viewModel: Model.Start.ViewModel)
    // func display(_ viewModel: Model..ViewModel)
}

protocol LogInAnalitics: AnyObject {
    typealias Model = LogInModel
    func logStart(_ info: Model.Start.Info)
    // func log(_ viewModel: Model..Info)
}


final class LogInViewController: UIViewController,
                                 LogInDisplayLogic {
    // MARK: - Constants
    private enum Constants {
        static let fatalError: String = "init(coder:) has not been implemented"
    }
    
    // MARK: - Fields
    private let router: LogInRoutingLogic
    private let interactor: LogInBusinessLogic
    
    private let loginImage: UIImage = UIImage(named: "LogInImage") ?? UIImage()
    
    private let phoneTextField: UITextField = UITextField()
    private let phoneLabel: UILabel = UILabel()
    private let phoneErrorLabel: UILabel = UILabel()
    
    private let usernameTextField: UITextField = UITextField()
    private let usernameLabel: UILabel = UILabel()
    private let usernameErrorLabel: UILabel = UILabel()
    
    private let genderLabel: UILabel = UILabel()
    private let genderSwitcher: UISegmentedControl = UISegmentedControl()
    private var selectedGender: String = String()
    
    private let ageLabel: UILabel = UILabel()
    private let openPickerButton: UIButton = UIButton()
    private let agePicker: UIPickerView = UIPickerView()
    private var ages: [Int] = []
    private var selectedAge: Int = 18
    
    private let passwordTextField: UITextField = UITextField()
    private let passwordLabel: UILabel = UILabel()
    private let passwordErrorLabel: UILabel = UILabel()
    
    private let repeatedPasswordTextField: UITextField = UITextField()
    private let repeatedPasswordLabel: UILabel = UILabel()
    private let repeatedPasswordErrorLabel: UILabel = UILabel()
    
    private let loginButton: UIButton = UIButton()
    
    // MARK: - LifeCycle
    init(
        router: LogInRoutingLogic,
        interactor: LogInBusinessLogic
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
        self.navigationController?.navigationBar.isHidden = true
        interactor.loadStart(Model.Start.Request())
        view.setBackgroundPhoto(to: view, image: loginImage)
        setupPhone()
        setupUsername()
        setupGenderButton()
        setupPassword()
        setupRepeatedPassword()
        setupButton()
    }
    
    // MARK: - Configuration
    private func setupPhone() {
        phoneLabel.text = "Номер телефона"
        
        view.addSubview(phoneLabel)
        
        phoneLabel.pinLeft(to: view.leadingAnchor, 80)
        phoneLabel.pinTop(to: view.topAnchor, 300)
        phoneLabel.pinRight(to: view.trailingAnchor, 80)
        
        phoneTextField.placeholder = "8 (000) 000 - 00 - 00"
        phoneTextField.borderStyle = .roundedRect
        
        view.addSubview(phoneTextField)
        
        phoneTextField.pinLeft(to: view.leadingAnchor, 80)
        phoneTextField.pinTop(to: phoneLabel.bottomAnchor, 10)
        phoneTextField.pinRight(to: view.trailingAnchor, 80)
        
        view.addSubview(phoneErrorLabel)
        
        phoneErrorLabel.pinLeft(to: view.leadingAnchor, 80)
        phoneErrorLabel.pinTop(to: phoneTextField.bottomAnchor, 10)
        phoneErrorLabel.pinRight(to: view.trailingAnchor, 80)
    }
    
    private func setupUsername() {
        usernameLabel.text = "ФИО"
        
        view.addSubview(usernameLabel)
        
        usernameLabel.pinLeft(to: view.leadingAnchor, 80)
        usernameLabel.pinTop(to: phoneErrorLabel.bottomAnchor, 20)
        usernameLabel.pinRight(to: view.trailingAnchor, 80)
        
        usernameTextField.placeholder = "Иванов Иван Иванович"
        usernameTextField.borderStyle = .roundedRect
        
        view.addSubview(usernameTextField)
        
        usernameTextField.pinLeft(to: view.leadingAnchor, 80)
        usernameTextField.pinTop(to: usernameLabel.bottomAnchor, 10)
        usernameTextField.pinRight(to: view.trailingAnchor, 80)
        
        view.addSubview(usernameErrorLabel)
        
        usernameErrorLabel.pinLeft(to: view.leadingAnchor, 80)
        usernameErrorLabel.pinTop(to: usernameTextField.bottomAnchor, 10)
        usernameErrorLabel.pinRight(to: view.trailingAnchor, 80)
    }
    
    private func setupGenderButton() {
        genderLabel.text = "Пол"
        genderLabel.textColor = .black
        
        view.addSubview(genderLabel)
        
        genderLabel.pinLeft(to: view.leadingAnchor, 80)
        genderLabel.pinTop(to: usernameErrorLabel, 20)
        
        genderSwitcher.insertSegment(withTitle: "женский", at: 1, animated: true)
        genderSwitcher.insertSegment(withTitle: "мужской", at: 2, animated: true)
     
        
        view.addSubview(genderSwitcher)
        
        genderSwitcher.pinLeft(to: view.leadingAnchor, 80)
        genderSwitcher.pinTop(to: genderLabel.bottomAnchor, 10)
        genderSwitcher.pinRight(to: view.trailingAnchor, 80)
        
        if genderSwitcher.selectedSegmentIndex == 1 { selectedGender = "женский" }
        else { selectedGender = "мужской"}
    }
    
    
    private func setupPassword() {
        passwordLabel.text = "Пароль"
        
        view.addSubview(passwordLabel)
        
        passwordLabel.pinLeft(to: view.leadingAnchor, 80)
        passwordLabel.pinTop(to: openPickerButton.bottomAnchor, 20)
        passwordLabel.pinRight(to: view.trailingAnchor, 80)
        
        passwordTextField.placeholder = "введите"
        passwordTextField.borderStyle = .roundedRect
        
        view.addSubview(passwordTextField)
        
        passwordTextField.pinLeft(to: view.leadingAnchor, 80)
        passwordTextField.pinTop(to: passwordLabel.bottomAnchor, 10)
        passwordTextField.pinRight(to: view.trailingAnchor, 80)
        
        view.addSubview(passwordErrorLabel)
        
        passwordErrorLabel.pinLeft(to: view.leadingAnchor, 80)
        passwordErrorLabel.pinTop(to: passwordTextField.bottomAnchor, 10)
        passwordErrorLabel.pinRight(to: view.trailingAnchor, 80)
    }
    
    private func setupRepeatedPassword() {
        repeatedPasswordLabel.text = "Пароль(еще раз)"
        
        view.addSubview(repeatedPasswordLabel)
        
        repeatedPasswordLabel.pinLeft(to: view.leadingAnchor, 80)
        repeatedPasswordLabel.pinTop(to: passwordErrorLabel.bottomAnchor, 20)
        repeatedPasswordLabel.pinRight(to: view.trailingAnchor, 80)
        
        repeatedPasswordTextField.placeholder = "введите"
        repeatedPasswordTextField.borderStyle = .roundedRect
        
        view.addSubview(repeatedPasswordTextField)
        
        repeatedPasswordTextField.pinLeft(to: view.leadingAnchor, 80)
        repeatedPasswordTextField.pinTop(to: repeatedPasswordLabel.bottomAnchor, 10)
        repeatedPasswordTextField.pinRight(to: view.trailingAnchor, 80)
        
        view.addSubview(repeatedPasswordErrorLabel)
        
        repeatedPasswordErrorLabel.pinLeft(to: view.leadingAnchor, 80)
        repeatedPasswordErrorLabel.pinTop(to: repeatedPasswordTextField.bottomAnchor, 10)
        repeatedPasswordErrorLabel.pinRight(to: view.trailingAnchor, 80)
    }
    
    private func setupButton() {
        loginButton.setTitle("зарегистироваться", for: .normal)
        
        view.addSubview(loginButton)
        
        loginButton.backgroundColor = .black
        loginButton.layer.cornerRadius = 10
        
        loginButton.pinTop(to: repeatedPasswordErrorLabel.bottomAnchor, 30)
        loginButton.pinLeft(to: view.leadingAnchor, 70)
        loginButton.pinRight(to: view.trailingAnchor, 70)
        
        loginButton.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
    }
    
    // MARK: - Actions
    @objc private func buttonTapped() {
        router.routeToMain()
    }
    
    // MARK: - DisplayLogic
    func displayStart(_ viewModel: Model.Start.ViewModel) {
        
    }
}
