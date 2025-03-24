//
//  ChatModel.swift
//  malova_app
//
//  Created by Малова Олеся on 05.03.2025.
//
import UIKit

enum UserChatModel {
    struct LoadMessages {
        struct Request {
            let chatId: String
        }
        struct Response {
            let messages: [Message]
        }
        struct ViewModel {
            let messageGroups: [MessageGroup]
        }
    }
    
    struct SendMessage {
        struct Request {
            let chatId: String
            let text: String
            let senderId: String
        }
        struct Response {}
        struct ViewModel {}
    }
    
    struct CreateChat {
        struct Request {
            let userId: String
            let adminId: String
        }
        struct Response {
            let chatId: String
        }
        struct ViewModel {
            let chatId: String
        }
    }
    
    struct Error {
        struct ViewModel {
            let message: String
        }
    }
}

struct Message {
    let senderId: String
    let text: String
    let timestamp: Date
}

struct MessageGroup {
    let date: Date
    let messages: [Message]
}
