//
//  WelcomeInteractor.swift
//  clinic
//
//  Created by Малова Олеся on 24.01.2025.
//

protocol WelcomeBusinessLogic {
    func fetchGreeting()
}

final class WelcomeInteractor: WelcomeBusinessLogic {
    private let presenter: WelcomePresentationLogic
    
    init(presenter: WelcomePresentationLogic) {
        self.presenter = presenter
    }
    
    func fetchGreeting() {
        // Логика получения данных. В нашем случае это простая заглушка.
        let response = Welcome.Greeting.Response()
        presenter.presentGreeting(response: response)
    }
}

