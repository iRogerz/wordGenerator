import SwiftUI

struct IdiomFillInView: View {
    @EnvironmentObject var router: AppRouter
    @State private var answer: String = ""
    @StateObject private var viewModel = IdiomFillInViewModel()
    
    var body: some View {
        ZStack {
            Color.Background.yellow
                .ignoresSafeArea()
          
            VStack(spacing: 32) {
                // 標題
                Text("成語填空")
                    .font(.system(size: 40, weight: .bold))
                    .foregroundColor(Color.Primary.deepBlue)
//                    .padding(.top, 16)
                
                // 古語典故區塊
                VStack(alignment: .center, spacing: 12) {
                    Text("古語典故")
                        .font(.title2)
                        .bold()
                        .foregroundColor(Color.Primary.deepBlue)
                    ScrollView {
                        Text(viewModel.maskedAllusion)
                            .font(.system(size: 20))
                            .foregroundColor(Color.Primary.deepBlue)
                            .multilineTextAlignment(.leading)
                    }
                    .frame(height: 300)
                }
                .padding()
                .background(Color.Background.lightYellow)
                .cornerRadius(20)
                .overlay(
                    RoundedRectangle(cornerRadius: 20)
                        .stroke(Color.Primary.deepBlue, lineWidth: 6)
                )
                .padding(.horizontal)
                
                // 填空題區塊
                VStack(spacing: 16) {
                    Text("請填入正確的成語")
                        .font(.title3)
                        .foregroundColor(Color.Primary.deepBlue)
                    HStack(spacing: 8) {
                        // 左側 AB 結果
                        let ab = viewModel.abResult(for: answer)
                        Text("\(ab.a)A\(ab.b)B")
                            .font(.title2)
                            .foregroundColor(.Primary.orange)
                            .frame(width: 60, alignment: .trailing)
                        // 輸入框
                        TextField("請輸入", text: Binding(
                            get: {
                                if let word = viewModel.currentWord {
                                    return String(answer.prefix(word.name.count))
                                } else {
                                    return answer
                                }
                            },
                            set: { newValue in
                                if let word = viewModel.currentWord {
                                    answer = String(newValue.prefix(word.name.count))
                                } else {
                                    answer = newValue
                                }
                            }
                        ))
                        .font(.system(size: 38, weight: .bold))
                        .multilineTextAlignment(.center)
                        .cornerRadius(8)
                        .frame(width: 180)
                        .submitLabel(.done)
                        // 右側答對提示
                        if let word = viewModel.currentWord, ab.a == word.name.count && word.name.count > 0 {
                            Text("答對！")
                                .font(.title2)
                                .foregroundColor(.green)
                                .bold()
                                .fixedSize()
                                .frame(minWidth: 60, alignment: .leading)
                        } else {
                            Spacer().frame(width: 60)
                        }
                    }
                }
                .padding()
                .background(Color.Background.lightYellow)
                .cornerRadius(20)
                .overlay(
                    RoundedRectangle(cornerRadius: 20)
                        .stroke(Color.Primary.deepBlue, lineWidth: 6)
                )
                .padding(.horizontal)
              
                Spacer()
                
                // 按鈕區塊
                HStack(spacing: 32) {
                    Button(action: {
                        // 提示功能
                    }) {
                        HStack {
                            Image(systemName: "lightbulb")
                                .font(.system(size: 28))
                            Text("提示")
                                .font(.title2)
                                .bold()
                        }
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.Background.yellow)
                        .foregroundColor(Color.Primary.deepBlue)
                        .cornerRadius(16)
                        .overlay(
                            RoundedRectangle(cornerRadius: 16)
                                .stroke(Color.Primary.deepBlue, lineWidth: 4)
                        )
                    }
                    Button(action: {
                        viewModel.generateNewQuestion()
                        answer = ""
                    }) {
                        HStack {
                            Image(systemName: "dice")
                                .font(.system(size: 28))
                            Text("產生")
                                .font(.title2)
                                .bold()
                        }
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.Primary.orange)
                        .foregroundColor(Color.Primary.deepBlue)
                        .cornerRadius(16)
                        .overlay(
                            RoundedRectangle(cornerRadius: 16)
                                .stroke(Color.Primary.deepBlue, lineWidth: 4)
                        )
                    }
                }
                .padding(.horizontal)
                .padding(.bottom, 40)
            }
        }
        .toolbar {
          ToolbarItem(placement: .topBarLeading) {
            Button(action: {
              router.pop()
            }) {
              Image(systemName: "chevron.backward")
              Text("返回")
            }
            .font(.title3)
            .bold()
            .foregroundColor(.Primary.deepBlue)
              
          }
        }
        .navigationBarBackButtonHidden()
    }
}

struct IdiomFillInView_Previews: PreviewProvider {
    static var previews: some View {
        IdiomFillInView()
    }
} 
