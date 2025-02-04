//
//  SingInViewController.swift
//  clinic
//
//  Created by Малова Олеся on 24.01.2025.
//

import UIKit

import UIKit

// MARK: - View
protocol SingInDisplayLogic: AnyObject {
    func displaySingInSuccess()
    func displaySingInFailure(error: String)
    func navigateToRegistration()
}

class SingInViewController: UIViewController, SingInDisplayLogic {
    
    var interactor: SingInBusinessLogic?
    var router: SingInRoutingLogic?

    // UI Elements
    private let usernameTextField: UITextField = UITextField()
    private let usernameLabel: UILabel = UILabel()
    private let usernameErrorLabel: UILabel = UILabel()
    
    
    private let passwordTextField: UITextField = UITextField()
    private let passwordLabel: UILabel = UILabel()
    private let passwordErrorLabel: UILabel = UILabel()
    
    
    private let singInButton = UIButton(type: .system)
    private let registerButton = UIButton(type: .system)
    
    private let singinImage: UIImage = UIImage(named: "SingInImage") ?? UIImage()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.setBackgroundPhoto(to: view, image: singinImage)
        setupUI()
    }
    
    private func setupUI() {
        setupUsername()
        setupPassword()
        setupSingInButton()
        setupRegisterButton()
    }
    
    private func setupUsername() {
        usernameLabel.text = "Номер телефона"
        
        view.addSubview(usernameLabel)
        
        usernameLabel.pinLeft(to: view.leadingAnchor, 80)
        usernameLabel.pinTop(to: view.topAnchor, 375)
        usernameLabel.pinRight(to: view.trailingAnchor, 80)
        
        usernameTextField.placeholder = "Введите"
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
    
    private func setupPassword() {
        passwordLabel.text = "Пароль"
        
        view.addSubview(passwordLabel)
        
        passwordLabel.pinLeft(to: view.leadingAnchor, 80)
        passwordLabel.pinTop(to: usernameErrorLabel.bottomAnchor, 20)
        passwordLabel.pinRight(to: view.trailingAnchor, 80)
        
        passwordTextField.placeholder = "Введите"
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
    
    private func setupSingInButton() {
        singInButton.setTitle("Войти", for: .normal)
        singInButton.backgroundColor = .black
        singInButton.layer.cornerRadius = 6
        singInButton.tintColor = .white
        
        view.addSubview(singInButton)
        
        singInButton.pinLeft(to: view.leadingAnchor, 80)
        singInButton.pinTop(to: passwordErrorLabel.bottomAnchor, 20)
        singInButton.pinRight(to: view.trailingAnchor, 80)
        singInButton.setHeight(35)
        
        singInButton.addTarget(self, action: #selector(singInButtonTapped), for: .touchUpInside)
    }

    @objc private func singInButtonTapped() {
        let username = usernameTextField.text ?? ""
        let password = passwordTextField.text ?? ""
        interactor?.login(username: username, password: password)
    }
    
    private func setupRegisterButton() {
        //registerButton.setTitle("Нет аккаунта? Создать", for: .normal)
        
        let attribute: [NSAttributedString.Key: Any] = [
            .underlineStyle: NSUnderlineStyle.single.rawValue,
        ]
                
        registerButton.setAttributedTitle(NSAttributedString(string: "Нет аккаунта? Создать", attributes: attribute), for: .normal)
        registerButton.backgroundColor = .clear
        registerButton.tintColor = .black
        
        view.addSubview(registerButton)
        
        registerButton.pinLeft(to: view.leadingAnchor, 80)
        registerButton.pinTop(to: singInButton.bottomAnchor, 30)
        
        registerButton.addTarget(self, action: #selector(registerButtonTapped), for: .touchUpInside)
        
    }
    
    @objc private func registerButtonTapped() {
        let nextVC = LogInViewController()
        navigationController?.pushViewController(nextVC, animated: true)
        //router?.navigateToRegistration()
    }
    
    // MARK: - LoginDisplayLogic
    func displaySingInSuccess() {
        router?.navigateToHome()
    }
    
    func displaySingInFailure(error: String) {
        // Show an error message
        let alert = UIAlertController(title: "Error", message: error, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
    
    func navigateToRegistration() {
        router?.navigateToRegistration()
    }
}

