//
//  ProceduresViewController.swift
//  malova_app
//
//  Created by Малова Олеся on 02.03.2025.
//

import UIKit

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


final class ProceduresViewController: UIViewController,
                                      ProceduresDisplayLogic {
    // MARK: - Constants
    private enum Constants {
        static let fatalError: String = "init(coder:) has not been implemented"
    }
    
    // MARK: - Fields
    private let router: ProceduresRoutingLogic
    private let interactor: ProceduresBusinessLogic
    
    var categories: [ProcedureCategory]?
    let tableView = UITableView()
    
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
        
        view.backgroundColor = UIColor(hex: "D1F3E3")
        // Загрузка данных
        categories = loadProcedures()
        
        // Настройка таблицы
        setupTableView()
        setupLabel()
        setupGoBackButton()
    }
    
    // MARK: - Configuration
    private func setupLabel() {
        malovaLabel.textColor = .white
        malovaLabel.font = UIFont(name: "TimesNewRomanPSMT", size: 100)
        malovaLabel.text = "Malova"
        
        view.addSubview(malovaLabel)
        
        malovaLabel.pinTop(to: view.topAnchor, 10)
        malovaLabel.pinRight(to: view.trailingAnchor, 15)
        malovaLabel.pinBottom(to: view.bottomAnchor, 600)
    }
    
    private func setupGoBackButton() {
        goBackButton.setImage(UIImage(systemName: "chevron.left"), for: .normal)
        goBackButton.tintColor = .black
        
        view.addSubview(goBackButton)
        
        goBackButton.pinTop(to: view.topAnchor, 45)
        goBackButton.pinLeft(to: view.leadingAnchor, 25)
        
        goBackButton.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
    }
    
    // Настройка таблицы
    private func setupTableView() {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        
        // Добавляем таблицу в иерархию представлений
        view.addSubview(tableView)
        tableView.backgroundColor = UIColor(hex: "D1F3E3")
        
//        tableView.pinTop(to: view.topAnchor, 250)
//        tableView.pinLeft(to: view.leadingAnchor)
//        tableView.pinRight(to: view.trailingAnchor)
        
        // Устанавливаем constraints для таблицы
        tableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(lessThanOrEqualTo: view.topAnchor, constant: 250),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
        
        // Перезагружаем данные таблицы
        tableView.reloadData()
    }
    
    // Загрузка данных из JSON
    private func loadProcedures() -> [ProcedureCategory]? {
        if let url = Bundle.main.url(forResource: "procedures", withExtension: "json") {
            do {
                let data = try Data(contentsOf: url)
                let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
                
                if let sheet2 = json?["Sheet2"] as? [[String: Any]] {
                    print("Found \(sheet2.count) procedures in JSON.")
                    let proceduresData = try JSONSerialization.data(withJSONObject: sheet2, options: [])
                    let procedures = try JSONDecoder().decode([Procedure].self, from: proceduresData)
                    
                    // Группируем процедуры по типу
                    let groupedProcedures = Dictionary(grouping: procedures, by: { $0.type })
                    
                    // Сортируем секции по типу процедуры
                    let sortedCategories = groupedProcedures.map { ProcedureCategory(type: $0.key, procedures: $0.value) }
                        .sorted { $0.type < $1.type } // Сортировка по алфавиту
                    
                    // Сортируем процедуры внутри каждой секции по названию
                    var finalCategories = sortedCategories
                    for i in 0..<finalCategories.count {
                        finalCategories[i].procedures.sort { $0.name < $1.name }
                    }
                    
                    print("Created \(finalCategories.count) categories.")
                    return finalCategories
                } else {
                    print("Sheet2 not found or is not an array.")
                }
            } catch {
                print("Error decoding JSON: \(error)")
            }
        } else {
            print("JSON file not found in bundle.")
        }
        return nil
    }
    
    // MARK: - Actions
    @objc
    private func backButtonTapped() {
        router.routeToMain()
    }
    
    // MARK: - DisplayLogic
    func displayStart(_ viewModel: Model.Start.ViewModel) {
        
    }
}

extension ProceduresViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return categories?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories?[section].procedures.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        if let procedure = categories?[indexPath.section].procedures[indexPath.row] {
            cell.textLabel?.text = procedure.name
            cell.backgroundColor = UIColor(hex: "D1F3E3")
            cell.textLabel?.textColor = UIColor(hex: "313638")
            cell.textLabel?.font = UIFont(name: "HelveticaNeue-Medium", size: 16)
            cell.textLabel?.textAlignment = .center
        }
        return cell
    }
}

extension ProceduresViewController: UITableViewDelegate {
    // Кастомный заголовок секции
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView()
        headerView.backgroundColor = UIColor(hex: "D1F3E3")
        
        let label = UILabel()
        label.text = categories?[section].type
        label.textColor = UIColor(hex: "313638")
        
        label.font = UIFont(name: "HelveticaNeue-Medium", size: 24)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        
        headerView.addSubview(label)
        
        // Добавляем constraints для label
        NSLayoutConstraint.activate([
            label.leadingAnchor.constraint(equalTo: headerView.leadingAnchor, constant: 16),
            label.trailingAnchor.constraint(equalTo: headerView.trailingAnchor, constant: -16),
            label.topAnchor.constraint(equalTo: headerView.topAnchor, constant: 8),
            label.bottomAnchor.constraint(equalTo: headerView.bottomAnchor, constant: -8)
        ])
        
        return headerView
    }
    
    // Высота заголовка секции
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }
    
    // Обработка нажатия на ячейку
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let procedure = categories?[indexPath.section].procedures[indexPath.row] {
            
            let detailVC = DetailAboutProcedureViewController()
            detailVC.procedure = procedure
            
            detailVC.modalPresentationStyle = .overCurrentContext
            detailVC.modalTransitionStyle = .crossDissolve
            
            present(detailVC, animated: true, completion: nil)
        }
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
        containerView.backgroundColor = UIColor(hex: "63917B")
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
