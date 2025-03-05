//
//  AdminChatListModel.swift
//  malova_app
//
//  Created by Малова Олеся on 05.03.2025.
//

import UIKit

enum AdminChatListModel {
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

struct Chat {
    let chatId: String
    let userId: String
    let userFullName: String
}
