import Foundation

enum WordType: String, Codable, CaseIterable {
    case simple = "一般詞語"
    case idiom = "成語"
}

struct RawWord: Codable {
    let name: String
    let note: String
    let idiom: IdiomWord?
    let mainIdioms: Bool?
}

class WordManager {
    static let shared = WordManager()
    
    private var words: [Word] = []
    private var idioms: [Word] = []
    
    private init() {
        loadWords()
    }
    
    private func loadWords() {
        // 讀取 simple.json
        if let simpleUrl = Bundle.main.url(forResource: "simple", withExtension: "json") {
            do {
                let data = try Data(contentsOf: simpleUrl)
                let rawWords = try JSONDecoder().decode([RawWord].self, from: data)
                // 只保留兩個字以上的詞語
                words = rawWords
                    .filter { $0.name.count >= 2 }
                    .map { rawWord in
                        return Word(name: rawWord.name, note: rawWord.note, type: .simple, idiom: nil)
                    }
                print("成功載入 \(words.count) 個詞語")
            } catch {
                print("Error loading simple.json: \(error)")
            }
        } else {
            print("找不到 simple.json 檔案")
        }
        
        // 讀取 idioms.json
        if let idiomsUrl = Bundle.main.url(forResource: "idioms", withExtension: "json") {
            do {
                let data = try Data(contentsOf: idiomsUrl)
                let rawWords = try JSONDecoder().decode([RawWord].self, from: data)
                // 只保留 mainIdioms 為 true 的成語
                idioms = rawWords
                    .filter { $0.mainIdioms == true }
                    .map { rawWord in
                        return Word(name: rawWord.name, note: rawWord.note, type: .idiom, idiom: rawWord.idiom)
                    }
                print("成功載入 \(idioms.count) 個成語")
            } catch {
                print("Error loading idioms.json: \(error)")
            }
        } else {
            print("找不到 idioms.json 檔案")
        }
    }
    
    func getRandomWord(type: WordType? = nil, lengths: Set<Int>? = nil) -> Word? {
        var sourceWords: [Word]
        
        if type == .idiom {
            sourceWords = idioms
        } else {
            // 一般模式：只使用 simple 的詞語
            sourceWords = words
        }
        
        if let lengths = lengths {
            sourceWords = sourceWords.filter { lengths.contains($0.name.count) }
        }
        
        return sourceWords.randomElement()
    }
    
}

struct Word: Codable {
    let name: String
    let note: String
    let type: WordType
    let idiom: IdiomWord?
}

struct IdiomWord: Codable {
    let interpretation: String
    let allusionDescription: String
    let usageDescription: String
    let example: String
    let usageCategory: String
    let mainIdioms: Bool
} 
