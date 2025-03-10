//
//  Message.swift
//  MQTTManager
//
//  Created by Joe Pan on 2025/3/9.
//

import Foundation

public struct Message: Codable {
    public let id: String
    public let userId: String
    public let userName: String
    public let content: String
    
    public init(userId: String, userName: String, content: String) {
        self.id = UUID().uuidString
        self.userId = userId
        self.userName = userName
        self.content = content
    }
}

public extension Notification.Name {
    static let MQTTReceivedMessage: Notification.Name = Notification.Name("MQTTReceivedMessage")
}
