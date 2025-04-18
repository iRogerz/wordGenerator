import Foundation

class WordManager {
    static let shared = WordManager()
    
    private var words: [Word] = []
    
    private init() {
        loadWords()
    }
    
    private func loadWords() {
        if let url = Bundle.main.url(forResource: "output", withExtension: "json") {
            do {
                let data = try Data(contentsOf: url)
                let rawWords = try JSONDecoder().decode([RawWord].self, from: data)
                words = rawWords.map { rawWord in
                    let type: WordType
                    if rawWord.name.count == 4 {
                        type = .idiom
                    } else if rawWord.name.count <= 3 {
                        type = .phrase
                    } else {
                        type = .random
                    }
                    return Word(name: rawWord.name, note: rawWord.note, type: type)
                }
                print("成功載入 \(words.count) 個詞語")
            } catch {
                print("Error loading words: \(error)")
            }
        } else {
            print("找不到output.json 檔案")
        }
    }
    
    func getRandomWord(type: WordType? = nil, lengths: Set<Int>? = nil) -> Word? {
        var filteredWords = words
        
        if let type = type {
            filteredWords = filteredWords.filter { $0.type == type }
        }
        
        if let lengths = lengths {
            filteredWords = filteredWords.filter { lengths.contains($0.name.count) }
        }
        
        return filteredWords.randomElement()
    }
    
    func getRandomWords(count: Int, type: WordType? = nil, lengths: Set<Int>? = nil) -> [Word] {
        var filteredWords = words
        
        if let type = type {
            filteredWords = filteredWords.filter { $0.type == type }
        }
        
        if let lengths = lengths {
            filteredWords = filteredWords.filter { lengths.contains($0.name.count) }
        }
        
        var result: [Word] = []
        for _ in 0..<count {
            if let word = filteredWords.randomElement() {
                result.append(word)
            }
        }
        
        return result
    }
}

struct Word: Codable {
    let name: String
    let note: String
    let type: WordType
}

struct RawWord: Codable {
    let name: String
    let note: String
}

enum WordType: String, Codable, CaseIterable {
    case phrase = "詞語"
    case idiom = "成語"
    case random = "隨機"
} 
