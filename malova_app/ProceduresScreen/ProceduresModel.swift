//
//  ProceduresModel.swift
//  malova_app
//
//  Created by Малова Олеся on 02.03.2025.
//

import UIKit

enum ProceduresModel {
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
struct Procedure: Codable {
    let type: String
    let performer: String
    let name: String
    let price: Int
    let duration: String
    
    // Используем CodingKeys для соответствия ключей в JSON и свойств структуры
    enum CodingKeys: String, CodingKey {
        case type = "Тип процедуры"
        case performer = "процедуру выполняет:"
        case name = "Наименование"
        case price = "Цена(руб)"
        case duration = "Время"
    }
}

struct ProcedureCategory {
    let type: String
    var procedures: [Procedure]
}
