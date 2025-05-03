import SwiftUI

struct GeneratorModeView: View {
    @Binding var navigationPath: NavigationPath
    @State private var selectedType = 0
    @State private var currentWord: GameWord?
    @State private var showHint = false
    
    let types = ["詞語", "成語"]
    
    var body: some View {
        VStack {
            Picker("選擇類型", selection: $selectedType) {
                ForEach(0..<types.count, id: \.self) { index in
                    Text(types[index]).tag(index)
                }
            }
            .pickerStyle(SegmentedPickerStyle())
            .padding()
            
            Spacer()
            
            if let word = currentWord {
                Text(word.name)
                    .font(.system(size: 40))
                    .fontWeight(.bold)
                    .multilineTextAlignment(.center)
                    .padding()
                
                if showHint {
                    Text(word.note)
                        .font(.subheadline)
                        .foregroundColor(.gray)
                        .padding()
                }
            }
            
            Spacer()
            
            HStack(spacing: 20) {
                Button(action: {
                    generateNewWord()
                }) {
                    Text("產生詞彙")
                        .font(.title2)
                        .foregroundColor(.white)
                        .padding()
                        .background(Color.blue)
                        .cornerRadius(10)
                }
                
                Button(action: {
                    showHint.toggle()
                }) {
                    Text("提示")
                        .font(.title2)
                        .foregroundColor(.white)
                        .padding()
                        .background(Color.gray)
                        .cornerRadius(10)
                }
            }
            .padding(.bottom)
        }
        .padding()
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            generateNewWord()
        }
    }
    
    private func generateNewWord() {
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
}

#Preview {
    GeneratorModeView(navigationPath: .constant(NavigationPath()))
} 
