import SwiftUI

enum WordLengthOption: Hashable, CaseIterable {
    case two, three, four, aboveFour

    var displayText: String {
        switch self {
        case .two: return "2字"
        case .three: return "3字"
        case .four: return "4字"
        case .aboveFour: return "4字以上"
        }
    }

    var lengthRange: ClosedRange<Int> {
        switch self {
        case .two: return 2...2
        case .three: return 3...3
        case .four: return 4...4
        case .aboveFour: return 5...20 // 可依資料調整最大值
        }
    }

    var allLengths: [Int] {
        Array(lengthRange)
    }
}

class GameSettingModeViewModel: ObservableObject {
    @Published var selectedTimeLimit = 30
    @Published var selectedWordTypeIndex: Int = 0 // 0: simple, 1: idiom
    @Published var selectedWordLengths: Set<WordLengthOption> = Set(WordLengthOption.allCases)
    
    func getGameConfig() -> GameConfig {
        var wordLengths = Set<Int>()
        if selectedWordTypeIndex == 1 {
            wordLengths = [4]
        } else {
            wordLengths = Set(selectedWordLengths.flatMap { $0.allLengths })
        }
        return GameConfig(timeLimit: selectedTimeLimit, wordLengths: wordLengths)
    }
} 
