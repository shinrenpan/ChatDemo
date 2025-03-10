//
//  ViewController.swift
//  Room
//
//  Created by Joe Pan on 2025/3/6.
//

import UIKit
import SwiftUI

public final class ViewController: UIViewController {
    private let vo = ViewOutlet()
    private let vm: ViewModel
    private lazy var dataSource = makeDataSource()
    
    public init(userName: String) {
        self.vm = .init(userName: userName)
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        setupSelf()
        setupBinding()
        setupVO()
    }
    
    public override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        vm.doAction(.connect)
    }
    public override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        vm.doAction(.disconnect)
    }
}

// MARK: - Private

private extension ViewController {
    func setupSelf() {
        view.backgroundColor = vo.mainView.backgroundColor
        contentUnavailableConfiguration = UIContentUnavailableConfiguration.loading()
        var snapshot = SnapShot()
        snapshot.appendSections([0])
        dataSource.apply(snapshot)
    }
    
    func setupBinding() {
        _ = withObservationTracking {
            vm.state
        } onChange: { [weak self] in
            guard let self else { return }
            Task { @MainActor [weak self] in
                guard let self else { return }
                if viewIfLoaded?.window == nil { return }
                
                switch vm.state {
                case .none:
                    stateNone()
                case .connected:
                    stateConnected()
                case let .error(error):
                    stateError(error: error)
                case .sendSuccess:
                    stateSendSuccess()
                case let .recievedMessage(message):
                    stateRecievedMessage(message: message)
                }
                
                setupBinding()
            }
        }
    }
    
    func setupVO() {
        view.addSubview(vo.mainView)
        
        NSLayoutConstraint.activate([
            vo.mainView.topAnchor.constraint(equalTo: view.topAnchor),
            vo.mainView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            vo.mainView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            vo.mainView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])
        
        vo.keyIn.sendButton.addAction(.init() { [weak self] _ in
            guard let self else { return }
            guard let message = vo.keyIn.input.text, !message.isEmpty else { return }
            vm.doAction(.sendMessage(message))
        }, for: .touchUpInside)
    }
    
    func stateNone() {}
    
    func stateConnected() {
        contentUnavailableConfiguration = nil
        vo.reloadUI(connected: true)
    }
    
    func stateError(error: MQTTError) {
        vo.reloadUI(connected: false)
        
        contentUnavailableConfiguration = UIHostingConfiguration {
            Text("連線失敗")
                .foregroundStyle(.red)
                .bold()
        }
    }
    
    func stateSendSuccess() {
        vo.reloadKeyIn()
    }
    
    func stateRecievedMessage(message: DisplayMessage) {
        var snapshot = dataSource.snapshot()
        snapshot.appendItems([message], toSection: 0)
        dataSource.apply(snapshot, animatingDifferences: true) { [weak self] in
            self?.vo.reloadListToLast(count: 0)
        }
    }
    
    func makeCell() -> CellRegistration {
        .init { cell, indexPath, itemIdentifier in
            switch itemIdentifier.fromMe {
            case true:
                cell.contentConfiguration = UIHostingConfiguration {
                    MyCell(message: itemIdentifier)
                }
            case false:
                cell.contentConfiguration = UIHostingConfiguration {
                    TargetCell(message: itemIdentifier)
                }
            }
        }
    }
    
    func makeDataSource() -> DataSource {
        let cell = makeCell()
        
        return .init(collectionView: vo.list) { collectionView, indexPath, itemIdentifier in
            collectionView.dequeueConfiguredReusableCell(using: cell, for: indexPath, item: itemIdentifier)
        }
    }
}
