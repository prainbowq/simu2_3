import SwiftUI
import SwiftData

struct LoginScreen: View {
    @Query private let users: [User]
    @State private var email = ""
    @State private var password = ""
    @State private var failure: String?
    @State private var success: String?
    
    func logIn() {
        guard !email.isEmpty else {
            failure = "電子郵件不可為空。"
            return
        }
        guard !password.isEmpty else {
            failure = "密碼不可為空。"
            return
        }
        guard let user = users.first(where: { $0.email == email }), password == user.password else {
            failure = "電子郵件或密碼錯誤。"
            return
        }
        CommerceApp.user = user
        success = "你好，\(user.name)！"
    }
    
    var body: some View {
        VStack {
            Text("登入")
                .font(.largeTitle)
            Grid {
                GridRow {
                    Text("電子郵件")
                        .font(.headline)
                        .gridColumnAlignment(.trailing)
                    TextField(text: $email) {}
                        .keyboardType(.emailAddress)
                        .textInputAutocapitalization(.never)
                }
                GridRow {
                    Text("密碼")
                        .font(.headline)
                    SecureField(text: $password) {}
                        .onSubmit(logIn)
                }
            }
            .textFieldStyle(.roundedBorder)
            Button("登入", action: logIn)
                .buttonStyle(.borderedProminent)
            HStack {
                Text("還沒有帳號嗎？")
                NavigationLink("註冊") {
                    SignupScreen()
                }
            }
        }
        .padding(.horizontal)
        .alert("失敗", isPresented: .constant(failure != nil)) {
            Button("確認") {
                failure = nil
            }
        } message: {
            Text(failure ?? "")
        }
        .alert("成功", isPresented: .constant(success != nil)) {
            NavigationLink("確認") {
                MainScreen()
                    .navigationBarBackButtonHidden()
            }
        } message: {
            Text(success ?? "")
        }
    }
}
