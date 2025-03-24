//
//  ChatInteractor.swift
//  malova_app
//
//  Created by Малова Олеся on 05.03.2025.
//

import UIKit

protocol UserChatBusinessLogic {
    func loadMessages(request: UserChatModel.LoadMessages.Request)
    func sendMessage(request: UserChatModel.SendMessage.Request)
    func createOrLoadChat(request: UserChatModel.CreateChat.Request)
}

final class UserChatInteractor: UserChatBusinessLogic {
    // MARK: - Fields
    private let presenter: UserChatPresentationLogic
    private let worker: UserChatWorkerProtocol
    
    // MARK: - Lifecycle
    init(presenter: UserChatPresentationLogic, worker: UserChatWorkerProtocol = UserChatWorker()) {
        self.presenter = presenter
        self.worker = worker
    }
    
    // MARK: - BusinessLogic
    func loadMessages(request: UserChatModel.LoadMessages.Request) {
        worker.loadMessages(chatId: request.chatId) { [weak self] result in
            switch result {
            case .success(let messages):
                let response = UserChatModel.LoadMessages.Response(messages: messages)
                self?.presenter.presentMessages(response: response)
            case .failure(let error):
                self?.presenter.presentError(error: error)
            }
        }
    }
        
    func sendMessage(request: UserChatModel.SendMessage.Request) {
        worker.sendMessage(
            chatId: request.chatId,
            text: request.text,
            senderId: request.senderId
        ) { [weak self] result in
            switch result {
            case .success:
                let response = UserChatModel.SendMessage.Response()
                self?.presenter.presentMessageSent(response: response)
            case .failure(let error):
                self?.presenter.presentError(error: error)
            }
        }
    }
        
    func createOrLoadChat(request: UserChatModel.CreateChat.Request) {
        worker.createOrLoadChat(
            userId: request.userId,
            adminId: request.adminId
        ) { [weak self] result in
            switch result {
            case .success(let chatId):
                let response = UserChatModel.CreateChat.Response(chatId: chatId)
                self?.presenter.presentChatCreated(response: response)
            case .failure(let error):
                self?.presenter.presentError(error: error)
            }
        }
    }
}
