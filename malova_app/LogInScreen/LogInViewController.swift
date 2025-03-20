//
//  LogInViewController.swift
//  clinic
//
//  Created by Малова Олеся on 02.02.2025.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore

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


final class LogInViewController: UIViewController, LogInDisplayLogic {
    // MARK: - Constants
    private enum Constants {
        static let fatalError: String = "init(coder:) has not been implemented"
        static let loginImageName: String = "LogInImage"
        
        static let blackColor: UIColor = .black
        static let whiteColor: UIColor = .white
        
        static let leftOffset: Double = 80
        static let rightOffset: Double = 80
        static let topOffset: Double = 300
        static let smallTopOffset: Double = 10
        static let mediumTopOffset: Double = 20
        static let largeTopOffset: Double = 70
        static let buttonCornerRadius: Double = 10
        
        static let emailLabelText: String = "Электронная почта"
        static let emailPlaceholder: String = "sometext@gmail.com"
        
        static let usernameLabelText: String = "ФИО"
        static let usernamePlaceholder: String = "Иванов Иван Иванович"
        
        static let genderLabelText: String = "Пол"
        static let femaleGenderText: String = "женский"
        static let maleGenderText: String = "мужской"
        
        static let ageLabelText: String = "Возраст"
        static let agePlaceholder: String = "18"
        
        static let passwordLabelText: String = "Пароль"
        static let passwordPlaceholder: String = "введите"
        
        static let repeatedPasswordLabelText: String = "Пароль(еще раз)"
        static let repeatedPasswordPlaceholder: String = "введите"
        
        static let loginButtonText: String = "зарегистироваться"
        
        static let errorTitle: String = "Ошибка"
        static let errorMessage: String = "Пожалуйста, заполните все поля корректно."
        static let passwordMismatchMessage: String = "Пароли не совпадают."
        static let registrationErrorMessage: String = "Ошибка регистрации."
    }
    
    // MARK: - Fields
    private let router: LogInRoutingLogic
    private let interactor: LogInBusinessLogic
    
    private let loginImage: UIImage = UIImage(named: Constants.loginImageName) ?? UIImage()
    
    private let emailTextField: UITextField = UITextField()
    private let emailLabel: UILabel = UILabel()
    
    private let usernameTextField: UITextField = UITextField()
    private let usernameLabel: UILabel = UILabel()
    
    private let genderLabel: UILabel = UILabel()
    private let genderSwitcher: UISegmentedControl = UISegmentedControl()
    private var selectedGender: String = String()
    
    private let ageTextField: UITextField = UITextField()
    private let ageLabel: UILabel = UILabel()
    
    private let passwordTextField: UITextField = UITextField()
    private let passwordLabel: UILabel = UILabel()
    
    private let repeatedPasswordTextField: UITextField = UITextField()
    private let repeatedPasswordLabel: UILabel = UILabel()
    
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
        interactor.loadStart(Model.Start.Request())
        view.setBackgroundPhoto(to: view, image: loginImage)
        
        setupEmail()
        setupUsername()
        setupGenderButton()
        setupAge()
        setupPassword()
        setupRepeatedPassword()
        setupButton()
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        view.addGestureRecognizer(tapGesture)
    }
    
    // MARK: - Configuration
    private func setupEmail() {
        emailLabel.text = Constants.emailLabelText
        
        view.addSubview(emailLabel)
        
        emailLabel.pinLeft(to: view.leadingAnchor, Constants.leftOffset)
        emailLabel.pinTop(to: view.topAnchor, Constants.topOffset)
        emailLabel.pinRight(to: view.trailingAnchor, Constants.rightOffset)
        
        emailTextField.placeholder = Constants.emailPlaceholder
        emailTextField.borderStyle = .roundedRect
        
        view.addSubview(emailTextField)
        
        emailTextField.pinLeft(to: view.leadingAnchor, Constants.leftOffset)
        emailTextField.pinTop(to: emailLabel.bottomAnchor, Constants.smallTopOffset)
        emailTextField.pinRight(to: view.trailingAnchor, Constants.rightOffset)
    }
    
    private func setupUsername() {
        usernameLabel.text = Constants.usernameLabelText
        
        view.addSubview(usernameLabel)
        
        usernameLabel.pinLeft(to: view.leadingAnchor, Constants.leftOffset)
        usernameLabel.pinTop(to: emailTextField.bottomAnchor, Constants.mediumTopOffset)
        usernameLabel.pinRight(to: view.trailingAnchor, Constants.rightOffset)
        
        usernameTextField.placeholder = Constants.usernamePlaceholder
        usernameTextField.borderStyle = .roundedRect
        
        view.addSubview(usernameTextField)
        
        usernameTextField.pinLeft(to: view.leadingAnchor, Constants.leftOffset)
        usernameTextField.pinTop(to: usernameLabel.bottomAnchor, Constants.smallTopOffset)
        usernameTextField.pinRight(to: view.trailingAnchor, Constants.rightOffset)
    }
    
    private func setupGenderButton() {
        genderLabel.text = Constants.genderLabelText
        genderLabel.textColor = Constants.blackColor
        
        view.addSubview(genderLabel)
        
        genderLabel.pinLeft(to: view.leadingAnchor, Constants.leftOffset)
        genderLabel.pinTop(to: usernameTextField.bottomAnchor, Constants.mediumTopOffset)
        
        genderSwitcher.insertSegment(withTitle: Constants.femaleGenderText, at: 0, animated: true)
        genderSwitcher.insertSegment(withTitle: Constants.maleGenderText, at: 1, animated: true)
        
        view.addSubview(genderSwitcher)
        
        genderSwitcher.pinLeft(to: view.leadingAnchor, Constants.leftOffset)
        genderSwitcher.pinTop(to: genderLabel.bottomAnchor, Constants.smallTopOffset)
        genderSwitcher.pinRight(to: view.trailingAnchor, Constants.rightOffset)
        
        selectedGender = genderSwitcher.selectedSegmentIndex == 0 ? Constants.femaleGenderText : Constants.maleGenderText
    }
    
    private func setupAge() {
        ageLabel.text = Constants.ageLabelText
        
        view.addSubview(ageLabel)
        
        ageLabel.pinLeft(to: view.leadingAnchor, Constants.leftOffset)
        ageLabel.pinTop(to: genderSwitcher.bottomAnchor, Constants.mediumTopOffset)
        ageLabel.pinRight(to: view.trailingAnchor, Constants.rightOffset)
        
        ageTextField.placeholder = Constants.agePlaceholder
        ageTextField.borderStyle = .roundedRect
        
        view.addSubview(ageTextField)
        
        ageTextField.pinLeft(to: view.leadingAnchor, Constants.leftOffset)
        ageTextField.pinTop(to: ageLabel.bottomAnchor, Constants.smallTopOffset)
        ageTextField.pinRight(to: view.trailingAnchor, Constants.rightOffset)
    }
    
    private func setupPassword() {
        passwordLabel.text = Constants.passwordLabelText
        
        view.addSubview(passwordLabel)
        
        passwordLabel.pinLeft(to: view.leadingAnchor, Constants.leftOffset)
        passwordLabel.pinTop(to: ageTextField.bottomAnchor, Constants.mediumTopOffset)
        passwordLabel.pinRight(to: view.trailingAnchor, Constants.rightOffset)
        
        passwordTextField.placeholder = Constants.passwordPlaceholder
        passwordTextField.borderStyle = .roundedRect
        
        view.addSubview(passwordTextField)
        
        passwordTextField.pinLeft(to: view.leadingAnchor, Constants.leftOffset)
        passwordTextField.pinTop(to: passwordLabel.bottomAnchor, Constants.smallTopOffset)
        passwordTextField.pinRight(to: view.trailingAnchor, Constants.rightOffset)
    }
    
    private func setupRepeatedPassword() {
        repeatedPasswordLabel.text = Constants.repeatedPasswordLabelText
        
        view.addSubview(repeatedPasswordLabel)
        
        repeatedPasswordLabel.pinLeft(to: view.leadingAnchor, Constants.leftOffset)
        repeatedPasswordLabel.pinTop(to: passwordTextField.bottomAnchor, Constants.mediumTopOffset)
        repeatedPasswordLabel.pinRight(to: view.trailingAnchor, Constants.rightOffset)
        
        repeatedPasswordTextField.placeholder = Constants.repeatedPasswordPlaceholder
        repeatedPasswordTextField.borderStyle = .roundedRect
        
        view.addSubview(repeatedPasswordTextField)
        
        repeatedPasswordTextField.pinLeft(to: view.leadingAnchor, Constants.leftOffset)
        repeatedPasswordTextField.pinTop(to: repeatedPasswordLabel.bottomAnchor, Constants.smallTopOffset)
        repeatedPasswordTextField.pinRight(to: view.trailingAnchor, Constants.rightOffset)
    }
    
    private func setupButton() {
        loginButton.setTitle(Constants.loginButtonText, for: .normal)
        loginButton.backgroundColor = Constants.blackColor
        loginButton.layer.cornerRadius = Constants.buttonCornerRadius
        loginButton.tintColor = Constants.whiteColor
        
        view.addSubview(loginButton)
        
        loginButton.pinTop(to: repeatedPasswordTextField.bottomAnchor, Constants.largeTopOffset)
        loginButton.pinLeft(to: view.leadingAnchor, Constants.leftOffset)
        loginButton.pinRight(to: view.trailingAnchor, Constants.rightOffset)
        
        loginButton.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
    }
    
    // MARK: - Actions
    @objc private func buttonTapped() {
        guard let email = emailTextField.text, !email.isEmpty,
              let password = passwordTextField.text, !password.isEmpty,
              let repeatedPassword = repeatedPasswordTextField.text, !repeatedPassword.isEmpty,
              let fullName = usernameTextField.text, !fullName.isEmpty,
              let ageText = ageTextField.text, !ageText.isEmpty,
              let age = Int(ageText) else {
            showError(message: Constants.errorMessage)
            return
        }
        
        if password != repeatedPassword {
            showError(message: Constants.passwordMismatchMessage)
            return
        }
        
        let gender = genderSwitcher.selectedSegmentIndex == 0 ? Constants.femaleGenderText : Constants.maleGenderText
        
        registerUser(phoneNumber: email, password: password, fullName: fullName, gender: gender, age: age) { success, errorMessage in
            if success {
                self.router.routeToMain()
            } else {
                self.showError(message: errorMessage ?? Constants.registrationErrorMessage)
            }
        }
    }
    
    @objc private func hideKeyboard() {
        view.endEditing(true)
    }
    
    // MARK: - DisplayLogic
    func displayStart(_ viewModel: Model.Start.ViewModel) {
        // Обработка данных для отображения
    }
    
    // MARK: - Private Methods
    private func registerUser(phoneNumber: String, password: String, fullName: String, gender: String, age: Int, completion: @escaping (Bool, String?) -> Void) {
        Auth.auth().createUser(withEmail: phoneNumber, password: password) { authResult, error in
            if let error = error {
                completion(false, error.localizedDescription)
                return
            }
            
            guard let user = authResult?.user else {
                completion(false, "Ошибка: пользователь не создан")
                return
            }
            let uid = user.uid
            
            let db = Firestore.firestore()
            let userData: [String: Any] = [
                "phoneNumber": phoneNumber,
                "fullName": fullName,
                "gender": gender,
                "age": age
            ]
            
            db.collection("users").document(uid).setData(userData) { error in
                if let error = error {
                    completion(false, error.localizedDescription)
                } else {
                    completion(true, nil)
                }
            }
        }
    }
    
    private func showError(message: String) {
        let alert = UIAlertController(title: Constants.errorTitle, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
}
