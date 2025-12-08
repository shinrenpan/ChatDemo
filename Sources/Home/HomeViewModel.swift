//
//  HomeViewModel.swift
//  ChatDemo
//
//  Created by Joe Pan on 2025/12/8.
//

import Foundation
import Observation

@MainActor
@Observable
final class HomeViewModel: ViewModel {
  enum Action: Equatable, Sendable {
    case view(ViewAction)
    case router(Router)
  }

  enum Callback: Equatable, Sendable {}

  @ObservationIgnored
  var onAction: (@MainActor (Action) -> Void)?

  @ObservationIgnored
  var onCallback: (@MainActor (Callback) -> Void)?

  var state: State = .init()

  func doAction(_ action: Action) async {
    switch action {
    case let .view(action):
      await handleViewAction(action)

    case let .router(router):
      await handleRouter(router)
    }
  }
}

// MARK: - View Action

extension HomeViewModel {
  enum ViewAction: Equatable {
    case enterButtonDidTap
    case textFieldOnSubmit
  }

  private func handleViewAction(_ action: ViewAction) async {
    switch action {
    case .enterButtonDidTap, .textFieldOnSubmit:
      if state.userName.isEmpty {
        await handleRouter(.showAlert)
      }
      else {
        await handleRouter(.toRoom(state.userName))
      }
    }
  }
}

// MARK: - Router

extension HomeViewModel {
  enum Router: Equatable {
    case showAlert
    case toRoom(_ userName: String)
  }

  private func handleRouter(_ router: Router) async {
    onAction?(.router(router))
  }
}
