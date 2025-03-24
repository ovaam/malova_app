//
//  ProceduresModel.swift
//  malova_app
//
//  Created by Малова Олеся on 02.03.2025.
//

import UIKit

enum ProceduresModel {
    struct LoadProcedures {
        struct Request {}
        struct Response {
            let categories: [ProcedureCategory]
        }
        struct ViewModel {
            let categories: [ProcedureCategory]
        }
    }
    
    struct FilterProcedures {
        struct Request {
            let searchText: String
        }
        struct Response {
            let filteredCategories: [ProcedureCategory]
        }
        struct ViewModel {
            let filteredCategories: [ProcedureCategory]
        }
    }
}

struct Procedure {
    let type: String
    let performer: String
    let name: String
    let price: Int
    let duration: String
}

struct ProcedureCategory {
    let type: String
    let procedures: [Procedure]
}
