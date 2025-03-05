//
//  MessageCell.swift
//  malova_app
//
//  Created by Малова Олеся on 05.03.2025.
//

import UIKit

final class AdminMessageCell: UITableViewCell {
    // MARK: - UI Elements
    private let bubbleView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 12
        view.layer.masksToBounds = true
        return view
    }()

    private let messageLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0 // Многострочный текст
        label.font = UIFont.systemFont(ofSize: 16)
        return label
    }()

    // MARK: - Constraints
    private var leftConstraint: NSLayoutConstraint!
    private var rightConstraint: NSLayoutConstraint!

    // MARK: - Init
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
        backgroundColor = .clear
        contentView.backgroundColor = .clear
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Setup UI
    private func setupUI() {
        // Настройка bubbleView
        contentView.addSubview(bubbleView)
        bubbleView.translatesAutoresizingMaskIntoConstraints = false
        
        // Настройка messageLabel
        bubbleView.addSubview(messageLabel)
        messageLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            messageLabel.topAnchor.constraint(equalTo: bubbleView.topAnchor, constant: 8),
            messageLabel.leadingAnchor.constraint(equalTo: bubbleView.leadingAnchor, constant: 12),
            messageLabel.trailingAnchor.constraint(equalTo: bubbleView.trailingAnchor, constant: -12),
            messageLabel.bottomAnchor.constraint(equalTo: bubbleView.bottomAnchor, constant: -8)
        ])
        
        // Инициализация констрейнтов для bubbleView
        leftConstraint = bubbleView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16)
        rightConstraint = bubbleView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16)
        
        // Активируем базовые констрейнты
        NSLayoutConstraint.activate([
            bubbleView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            bubbleView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),
            bubbleView.widthAnchor.constraint(lessThanOrEqualToConstant: 250) // Максимальная ширина сообщения
        ])
    }

    // MARK: - Configure Cell
    func configure(with message: Message, isCurrentUser: Bool) {
        messageLabel.text = message.text

        // Настройка стиля пузырька в зависимости от отправителя
        if isCurrentUser {
            // Сообщение текущего пользователя
            bubbleView.backgroundColor = UIColor(hex: "647269")
            messageLabel.textColor = .white

            // Выравнивание справа
            leftConstraint.isActive = false
            rightConstraint.isActive = true
        } else {
            // Сообщение другого пользователя
            bubbleView.backgroundColor = UIColor(hex: "EDF4ED")
            messageLabel.textColor = .black

            // Выравнивание слева
            rightConstraint.isActive = false
            leftConstraint.isActive = true
        }
    }

    // MARK: - Prepare for Reuse
    override func prepareForReuse() {
        super.prepareForReuse()
        // Сбрасываем констрейнты
        leftConstraint.isActive = false
        rightConstraint.isActive = false
    }
}

