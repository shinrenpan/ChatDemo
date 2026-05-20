import SwiftUI

@MainActor
final class RoomHostController: UIHostingController<RoomView> {
  private let viewModel: RoomViewModel

  init(viewModel: RoomViewModel) {
    self.viewModel = viewModel
    super.init(rootView: RoomView(viewModel: viewModel))
  }

  @available(*, unavailable)
  required init?(coder: NSCoder) { fatalError() }

  override func viewDidLoad() {
    super.viewDidLoad()
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

// MARK: - Router

private extension RoomHostController {
  func handleRouter(_ router: RoomViewModel.Router) {}
}
