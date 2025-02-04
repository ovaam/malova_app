//
//  WelcomePresenter.swift
//  clinic
//
//  Created by Малова Олеся on 24.01.2025.
//

protocol WelcomePresentationLogic {
    func presentGreeting(response: Welcome.Greeting.Response)
}

class WelcomePresenter: WelcomePresentationLogic {

    weak var viewController: WelcomeDisplayLogic?
    
    func presentGreeting(response: Welcome.Greeting.Response) {
        let viewModel = Welcome.Greeting.ViewModel()
        viewController?.displayGreeting(viewModel: viewModel)
    }
}

