//
//  ViewOutlet.swift
//  Home
//
//  Created by Joe Pan on 2025/3/6.
//

import UIKit

@MainActor final class ViewOutlet {
    let mainView = UIView()
    let nameField = UITextField()
    let enterButton = UIButton(type: .system)
    
    init() {
        setupSelf()
        addViews()
    }
}

// MARK: - Private

private extension ViewOutlet {
    func setupSelf() {
        mainView.backgroundColor = .white
        mainView.translatesAutoresizingMaskIntoConstraints = false
        nameField.translatesAutoresizingMaskIntoConstraints = false
        enterButton.translatesAutoresizingMaskIntoConstraints = false
        nameField.placeholder = "Enter your name"
        nameField.borderStyle = .roundedRect
        enterButton.setTitle("Enter", for: .normal)
    }
    
    func addViews() {
        let vStack = UIStackView(arrangedSubviews: [nameField, enterButton])
        vStack.translatesAutoresizingMaskIntoConstraints = false
        vStack.axis = .vertical
        vStack.spacing = 8
        
        mainView.addSubview(vStack)
        NSLayoutConstraint.activate([
            vStack.widthAnchor.constraint(equalTo: mainView.widthAnchor, multiplier: 0.8),
            vStack.centerXAnchor.constraint(equalTo: mainView.centerXAnchor),
            vStack.centerYAnchor.constraint(equalTo: mainView.centerYAnchor)
        ])
    }
}
