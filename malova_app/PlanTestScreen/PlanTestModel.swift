//
//  PlanTestModel.swift
//  malova_app
//
//  Created by Малова Олеся on 25.03.2025.
//

import UIKit

enum PlanTestModel {
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
enum TestType {
    case face
    case body
}

enum FaceQuestion: Int, CaseIterable {
    case wrinkles = 0
    case pigmentation
    case dryness
    case blackheads
    case doubleChin
    case nasolabialFolds
    case skinLaxity
    case darkCircles
    
    var questionText: String {
        switch self {
        case .wrinkles: return "У вас есть мимические морщины?"
        case .pigmentation: return "У вас есть пигментные пятна на лице?"
        case .dryness: return "У вас есть сухость кожи?"
        case .blackheads: return "У вас есть черные точки на лице?"
        case .doubleChin: return "У вас есть второй подбородок?"
        case .nasolabialFolds: return "У вас есть носогубные морщины?"
        case .skinLaxity: return "У вас есть дряблость кожи?"
        case .darkCircles: return "У вас есть синяки или отёки под глазами?"
        }
    }
    
    func proceduresForAnswer(_ answer: Bool) -> [String] {
        switch self {
        case .wrinkles:
            return answer ? ["Микро токи", "Диспорт"] : ["Уходовые процедуры"]
        case .pigmentation:
            return answer ? ["Фототерапия", "Крем с SPF утром", "Отбеливающий крем на ночь"] : ["Уходовые процедуры"]
        case .dryness:
            return answer ? ["Биоревитализация", "Питательный крем на ночь", "Увлажняющий крем утром", "Пилинги"] : []
        case .blackheads:
            return answer ? ["Чистка лица", "Пилинги"] : ["Уходовые процедуры"]
        case .doubleChin:
            return answer ? ["Массаж", "Липолитики", "Микротоковая терапия"] : []
        case .nasolabialFolds:
            return answer ? ["Филлеры"] : []
        case .skinLaxity:
            return answer ? ["Коллагенотерапия", "RF лифтинг", "Введение полимолочной кислоты"] : []
        case .darkCircles:
            return answer ? ["Микро токи", "Коллагенотерапия", "Мезотерапия"] : []
        }
    }
}

enum BodyQuestion: Int, CaseIterable {
    case pigmentation = 0
    case stretchMarks
    case excessWeight
    case bodySkinLaxity
    
    var questionText: String {
        switch self {
        case .pigmentation: return "У вас есть пигментные пятна на теле?"
        case .stretchMarks: return "У вас есть растяжки?"
        case .excessWeight: return "У вас есть лишний вес?"
        case .bodySkinLaxity: return "У вас есть дряблость кожи (колени, локти, живот, внутренняя поверхность бёдер или рук)?"
        }
    }
    
    func proceduresForAnswer(_ answer: Bool) -> [String] {
        switch self {
        case .pigmentation:
            return answer ? ["Фото лечение", "Крем с SPF"] : []
        case .stretchMarks:
            return answer ? ["Коллагенотерапия", "RF лифтинг", "Инъекции Полимолочной кислоты", "Инъекции Гиалуроновой кислоты"] : []
        case .excessWeight:
            return answer ? ["Диета", "Спорт", "Антицеллюлитный массаж", "Введение липолитиков"] : []
        case .bodySkinLaxity:
            return answer ? ["Инъекции гиалуроновой кислоты", "RF лифтинг", "Инъекции полимолочной кислоты"] : []
        }
    }
}
