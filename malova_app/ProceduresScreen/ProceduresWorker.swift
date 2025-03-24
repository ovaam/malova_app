//
//  ProceduresWorker.swift
//  malova_app
//
//  Created by Малова Олеся on 25.03.2025.
//
import UIKit
import FirebaseFirestore
import FirebaseAuth

protocol ProceduresWorkerProtocol {
    var cachedCategories: [ProcedureCategory] { get }
    func fetchProcedures(completion: @escaping (Result<[Procedure], Error>) -> Void)
    func filterProcedures(searchText: String, categories: [ProcedureCategory], completion: @escaping (Result<[ProcedureCategory], Error>) -> Void)
}

final class ProceduresWorker: ProceduresWorkerProtocol {
    private let db = Firestore.firestore()
    private(set) var cachedCategories: [ProcedureCategory] = []
    
    func fetchProcedures(completion: @escaping (Result<[Procedure], Error>) -> Void) {
        db.collection("procedures").getDocuments { snapshot, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let documents = snapshot?.documents else {
                completion(.success([]))
                return
            }
            
            let procedures = documents.compactMap { document -> Procedure? in
                let data = document.data()
                guard let type = data["type"] as? String,
                      let name = data["name"] as? String,
                      let performer = data["performer"] as? String,
                      let price = data["price"] as? Int,
                      let duration = data["duration"] as? String else {
                    return nil
                }
                return Procedure(type: type, performer: performer, name: name, price: price, duration: duration)
            }
            
            completion(.success(procedures))
        }
    }
    
    func filterProcedures(searchText: String, categories: [ProcedureCategory], completion: @escaping (Result<[ProcedureCategory], Error>) -> Void) {
        if searchText.isEmpty {
            completion(.success(categories))
            return
        }
        
        let filtered = categories.compactMap { category in
            let filteredProcedures = category.procedures.filter {
                $0.name.localizedCaseInsensitiveContains(searchText) ||
                $0.type.localizedCaseInsensitiveContains(searchText)
            }
            return filteredProcedures.isEmpty ? nil : ProcedureCategory(type: category.type, procedures: filteredProcedures)
        }
        
        completion(.success(filtered))
    }
}
