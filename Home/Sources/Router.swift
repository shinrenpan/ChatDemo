//
//  Router.swift
//  Home
//
//  Created by Joe Pan on 2025/3/6.
//

import Room

@MainActor final class Router {
    weak var vc: ViewController?
}

// MARK: - Internal

extension Router {
    func toRoom(userName: String) {
        let to = Room.ViewController(userName: userName)
        vc?.navigationController?.pushViewController(to, animated: true)
    }
}
