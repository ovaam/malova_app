//
//  MessageCell.swift
//  malova_app
//
//  Created by Малова Олеся on 05.03.2025.
//

import UIKit

final class MessageCell: UITableViewCell {
    // MARK: - UI Elements
    private let bubbleView: UIView = UIView()

    private let messageLabel: UILabel = UILabel()

    private let timeLabel: UILabel = UILabel()

    // MARK: - Constraints
    private var bubbleLeadingConstraint: NSLayoutConstraint = NSLayoutConstraint()
    private var bubbleTrailingConstraint: NSLayoutConstraint = NSLayoutConstraint()
    private var timeLeadingConstraint: NSLayoutConstraint = NSLayoutConstraint()
    private var timeTrailingConstraint: NSLayoutConstraint = NSLayoutConstraint()

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
        setupBubble()
        setupMessage()
        setupTime()
        
        bubbleView.translatesAutoresizingMaskIntoConstraints = false
        timeLabel.translatesAutoresizingMaskIntoConstraints = false
        
        // Чтобы сообщение имело ограничение по ширине, если текст большой
        bubbleView.widthAnchor.constraint(lessThanOrEqualTo: contentView.widthAnchor, multiplier: 0.7).isActive = true
        
        // Инициализация констрейнтов для bubbleView и timeLabel
        bubbleLeadingConstraint = bubbleView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16)
        bubbleTrailingConstraint = bubbleView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16)
        
        timeLeadingConstraint = timeLabel.leadingAnchor.constraint(equalTo: bubbleView.trailingAnchor, constant: 8)
        timeTrailingConstraint = timeLabel.trailingAnchor.constraint(equalTo: bubbleView.leadingAnchor, constant: -8)
    }
    
    private func setupBubble() {
        bubbleView.layer.cornerRadius = 12
        bubbleView.layer.masksToBounds = true
        
        contentView.addSubview(bubbleView)
        
        bubbleView.pinTop(to: contentView.topAnchor, 8)
        bubbleView.pinBottom(to: contentView.bottomAnchor, 8)
    }
    
    private func setupMessage() {
        messageLabel.numberOfLines = 0 // Многострочный текст
        messageLabel.font = UIFont.systemFont(ofSize: 16)
        
        bubbleView.addSubview(messageLabel)
        
        messageLabel.pinTop(to: bubbleView.topAnchor, 8)
        messageLabel.pinLeft(to: bubbleView.leadingAnchor, 12)
        messageLabel.pinRight(to: bubbleView.trailingAnchor, 12)
        messageLabel.pinBottom(to: bubbleView.bottomAnchor, 8)
        
    }
    
    private func setupTime() {
        timeLabel.font = UIFont.systemFont(ofSize: 12)
        timeLabel.textColor = .gray
        
        contentView.addSubview(timeLabel)
        timeLabel.pinCenterY(to: bubbleView.centerYAnchor)
    }

    // MARK: - Configure Cell
    func configure(with message: Message, isCurrentUser: Bool) {
        messageLabel.text = message.text
        
        // Форматируем время
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm"
        timeLabel.text = dateFormatter.string(from: message.timestamp)

        if isCurrentUser {
            // Сообщение текущего пользователя
            bubbleView.backgroundColor = UIColor(hex: "647269")
            messageLabel.textColor = .white

            // Выравнивание справа от пузырька
            bubbleLeadingConstraint.isActive = false
            bubbleTrailingConstraint.isActive = true
            
            // Время слева
            timeTrailingConstraint.isActive = true
            timeLeadingConstraint.isActive = false
        } else {
            // Сообщение другого пользователя
            bubbleView.backgroundColor = UIColor(hex: "EDF4ED")
            messageLabel.textColor = .black

            // Выравнивание слева
            bubbleTrailingConstraint.isActive = false
            bubbleLeadingConstraint.isActive = true
            
            // Время справа
            timeLeadingConstraint.isActive = true
            timeTrailingConstraint.isActive = false
        }
    }

    // MARK: - Prepare for Reuse
    override func prepareForReuse() {
        super.prepareForReuse()
        
        bubbleLeadingConstraint.isActive = false
        bubbleTrailingConstraint.isActive = false
        timeLeadingConstraint.isActive = false
        timeTrailingConstraint.isActive = false
        
        messageLabel.text = nil
        timeLabel.text = nil
    }
}
