import Foundation
import SwiftData
import SwiftUI

class IdiomFillInViewModel: ObservableObject {
    @Published var currentWord: GameWord?
    @Published var maskedAllusion: String = ""
    @Published var hintCount: Int = 0
    
    /// 目前提示到的答案內容
    var currentHintAnswer: String {
        guard let word = currentWord else { return "" }
        if hintCount > 0 {
            return String(word.name.prefix(hintCount))
        } else {
            return ""
        }
    }
    
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
        hintCount = 0 // 產生新題時重置提示
    }
    
    // 提示：顯示下一個字
    func revealNextHint() {
        guard let word = currentWord else { return }
        if hintCount < word.name.count {
            hintCount += 1
        }
    }
    // 重置提示
    func resetHint() {
        hintCount = 0
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

    // 顯示用：根據答題狀態產生 AttributedString，square 為紅色，答對時原字為綠色
    func maskedAllusionDisplay(answer: String) -> AttributedString {
        guard let word = currentWord else { return AttributedString(maskedAllusion) }
        let ab = abResult(for: answer)
        if ab.a == word.name.count && word.name.count > 0 {
            guard let allusion = word.idiom?.allusionDescription else { return AttributedString("") }
            var attr = AttributedString(allusion)
            let idiomSet = Set(word.name).subtracting([" "])
            for (i, char) in attr.characters.enumerated() {
                if idiomSet.contains(char) {
                    let start = attr.characters.index(attr.characters.startIndex, offsetBy: i)
                    let end = attr.characters.index(after: start)
                    let range = start..<end
                    attr[range].foregroundColor = .green
                }
            }
            return attr
        } else {
            var attr = AttributedString(maskedAllusion)
            for (i, char) in attr.characters.enumerated() {
                if char == "□" {
                    let start = attr.characters.index(attr.characters.startIndex, offsetBy: i)
                    let end = attr.characters.index(after: start)
                    let range = start..<end
                    attr[range].foregroundColor = .red
                }
            }
            return attr
        }
    }
} 
