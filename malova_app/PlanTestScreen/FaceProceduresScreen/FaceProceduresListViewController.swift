//
//  FaceProceduresListViewController.swift
//  malova_app
//
//  Created by Малова Олеся on 07.04.2025.
//
import UIKit

class ProceduresListViewController: UITableViewController {
    
    var procedures: [FaceProcedure] = []
    var zoneName: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
    }
    
    private func setupTableView() {
        title = zoneName
        tableView.register(ProcedureCell.self, forCellReuseIdentifier: "ProcedureCell")
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 80
        tableView.separatorInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return procedures.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ProcedureCell", for: indexPath) as! ProcedureCell
        let procedure = procedures[indexPath.row]
        cell.configure(with: procedure)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let procedure = procedures[indexPath.row]
        showProcedureDetail(procedure)
    }
    
    private func showProcedureDetail(_ procedure: FaceProcedure) {
//        let vc = ProcedureDetailViewController()
//        vc.procedure = procedure
//        navigationController?.pushViewController(vc, animated: true)
    }
}

class ProcedureCell: UITableViewCell {
    private let nameLabel = UILabel()
    private let priceLabel = UILabel()
    private let durationLabel = UILabel()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        nameLabel.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        priceLabel.font = UIFont.systemFont(ofSize: 14)
        priceLabel.textColor = .systemGreen
        durationLabel.font = UIFont.systemFont(ofSize: 14)
        durationLabel.textColor = .secondaryLabel
        
        let stackView = UIStackView(arrangedSubviews: [nameLabel, priceLabel, durationLabel])
        stackView.axis = .vertical
        stackView.spacing = 4
        contentView.addSubview(stackView)
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 12),
            stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            stackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -12)
        ])
    }
    
    func configure(with procedure: FaceProcedure) {
        nameLabel.text = procedure.name
        priceLabel.text = "Цена: \(procedure.price) руб."
        durationLabel.text = "Длительность: \(procedure.duration)"
    }
}
