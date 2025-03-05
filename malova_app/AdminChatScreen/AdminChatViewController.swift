//
//  AdminChatViewController.swift
//  malova_app
//
//  Created by Малова Олеся on 05.03.2025.
//

import UIKit

protocol AdminChatDisplayLogic: AnyObject {
    typealias Model = AdminChatModel
    func displayStart(_ viewModel: Model.Start.ViewModel)
    // func display(_ viewModel: Model..ViewModel)
}

protocol AdminChatAnalitics: AnyObject {
    typealias Model = AdminChatModel
    func logStart(_ info: Model.Start.Info)
    // func log(_ viewModel: Model..Info)
}


final class AdminChatViewController: UIViewController,
                                     AdminChatDisplayLogic {
    // MARK: - Constants
    private enum Constants {
        static let fatalError: String = "init(coder:) has not been implemented"
    }
    
    // MARK: - Fields
    private let router: AdminChatRoutingLogic
    private let interactor: AdminChatBusinessLogic
    
    // MARK: - LifeCycle
    init(
        router: AdminChatRoutingLogic,
        interactor: AdminChatBusinessLogic
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

