//
//  PlanTestViewController.swift
//  malova_app
//
//  Created by Малова Олеся on 25.03.2025.
//
import UIKit

protocol PlanTestDisplayLogic: AnyObject {
    typealias Model = PlanTestModel
    func displayStart(_ viewModel: Model.Start.ViewModel)
}

final class PlanTestViewController: UIViewController, PlanTestDisplayLogic {
    
    // MARK: - Constants
    private enum Constants {
        static let fatalError: String = "init(coder:) has not been implemented"
        static let backgroundColor = UIColor(hex: "#EAEAEA")
        static let yesButtonColor = UIColor(hex: "#EDF4ED")
        static let noButtonColor = UIColor(hex: "#647269")
        static let yesButtonTextColor = UIColor(hex: "#000000")
        static let noButtonTextColor = UIColor(hex: "#FFFFFF")
    }
    
    // MARK: - Properties
    private var currentTestType: TestType = .face
    private var faceAnswers: [FaceQuestion: Bool] = [:]
    private var bodyAnswers: [BodyQuestion: Bool] = [:]
    private var recommendedProcedures: [String] = []
    
    // MARK: - UI Elements
    private let testTypeSegmentedControl: UISegmentedControl = {
        let control = UISegmentedControl(items: ["Тест для лица", "Тест для тела"])
        control.selectedSegmentIndex = 0
        control.addTarget(PlanTestViewController.self, action: #selector(testTypeChanged), for: .valueChanged)
        control.isHidden = true // Скрываем до завершения тестов
        return control
    }()
    
    private let questionLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = UIFont.systemFont(ofSize: 20, weight: .medium)
        label.textAlignment = .center
        label.textColor = .darkGray
        return label
    }()
    
    private let yesButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Да", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        button.backgroundColor = Constants.yesButtonColor
        button.setTitleColor(Constants.yesButtonTextColor, for: .normal)
        button.layer.cornerRadius = 12
        button.layer.shadowColor = UIColor.black.cgColor
        button.layer.shadowOffset = CGSize(width: 0, height: 2)
        button.layer.shadowOpacity = 0.1
        button.layer.shadowRadius = 4
        return button
    }()
    
    private let noButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Нет", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        button.backgroundColor = Constants.noButtonColor
        button.setTitleColor(Constants.noButtonTextColor, for: .normal)
        button.layer.cornerRadius = 12
        button.layer.shadowColor = UIColor.black.cgColor
        button.layer.shadowOffset = CGSize(width: 0, height: 2)
        button.layer.shadowOpacity = 0.1
        button.layer.shadowRadius = 4
        return button
    }()
    
    private let progressLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        label.textColor = .gray
        label.textAlignment = .center
        return label
    }()
    
    private let resultsTextView: UITextView = {
        let textView = UITextView()
        textView.isEditable = false
        textView.font = UIFont.systemFont(ofSize: 16)
        textView.isHidden = true
        textView.backgroundColor = .clear
        textView.textColor = .darkGray
        return textView
    }()
    
    private let nextTestButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Пройти тест для тела", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        button.backgroundColor = Constants.yesButtonColor
        button.setTitleColor(Constants.yesButtonTextColor, for: .normal)
        button.layer.cornerRadius = 12
        button.layer.shadowColor = UIColor.black.cgColor
        button.layer.shadowOffset = CGSize(width: 0, height: 2)
        button.layer.shadowOpacity = 0.1
        button.layer.shadowRadius = 4
        button.isHidden = true
        return button
    }()
    
    private let finishButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Завершить", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        button.backgroundColor = Constants.noButtonColor
        button.setTitleColor(Constants.noButtonTextColor, for: .normal)
        button.layer.cornerRadius = 12
        button.layer.shadowColor = UIColor.black.cgColor
        button.layer.shadowOffset = CGSize(width: 0, height: 2)
        button.layer.shadowOpacity = 0.1
        button.layer.shadowRadius = 4
        button.isHidden = true
        return button
    }()
    // MARK: - Fields
    private let router: PlanTestRoutingLogic
    private let interactor: PlanTestBusinessLogic
    
    // MARK: - LifeCycle
    init(router: PlanTestRoutingLogic, interactor: PlanTestBusinessLogic) {
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
        setupUI()
        setupButtons()
        startTest()
    }
    
    static func isTestCompleted() -> Bool {
        return UserDefaults.standard.bool(forKey: "isTestCompleted")
    }

    static func getSavedProcedures() -> [String] {
        return UserDefaults.standard.stringArray(forKey: "recommendedProcedures") ?? []
    }
    
    // MARK: - Configuration
    private func setupUI() {
        view.backgroundColor = Constants.backgroundColor
        title = "Тест для подбора процедур"
        
        let stackView = UIStackView(arrangedSubviews: [
            testTypeSegmentedControl,
            questionLabel,
            progressLabel,
            yesButton,
            noButton,
            resultsTextView,
            nextTestButton,
            finishButton
        ])
        
        stackView.axis = .vertical
        stackView.spacing = 20
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(stackView)
        
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 220),
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            stackView.bottomAnchor.constraint(lessThanOrEqualTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20),
            
            yesButton.heightAnchor.constraint(equalToConstant: 50),
            noButton.heightAnchor.constraint(equalToConstant: 50),
            nextTestButton.heightAnchor.constraint(equalToConstant: 50),
            finishButton.heightAnchor.constraint(equalToConstant: 50),
            resultsTextView.heightAnchor.constraint(equalToConstant: 200)
        ])
    }
    
    private func setupButtons() {
        yesButton.addTarget(self, action: #selector(answerYes), for: .touchUpInside)
        noButton.addTarget(self, action: #selector(answerNo), for: .touchUpInside)
        nextTestButton.addTarget(self, action: #selector(startBodyTest), for: .touchUpInside)
        finishButton.addTarget(self, action: #selector(showFinalPlan), for: .touchUpInside)
    }
    
    private func startTest() {
        recommendedProcedures.removeAll()
        updateQuestion()
    }
    
    private func updateQuestion() {
        switch currentTestType {
        case .face:
            let currentIndex = faceAnswers.count
            if currentIndex < FaceQuestion.allCases.count {
                let question = FaceQuestion.allCases[currentIndex]
                questionLabel.text = question.questionText
                progressLabel.text = "Вопрос \(currentIndex + 1) из \(FaceQuestion.allCases.count)"
            } else {
                finishTest()
            }
            
        case .body:
            let currentIndex = bodyAnswers.count
            if currentIndex < BodyQuestion.allCases.count {
                let question = BodyQuestion.allCases[currentIndex]
                questionLabel.text = question.questionText
                progressLabel.text = "Вопрос \(currentIndex + 1) из \(BodyQuestion.allCases.count)"
            } else {
                finishTest()
            }
        }
    }
    
    private func finishTest() {
        questionLabel.isHidden = true
        yesButton.isHidden = true
        noButton.isHidden = true
        progressLabel.isHidden = true
        
        resultsTextView.isHidden = false
        
        var resultText = "Рекомендуемые процедуры для \(currentTestType == .face ? "лица" : "тела"):\n\n"
        
        var procedures = currentTestType == .face ?
        faceAnswers.flatMap { $0.key.proceduresForAnswer($0.value) } :
        bodyAnswers.flatMap { $0.key.proceduresForAnswer($0.value) }
        
        // Удаляем дубликаты
        procedures = Array(Set(procedures))
        
        if procedures.isEmpty {
            resultText += "Уходовые процедуры"
        } else {
            resultText += procedures.map { "• \($0)" }.joined(separator: "\n")
        }
        
        recommendedProcedures.append(contentsOf: procedures)
        resultsTextView.text = resultText
        
        // Показываем соответствующие кнопки
        if currentTestType == .face && bodyAnswers.isEmpty {
            nextTestButton.isHidden = false
            finishButton.isHidden = false
            finishButton.setTitle("Пропустить тест для тела", for: .normal)
        } else {
            finishButton.isHidden = false
            finishButton.setTitle("Завершить", for: .normal)
        }
    }
    
    private func saveTestCompletion() {
        UserDefaults.standard.set(true, forKey: "isTestCompleted")
        UserDefaults.standard.set(recommendedProcedures, forKey: "recommendedProcedures")
    }
    
    // MARK: - Actions
    @objc private func testTypeChanged() {
        currentTestType = testTypeSegmentedControl.selectedSegmentIndex == 0 ? .face : .body
        startTest()
    }
    
    @objc private func answerYes() {
        recordAnswer(true)
    }
    
    @objc private func answerNo() {
        recordAnswer(false)
    }
    
    @objc private func startBodyTest() {
        currentTestType = .body
        resetTestUI()
        startTest()
    }
    
    @objc private func showFinalPlan() {
        saveTestCompletion()
        
        let uniqueProcedures = Array(Set(recommendedProcedures))
            .filter { $0 != "Уходовые процедуры" || recommendedProcedures.count == 1 }
        
        let finalVC = FinalPlanViewController(router: router)
        finalVC.procedures = uniqueProcedures.isEmpty ? ["Уходовые процедуры"] : uniqueProcedures
        navigationController?.pushViewController(finalVC, animated: true)
    }
    
    private func recordAnswer(_ answer: Bool) {
        switch currentTestType {
        case .face:
            let currentIndex = faceAnswers.count
            guard currentIndex < FaceQuestion.allCases.count else { return }
            let question = FaceQuestion.allCases[currentIndex]
            faceAnswers[question] = answer
            
        case .body:
            let currentIndex = bodyAnswers.count
            guard currentIndex < BodyQuestion.allCases.count else { return }
            let question = BodyQuestion.allCases[currentIndex]
            bodyAnswers[question] = answer
        }
        
        updateQuestion()
    }
    
    private func resetTestUI() {
        questionLabel.isHidden = false
        yesButton.isHidden = false
        noButton.isHidden = false
        progressLabel.isHidden = false
        resultsTextView.isHidden = true
        nextTestButton.isHidden = true
        finishButton.isHidden = true
    }
    
    // MARK: - DisplayLogic
    func displayStart(_ viewModel: Model.Start.ViewModel) {
    }
}
