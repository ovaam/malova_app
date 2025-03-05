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
        setupAgeLabel()
        setupGenderLabel()
        setupQuestionButton()
    }
    
    private func setupGoBackButton() {
        goBackButton.setImage(UIImage(systemName: "chevron.left"), for: .normal)
        goBackButton.tintColor = .black
        
        view.addSubview(goBackButton)
        
        goBackButton.pinTop(to: view.safeAreaLayoutGuide.topAnchor, 16)
        goBackButton.pinLeft(to: view.leadingAnchor, 16)
        
        goBackButton.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
    }
    
    private func setupFullNameLabel() {
        fullNameLabel.font = UIFont(name: "HelveticaNeue-Medium", size: 18)
        fullNameLabel.textAlignment = .center
        
        view.addSubview(fullNameLabel)
        
        fullNameLabel.pinTop(to: view.topAnchor, 300)
        fullNameLabel.pinLeft(to: view.leadingAnchor, 30)
        fullNameLabel.pinRight(to: view.trailingAnchor, 30)
    }
    
    private func setupEmailLabel() {
        emailLabel.font = UIFont(name: "HelveticaNeue-Medium", size: 18)
        emailLabel.textAlignment = .center
        
        view.addSubview(emailLabel)
        
        emailLabel.pinTop(to: fullNameLabel.bottomAnchor, 20)
        emailLabel.pinLeft(to: view.leadingAnchor, 30)
        emailLabel.pinRight(to: view.trailingAnchor, 30)
    }
    
    private func setupAgeLabel() {
        ageLabel.font = UIFont(name: "HelveticaNeue-Medium", size: 18)
        ageLabel.textAlignment = .center
        
        view.addSubview(ageLabel)
        
        ageLabel.pinTop(to: emailLabel.bottomAnchor, 20)
        ageLabel.pinLeft(to: view.leadingAnchor, 30)
        ageLabel.pinRight(to: view.trailingAnchor, 30)
    }
    
    private func setupGenderLabel() {
        genderLabel.font = UIFont(name: "HelveticaNeue-Medium", size: 18)
        genderLabel.textAlignment = .center
        
        view.addSubview(genderLabel)
        
        genderLabel.pinTop(to: ageLabel.bottomAnchor, 20)
        genderLabel.pinLeft(to: view.leadingAnchor, 30)
        genderLabel.pinRight(to: view.trailingAnchor, 30)
    }
    
    private func setupQuestionButton() {
        questionButton.setImage(UIImage(systemName: "questionmark.circle"), for: .normal)
        questionButton.tintColor = .black // Цвет иконки
        questionButton.addTarget(self, action: #selector(openHelpScreen), for: .touchUpInside)
      
        view.addSubview(questionButton)
        questionButton.translatesAutoresizingMaskIntoConstraints = false
        
        questionButton.pinTop(to: view.safeAreaLayoutGuide.topAnchor, 20)
        questionButton.pinRight(to: view.trailingAnchor, 20)
        questionButton.setWidth(40)
        questionButton.setHeight(40)
    }
        
    // MARK: - Load User Data
    private func loadUserData() {
        viewModel.fetchUserData { [weak self] user in
            guard let self = self else { return }
            
            if let user = user {
                print("Данные пользователя загружены: \(user)")
                DispatchQueue.main.async {
                    self.fullNameLabel.text = "ФИО: \(user.fullName)"
                    self.emailLabel.text = "Почта: \(user.email)"
                    self.ageLabel.text = "Возраст: \(user.age)"
                    self.genderLabel.text = "Пол: \(user.gender)"
                }
            } else {
                print("Данные пользователя не найдены")
            }
        }
    }
    
    // MARK: - Actions
    @objc
    private func backButtonTapped() {
        router.routeToMain()
    }
    
    @objc private func openHelpScreen() {
        
    }
    
    // MARK: - DisplayLogic
    func displayStart(_ viewModel: Model.Start.ViewModel) {
        
    }
}

final class ProfileViewModel {
    private let db = Firestore.firestore()
    
    func fetchUserData(completion: @escaping (User?) -> Void) {
        guard let userId = Auth.auth().currentUser?.uid else {
            completion(nil)
            return
        }
        
        db.collection("users").document(userId).getDocument { snapshot, error in
            if let error = error {
                print("Ошибка загрузки данных пользователя: \(error.localizedDescription)")
                completion(nil)
                return
            }
            
            guard let data = snapshot?.data() else {
                print("Данные пользователя не найдены")
                completion(nil)
                return
            }
            
            let user = User(data: data, uid: userId)
            completion(user)
        }
    }
}
