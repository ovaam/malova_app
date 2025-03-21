//
//  WelcomeViewController.swift
//  malova_app
//
//  Created by Малова Олеся on 04.02.2025.
//

import UIKit
import FirebaseAuth

protocol WelcomeDisplayLogic: AnyObject {
    func displayGreeting(viewModel: Welcome.Greeting.ViewModel)
}

class WelcomeViewController: UIViewController, WelcomeDisplayLogic, UIGestureRecognizerDelegate {
    // MARK: - Constants
    private enum Constants {
        static let fatalError: String = "init(coder:) has not been implemented"
        static let welcomeImage: String = "WelcomeImage"
        
        static let malovaLabelSize: CGFloat = 122
        static let malovaLabelFont: String = "TimesNewRomanPSMT"
        static let malovaLabelText: String = "Malova"
        static let malovaLabelColor: UIColor = .white
        static let malovaLabelCenterY: Double = -70
        
        static let clinicLabelSize: CGFloat = 20
        static let clinicLabelFont: String = "Zapfino"
        static let clinicLabelText: String = "clinic"
        static let clinicLabelColor: UIColor = .white
        static let clinicLabelBottom: Double = -25
        
        static let startButtonText: String = "start"
        static let startButtonColor: UIColor = .white
        static let startButtonFont: String = "TimesNewRomanPSMT"
        static let startButtonFontSize: CGFloat = 28
        static let startButtonAlphaComponent: Double = 0.3
        static let startButtonCornerRadius: Double = 15
        static let startButtonTop: Double = 390
        static let startButtonLeft: Double = 90
        static let startButtonRight: Double = 90
    }

    private var interactor: WelcomeBusinessLogic?
    private var router: WelcomeRoutingLogic?

    private let startButton = UIButton(type: .system)
    private let clinicLabel = UILabel()
    private let malovaLabel = UILabel()
    private let welcomeImage: UIImage = UIImage(named: Constants.welcomeImage) ?? UIImage()

    // MARK: - LifeCycle
    init(
        router: WelcomeRoutingLogic,
        interactor: WelcomeBusinessLogic
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
        navigationController?.interactivePopGestureRecognizer?.delegate = self
        navigationController?.interactivePopGestureRecognizer?.isEnabled = false
        setupUI()
        interactor?.fetchGreeting()
    }

    func setupUI() {
        view.setBackgroundPhoto(to: view, image: welcomeImage)
        
        setMalovaLabel()
        setClinicLabel()
        setStartButton()
    }
    
    private func setMalovaLabel() {
        malovaLabel.font = UIFont(name: Constants.malovaLabelFont, size: Constants.malovaLabelSize)
        malovaLabel.text = Constants.malovaLabelText
        malovaLabel.textAlignment = .center
        malovaLabel.textColor = Constants.malovaLabelColor
        
        view.addSubview(malovaLabel)
        
        malovaLabel.pinCenterX(to: view.centerXAnchor)
        malovaLabel.pinCenterY(to: view.centerYAnchor, Constants.malovaLabelCenterY)
    }
    
    private func setClinicLabel() {
        clinicLabel.text = Constants.clinicLabelText
        clinicLabel.font = UIFont(name: Constants.clinicLabelFont, size: Constants.clinicLabelSize)
        
        clinicLabel.textAlignment = .center
        clinicLabel.textColor = Constants.clinicLabelColor
        
        view.addSubview(clinicLabel)
        
        clinicLabel.pinCenterX(to: view.centerXAnchor)
        clinicLabel.pinBottom(to: malovaLabel.topAnchor, Constants.clinicLabelBottom)
    }
    
    private func setStartButton() {
        startButton.setTitle(Constants.startButtonText, for: .normal)
        startButton.titleLabel?.font = UIFont(name: Constants.startButtonFont, size: Constants.startButtonFontSize)
        startButton.backgroundColor = UIColor.black.withAlphaComponent(Constants.startButtonAlphaComponent)
        
        
        startButton.setTitleColor(Constants.startButtonColor, for: .normal)
        startButton.layer.cornerRadius = Constants.startButtonCornerRadius
        
        startButton.addTarget(self, action: #selector(startButtonTapped), for: .touchUpInside)
        view.addSubview(startButton)
        
        startButton.pinTop(to: malovaLabel, Constants.startButtonTop)
        startButton.pinLeft(to: view.leadingAnchor, Constants.startButtonLeft)
        startButton.pinRight(to: view.trailingAnchor, Constants.startButtonRight)
    }

    @objc func startButtonTapped() {
        if Auth.auth().currentUser != nil {
            // Если пользователь уже авторизован, переходим на главный экран
            router?.routeToMain()
        } else {
            router?.routeToSingIn()
        }
    }

    func displayGreeting(viewModel: Welcome.Greeting.ViewModel) {
        
    }
}


