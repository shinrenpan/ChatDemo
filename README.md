# ChatDemo

透過 MQTT 實作即時聊天示範 App。

參考文章：https://joepan.hashnode.dev/mqtt-demo

---

## 使用方式

```bash
brew install xcodegen
xcodegen generate
open ChatDemo.xcodeproj
```

---

## 功能

- 輸入使用者名稱進入聊天室
- 連線公開 MQTT broker（broker.emqx.io）
- 即時發送與接收聊天訊息

## 架構

採用 MVVMC 架構，兩個頁面：

| 頁面 | 層 | 檔案 |
|------|---|------|
| Home | M | `HomeViewModel+Models.swift` |
| Home | VM | `HomeViewModel.swift` |
| Home | V | `HomeView.swift` |
| Home | C | `HomeHostController.swift` |
| Room | M | `RoomViewModel+Models.swift` |
| Room | VM | `RoomViewModel.swift` |
| Room | V | `RoomView.swift` |
| Room | C | `RoomHostController.swift` |

## 技術

- Swift 6 / iOS 18
- UIKit + SwiftUI（`UIHostingController`）
- Swift Observation（`@Observable`）
- Swift Concurrency（`async/await`）
- [MQTTNIO](https://github.com/swift-server-community/mqtt-nio) 2.12.1
