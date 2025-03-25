//
//  ChatPresenter.swift
//  malova_app
//
//  Created by Малова Олеся on 05.03.2025.
//

import UIKit

protocol UserChatPresentationLogic {
    func presentMessages(response: UserChatModel.LoadMessages.Response)
    func presentMessageSent(response: UserChatModel.SendMessage.Response)
    func presentChatCreated(response: UserChatModel.CreateChat.Response)
    func presentError(error: Error)
}

final class UserChatPresenter: UserChatPresentationLogic {
    weak var view: UserChatDisplayLogic?
    
    // MARK: - PresentationLogic
    func presentMessages(response: UserChatModel.LoadMessages.Response) {
        let groupedMessages = groupMessagesByDate(response.messages)
        let viewModel = UserChatModel.LoadMessages.ViewModel(messageGroups: groupedMessages)
        view?.displayMessages(viewModel: viewModel)
    }
        
    func presentMessageSent(response: UserChatModel.SendMessage.Response) {
        view?.displayMessageSent()
    }
        
    func presentChatCreated(response: UserChatModel.CreateChat.Response) {
        let viewModel = UserChatModel.CreateChat.ViewModel(chatId: response.chatId)
        view?.displayChatCreated(viewModel: viewModel)
    }
        
    func presentError(error: Error) {
        view?.displayError(message: error.localizedDescription)
    }
        
    private func groupMessagesByDate(_ messages: [Message]) -> [MessageGroup] {
        let grouped = Dictionary(grouping: messages) { Calendar.current.startOfDay(for: $0.timestamp) }
        return grouped.map { MessageGroup(date: $0.key, messages: $0.value) }
            .sorted { $0.date < $1.date }
    }
}
