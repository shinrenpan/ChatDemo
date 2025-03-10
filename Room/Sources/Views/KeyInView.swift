//
//  KeyInView.swift
//  Room
//
//  Created by Joe Pan on 2025/3/9.
//

import UIKit

final class KeyInView: UIView {
    let input = UITextView()
    let sendButton = UIButton(type: .system)
    
    init() {
        super.init(frame: .zero)
        setupSelf()
        addViews()
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Private

private extension KeyInView {
    func setupSelf() {
        backgroundColor = .lightGray
        
        input.translatesAutoresizingMaskIntoConstraints = false
        input.delegate = self
        input.isEditable = true
        input.isScrollEnabled = false
        input.font = .systemFont(ofSize: 17)
        input.clipsToBounds = true
        input.layer.borderColor = UIColor.gray.cgColor
        input.layer.borderWidth = 1
        input.layer.cornerRadius = 8
        
        sendButton.translatesAutoresizingMaskIntoConstraints = false
        sendButton.setContentHuggingPriority(.required, for: .horizontal)
        sendButton.setContentCompressionResistancePriority(.required, for: .horizontal)
        sendButton.setTitle("Send", for: .normal)
    }
    
    func addViews() {
        addSubview(sendButton)
        NSLayoutConstraint.activate([
            sendButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            sendButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -16),
        ])
        
        addSubview(input)
        NSLayoutConstraint.activate([
            input.topAnchor.constraint(equalTo: topAnchor, constant: 16),
            input.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            input.trailingAnchor.constraint(equalTo: sendButton.leadingAnchor, constant: -8),
            input.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -16),
        ])
    }
}

// MARK: - UITextViewDelegate

extension KeyInView: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        textView.isScrollEnabled = textView.text.count > 100
        sendButton.isEnabled = !textView.text.isEmpty
    }
}
