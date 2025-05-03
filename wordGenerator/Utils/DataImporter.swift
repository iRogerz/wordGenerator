import Foundation
import SwiftData

class DataImporter {
    static func importIfNeeded(context: ModelContext) {
        // 檢查是否已經有資料，避免重複匯入
        let idiomCount = (try? context.fetch(FetchDescriptor<IdiomWord>()).count) ?? 0
        let simpleCount = (try? context.fetch(FetchDescriptor<SimpleWord>()).count) ?? 0
        
        guard idiomCount == 0, simpleCount == 0 else {
            print("已存在資料，跳過匯入")
            return
        }
        
        // 匯入 simple.json
        if let simpleUrl = Bundle.main.url(forResource: "simple", withExtension: "json") {
            do {
                let data = try Data(contentsOf: simpleUrl)
                let rawWords = try JSONDecoder().decode([RawWord].self, from: data)
                let simpleWords = rawWords
                .filter { $0.name.count >= 2 }
                .map { raw in
                    SimpleWord(name: raw.name, note: raw.note, zhuyin: raw.zhuyin)
                }
                for word in simpleWords {
                    context.insert(word)
                }
                print("匯入 simple.json 完成，共 \(simpleWords.count) 筆")
            } catch {
                print("simple.json 匯入失敗: \(error)")
            }
        }
        // 匯入 idioms.json
        if let idiomsUrl = Bundle.main.url(forResource: "idioms", withExtension: "json") {
            do {
                let data = try Data(contentsOf: idiomsUrl)
                let rawWords = try JSONDecoder().decode([RawWord].self, from: data)
                let idiomWords = rawWords.filter { $0.mainIdioms == true }.map { raw in
                    IdiomWord(
                        name: raw.name,
                        note: raw.note,
                        zhuyin: raw.zhuyin,
                        interpretation: raw.interpretation,
                        allusionDescription: raw.allusionDescription,
                        usageDescription: raw.usageDescription,
                        example: raw.example,
                        usageCategory: raw.usageCategory,
                        mainIdioms: raw.mainIdioms ?? false
                    )
                }
                for word in idiomWords {
                    context.insert(word)
                }
                print("匯入 idioms.json 完成，共 \(idiomWords.count) 筆")
            } catch {
                print("idioms.json 匯入失敗: \(error)")
            }
        }
        do {
            try context.save()
        } catch {
            print("SwiftData 儲存失敗: \(error)")
        }
    }
}
