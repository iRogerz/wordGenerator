import Foundation

// 全域路由列舉，集中管理所有 navigation path

enum AppRoute: Hashable {
    case gameMode
    case generatorMode
    case idiomFillIn
    case gamePlay(GameConfig)
    case gameOver(GameOverRoute)
} 