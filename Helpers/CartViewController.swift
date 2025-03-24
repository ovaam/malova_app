//
//  CartViewController.swift
//  malova_app
//
//  Created by Малова Олеся on 24.03.2025.
//

import UIKit

final class CartViewController: UIViewController {
    private let tableView: UITableView = UITableView()
    private let closeButton: UIButton = UIButton(type: .system)
    private let totalView: UIView = UIView()
    private let totalLabel: UILabel = UILabel()
    private let emptyMessage: UILabel = UILabel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        
        setupTableView()
        setupCloseButton()
        setupTotalView()
        setupEmptyMessage()
        
        if Cart.shared.procedures.isEmpty {
            totalView.isHidden = true
            emptyMessage.isHidden = false
        } else {
            totalView.isHidden = false
            emptyMessage.isHidden = true
        }
    }
    
    private func setupTableView() {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cartCell")
        tableView.backgroundColor = UIColor(hex: "EAEAEA")
        tableView.separatorStyle = .none
        tableView.layer.cornerRadius = 20
        
        view.addSubview(tableView)
        
        tableView.pinTop(to: view.topAnchor, 250)
        tableView.pinLeft(to: view.leadingAnchor, 16)
        tableView.pinRight(to: view.trailingAnchor, 16)
        tableView.pinBottom(to: view.bottomAnchor, 250)
    }
    
    private func setupCloseButton() {
        closeButton.setTitle("Закрыть", for: .normal)
        closeButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        closeButton.tintColor = .black
        closeButton.backgroundColor = UIColor(hex: "EAEAEA")
        closeButton.layer.cornerRadius = 8
        closeButton.layer.masksToBounds = true
        closeButton.addTarget(self, action: #selector(closeButtonTapped), for: .touchUpInside)
        
        view.addSubview(closeButton)
        
        closeButton.pinBottom(to: view.bottomAnchor, 200)
        closeButton.pinCenterX(to: view.centerXAnchor)
        closeButton.setWidth(100)
        closeButton.setHeight(40)
    }
    
    private func setupTotalView() {
        totalView.backgroundColor = UIColor(hex: "647269")
        totalView.layer.cornerRadius = 8
        totalView.layer.masksToBounds = true
        
        view.addSubview(totalView)
        
        totalView.pinTop(to: tableView.bottomAnchor, -50)
        totalView.pinLeft(to: view.leadingAnchor, 16)
        totalView.pinRight(to: view.trailingAnchor, 16)
        totalView.setHeight(50)
        
        totalLabel.textColor = .white
        totalLabel.font = UIFont.boldSystemFont(ofSize: 18)
        totalLabel.textAlignment = .left
        totalLabel.text = "Итого: \(calculateTotal()) руб."
        
        totalView.addSubview(totalLabel)
        
        totalLabel.pinCenterX(to: totalView.centerXAnchor)
        totalLabel.pinCenterY(to: totalView.centerYAnchor)
    }
    
    private func setupEmptyMessage() {
        emptyMessage.text = "нет выбранных процедур"
        emptyMessage.textColor = .lightGray
        emptyMessage.textAlignment = .center
        
        view.addSubview(emptyMessage)
        
        emptyMessage.pinCenterY(to: view.centerYAnchor)
        emptyMessage.pinLeft(to: view.leadingAnchor, 110)
    }
        
    private func calculateTotal() -> Int {
        return Cart.shared.procedures.reduce(0) { $0 + $1.price }
    }
    
    @objc private func closeButtonTapped() {
        dismiss(animated: true, completion: nil)
    }
}

// MARK: - UITableViewDataSource
extension CartViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Cart.shared.procedures.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cartCell", for: indexPath)
        let procedure = Cart.shared.procedures[indexPath.row]
        cell.textLabel?.text = "\(procedure.name) - \(procedure.price) руб."
        cell.textLabel?.font = UIFont(name: "TimesNewRomanPSMT", size: 20)
        cell.textLabel?.textColor = UIColor(hex: "313638")
        cell.backgroundColor = UIColor(hex: "EAEAEA")
        cell.textLabel?.numberOfLines = 0
        return cell
    }
}

// MARK: - UITableViewDelegate
extension CartViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Удаляем процедуру из корзины
            Cart.shared.removeProcedure(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .automatic)
            
            // Обновляем итоговую сумму
            totalLabel.text = "Итого: \(calculateTotal()) руб."
        }
    }
    
    func tableView(_ tableView: UITableView, titleForDeleteConfirmationButtonForRowAt indexPath: IndexPath) -> String? {
        return "Удалить"
    }
}
