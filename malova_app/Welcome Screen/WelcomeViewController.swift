//
//  WelcomeViewController.swift
//  malova_app
//
//  Created by Малова Олеся on 04.02.2025.
//

import UIKit

protocol WelcomeDisplayLogic: AnyObject {
    func displayGreeting(viewModel: Welcome.Greeting.ViewModel)
}

class WelcomeViewController: UIViewController, WelcomeDisplayLogic {

    private var interactor: WelcomeBusinessLogic?
    private var router: WelcomeRoutingLogic?

    private let startButton = UIButton(type: .system)
    private let clinicLabel = UILabel()
    private let malovaLabel = UILabel()
    private let welcomeImage: UIImage = UIImage(named: "WelcomeImage") ?? UIImage()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        router = WelcomeRouter()
        interactor = WelcomeInteractor()
        
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
        malovaLabel.font = UIFont(name: "TimesNewRomanPSMT", size: 122)
        malovaLabel.text = "Malova"
        malovaLabel.textAlignment = .center
        malovaLabel.textColor = UIColor.white
        
        view.addSubview(malovaLabel)
        
        malovaLabel.pinCenterX(to: view.centerXAnchor)
        malovaLabel.pinCenterY(to: view.centerYAnchor, -70)
    }
    
    private func setClinicLabel() {
        clinicLabel.text = "clinic"
        clinicLabel.font = UIFont(name: "Zapfino", size: 20)
        
        clinicLabel.textAlignment = .center
        clinicLabel.textColor = UIColor.white
        
        view.addSubview(clinicLabel)
        
        clinicLabel.pinCenterX(to: view.centerXAnchor)
        clinicLabel.pinBottom(to: malovaLabel.topAnchor, -25)
    }
    
    private func setStartButton() {
        startButton.setTitle("start", for: .normal)
        startButton.titleLabel?.font = UIFont(name: "TimesNewRomanPSMT", size: 28)
        
        startButton.backgroundColor = UIColor.black
        startButton.layer.opacity = 0.3
        startButton.setTitleColor(.white, for: .normal)
        startButton.layer.cornerRadius = 15
        
        startButton.addTarget(self, action: #selector(startButtonTapped), for: .touchUpInside)
        view.addSubview(startButton)
        
        startButton.pinCenterX(to: view.centerXAnchor)
        startButton.pinTop(to: malovaLabel, 390)
    }

    @objc func startButtonTapped() {
        let nextVC = SingInViewController()
        navigationController?.pushViewController(nextVC, animated: true)
        
        //router?.routeToNextScreen(currentVC: UIViewController())
        //print("button tapped")
    }

    func displayGreeting(viewModel: Welcome.Greeting.ViewModel) {
        // Обработка данных для отображения на экране
    }
}


