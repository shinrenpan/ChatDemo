import SwiftUI

@MainActor
final class HomeHostController: UIHostingController<HomeView> {
  private let viewModel: HomeViewModel

  init(viewModel: HomeViewModel) {
    self.viewModel = viewModel
    super.init(rootView: HomeView(viewModel: viewModel))
  }

  @available(*, unavailable)
  required init?(coder: NSCoder) { fatalError() }

  override func viewDidLoad() {
    super.viewDidLoad()
    viewModel.onRoute = { [weak self] router in
      self?.handleRouter(router)
    }
  }
}

// MARK: - Router

private extension HomeHostController {
  func handleRouter(_ router: HomeViewModel.Router) {
    switch router {
    case .showAlert:
      let alert = UIAlertController(title: "錯誤", message: "姓名不能為空", preferredStyle: .alert)
      alert.addAction(UIAlertAction(title: "確定", style: .default))
      present(alert, animated: true)

    case let .toRoom(userName):
      navigationController?.pushViewController(
        RoomHostController(viewModel: .init(userName: userName)),
        animated: true
      )
    }
  }
}
