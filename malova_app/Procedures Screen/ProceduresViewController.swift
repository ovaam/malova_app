//
//  ProceduresViewController.swift
//  malova_app
//
//  Created by Малова Олеся on 02.03.2025.
//

import UIKit
import FirebaseFirestore

protocol ProceduresDisplayLogic: AnyObject {
    typealias Model = ProceduresModel
    func displayStart(_ viewModel: Model.Start.ViewModel)
    // func display(_ viewModel: Model..ViewModel)
}

protocol ProceduresAnalitics: AnyObject {
    typealias Model = ProceduresModel
    func logStart(_ info: Model.Start.Info)
    // func log(_ viewModel: Model..Info)
}

final class ProceduresViewController: UIViewController, ProceduresDisplayLogic {
    // MARK: - Constants
    private enum Constants {
        static let fatalError: String = "init(coder:) has not been implemented"
        static let cellIdentifier: String = "cell"
        static let collectionName: String = "procedures"
    }
    
    // MARK: - Fields
    private let router: ProceduresRoutingLogic
    private let interactor: ProceduresBusinessLogic
    private let db = Firestore.firestore()
    
    var categories: [ProcedureCategory]?
    var filteredCategories: [ProcedureCategory]? // Для фильтрации
    let tableView = UITableView()
    private let searchBar = UISearchBar() // Поле для поиска
    
    private let malovaLabel: UILabel = UILabel()
    private let goBackButton: UIButton = UIButton()
    
    // MARK: - LifeCycle
    init(
        router: ProceduresRoutingLogic,
        interactor: ProceduresBusinessLogic
    ) {
        self.router = router
        self.interactor = interactor
        super.init(nibName: nil, bundle: nil)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError(Constants.fatalError)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        interactor.loadStart(Model.Start.Request())
        
        view.backgroundColor = UIColor(hex: "EAEAEA")
        
        setupLabel()
        setupSearchBar()
        setupTableView()
        setupGoBackButton()
        
        // Загружаем данные из Firestore
        loadProceduresFromFirestore()
    }
    
    // MARK: - Configuration
    private func setupLabel() {
        malovaLabel.textColor = .white
        malovaLabel.font = UIFont(name: "TimesNewRomanPSMT", size: 100)
        malovaLabel.text = "Malova"
        
        view.addSubview(malovaLabel)
        
        malovaLabel.pinTop(to: view.topAnchor, 80)
        malovaLabel.pinRight(to: view.trailingAnchor, 15)
        //malovaLabel.pinBottom(to: view.bottomAnchor, 600)
    }
    
    private func setupGoBackButton() {
        goBackButton.setImage(UIImage(systemName: "chevron.left"), for: .normal)
        goBackButton.tintColor = .black
        
        view.addSubview(goBackButton)
        
        goBackButton.pinTop(to: view.topAnchor, 45)
        goBackButton.pinLeft(to: view.leadingAnchor, 25)
        
        goBackButton.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
    }
    
    // Настройка поиска
    private func setupSearchBar() {
        searchBar.placeholder = "Поиск процедуры"
        searchBar.delegate = self
        searchBar.barTintColor = UIColor(hex: "EAEAEA")
        searchBar.searchTextField.backgroundColor = UIColor.white.withAlphaComponent(0.3)
        
        view.addSubview(searchBar)
        
        searchBar.pinTop(to: malovaLabel.bottomAnchor)
        searchBar.pinLeft(to: view.leadingAnchor)
        searchBar.pinRight(to: view.trailingAnchor)
    }
    
    // Настройка таблицы
    private func setupTableView() {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: Constants.cellIdentifier)
        
        view.addSubview(tableView)
        tableView.backgroundColor = UIColor(hex: "EAEAEA")
        
        tableView.pinTop(to: searchBar.bottomAnchor)
        tableView.pinLeft(to: view.leadingAnchor)
        tableView.pinRight(to: view.trailingAnchor)
        tableView.pinBottom(to: view.bottomAnchor)
    }
    
    // Загрузка данных из Firestore
    private func loadProceduresFromFirestore() {
        db.collection(Constants.collectionName).getDocuments { [weak self] snapshot, error in
            guard let self = self else { return }
            
            if let error = error {
                print("Ошибка загрузки процедур: \(error.localizedDescription)")
                return
            }
            
            guard let documents = snapshot?.documents else {
                print("Документы не найдены")
                return
            }
            
            // Преобразуем документы в массив процедур
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
            
            // Группируем процедуры по типу
            let groupedProcedures = Dictionary(grouping: procedures, by: { $0.type })
            
            // Создаем категории
            self.categories = groupedProcedures.map { ProcedureCategory(type: $0.key, procedures: $0.value) }
                .sorted { $0.type < $1.type } // Сортировка по алфавиту
            
            // Сортируем процедуры внутри каждой категории
            for i in 0..<(self.categories?.count ?? 0) {
                self.categories?[i].procedures.sort { $0.name < $1.name }
            }
            
            // Сохраняем отфильтрованные данные
            self.filteredCategories = self.categories
            
            // Обновляем таблицу
            self.tableView.reloadData()
        }
    }
    
    // Фильтрация данных
    private func filterProcedures(with searchText: String) {
        if searchText.isEmpty {
            filteredCategories = categories
        } else {
            filteredCategories = categories?.compactMap { category in
                let filteredProcedures = category.procedures.filter {
                    $0.name.localizedCaseInsensitiveContains(searchText) ||
                    $0.type.localizedCaseInsensitiveContains(searchText)
                }
                return filteredProcedures.isEmpty ? nil : ProcedureCategory(type: category.type, procedures: filteredProcedures)
            }
        }
        tableView.reloadData()
    }
    
    // MARK: - Actions
    @objc
    private func backButtonTapped() {
        router.routeToMain()
    }
    
    // MARK: - DisplayLogic
    func displayStart(_ viewModel: Model.Start.ViewModel) {
        // Обработка данных для отображения
    }
}

// MARK: - UITableViewDataSource
extension ProceduresViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return filteredCategories?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredCategories?[section].procedures.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.cellIdentifier, for: indexPath)
        if let procedure = filteredCategories?[indexPath.section].procedures[indexPath.row] {
            cell.textLabel?.text = procedure.name
            cell.backgroundColor = UIColor(hex: "EAEAEA")
            cell.textLabel?.textColor = UIColor(hex: "313638")
            cell.textLabel?.font = UIFont(name: "TimesNewRomanPSMT", size: 16)
            cell.textLabel?.textAlignment = .left // Выравнивание текста справа
        }
        return cell
    }
}

// MARK: - UITableViewDelegate
extension ProceduresViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView()
        headerView.backgroundColor = UIColor(hex: "EAEAEA")
        
        let label = UILabel()
        label.text = filteredCategories?[section].type
        label.textColor = UIColor(hex: "313638")
        label.font = UIFont(name: "TimesNewRomanPSMT", size: 24)
        label.textAlignment = .left
        label.translatesAutoresizingMaskIntoConstraints = false
        
        headerView.addSubview(label)
        
        NSLayoutConstraint.activate([
            label.leadingAnchor.constraint(equalTo: headerView.leadingAnchor, constant: 16),
            label.trailingAnchor.constraint(equalTo: headerView.trailingAnchor, constant: -16),
            label.topAnchor.constraint(equalTo: headerView.topAnchor, constant: 8),
            label.bottomAnchor.constraint(equalTo: headerView.bottomAnchor, constant: -8)
        ])
        
        return headerView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let procedure = filteredCategories?[indexPath.section].procedures[indexPath.row] {
            let detailVC = DetailAboutProcedureViewController()
            detailVC.procedure = procedure
            
            detailVC.modalPresentationStyle = .overCurrentContext
            detailVC.modalTransitionStyle = .crossDissolve
            
            present(detailVC, animated: true, completion: nil)
        }
    }
}

// MARK: - UISearchBarDelegate
extension ProceduresViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        filterProcedures(with: searchText)
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder() // Скрываем клавиатуру
    }
}

class DetailAboutProcedureViewController: UIViewController {
    
    var procedure: Procedure?
    
    private let containerView: UIView = UIView()
    private let titleLabel: UILabel = UILabel()
    private let infoLabel: UILabel = UILabel()
    private let closeButton: UIButton = UIButton(type: .system)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Настройка фона с размытием
        view.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        
        setupContainerView()
        setupLable()
        setupInfoLabel()
        setupCloseButton()
        
        if let procedure = procedure {
            infoLabel.text = """
            \(procedure.type)
            Названние: \(procedure.name)
            Исполнитель: \(procedure.performer)
            Цена: \(procedure.price) руб.
            Время: \(procedure.duration)
            """
        }
        closeButton.addTarget(self, action: #selector(closeButtonTapped), for: .touchUpInside)
    }
    
    private func setupContainerView() {
        containerView.backgroundColor = UIColor(hex: "647269")
        containerView.layer.cornerRadius = 12
        containerView.layer.masksToBounds = true
        
        view.addSubview(containerView)
        
        containerView.pinCenterX(to: view.centerXAnchor)
        containerView.pinCenterY(to: view.centerYAnchor)
        containerView.setWidth(300)
        containerView.setHeight(250)
    }
    
    private func setupLable() {
        titleLabel.textColor = .white
        titleLabel.text = "Информация о процедуре"
        titleLabel.font = UIFont.boldSystemFont(ofSize: 20)
        titleLabel.textAlignment = .center
        
        containerView.addSubview(titleLabel)
        
        titleLabel.pinTop(to: containerView.topAnchor, 16)
        titleLabel.pinLeft(to: containerView.leadingAnchor, 16)
        titleLabel.pinRight(to: containerView.trailingAnchor, 16)
    }
    
    private func setupInfoLabel() {
        infoLabel.textColor = .white
        infoLabel.numberOfLines = 0
        infoLabel.textAlignment = .center
        infoLabel.font = UIFont.systemFont(ofSize: 16)
        
        containerView.addSubview(infoLabel)
        
        infoLabel.pinTop(to: titleLabel.bottomAnchor, 16)
        infoLabel.pinLeft(to: containerView.leadingAnchor, 16)
        infoLabel.pinRight(to: containerView.trailingAnchor, 16)
    }
    
    private func setupCloseButton() {
        closeButton.tintColor = .black
        closeButton.setTitle("Закрыть", for: .normal)
        closeButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        
        containerView.addSubview(closeButton)
        
        closeButton.pinBottom(to: containerView.bottomAnchor, 16)
        closeButton.pinCenterX(to: containerView.centerXAnchor)
    }
    
    @objc private func closeButtonTapped() {
        dismiss(animated: true, completion: nil)
    }
}
