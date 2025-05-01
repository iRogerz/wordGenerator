import SwiftUI

class GameModeViewModel: ObservableObject {
    @Published var selectedTimeLimit = 30
  @Published var selectedWordTypes: Set<WordType> = [.simple]
    
    func getGameConfig() -> GameConfig {
        let wordLengths = Set(selectedWordTypes.flatMap { type -> [Int] in
            switch type {
            case .idiom:
                return [4]
            case .simple:
                return [2, 3]
            }
        })
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
