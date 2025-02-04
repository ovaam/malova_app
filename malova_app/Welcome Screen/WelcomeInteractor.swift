//
//  WelcomeInteractor.swift
//  clinic
//
//  Created by Малова Олеся on 24.01.2025.
//

protocol WelcomeBusinessLogic {
    func fetchGreeting()
}

class WelcomeInteractor: WelcomeBusinessLogic {
    
    var presenter: WelcomePresentationLogic?
    
    func fetchGreeting() {
        // Логика получения данных. В нашем случае это простая заглушка.
        let response = Welcome.Greeting.Response()
        presenter?.presentGreeting(response: response)
    }
}

