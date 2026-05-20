# ChatDemo

## App 架構

UIKit + SwiftUI 混合，使用 SceneDelegate 管理 window，UINavigationController 管理頁面堆疊。

## Project Structure

```
Sources/
├── AppDelegate.swift
├── SceneDelegate.swift
├── Extensions/
│   └── Notification+Extensions.swift   # MQTTReceivedMessage 通知名稱
├── Manager/
│   └── MQTTManager.swift               # actor，管理 MQTT 連線/發送/斷線
├── Home/
│   ├── HomeViewModel+Models.swift       # M
│   ├── HomeViewModel.swift              # VM
│   ├── HomeView.swift                   # V
│   └── HomeHostController.swift         # C
└── Room/
    ├── RoomViewModel+Models.swift        # M
    ├── RoomViewModel.swift               # VM
    ├── RoomView.swift                    # V
    └── RoomHostController.swift          # C
```

## Architecture: MVVMC

| 層 | 職責 |
|---|---|
| M | State struct（Sendable）、Domain Models |
| VM | @Observable @MainActor，doAction 單一進入點，onRoute 觸發導航 |
| V | 純 SwiftUI，零導航邏輯 |
| C | UIHostingController，設定 onRoute，處理導航 |

## MQTT 訊息流

1. `MQTTManager.connect()` 連線並訂閱 topic，收到訊息後 post `MQTTReceivedMessage` 通知
2. `RoomViewModel` 訂閱通知，decode `Message`，append 至 `state.messages`
3. `RoomHostController` 在 `viewDidAppear` / `viewDidDisappear` 觸發連線與斷線

## 使用方式

```bash
brew install xcodegen
xcodegen generate
open ChatDemo.xcodeproj
```
