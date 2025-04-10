//
//  FaceProceduresViewController.swift
//  malova_app
//
//  Created by Малова Олеся on 07.04.2025.
//

import UIKit
import FirebaseFirestore

class FaceProceduresViewController: UIViewController {
    
    private var procedures: [FaceProcedure] = []
    private let db = Firestore.firestore()
    
//    private let faceImageView: UIImageView = {
//        let imageView = UIImageView()
//        imageView.image = UIImage(named: "FaceMap")
//        imageView.isUserInteractionEnabled = true
//        return imageView
//    }()
    
    private let activityIndicator = UIActivityIndicatorView(style: .large)
    
    // Координаты и размеры зон (нормализованные значения от 0 до 1)
    private let zoneCoordinates: [FaceZone: (center: CGPoint, size: CGSize)] = [
        .forehead: (CGPoint(x: 0.5, y: 0.15), CGSize(width: 0.3, height: 0.1)),
        .eyes: (CGPoint(x: 0.5, y: 0.3), CGSize(width: 0.4, height: 0.1)),
        .cheekBones: (CGPoint(x: 0.5, y: 0.4), CGSize(width: 0.15, height: 0.15)),
        .cheeks: (CGPoint(x: 0.4, y: 0.5), CGSize(width: 0.3, height: 0.2)),
        .lips: (CGPoint(x: 0.5, y: 0.65), CGSize(width: 0.2, height: 0.1)),
        .chin: (CGPoint(x: 0.5, y: 0.8), CGSize(width: 0.2, height: 0.1)),
        .neck: (CGPoint(x: 0.5, y: 0.95), CGSize(width: 0.4, height: 0.1)),
        .ears: (CGPoint(x: 0.2, y: 0.4), CGSize(width: 0.1, height: 0.3)),
        .nasolabialFolds: (CGPoint(x: 0.4, y: 0.6), CGSize(width: 0.2, height: 0.05)),
        .purseStringWrinkles: (CGPoint(x: 0.5, y: 0.7), CGSize(width: 0.15, height: 0.05))
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        loadProcedures()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        updateZoneButtons()
    }
    
    private func setupUI() {
        view.setBackgroundPhoto(to: view, image: UIImage(named: "FaceMap") ?? UIImage())
        //view.backgroundColor = .white
        //title = "Процедуры для лица"
        
//        view.addSubview(faceImageView)
//        faceImageView.contentMode = .scaleAspectFill
//        faceImageView.translatesAutoresizingMaskIntoConstraints = false
//        NSLayoutConstraint.activate([
//            faceImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
//            faceImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
//            faceImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
//            faceImageView.heightAnchor.constraint(equalTo: faceImageView.widthAnchor)
//        ])
//        faceImageView.clipsToBounds = true
        
        view.addSubview(activityIndicator)
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
    
    private func updateZoneButtons() {
        // Удаляем старые кнопки
        view.subviews.forEach { if $0 is UIButton { $0.removeFromSuperview() } }
        
        // Добавляем новые кнопки с учетом текущего размера изображения
        for (zone, coordinates) in zoneCoordinates {
            let button = ZoneButton(type: .custom)
            button.zone = zone
            button.setImage(UIImage(systemName: "circle.fill"), for: .normal)
            button.tintColor = .systemBlue.withAlphaComponent(0.7)
            button.addTarget(self, action: #selector(zoneButtonTapped(_:)), for: .touchUpInside)
            
            let imgViewSize = view.bounds.size
            let buttonWidth = coordinates.size.width * imgViewSize.width
            let buttonHeight = coordinates.size.height * imgViewSize.height
            let x = coordinates.center.x * imgViewSize.width - buttonWidth/2
            let y = coordinates.center.y * imgViewSize.height - buttonHeight/2
            
            button.frame = CGRect(x: x, y: y, width: buttonWidth, height: buttonHeight)
            button.layer.cornerRadius = buttonHeight / 2
            button.layer.masksToBounds = true
            button.backgroundColor = .systemBlue.withAlphaComponent(0.2)
            
            view.addSubview(button)
        }
    }
    
    @objc private func zoneButtonTapped(_ sender: ZoneButton) {
        guard let zone = sender.zone else { return }
        showProceduresForZone(zone.rawValue)
    }
    
    private func showProceduresForZone(_ zone: String) {
        let filteredProcedures = procedures.filter { $0.zone == zone }
        
        if filteredProcedures.isEmpty {
            showEmptyAlert(for: zone)
        } else {
            let vc = ProceduresListViewController()
            vc.procedures = filteredProcedures
            vc.zoneName = zone
            navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    private func showEmptyAlert(for zone: String) {
        let alert = UIAlertController(
            title: "Нет процедур",
            message: "Для зоны \"\(zone)\" пока нет доступных процедур",
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
    
    private func loadProcedures() {
        activityIndicator.startAnimating()
        
        db.collection("face_procedures").getDocuments { [weak self] snapshot, error in
            guard let self = self else { return }
            self.activityIndicator.stopAnimating()
            
            if let error = error {
                self.showErrorAlert(message: error.localizedDescription)
                return
            }
            
            guard let documents = snapshot?.documents else {
                self.showErrorAlert(message: "Не удалось загрузить процедуры")
                return
            }
            
            self.procedures = documents.compactMap { document in
                FaceProcedure(id: document.documentID, data: document.data())
            }
        }
    }
    
    private func showErrorAlert(message: String) {
        let alert = UIAlertController(
            title: "Ошибка",
            message: message,
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
}

class ZoneButton: UIButton {
    var zone: FaceZone?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
    
    private func setup() {
        setImage(UIImage(systemName: "circle.fill"), for: .normal)
        tintColor = .systemBlue.withAlphaComponent(0.7)
        backgroundColor = .systemBlue.withAlphaComponent(0.2)
        layer.cornerRadius = bounds.height / 2
        layer.masksToBounds = true
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        layer.cornerRadius = bounds.height / 2
    }
}

enum FaceZone: String, CaseIterable {
    case forehead = "Лоб"
    case eyes = "Зона вокруг глаз"
    case cheekBones = "Скулы"
    case cheeks = "Щёки"
    case lips = "Губы"
    case chin = "Подбородок"
    case neck = "Шея"
    case ears = "Мочка уха и околоушная зона"
    case nasolabialFolds = "Носогубные борозды"
    case purseStringWrinkles = "Кисетные морщины"
}
