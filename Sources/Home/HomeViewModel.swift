import Foundation
import Observation

@Observable
@MainActor
final class HomeViewModel {
  enum Action: Sendable {
    case view(ViewAction)
  }

  var state: State = .init()

  @ObservationIgnored
  var onRoute: (@MainActor (Router) -> Void)?

  func doAction(_ action: Action) async {
    switch action {
    case let .view(action):
      await handleViewAction(action)
    }
  }
}

// MARK: - View Action

extension HomeViewModel {
  enum ViewAction: Sendable {
    case enterButtonDidTap
    case textFieldOnSubmit
  }

  private func handleViewAction(_ action: ViewAction) async {
    switch action {
    case .enterButtonDidTap, .textFieldOnSubmit:
      if state.userName.isEmpty {
        onRoute?(.showAlert)
      } else {
        onRoute?(.toRoom(state.userName))
      }
    }
  }
}

// MARK: - Router

extension HomeViewModel {
  enum Router: Sendable {
    case showAlert
    case toRoom(_ userName: String)
  }
}
