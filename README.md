# Word Generator

這是一個使用 Swift 開發的單詞生成器應用程式。

## 開發工具使用比例

本專案使用以下工具進行開發：

- 80% 使用 [Cursor](https://cursor.sh/) - 主要用於代碼生成、重構和自動完成
- 10% 使用 ChatGPT - 用於解決特定問題和提供建議
- 10% 手動修改 - 用於微調和優化代碼

## 功能特點

- 生成隨機單詞
- 自定義單詞生成規則
- 用戶友好的界面

## 系統需求

- iOS 15.0 或更高版本
- Xcode 13.0 或更高版本
- Swift 5.0 或更高版本

## 安裝說明

1. 克隆此專案到本地：

```bash
git clone [repository-url]
```

2. 使用 Xcode 打開 `wordGenerator.xcodeproj` 文件

3. 選擇目標設備或模擬器

4. 點擊運行按鈕或使用快捷鍵 `Cmd + R` 來運行應用程式

## 專案結構

```
wordGenerator/
├── wordGenerator/
│   ├── Models/           # 資料模型
│   │   └── Item.swift
│   ├── Views/            # 視圖組件
│   │   ├── ContentView.swift
│   │   ├── GameModeView.swift
│   │   ├── GamePlayView.swift
│   │   └── GeneratorModeView.swift
│   ├── Services/         # 服務層
│   │   └── WordManager.swift
│   ├── ViewModels/       # 視圖模型
│   ├── Utils/            # 工具類
│   ├── Assets.xcassets/  # 資源文件
│   ├── Preview Content/  # 預覽內容
│   └── wordGeneratorApp.swift
└── wordGenerator.xcodeproj/
```

## 開發工具推薦

- [Cursor](https://cursor.sh/) - 強大的 AI 輔助開發工具
- Xcode - Apple 官方開發環境
- ChatGPT - 用於解決特定編程問題

## 貢獻指南

歡迎提交 Pull Request 或提出 Issue。

## 授權

[MIT License](LICENSE)
