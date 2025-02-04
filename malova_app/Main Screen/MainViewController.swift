//
//  MainViewController.swift
//  clinic
//
//  Created by Малова Олеся on 02.02.2025.
//
import UIKit

class MainViewController: UIViewController {
    private let mainImage: UIImage = UIImage(named: "MainImage") ?? UIImage()
    
    private let appointmentButton: UIButton = UIButton()
    private let scanButton: UIButton = UIButton()
    private let procedureButton: UIButton = UIButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.setBackgroundPhoto(to: view, image: mainImage)
        setupUI()
    }
    
    private func setupUI() {
        setAppointmentButton()
        setupScanButton()
        setupProcedureButton()
    }
    
    private func setAppointmentButton() {
        appointmentButton.setTitle("записаться на услугу", for: .normal)
        appointmentButton.setTitleColor(.black, for: .normal)
        appointmentButton.backgroundColor = UIColor(hex: "DEE3E0")
        appointmentButton.layer.cornerRadius = 20
        
        view.addSubview(appointmentButton)
        
        appointmentButton.pinTop(to: view.topAnchor, 190)
        appointmentButton.pinRight(to: view.trailingAnchor, 90)
        appointmentButton.setWidth(450)
        appointmentButton.setHeight(50)
        
        appointmentButton.addTarget(self, action: #selector(appointmentButtonTapped), for: .touchUpInside)
    }
    
    @objc func appointmentButtonTapped() {
        // go to other screen
    }
    
    private func setupScanButton() {
        scanButton.setTitle("отсканировать свое лицо", for: .normal)
        scanButton.setTitleColor(.black, for: .normal)
        scanButton.backgroundColor = UIColor(hex: "DEE3E0")
        scanButton.layer.cornerRadius = 20
        
        view.addSubview(scanButton)
        
        scanButton.pinTop(to: appointmentButton.bottomAnchor, 40)
        scanButton.pinLeft(to: view.leadingAnchor, 80)
        scanButton.setWidth(450)
        scanButton.setHeight(50)
        
        scanButton.addTarget(self, action: #selector(scanButtonTapped), for: .touchUpInside)
    }
    
    @objc func scanButtonTapped() {
        // go to other screen
    }
    
    private func setupProcedureButton() {
        procedureButton.setTitle("список всех процедур", for: .normal)
        procedureButton.setTitleColor(.black, for: .normal)
        procedureButton.backgroundColor = UIColor(hex: "DEE3E0")
        procedureButton.layer.cornerRadius = 20
        
        view.addSubview(procedureButton)
        
        procedureButton.pinTop(to: scanButton.bottomAnchor, 400)
        procedureButton.pinRight(to: view.trailingAnchor, 100)
        procedureButton.setWidth(450)
        procedureButton.setHeight(50)
        
        procedureButton.addTarget(self, action: #selector(procedureButtonTapped), for: .touchUpInside)
    }
    
    @objc func procedureButtonTapped() {
        // go to other screen
    }
}
