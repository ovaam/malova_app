//
//  SingInViewController.swift
//  clinic
//
//  Created by Малова Олеся on 24.01.2025.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore

protocol SingInDisplayLogic: AnyObject {
    typealias Model = SingInModel
    func displayStart(_ viewModel: Model.Start.ViewModel)
    // func display(_ viewModel: Model..ViewModel)
}

protocol SingInAnalitics: AnyObject {
    typealias Model = SingInModel
    func logStart(_ info: Model.Start.Info)
    // func log(_ viewModel: Model..Info)
}


final class SingInViewController: UIViewController,
                            SingInDisplayLogic {
    // MARK: - Constants
    private enum Constants {
        static let fatalError: String = "init(coder:) has not been implemented"
    }
    
    // MARK: - Fields
    private let router: SingInRoutingLogic
    private let interactor: SingInBusinessLogic
    
    private let emailTextField: UITextField = UITextField()
    private let emailLabel: UILabel = UILabel()
    private let emailErrorLabel: UILabel = UILabel()
    
    
    private let passwordTextField: UITextField = UITextField()
    private let passwordLabel: UILabel = UILabel()
    private let passwordErrorLabel: UILabel = UILabel()
    
    
    private let singInButton = UIButton(type: .system)
    private let registerButton = UIButton(type: .system)
    
    private let singinImage: UIImage = UIImage(named: "SingInImage") ?? UIImage()
    
    // MARK: - LifeCycle
    init(
        router: SingInRoutingLogic,
        interactor: SingInBusinessLogic
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
        //self.navigationController?.navigationBar.isHidden = true
        interactor.loadStart(Model.Start.Request())
        view.setBackgroundPhoto(to: view, image: singinImage)
        setupEmail()
        setupPassword()
        setupSingInButton()
        setupRegisterButton()
    }
    
    // MARK: - Configuration
    private func setupEmail() {
        emailLabel.text = "Электронная почта"
        
        view.addSubview(emailLabel)
        
        emailLabel.pinLeft(to: view.leadingAnchor, 80)
        emailLabel.pinTop(to: view.topAnchor, 375)
        emailLabel.pinRight(to: view.trailingAnchor, 80)
        
        emailTextField.placeholder = "Введите"
        emailTextField.borderStyle = .roundedRect
        
        view.addSubview(emailTextField)
        
        emailTextField.pinLeft(to: view.leadingAnchor, 80)
        emailTextField.pinTop(to: emailLabel.bottomAnchor, 10)
        emailTextField.pinRight(to: view.trailingAnchor, 80)
        
        view.addSubview(emailErrorLabel)
        
        emailErrorLabel.pinLeft(to: view.leadingAnchor, 80)
        emailErrorLabel.pinTop(to: emailTextField.bottomAnchor, 10)
        emailErrorLabel.pinRight(to: view.trailingAnchor, 80)
    }
   
    private func setupPassword() {
        passwordLabel.text = "Пароль"
        
        view.addSubview(passwordLabel)
        
        passwordLabel.pinLeft(to: view.leadingAnchor, 80)
        passwordLabel.pinTop(to: emailErrorLabel.bottomAnchor, 20)
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
    
    private func loginUser(email: String, password: String, completion: @escaping (Bool, String?) -> Void) {
        Auth.auth().signIn(withEmail: email, password: password) { authResult, error in
            if let error = error {
                completion(false, error.localizedDescription)
                return
            }
            
            guard let user = authResult?.user else {
                completion(false, "Ошибка: пользователь не найден")
                return
            }
            let uid = user.uid
            
            let db = Firestore.firestore()
            db.collection("users").document(uid).getDocument { document, error in
                if let error = error {
                    completion(false, error.localizedDescription)
                    return
                }
                
                if let document = document, document.exists {
                    let data = document.data()
                    print("Данные пользователя: \(data ?? [:])")
                    completion(true, nil)
                } else {
                    completion(false, "Данные пользователя не найдены")
                }
            }
        }
    }
    
    private func showError(message: String) {
        let alert = UIAlertController(title: "Ошибка", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    // MARK: - Actions
    @objc private func singInButtonTapped() {
        guard let email = emailTextField.text, !email.isEmpty,
              let password = passwordTextField.text, !password.isEmpty else {
            showError(message: "Пожалуйста, заполните все поля.")
            return
        }
        
        loginUser(email: email, password: password) { success, errorMessage in
            if success {
                self.router.routeToMain()
            } else {
                self.showError(message: errorMessage ?? "Ошибка аутентификации.")
            }
        }
    }
    
    @objc private func registerButtonTapped() {
        router.routeToRegistration()
    }
    
    // MARK: - DisplayLogic
    func displayStart(_ viewModel: Model.Start.ViewModel) {
        
    }
}

