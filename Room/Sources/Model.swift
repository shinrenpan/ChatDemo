//
//  Model.swift
//  Room
//
//  Created by Joe Pan on 2025/3/7.
//

import MQTTManager
import UIKit

typealias DataSource = UICollectionViewDiffableDataSource<Int, DisplayMessage>
typealias SnapShot = NSDiffableDataSourceSnapshot<Int, DisplayMessage>
typealias CellRegistration = UICollectionView.CellRegistration<UICollectionViewCell, DisplayMessage>

enum Action {
    case connect
    case disconnect
    case sendMessage(String)
}

enum MQTTError: Error {
    case connectFailed
    case sendFailed
}

enum State {
    case none
    case connected
    case error(MQTTError)
    case sendSuccess
    case recievedMessage(DisplayMessage)
}

struct DisplayMessage: Hashable {
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
