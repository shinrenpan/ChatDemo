import Foundation

// MARK: - State

extension RoomViewModel {
  struct State: Sendable {
    let user: User
    var messages: [DisplayMessage] = []
    var sendText: String = ""
    var mqttState: MQTTState = .connecting
  }
}

// MARK: - Domain Models

extension RoomViewModel {
  enum MQTTState: Sendable {
    case connecting
    case connected
    case failed
  }

  struct User: Identifiable, Sendable {
    let id = UUID().uuidString
    let name: String
  }

  struct Message: Codable, Sendable {
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

  struct DisplayMessage: Identifiable, Sendable {
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
