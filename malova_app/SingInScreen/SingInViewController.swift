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

// TODO: - убрать эту глупую идею с белой плашкой на картинке - сделать вью, потому что на темной теме происходит треш + то же самое логин скрин

final class SingInViewController: UIViewController, SingInDisplayLogic, UIGestureRecognizerDelegate {
    // MARK: - Constants
    private enum Constants {
        static let fatalError: String = "init(coder:) has not been implemented"
        
        static let singinImage: String = "WelcomeImage"
        
        static let emailLabelText: String = "Электронная почта"
        static let emailLabelColor: UIColor = .black
        static let emailLabelTop: Double = 375
        static let emailLabelLeft: Double = 80
        static let emailLabelRight: Double = 80
        
        static let emailPlaceholder: String = "Введите"
        static let emailTextFieldTop: Double = 10
        static let emailTextFieldBorderStyle: UITextField.BorderStyle = .roundedRect
        static let emailTextFieldReturnKeyType: UIReturnKeyType = .done
        
        static let emailErrorLabelTop: Double = 10
        
        static let malovaLabelSize: CGFloat = 122
        static let malovaLabelFont: String = "TimesNewRomanPSMT"
        static let malovaLabelText: String = "Malova"
        static let malovaLabelColor: UIColor = UIColor.white.withAlphaComponent(0.5)
        static let malovaLabelCenterY: Double = -250
        
        static let passwordLabelText: String = "Пароль"
        static let passwordLabelColor: UIColor = .black
        static let passwordLabelTop: Double = 20
        
        static let passwordPlaceholder: String = "Введите"
        static let passwordTextFieldTop: Double = 10
        static let passwordTextFieldBorderStyle: UITextField.BorderStyle = .roundedRect
        static let passwordTextFieldReturnKeyType: UIReturnKeyType = .done
        
        static let passwordErrorLabelTop: Double = 10
        
        static let singInButtonText: String = "Войти"
        static let singInButtonColor: UIColor = .black
        static let singInButtonTintColor: UIColor = .white
        static let singInButtonCornerRadius: Double = 6
        static let singInButtonTop: Double = 20
        static let singInButtonLeft: Double = 80
        static let singInButtonRight: Double = 80
        static let singInButtonHeight: Double = 35
        
        static let subviewColor: UIColor = .white
        static let subviewCornerradius: Double = 30
        static let subviewTop: Double = 365
        static let subviewRight: Double = 70
        static let subviewLeft: Double = 70
        static let subviewBottom: Double = 270
        
        static let registerButtonText: String = "Нет аккаунта? Создать"
        static let registerButtonColor: UIColor = .clear
        static let registerButtonTintColor: UIColor = .black
        static let registerButtonTop: Double = 30
        
        static let errorTitle: String = "Ошибка"
        static let errorMessage: String = "Пожалуйста, заполните все поля."
        static let authErrorMessage: String = "Ошибка аутентификации."
    }
    
    // MARK: - Fields
    private let router: SingInRoutingLogic
    private let interactor: SingInBusinessLogic
    
    private let subview: UIView = UIView()
    private let malovaLabel: UILabel = UILabel()
    
    private let emailTextField: UITextField = UITextField()
    private let emailLabel: UILabel = UILabel()
    private let emailErrorLabel: UILabel = UILabel()
    
    private let passwordTextField: UITextField = UITextField()
    private let passwordLabel: UILabel = UILabel()
    private let passwordErrorLabel: UILabel = UILabel()
    
    private let singInButton = UIButton(type: .system)
    private let registerButton = UIButton(type: .system)
    
    private let singinImage: UIImage = UIImage(named: Constants.singinImage) ?? UIImage()
    
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
        
        navigationController?.interactivePopGestureRecognizer?.delegate = self
        navigationController?.interactivePopGestureRecognizer?.isEnabled = true
        
        interactor.loadStart(Model.Start.Request())
        view.setBackgroundPhoto(to: view, image: singinImage)
        setupSubview()
        setupMalovaLabel()
        setupEmail()
        setupPassword()
        setupSingInButton()
        setupRegisterButton()
    }
    
    // MARK: - Configuration
    private func setupSubview() {
        subview.backgroundColor = Constants.subviewColor
        subview.layer.cornerRadius = Constants.subviewCornerradius
        
        view.addSubview(subview)
        
        subview.pinTop(to: view.topAnchor, Constants.subviewTop)
        subview.pinRight(to: view.trailingAnchor, Constants.subviewRight)
        subview.pinLeft(to: view.leadingAnchor, Constants.subviewLeft)
        subview.pinBottom(to: view.bottomAnchor, Constants.subviewBottom)
    }
    
    private func setupMalovaLabel() {
        malovaLabel.font = UIFont(name: Constants.malovaLabelFont, size: Constants.malovaLabelSize)
        malovaLabel.text = Constants.malovaLabelText
        malovaLabel.textAlignment = .center
        malovaLabel.textColor = Constants.malovaLabelColor
        
        view.addSubview(malovaLabel)
        
        malovaLabel.pinCenterX(to: view.centerXAnchor)
        malovaLabel.pinCenterY(to: view.centerYAnchor, Constants.malovaLabelCenterY)
    }
    
    private func setupEmail() {
        emailLabel.text = Constants.emailLabelText
        emailLabel.tintColor = Constants.emailLabelColor
        
        view.addSubview(emailLabel)
        
        emailLabel.pinLeft(to: view.leadingAnchor, Constants.emailLabelLeft)
        emailLabel.pinTop(to: view.topAnchor, Constants.emailLabelTop)
        emailLabel.pinRight(to: view.trailingAnchor, Constants.emailLabelRight)
        
        emailTextField.placeholder = Constants.emailPlaceholder
        emailTextField.borderStyle = .roundedRect
        
        view.addSubview(emailTextField)
        
        emailTextField.pinLeft(to: view.leadingAnchor, Constants.emailLabelLeft)
        emailTextField.pinTop(to: emailLabel.bottomAnchor, Constants.emailTextFieldTop)
        emailTextField.pinRight(to: view.trailingAnchor, Constants.emailLabelRight)
        emailTextField.returnKeyType = .done
        
        view.addSubview(emailErrorLabel)
        
        emailErrorLabel.pinLeft(to: view.leadingAnchor, Constants.emailLabelLeft)
        emailErrorLabel.pinTop(to: emailTextField.bottomAnchor, Constants.passwordErrorLabelTop)
        emailErrorLabel.pinRight(to: view.trailingAnchor, Constants.emailLabelRight)
    }
   
    private func setupPassword() {
        passwordLabel.text = Constants.passwordLabelText
        
        view.addSubview(passwordLabel)
        
        passwordLabel.pinLeft(to: view.leadingAnchor, Constants.emailLabelLeft)
        passwordLabel.pinTop(to: emailErrorLabel.bottomAnchor, Constants.passwordLabelTop)
        passwordLabel.pinRight(to: view.trailingAnchor, Constants.emailLabelRight)
        passwordLabel.tintColor = Constants.passwordLabelColor
        
        passwordTextField.placeholder = Constants.passwordPlaceholder
        passwordTextField.borderStyle = .roundedRect
        passwordTextField.returnKeyType = .done
        
        view.addSubview(passwordTextField)
        
        passwordTextField.pinLeft(to: view.leadingAnchor, Constants.emailLabelLeft)
        passwordTextField.pinTop(to: passwordLabel.bottomAnchor, Constants.passwordTextFieldTop)
        passwordTextField.pinRight(to: view.trailingAnchor, Constants.emailLabelRight)
        
        view.addSubview(passwordErrorLabel)
        
        passwordErrorLabel.pinLeft(to: view.leadingAnchor, Constants.emailLabelLeft)
        passwordErrorLabel.pinTop(to: passwordTextField.bottomAnchor, Constants.passwordErrorLabelTop)
        passwordErrorLabel.pinRight(to: view.trailingAnchor, Constants.emailLabelRight)
    }
   
    private func setupSingInButton() {
        singInButton.setTitle(Constants.singInButtonText, for: .normal)
        singInButton.backgroundColor = Constants.singInButtonColor
        singInButton.layer.cornerRadius = Constants.singInButtonCornerRadius
        singInButton.tintColor = Constants.singInButtonTintColor
        
        view.addSubview(singInButton)
        
        singInButton.pinLeft(to: view.leadingAnchor, Constants.emailLabelLeft)
        singInButton.pinTop(to: passwordErrorLabel.bottomAnchor, Constants.singInButtonTop)
        singInButton.pinRight(to: view.trailingAnchor, Constants.emailLabelRight)
        singInButton.setHeight(Constants.singInButtonHeight)
        
        singInButton.addTarget(self, action: #selector(singInButtonTapped), for: .touchUpInside)
    }
   
    private func setupRegisterButton() {
        let attribute: [NSAttributedString.Key: Any] = [
            .underlineStyle: NSUnderlineStyle.single.rawValue,
        ]
        
        registerButton.setAttributedTitle(
            NSAttributedString(string: Constants.registerButtonText, attributes: attribute),
            for: .normal
        )
        registerButton.backgroundColor = Constants.registerButtonColor
        registerButton.tintColor = Constants.registerButtonTintColor
        
        view.addSubview(registerButton)
        
        registerButton.pinLeft(to: view.leadingAnchor, Constants.emailLabelLeft)
        registerButton.pinTop(to: singInButton.bottomAnchor, Constants.registerButtonTop)
        
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
        let alert = UIAlertController(title: Constants.errorTitle, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    // MARK: - Actions
    @objc private func singInButtonTapped() {
        guard let email = emailTextField.text, !email.isEmpty,
              let password = passwordTextField.text, !password.isEmpty else {
            showError(message: Constants.errorMessage)
            return
        }
        
        loginUser(email: email, password: password) { success, errorMessage in
            if success {
                self.router.routeToMain()
            } else {
                self.showError(message: errorMessage ?? Constants.authErrorMessage)
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
