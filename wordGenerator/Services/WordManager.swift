import Foundation
import SwiftData

enum WordType: String, Codable, CaseIterable, Equatable, Hashable {
    case simple = "詞語"
    case idiom = "成語"
}

class WordManager {
    static let shared = WordManager()
    private init() {}

    private(set) var simpleWords: [SimpleWord] = []
    private(set) var idiomWords: [IdiomWord] = []

    /// 載入所有詞語與成語到記憶體快取
    func loadAllWords(context: ModelContext) {
        simpleWords = (try? context.fetch(FetchDescriptor<SimpleWord>())) ?? []
        idiomWords = (try? context.fetch(FetchDescriptor<IdiomWord>())) ?? []
        print("快取 simpleWords: \(simpleWords.count) 筆, idiomWords: \(idiomWords.count) 筆")
    }

    /// 只從快取 array 取隨機詞語或成語
    func getRandomWord(type: WordType? = nil, lengths: Set<Int>? = nil) -> GameWord? {
        switch type {
        case .idiom:
            // 成語直接隨機取，不篩選長度
            guard let idiom = idiomWords.randomElement() else { return nil }
            return GameWord(
                name: idiom.name,
                note: idiom.note,
                type: .idiom,
                idiom: IdiomDetail(
                    interpretation: idiom.interpretation,
                    allusionDescription: idiom.allusionDescription,
                    usageDescription: idiom.usageDescription,
                    example: idiom.example,
                    usageCategory: idiom.usageCategory,
                    mainIdioms: idiom.mainIdioms
                )
            )
        default:
            let filtered = lengths == nil ? simpleWords : simpleWords.filter { lengths!.contains($0.name.count) }
            guard let word = filtered.randomElement() else { return nil }
            return GameWord(
                name: word.name,
                note: word.note,
                type: .simple,
                idiom: nil
            )
        }
    }
}

struct GameWord: Codable, Equatable, Hashable {
    let name: String
    let note: String
    let type: WordType
    let idiom: IdiomDetail?
}

struct IdiomDetail: Codable, Equatable, Hashable {
    let interpretation: String?
    let allusionDescription: String?
    let usageDescription: String?
    let example: String?
    let usageCategory: String?
    let mainIdioms: Bool
}

/// 僅供 DataImporter 使用的 JSON 解析結構
struct RawWord: Codable {
    let name: String
    let note: String
    let zhuyin: String
    let interpretation: String?
    let allusionDescription: String?
    let usageDescription: String?
    let usageCategory: String?
    let example: String?
    let mainIdioms: Bool?
}
