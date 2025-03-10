//
//  MQTTManager.swift
//  MQTTManager
//
//  Created by Joe Pan on 2025/3/9.
//

import MQTTNIO
import Logging
import NIOTransportServices
import Foundation

public actor MQTTManager {
    public static let shared = MQTTManager()
    private let topic = "JoeChatDemo/chat"
    private var client: MQTTClient?
    private let eventLoopGroup = NIOTSEventLoopGroup()
    
    private init() {}
}

// MARK: - Public

public extension MQTTManager {
    func send(message: Message) async throws {
        let data = try JSONEncoder().encode(message)
        try await client?.publish(to: topic, payload: .init(data: data), qos: .exactlyOnce)
    }
    
    func connect(userId: String) async throws {
        try? await disconnect()
        
        self.client = MQTTClient(
            host: "broker.emqx.io",
            port: 1883,
            identifier: userId,
            eventLoopGroupProvider: .shared(eventLoopGroup)
        )
        
        client?.addPublishListener(named: topic) { result in
            switch result {
            case let .success(value):
                if let data = String(buffer: value.payload).data(using: .utf8) {
                    NotificationCenter.default.post(name: .MQTTReceivedMessage, object: data)
                }
            case .failure:
                break
            }
        }
        
        try await client?.connect(cleanSession: true)
        let topic = MQTTSubscribeInfo(topicFilter: "JoeChatDemo/chat", qos: .exactlyOnce)
        _ = try await client?.subscribe(to: [topic])
    }
    
    func disconnect() async throws {
        client?.removePublishListener(named: topic)
        try? await client?.unsubscribe(from: [topic])
        try? await client?.disconnect()
        try? await client?.shutdown()
        self.client = nil
    }
}
