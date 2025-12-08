//
//  HomeViewController.swift
//  ChatDemo
//
//  Created by Joe Pan on 2025/12/8.
//

import SwiftUI

@MainActor
final class HomeViewController: UIHostingController<HomeView> {
  private let viewModel: HomeViewModel

  init(viewModel: HomeViewModel) {
    self.viewModel = viewModel
    let view = HomeView(viewModel: viewModel)
    super.init(rootView: view)
    listenAction()
  }
  
  required dynamic init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}

// MARK: -

private extension HomeViewController {
  func listenAction() {
    viewModel.onAction = { [weak self] action in
      switch action {
      case .view:
        break

      case let .router(router):
        self?.handleRouter(router)
      }
    }
  }

  func handleRouter(_ router: HomeViewModel.Router) {
    switch router {
    case .showAlert:
      showEmptyNameAlert()

    case let .toRoom(userName):
      toRoom(userName)
    }
  }

  func showEmptyNameAlert() {
    let alert = UIAlertController(title: "錯誤", message: "姓名不能為空", preferredStyle: .alert)
    alert.addAction(UIAlertAction(title: "確定", style: .default))
    present(alert, animated: true)
  }

  func toRoom(_ userName: String) {
    let vc = RoomViewController(viewModel: .init(userName: userName))
    navigationController?.pushViewController(vc, animated: true)
  }
}
