import Foundation
import Observation
import Combine

@Observable
@MainActor
final class RoomViewModel {
  enum Action: Sendable {
    case view(ViewAction)
  }

  var state: State

  @ObservationIgnored
  var onRoute: (@MainActor (Router) -> Void)?

  @ObservationIgnored
  private var cancellable: AnyCancellable?

  init(userName: String) {
    self.state = .init(user: .init(name: userName))
    setupCancellable()
  }

  func doAction(_ action: Action) async {
    switch action {
    case let .view(action):
      await handleViewAction(action)
    }
  }
}

// MARK: - View Action

extension RoomViewModel {
  enum ViewAction: Sendable {
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
      } catch {
        state.mqttState = .failed
      }

    case .onDisappear:
      try? await MQTTManager.shared.disconnect()

    case .sendDidTap:
      guard !state.sendText.isEmpty else { return }
      do {
        try await MQTTManager.shared.send(message: .init(userId: state.user.id, userName: state.user.name, content: state.sendText))
        state.sendText = ""
      } catch {}
    }
  }
}

// MARK: - Router

extension RoomViewModel {
  enum Router: Sendable {}
}

// MARK: - Private

private extension RoomViewModel {
  func setupCancellable() {
    cancellable = NotificationCenter.default
      .publisher(for: .MQTTReceivedMessage)
      .receive(on: DispatchQueue.main)
      .sink { [weak self] notify in
        self?.handleReceiveMessage(notify: notify)
      }
  }

  func handleReceiveMessage(notify: Notification) {
    guard let data = notify.object as? Data,
          let message = try? JSONDecoder().decode(Message.self, from: data) else { return }
    state.messages.append(DisplayMessage(message: message, myId: state.user.id))
  }
}
