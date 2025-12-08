//
//  ViewModel.swift
//  ChatDemo
//
//  Created by Joe Pan on 2025/12/8.
//

import Foundation

@MainActor
protocol ViewModel: AnyObject {
  associatedtype Action: Sendable, Equatable
  associatedtype Callback: Sendable, Equatable

  var onAction: (@MainActor (Action) -> Void)? { get set }
  var onCallback: (@MainActor (Callback) -> Void)? { get set }

  func doAction(_ action: Action) async
}
