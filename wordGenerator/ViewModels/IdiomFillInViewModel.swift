import Foundation
import SwiftData

class IdiomFillInViewModel: ObservableObject {
    @Published var currentWord: GameWord?
    @Published var maskedAllusion: String = ""
    
    init() {
        generateNewQuestion()
    }
    
    func generateNewQuestion() {
        // 取一個隨機成語
        if let word = WordManager.shared.getRandomWord(type: .idiom) {
            currentWord = word
            if let allusion = word.idiom?.allusionDescription {
                // 遮蔽邏輯：只要 allusion 內有出現成語 name 的任一個字，都換成 □
                var masked = allusion
                for char in Set(word.name) where char != " " {
                    masked = masked.replacingOccurrences(of: String(char), with: "□")
                }
                maskedAllusion = masked
            } else {
                maskedAllusion = ""
            }
        } else {
            currentWord = nil
            maskedAllusion = ""
        }
    }
    
    // AB 計算邏輯
    func abResult(for answer: String) -> (a: Int, b: Int) {
        guard let word = currentWord else { return (0, 0) }
        let answerArr = Array(answer)
        let targetArr = Array(word.name)
        var a = 0, b = 0
        var usedTarget = Array(repeating: false, count: targetArr.count)
        var usedAnswer = Array(repeating: false, count: answerArr.count)
        // 先算A
        for i in 0..<min(answerArr.count, targetArr.count) {
            if answerArr[i] == targetArr[i] {
                a += 1
                usedTarget[i] = true
                usedAnswer[i] = true
            }
        }
        // 再算B
        for i in 0..<answerArr.count {
            if usedAnswer[i] { continue }
            for j in 0..<targetArr.count {
                if !usedTarget[j] && answerArr[i] == targetArr[j] {
                    b += 1
                    usedTarget[j] = true
                    break
                }
            }
        }
        return (a, b)
    }
} 
