//
//  SettingsModel.swift
//  malova_app
//
//  Created by Малова Олеся on 28.02.2025.
//

import UIKit

enum SettingsModel {
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

enum Section: Int, CaseIterable {
    case account
    case actions
    
    var title: String {
        switch self {
        case .account: return "Изменить данные учетной записи"
        case .actions: return "Действия"
        }
    }
    
    var rows: [Row] {
        switch self {
        case .account:
            return [.name, .age, .changePassword]
        case .actions:
            return [.logOut, .deleteAccount]
        }
    }
}

enum Row: Int, CaseIterable {
    case name
    case age
    case changePassword
    case logOut
    case deleteAccount
    
    var title: String {
        switch self {
        case .name: return "Имя"
        case .age: return "Возраст"
        case .changePassword: return "Сменить пароль"
        case .logOut: return "Выйти из аккаунта"
        case .deleteAccount: return "Удалить аккаунт"
        }
    }
}
