//
//  ProceduresViewController.swift
//  malova_app
//
//  Created by Малова Олеся on 02.03.2025.
//

import UIKit
import FirebaseFirestore

protocol ProceduresDisplayLogic: AnyObject {
    func displayProcedures(viewModel: ProceduresModel.LoadProcedures.ViewModel)
    func displayFilteredProcedures(viewModel: ProceduresModel.FilterProcedures.ViewModel)
    func displayError(message: String)
}

final class ProceduresViewController: UIViewController, ProceduresDisplayLogic {
    // MARK: - Constants
    private enum Constants {
        static let fatalError: String = "init(coder:) has not been implemented"
        static let cellIdentifier: String = "cell"
        static let collectionName: String = "procedures"
        
        static let backgroundColor: UIColor = UIColor(hex: "EAEAEA") ?? UIColor()
        static let textColor: UIColor = UIColor(hex: "313638") ?? UIColor()
        static let buttonColor: UIColor = UIColor(hex: "647269") ?? UIColor()
        static let searchFieldBackground: UIColor = UIColor.white.withAlphaComponent(0.3)
        
        static let labelFont: UIFont = UIFont(name: "TimesNewRomanPSMT", size: 100) ?? UIFont()
        static let headerFont: UIFont = UIFont(name: "TimesNewRomanPSMT", size: 30) ?? UIFont()
        static let cellFont: UIFont = UIFont(name: "TimesNewRomanPSMT", size: 20) ?? UIFont()
        static let searchFont: UIFont = UIFont(name: "TimesNewRomanPSMT", size: 16) ?? UIFont()
        static let cartButtonFont: UIFont = UIFont(name: "TimesNewRomanPSMT", size: 15) ?? UIFont()
        
        static let labelText: String = "Malova"
        static let searchPlaceholder: String = "Поиск процедуры"
        static let cartButtonTitle: String = "Корзина"
        static let backButtonImageName: String = "chevron.left"
        
        static let labelTop: Double = 80
        static let labelRight: Double = 15
        
        static let backButtonTop: Double = 45
        static let backButtonLeft: Double = 25
        
        static let cartButtonTop: Double = 10
        static let cartButtonRight: Double = 25
        static let cartButtonHeight: Double = 20
        static let cartButtonWidth: Double = 100
        static let cartButtonCornerRadius: Double = 10
        
        static let headerHeight: Double = 50
        static let headerTop: Double = 8
        static let headerBottom: Double = 8
        static let headerLeft: Double = 16
        static let headerRight: Double = 16
    }
    
    // MARK: - Fields
    private let router: ProceduresRoutingLogic
    private let interactor: ProceduresBusinessLogic
    private let db = Firestore.firestore()
    
    var categories: [ProcedureCategory]?
    var filteredCategories: [ProcedureCategory]?
    let tableView = UITableView()
    private let searchBar = UISearchBar()
    
    private let malovaLabel: UILabel = UILabel()
    private let goBackButton: UIButton = UIButton()
    private let cartButton: UIButton = UIButton()
    
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
        setupUI()
        loadProcedures()
    }
    
    // MARK: - Configuration
    private func setupUI() {
        view.backgroundColor = Constants.backgroundColor
        
        setupLabel()
        setupCartButton()
        setupSearchBar()
        setupTableView()
        setupGoBackButton()
    }
    
    private func setupLabel() {
        malovaLabel.textColor = .white
        malovaLabel.font = Constants.labelFont
        malovaLabel.text = Constants.labelText
        
        view.addSubview(malovaLabel)
        
        malovaLabel.pinTop(to: view.topAnchor, Constants.labelTop)
        malovaLabel.pinRight(to: view.trailingAnchor, Constants.labelRight)
    }
    
    private func setupGoBackButton() {
        goBackButton.setImage(UIImage(systemName: Constants.backButtonImageName), for: .normal)
        goBackButton.tintColor = .black
        
        view.addSubview(goBackButton)
        
        goBackButton.pinTop(to: view.topAnchor, Constants.backButtonTop)
        goBackButton.pinLeft(to: view.leadingAnchor, Constants.backButtonLeft)
        
        goBackButton.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
    }
    
    private func setupSearchBar() {
        searchBar.placeholder = Constants.searchPlaceholder
        searchBar.delegate = self
        searchBar.barTintColor = Constants.backgroundColor
        searchBar.searchTextField.font = Constants.searchFont
        searchBar.searchTextField.backgroundColor = Constants.searchFieldBackground
        
        view.addSubview(searchBar)
        
        searchBar.pinTop(to: cartButton.bottomAnchor)
        searchBar.pinLeft(to: view.leadingAnchor)
        searchBar.pinRight(to: view.trailingAnchor)
    }
    
    private func setupTableView() {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: Constants.cellIdentifier)
        
        view.addSubview(tableView)
        tableView.backgroundColor = Constants.backgroundColor
        tableView.separatorStyle = .none
        
        tableView.pinTop(to: searchBar.bottomAnchor)
        tableView.pinLeft(to: view.leadingAnchor)
        tableView.pinRight(to: view.trailingAnchor)
        tableView.pinBottom(to: view.bottomAnchor)
    }
    
    private func setupCartButton() {
        cartButton.setTitle(Constants.cartButtonTitle, for: .normal)
        cartButton.titleLabel?.font = Constants.cartButtonFont
        cartButton.tintColor = Constants.textColor
        cartButton.backgroundColor = Constants.buttonColor
        cartButton.layer.cornerRadius = Constants.cartButtonCornerRadius
        cartButton.addTarget(self, action: #selector(cartButtonTapped), for: .touchUpInside)
        
        view.addSubview(cartButton)
        
        cartButton.pinTop(to: malovaLabel.bottomAnchor, Constants.cartButtonTop)
        cartButton.pinRight(to: view.trailingAnchor, Constants.cartButtonRight)
        cartButton.setHeight(Constants.cartButtonHeight)
        cartButton.setWidth(Constants.cartButtonWidth)
    }
    
    private func loadProcedures() {
        let request = ProceduresModel.LoadProcedures.Request()
        interactor.loadProcedures(request: request)
    }
    
    // MARK: - Actions
    @objc private func backButtonTapped() {
        router.routeToMain()
    }
    
    @objc private func cartButtonTapped() {
        router.routeToCart()
    }

    // MARK: - DisplayLogic
    func displayProcedures(viewModel: ProceduresModel.LoadProcedures.ViewModel) {
        categories = viewModel.categories
        filteredCategories = viewModel.categories
        tableView.reloadData()
    }
        
    func displayFilteredProcedures(viewModel: ProceduresModel.FilterProcedures.ViewModel) {
        filteredCategories = viewModel.filteredCategories
        tableView.reloadData()
    }
        
    func displayError(message: String) {
        print(message)
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
            cell.backgroundColor = Constants.backgroundColor
            cell.textLabel?.textColor = Constants.textColor
            cell.textLabel?.font = Constants.cellFont
            cell.textLabel?.textAlignment = .left
        }
        return cell
    }
}

// MARK: - UITableViewDelegate
extension ProceduresViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView()
        headerView.backgroundColor = Constants.backgroundColor
        
        let label = UILabel()
        label.text = filteredCategories?[section].type
        label.textColor = Constants.textColor
        label.font = Constants.headerFont
        label.textAlignment = .left
        
        headerView.addSubview(label)
        
        label.pinLeft(to: headerView.leadingAnchor, Constants.headerLeft)
        label.pinRight(to: headerView.trailingAnchor, Constants.headerRight)
        label.pinTop(to: headerView.topAnchor, Constants.headerTop)
        label.pinBottom(to: headerView.bottomAnchor, Constants.headerBottom)
        
        return headerView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return Constants.headerHeight
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let procedure = filteredCategories?[indexPath.section].procedures[indexPath.row] {
            router.routeToProcedureDetail(procedure: procedure)
        }
    }
}

// MARK: - UISearchBarDelegate
extension ProceduresViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        let request = ProceduresModel.FilterProcedures.Request(searchText: searchText)
        interactor.filterProcedures(request: request)
    }
        
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
}
