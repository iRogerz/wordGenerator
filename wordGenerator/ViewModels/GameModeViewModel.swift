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

class GameModeViewModel: ObservableObject {
    @Published var selectedTimeLimit = 30
    @Published var selectedWordTypes: Set<WordType> = [.simple]
    @Published var selectedWordLengths: Set<WordLengthOption> = Set(WordLengthOption.allCases)
    
    func getGameConfig() -> GameConfig {
        var wordLengths = Set<Int>()
        if selectedWordTypes.contains(.idiom) && !selectedWordTypes.contains(.simple) {
            wordLengths = [4]
        } else if selectedWordTypes.contains(.simple) {
            // 合併所有勾選長度
            wordLengths = Set(selectedWordLengths.flatMap { $0.allLengths })
        }
        return GameConfig(timeLimit: selectedTimeLimit, wordLengths: wordLengths)
    }
    
    func updateWordTypes(_ newValue: Set<WordType>) {
        if newValue.isEmpty {
           selectedWordTypes = Set([.simple])
        } else {
            selectedWordTypes = newValue
        }
    }
} 
