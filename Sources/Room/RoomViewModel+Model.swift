//
//  RoomViewModel+Model.swift
//  ChatDemo
//
//  Created by Joe Pan on 2025/12/8.
//

import Foundation
import Combine

extension RoomViewModel {
  struct State: Equatable {
    let user: User
    var messages: [DisplayMessage] = []
    var sendText: String = ""
    var cancellable : AnyCancellable?
    var mqttState: MQTTState = .connecting
  }
}

extension RoomViewModel {
  enum MQTTState: Equatable {
    case connecting
    case connected
    case failed
  }
}

extension RoomViewModel {
  struct User: Equatable, Identifiable {
    let id = UUID().uuidString
    let name: String
  }
}

extension RoomViewModel {
  struct Message: Codable {
    let id: String
    let userId: String
    let userName: String
    let content: String

    init(userId: String, userName: String, content: String) {
      self.id = UUID().uuidString
      self.userId = userId
      self.userName = userName
      self.content = content
    }
  }
}

extension RoomViewModel {
  struct DisplayMessage: Equatable, Identifiable {
    let id: String
    let name: String
    let content: String
    let fromMe: Bool

    init(message: Message, myId: String) {
        self.id = message.id
        self.fromMe = message.userId == myId
        self.name = fromMe ? "我" : message.userName
        self.content = message.content
    }
  }
}
