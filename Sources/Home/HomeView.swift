//
//  HomeView.swift
//  ChatDemo
//
//  Created by Joe Pan on 2025/12/8.
//

import SwiftUI

struct HomeView: View {
  let viewModel: HomeViewModel
  @FocusState private var focused: Bool

  var body: some View {
    contentView()
  }
}

// MARK: - Views

private extension HomeView {
  @ViewBuilder
  func contentView() -> some View {
    ScrollView {
      VStack {
        textField()
        button()
      }
      .padding()
    }
  }

  @ViewBuilder
  func textField() -> some View {
    @Bindable var vm = viewModel

    TextField("Enter your name", text: $vm.state.userName)
      .focused($focused)
      .submitLabel(.go)
      .textFieldStyle(.roundedBorder)
      .textInputAutocapitalization(.never)
      .onSubmit {
        Task { await viewModel.doAction(.view(.textFieldOnSubmit)) }
      }
  }

  @ViewBuilder
  func button() -> some View {
    Button("Enter") {
      focused = false
      Task { await viewModel.doAction(.view(.enterButtonDidTap)) }
    }
    .buttonStyle(.borderedProminent)
  }
}
