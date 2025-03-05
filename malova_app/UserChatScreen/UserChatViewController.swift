//
//  ChatViewController.swift
//  malova_app
//
//  Created by Малова Олеся on 05.03.2025.
//

import UIKit

protocol ChatDisplayLogic: AnyObject {
    typealias Model = ChatModel
    func displayStart(_ viewModel: Model.Start.ViewModel)
    // func display(_ viewModel: Model..ViewModel)
}

protocol Analitics: AnyObject {
    typealias Model = ChatModel
    func logStart(_ info: Model.Start.Info)
    // func log(_ viewModel: Model..Info)
}


final class ChatViewController: UIViewController,
                            ChatDisplayLogic {
    // MARK: - Constants
    private enum Constants {
        static let fatalError: String = "init(coder:) has not been implemented"
    }
    
    // MARK: - Fields
    private let router: ChatRoutingLogic
    private let interactor: ChatBusinessLogic
    
    // MARK: - LifeCycle
    init(
        router: ChatRoutingLogic,
        interactor: ChatBusinessLogic
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

