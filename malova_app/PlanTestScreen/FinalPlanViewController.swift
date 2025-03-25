//
//  FinalPlanViewController.swift
//  malova_app
//
//  Created by Малова Олеся on 25.03.2025.
//

import UIKit

class FinalPlanViewController: UIViewController {
    
    var procedures: [String] = []
    private let router: PlanTestRoutingLogic
    
    private let textView: UITextView = {
        let tv = UITextView()
        tv.isEditable = false
        tv.font = UIFont.systemFont(ofSize: 16)
        tv.backgroundColor = UIColor(hex: "#EAEAEA")
        tv.textColor = .darkGray
        return tv
    }()
    private let goBackButton: UIButton = UIButton()
    
    // MARK: - LifeCycle
    init(router: PlanTestRoutingLogic) {
        self.router = router
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(hex: "#EAEAEA")
        title = "Ваш план процедур"
        setupGoBackButton()
        
        view.addSubview(textView)
        textView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            textView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 80),
            textView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            textView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            textView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20)
        ])
        
        textView.text = "Ваш индивидуальный план процедур:\n\n" +
                       procedures.map { "• \($0)" }.joined(separator: "\n")
    }
    
    private func addResetButton() {
        let resetButton = UIBarButtonItem(
            title: "Пройти заново",
            style: .plain,
            target: self,
            action: #selector(resetTest)
        )
        navigationItem.rightBarButtonItem = resetButton
    }
    
    private func setupGoBackButton() {
        goBackButton.setImage(UIImage(systemName: "chevron.left"), for: .normal)
        goBackButton.tintColor = .black
        
        view.addSubview(goBackButton)
        
        goBackButton.pinTop(to: view.safeAreaLayoutGuide.topAnchor, 16)
        goBackButton.pinLeft(to: view.leadingAnchor, 16)
        
        goBackButton.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
    }

    @objc private func backButtonTapped() {
        router.routeToMain()
    }
    
    @objc private func resetTest() {
        UserDefaults.standard.removeObject(forKey: "isTestCompleted")
        UserDefaults.standard.removeObject(forKey: "recommendedProcedures")
        
        router.routeToPlanTest()
    }
}
