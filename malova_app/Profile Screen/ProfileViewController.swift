//
//  ProfileViewController.swift
//  malova_app
//
//  Created by Малова Олеся on 22.02.2025.
//

import UIKit

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
    }
    
    // MARK: - Configuration
    private func configureUI() {
        
    }
    
    // MARK: - Actions
    @objc
    private func wasTapped() {
        
    }
    
    // MARK: - DisplayLogic
    func displayStart(_ viewModel: Model.Start.ViewModel) {
        
    }
}
