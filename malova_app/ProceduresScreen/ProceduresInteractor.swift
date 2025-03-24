//
//  ProceduresInteractor.swift
//  malova_app
//
//  Created by Малова Олеся on 02.03.2025.
//

import UIKit

protocol ProceduresBusinessLogic {
    func loadProcedures(request: ProceduresModel.LoadProcedures.Request)
    func filterProcedures(request: ProceduresModel.FilterProcedures.Request)
}

final class ProceduresInteractor: ProceduresBusinessLogic {
    // MARK: - Fields
    private let presenter: ProceduresPresentationLogic
    private let worker: ProceduresWorkerProtocol
    
    // MARK: - Lifecycle
    init(presenter: ProceduresPresentationLogic, worker: ProceduresWorkerProtocol = ProceduresWorker()) {
        self.presenter = presenter
        self.worker = worker
    }
    
    // MARK: - BusinessLogic
    func loadProcedures(request: ProceduresModel.LoadProcedures.Request) {
        worker.fetchProcedures { [weak self] result in
            switch result {
            case .success(let procedures):
                let grouped = Dictionary(grouping: procedures, by: { $0.type })
                let categories = grouped.map { ProcedureCategory(type: $0.key, procedures: $0.value) }
                    .sorted { $0.type < $1.type }
                
                let response = ProceduresModel.LoadProcedures.Response(categories: categories)
                self?.presenter.presentProcedures(response: response)
            case .failure(let error):
                self?.presenter.presentError(error: error)
            }
        }
    }
        
    func filterProcedures(request: ProceduresModel.FilterProcedures.Request) {
        worker.filterProcedures(
            searchText: request.searchText,
            categories: worker.cachedCategories
        ) { [weak self] result in
            switch result {
            case .success(let filteredCategories):
                let response = ProceduresModel.FilterProcedures.Response(filteredCategories: filteredCategories)
                self?.presenter.presentFilteredProcedures(response: response)
            case .failure(let error):
                self?.presenter.presentError(error: error)
            }
        }
    }
}
