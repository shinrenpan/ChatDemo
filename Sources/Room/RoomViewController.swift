//
//  RoomViewController.swift
//  ChatDemo
//
//  Created by Joe Pan on 2025/12/8.
//

import SwiftUI

final class RoomViewController: UIHostingController<RoomView> {
  private let viewModel: RoomViewModel

  init(viewModel: RoomViewModel) {
    self.viewModel = viewModel
    let view = RoomView(viewModel: viewModel)
    super.init(rootView: view)
  }
  
  required dynamic init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    Task { await viewModel.doAction(.view(.onAppear)) }
  }

  override func viewDidDisappear(_ animated: Bool) {
    super.viewDidDisappear(animated)
    Task { await viewModel.doAction(.view(.onDisappear)) }
  }
}
