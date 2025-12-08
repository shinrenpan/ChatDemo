//
//  RoomView.swift
//  ChatDemo
//
//  Created by Joe Pan on 2025/12/8.
//

import SwiftUI

struct RoomView: View {
  let viewModel: RoomViewModel

  init(viewModel: RoomViewModel) {
    self.viewModel = viewModel
  }

  var body: some View {
    contentView()
  }
}

// MARK: - Views

private extension RoomView {
  @ViewBuilder
  func contentView() -> some View {
    switch viewModel.state.mqttState {
    case .connecting:
      ProgressView()

    case .connected:
      VStack {
        ScrollView {
          list()
        }

        inputView()
      }

    case .failed:
      Text("Connection Failed")
        .font(.largeTitle)
        .foregroundStyle(.red)
    }
  }

  @ViewBuilder
  func list() -> some View {
    LazyVStack {
      ForEach(viewModel.state.messages, id: \.id) {
        cell($0)
      }
    }
  }

  @ViewBuilder
  func cell(_ message: RoomViewModel.DisplayMessage) -> some View {
    if message.fromMe {
      myCell(message)
        .padding(.horizontal, 20)
    }
    else {
      targetCell(message)
        .padding(.horizontal, 20)
    }
  }

  @ViewBuilder
  func myCell(_ message: RoomViewModel.DisplayMessage) -> some View {
    HStack(alignment: .top) {
      Spacer()
      Text(message.content)
        .padding()
        .background(.green)
        .clipShape(RoundedRectangle(cornerRadius: 12))
      Text("我")
        .font(.headline)
    }
  }

  @ViewBuilder
  func targetCell(_ message: RoomViewModel.DisplayMessage) -> some View {
    HStack(alignment: .top) {
      Text(message.name)
        .font(.headline)
      Text(message.content)
        .padding()
        .background(.gray)
        .clipShape(RoundedRectangle(cornerRadius: 12))
      Spacer()
    }
  }

  @ViewBuilder
  func inputView() -> some View {
    HStack(alignment: .bottom, spacing: 12) {
      textField()
      sendButton()
    }
    .padding(.horizontal)
    .padding(.vertical, 8)
    .background(.ultraThickMaterial) // 整個 Bar 的背景 (毛玻璃效果)
  }

  @ViewBuilder
  func textField() -> some View {
    @Bindable var vm = viewModel

    TextField("輸入訊息...", text: $vm.state.sendText, axis: .vertical)
      .lineLimit(1...4) // 🔥 關鍵：限制 1 到 4 行，超過自動捲動
      .padding(.horizontal, 12)
      .padding(.vertical, 8)
      .background(Color(.white)) // 輸入框背景色
      .cornerRadius(20)
  }

  @ViewBuilder
  func sendButton() -> some View {
    @Bindable var vm = viewModel

    Button {
      Task { await viewModel.doAction(.view(.sendDidTap)) }
    } label: {
      Image(systemName: "paperplane.fill")
        .font(.system(size: 20))
        .foregroundColor(vm.state.sendText.isEmpty ? .gray : .blue)
        .padding(.bottom, 10) // 對齊底部
    }
    .disabled(vm.state.sendText.isEmpty)
  }
}
