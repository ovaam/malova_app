//
//  WelcomePresenter.swift
//  clinic
//
//  Created by Малова Олеся on 24.01.2025.
//

protocol WelcomePresentationLogic {
    func presentGreeting(response: Welcome.Greeting.Response)
}

final class WelcomePresenter: WelcomePresentationLogic {
    weak var view: WelcomeDisplayLogic?
    
    func presentGreeting(response: Welcome.Greeting.Response) {
        let viewModel = Welcome.Greeting.ViewModel()
        view?.displayGreeting(viewModel: viewModel)
    }
}

