//
//  SettingsViewController.swift
//  malova_app
//
//  Created by Малова Олеся on 28.02.2025.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore

protocol SettingsDisplayLogic: AnyObject {
    typealias Model = SettingsModel
    func displayStart(_ viewModel: Model.Start.ViewModel)
}

final class SettingsViewController: UIViewController,
                            SettingsDisplayLogic {
    // MARK: - Constants
    private enum Constants {
        static let fatalError: String = "init(coder:) has not been implemented"
    }
    
    // MARK: - Fields
    private let router: SettingsRoutingLogic
    private let interactor: SettingsBusinessLogic
    
    private let tableView = UITableView(frame: .zero, style: .insetGrouped)
    private let goBackButton: UIButton = UIButton()
    
    private var userData: [String: Any] = [:]
    private let db = Firestore.firestore()
    private var listener: ListenerRegistration?
    
    // MARK: - LifeCycle
    init(
        router: SettingsRoutingLogic,
        interactor: SettingsBusinessLogic
    ) {
        self.router = router
        self.interactor = interactor
        super.init(nibName: nil, bundle: nil)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError(Constants.fatalError)
    }
    
    deinit {
        listener?.remove()
        NotificationCenter.default.removeObserver(self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        interactor.loadStart(Model.Start.Request())
        setupUI()
        loadUserData()
    }
    
    // MARK: - Configuration
    private func setupUI() {
        view.backgroundColor = UIColor(hex: "8AA399")
        setupGoBackButton()
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.backgroundColor = UIColor(hex: "8AA399")
        
        view.addSubview(tableView)
        
        tableView.pinTop(to: view.topAnchor, 100)
        tableView.pinLeft(to: view.leadingAnchor, 20)
        tableView.pinRight(to: view.trailingAnchor, 20)
        tableView.pinBottom(to: view.bottomAnchor)
    }
    
    private func setupGoBackButton() {
        goBackButton.setImage(UIImage(systemName: "chevron.left"), for: .normal)
        goBackButton.tintColor = .black
        
        view.addSubview(goBackButton)
        
        goBackButton.pinTop(to: view.safeAreaLayoutGuide.topAnchor, 16)
        goBackButton.pinLeft(to: view.leadingAnchor, 16)
        
        goBackButton.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
    }
    
    // MARK: - Actions
    @objc private func backButtonTapped() {
        router.routeToProfile()
    }
    
    // MARK: - DisplayLogic
    func displayStart(_ viewModel: Model.Start.ViewModel) {
        
    }
    
    private func loadUserData() {
        guard let user = Auth.auth().currentUser else { return }
        
        // Используем snapshotListener для автоматического обновления
        listener = db.collection("users").document(user.uid)
            .addSnapshotListener { [weak self] snapshot, error in
                guard let self = self else { return }
                
                if let error = error {
                    print("Ошибка загрузки: \(error.localizedDescription)")
                    return
                }
                
                guard let data = snapshot?.data() else {
                    print("Документ не найден")
                    return
                }
                
                self.userData = data
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }
    }
    
    private func updateUserName() {
        let alert = UIAlertController(
            title: "Изменить имя",
            message: "Введите новое имя",
            preferredStyle: .alert
        )
        
        alert.addTextField { textField in
            textField.placeholder = "Новое имя"
            textField.text = self.userData["fullName"] as? String
        }
        
        alert.addAction(UIAlertAction(title: "Отмена", style: .cancel, handler: nil))
        
        alert.addAction(UIAlertAction(title: "Сохранить", style: .default) { [weak self] _ in
            guard let newName = alert.textFields?.first?.text, !newName.isEmpty else { return }
            self?.saveUserName(newName)
        })
        
        present(alert, animated: true)
    }
    
    private func saveUserName(_ name: String) {
        guard let user = Auth.auth().currentUser else {
            showAlert(title: "Ошибка", message: "Пользователь не авторизован")
            return
        }
        
        // Проверяем, что имя действительно изменилось
        if let currentName = userData["fullName"] as? String, currentName == name {
            showAlert(title: "Внимание", message: "Вы ввели то же самое имя")
            return
        }
        
        // Обновляем в Firestore
        db.collection("users").document(user.uid).updateData([
            "fullName": name
        ]) { [weak self] error in
            guard let self = self else { return }
            
            if let error = error {
                print("Ошибка сохранения: \(error.localizedDescription)")
                self.showAlert(title: "Ошибка", message: "Не удалось сохранить имя: \(error.localizedDescription)")
                return
            }
            
            // Важно: сначала обновляем локальные данные
            self.userData["fullName"] = name
            
            // Затем обновляем интерфейс
            DispatchQueue.main.async {
                self.tableView.reloadData()
                self.showAlert(title: "Успешно", message: "Имя изменено на \(name)")
            }
            
            // Дополнительно: обновляем профиль в Authentication
            let changeRequest = user.createProfileChangeRequest()
            changeRequest.displayName = name
            changeRequest.commitChanges { error in
                if let error = error {
                    print("Ошибка обновления профиля: \(error.localizedDescription)")
                }
            }
        }
    }
    
    private func updateAge() {
        let alert = UIAlertController(
            title: "Изменить возраст",
            message: "Введите ваш возраст",
            preferredStyle: .alert
        )
        
        alert.addTextField { textField in
            textField.placeholder = "Текущий возраст"
            textField.keyboardType = .numberPad
            
            if let age = self.userData["age"] as? Int {
                textField.text = "\(age)"
            }
        }
        
        alert.addAction(UIAlertAction(title: "Отмена", style: .cancel))
        alert.addAction(UIAlertAction(title: "Сохранить", style: .default) { [weak self] _ in
            guard let ageText = alert.textFields?.first?.text,
                  let age = Int(ageText),
                  age > 0, age < 120 else {
                self?.showAlert(title: "Ошибка", message: "Введите корректный возраст (1-119)")
                return
            }
            self?.saveAge(age)
        })
        
        present(alert, animated: true)
    }
    
    private func saveAge(_ age: Int) {
        guard let userId = Auth.auth().currentUser?.uid else {
            showAlert(title: "Ошибка", message: "Пользователь не авторизован")
            return
        }
        
        // Проверяем, изменился ли возраст
        if let currentAge = userData["age"] as? Int, currentAge == age {
            showAlert(title: "Внимание", message: "Возраст не изменился")
            return
        }
        
        // Обновляем в Firestore
        db.collection("users").document(userId).updateData([
            "age": age,
            "updatedAt": FieldValue.serverTimestamp()
        ]) { [weak self] error in
            guard let self = self else { return }
            
            if let error = error {
                self.showAlert(title: "Ошибка", message: "Не удалось сохранить возраст: \(error.localizedDescription)")
                return
            }
            
            // Обновляем локальные данные
            self.userData["age"] = age
            self.tableView.reloadData()
            
            self.showAlert(title: "Успешно", message: "Возраст изменен на \(age)")
        }
    }
    
    private func changePassword() {
        let alert = UIAlertController(
            title: "Смена пароля",
            message: "На ваш email будет отправлена ссылка для смены пароля",
            preferredStyle: .alert
        )
        
        alert.addAction(UIAlertAction(title: "Отмена", style: .cancel))
        alert.addAction(UIAlertAction(title: "Отправить", style: .default) { [weak self] _ in
            self?.sendPasswordResetEmail()
        })
        
        present(alert, animated: true)
    }
    
    private func sendPasswordResetEmail() {
        guard let email = Auth.auth().currentUser?.email else { return }
        
        Auth.auth().sendPasswordReset(withEmail: email) { [weak self] error in
            if let error = error {
                self?.showAlert(title: "Ошибка", message: error.localizedDescription)
                return
            }
            
            self?.showAlert(title: "Успешно", message: "Письмо для смены пароля отправлено на \(email)")
        }
    }
    
    private func logOut() {
        let alert = UIAlertController(
            title: "Выход из аккаунта",
            message: "Если вы выйдете, данные прийдется вводить заново. Вы уверены?",
            preferredStyle: .alert
        )
        
        alert.addAction(UIAlertAction(title: "Отмена", style: .cancel))
        alert.addAction(UIAlertAction(title: "Выйти", style: .destructive) { [weak self] _ in
            do {
                try Auth.auth().signOut()
                self?.router.routeToWelcome()
            } catch let signOutError as NSError {
                print("Ошибка при выходе из аккаунта: \(signOutError.localizedDescription)")
            }
        })
        
        present(alert, animated: true)
    }
    
    private func deleteAccount() {
        let alert = UIAlertController(
            title: "Удаление аккаунта",
            message: "Все ваши данные будут безвозвратно удалены. Вы уверены?",
            preferredStyle: .alert
        )
        
        alert.addAction(UIAlertAction(title: "Отмена", style: .cancel))
        alert.addAction(UIAlertAction(title: "Удалить", style: .destructive) { [weak self] _ in
            self?.performAccountDeletion()
        })
        
        present(alert, animated: true)
    }
    
    private func performAccountDeletion() {
        guard let user = Auth.auth().currentUser else { return }
        let userId = user.uid
        
        // 1. Удаляем данные пользователя из Firestore
        db.collection("users").document(userId).delete { [weak self] error in
            if let error = error {
                self?.showAlert(title: "Ошибка", message: error.localizedDescription)
                return
            }
            
            // 2. Удаляем сам аккаунт
            user.delete { error in
                if let error = error {
                    self?.showAlert(title: "Ошибка", message: error.localizedDescription)
                    return
                }
                
                // 3. Выходим и переходим на экран авторизации
                do {
                    try Auth.auth().signOut()
                    self?.navigateToWelcomeScreen()
                } catch {
                    self?.showAlert(title: "Ошибка", message: error.localizedDescription)
                }
            }
        }
    }
    
    private func navigateToWelcomeScreen() {
        router.routeToWelcome()
    }
    
    private func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
}

// MARK: - UITableViewDataSource & UITableViewDelegate
extension SettingsViewController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return Section.allCases.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Section.allCases[section].rows.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return Section.allCases[section].title
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let row = Section.allCases[indexPath.section].rows[indexPath.row]
        
        // Базовая настройка ячейки
        cell.textLabel?.text = row.title
        cell.accessoryType = .disclosureIndicator
        cell.backgroundColor = UIColor(hex: "DEE3E0")
        
        // Заполнение данных пользователя
        switch row {
        case .name:
            cell.detailTextLabel?.text = userData["fullName"] as? String
        case .age:
            cell.detailTextLabel?.text = userData["age"] as? String
        default:
            break
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let row = Section.allCases[indexPath.section].rows[indexPath.row]
        
        switch row {
        case .name:
            updateUserName()
        case .age:
            updateAge()
        case .changePassword:
            changePassword()
        case .logOut:
            logOut()
        case .deleteAccount:
            deleteAccount()
        }
    }
}
