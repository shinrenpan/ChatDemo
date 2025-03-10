//
//  ViewModel.swift
//  Room
//
//  Created by Joe Pan on 2025/3/6.
//

import Foundation
import MQTTManager
import Combine

@Observable final class ViewModel {
    private(set) var state = State.none
    private let userName: String
    private let userId: String = UUID().uuidString
    private var cancellable : AnyCancellable?
    
    deinit {
        actionDisconnect()
    }
    
    init(userName: String) {
        self.userName = userName
        
        cancellable = NotificationCenter.default
            .publisher(for: .MQTTReceivedMessage)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] note in
                self?.handleReceiveMessage(notify: note)
            }
    }
}

// MARK: - Internal

extension ViewModel {
    @MainActor func doAction(_ action: Action) {
        switch action {
        case .connect:
            actionConnect()
        case .disconnect:
            actionDisconnect()
        case let .sendMessage(message):
            actionSendMessage(message: message)
        }
    }
}

private extension ViewModel {
    @MainActor func actionConnect() {
        Task {
            do {
                try await MQTTManager.shared.connect(userId: userId)
                state = .connected
            }
            catch {
                state = .error(.connectFailed)
            }
        }
    }
    
    func actionDisconnect() {
        Task {
            try? await MQTTManager.shared.disconnect()
        }
    }
    
    @MainActor func actionSendMessage(message: String) {
        Task {
            do {
                let message = Message(userId: userId, userName: userName, content: message)
                try await MQTTManager.shared.send(message: message)
                state = .sendSuccess
            }
            catch {
                state = .error(.sendFailed)
            }
        }
    }
    
    @objc func handleReceiveMessage(notify: Notification) {
        guard let data = notify.object as? Data else { return }
        guard let message = try? JSONDecoder().decode(Message.self, from: data) else { return }
        let displayMessage = DisplayMessage(message: message, myId: userId)
        state = .recievedMessage(displayMessage)
    }
}
