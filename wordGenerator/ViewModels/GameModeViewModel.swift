import SwiftUI

class GameModeViewModel: ObservableObject {
    @Published var selectedTimeLimit = 30
    @Published var selectedWordTypes: Set<WordType> = [.phrase]
    
    func getGameConfig() -> GameConfig {
        let wordLengths = Set(selectedWordTypes.flatMap { type -> [Int] in
            switch type {
            case .idiom:
                return [4]
            case .phrase:
                return [2, 3]
            case .random:
                return [2, 3, 4]
            }
        })
        return GameConfig(timeLimit: selectedTimeLimit, wordLengths: wordLengths)
    }
    
    func updateWordTypes(_ newValue: Set<WordType>) {
        if newValue.isEmpty {
            selectedWordTypes = Set([.phrase])
        } else {
            selectedWordTypes = newValue
        }
    }
} 