import SwiftUI
import SwiftData

struct GeneratorModeView: View {
    @Binding var navigationPath: NavigationPath
    @StateObject private var viewModel = GeneratorModeViewModel()
    
    var body: some View {
        VStack {
            Picker("選擇類型", selection: $viewModel.selectedType) {
                ForEach(0..<viewModel.types.count, id: \.self) { index in
                    Text(viewModel.types[index]).tag(index)
                }
            }
            .pickerStyle(SegmentedPickerStyle())
            .padding()
            
            Spacer()
            
            if let word = viewModel.currentWord {
                Text(word.name)
                    .font(.system(size: 40))
                    .fontWeight(.bold)
                    .multilineTextAlignment(.center)
                    .padding()
                
                if viewModel.showHint {
                    Text(word.note)
                        .font(.subheadline)
                        .foregroundColor(.gray)
                        .padding()
                }
            }
            
            Spacer()
            
            HStack(spacing: 20) {
                Button(action: {
                    viewModel.generateNewWord()
                }) {
                    Text("產生詞彙")
                        .font(.title2)
                        .foregroundColor(.white)
                        .padding()
                        .background(Color.blue)
                        .cornerRadius(10)
                }
                
                Button(action: {
                    viewModel.toggleHint()
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
            viewModel.generateNewWord()
        }
    }
}

#Preview {
    GeneratorModeView(navigationPath: .constant(NavigationPath()))
} 
