//
//  RoomViewModel.swift
//  ChatDemo
//
//  Created by Joe Pan on 2025/12/8.
//

import Foundation
import Observation
import SwiftUI

@MainActor
@Observable

final class RoomViewModel: ViewModel {
  enum Action: Equatable, Sendable {
    case view(ViewAction)
  }

  enum Callback: Equatable, Sendable {}

  @ObservationIgnored
  var onAction: (@MainActor (Action) -> Void)?

  @ObservationIgnored
  var onCallback: (@MainActor (Callback) -> Void)?

  var state: State

  func doAction(_ action: Action) async {
    switch action {
    case let .view(action):
      await handleViewAction(action)
    }
  }

  init(userName: String) {
    self.state = .init(user: .init(name: userName))

    state.cancellable = NotificationCenter.default
      .publisher(for: .MQTTReceivedMessage)
      .receive(on: DispatchQueue.main)
      .sink { [weak self] notify in
        self?.handleReceiveMessage(notify: notify)
      }
  }
}

// MARK: - View Action

extension RoomViewModel {
  enum ViewAction: Equatable, Sendable {
    case onAppear
    case onDisappear
    case sendDidTap
  }

  private func handleViewAction(_ action: ViewAction) async {
    switch action {
    case .onAppear:
      do {
        try await MQTTManager.shared.connect(userId: state.user.id)
        state.mqttState = .connected
      }
      catch {
        state.mqttState = .failed
      }

    case .onDisappear:
      do {
        try await MQTTManager.shared.disconnect()
      }
      catch {

      }

    case .sendDidTap:
      if !state.sendText.isEmpty {
        do {
          try await MQTTManager.shared.send(message: .init(userId: state.user.id, userName: state.user.name, content: state.sendText))
          state.sendText = ""
        }
        catch {

        }
      }
    }
  }
}

private extension RoomViewModel {
  func handleReceiveMessage(notify: Notification) {
    guard let data = notify.object as? Data else { return }
    guard let message = try? JSONDecoder().decode(Message.self, from: data) else { return }
    let displayMessage = DisplayMessage(message: message, myId: state.user.id)
    state.messages.append(displayMessage)
  }
}
