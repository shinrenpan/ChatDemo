//
//  ViewController.swift
//  Home
//
//  Created by Joe Pan on 2025/3/6.
//

import UIKit

public final class ViewController: UIViewController {
    private let vo = ViewOutlet()
    private let router = Router()
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        setupSelf()
        setupVO()
    }
    
    public override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        view.endEditing(true)
    }
}

// MARK: - Private

private extension ViewController {
    func setupSelf() {
        view.backgroundColor = vo.mainView.backgroundColor
        router.vc = self
    }
    
    func setupVO() {
        view.addSubview(vo.mainView)
        
        NSLayoutConstraint.activate([
            vo.mainView.topAnchor.constraint(equalTo: view.topAnchor),
            vo.mainView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            vo.mainView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            vo.mainView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])
        
        vo.enterButton.addAction(.init() { [weak self] _  in
            guard let self else { return }
            guard let name = vo.nameField.text else { return }
            if name.isEmpty { return }
            router.toRoom(userName: name)
        }, for: .touchUpInside)
    }
}
