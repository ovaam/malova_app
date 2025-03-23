//
//  ChatModel.swift
//  malova_app
//
//  Created by Малова Олеся on 05.03.2025.
//
import UIKit

enum UserChatModel {
    enum Start {
        struct Request { }
        struct Response { }
        struct ViewModel { }
        struct Info { }
    }
    
    //    enum Other {
    //        struct Request { }
    //        struct Response { }
    //        struct ViewModel { }
    //        struct Info { }
    //    }
}

// MARK: - Message Model
struct Message {
    let senderId: String
    let text: String
    let timestamp: Date
}

struct MessageGroup {
    let date: Date
    let messages: [Message]
}
