import SwiftUI
import SwiftData

class GeneratorModeViewModel: ObservableObject {
    @Published var currentWord: GameWord?
    @Published var showHint = false
    @Published var selectedType: Int = 0
    
    let types = ["詞語", "成語"]
    
    func updateSelectedType(_ type: Int) {
        selectedType = type
    }
    
    func generateNewWord() {
        let type: WordType?
        switch selectedType {
        case 0:
          type = .simple
        case 1:
          type = .idiom
        default:
          type = nil
        }
        
        currentWord = WordManager.shared.getRandomWord(type: type)
        showHint = false
    }
    
    func toggleHint() {
        showHint.toggle()
    }
} 
