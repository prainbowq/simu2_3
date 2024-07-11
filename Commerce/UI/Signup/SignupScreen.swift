import SwiftUI
import SwiftData

struct SignupScreen: View {
    static private let rolesActions = [("買家", "購物"), ("賣家", "販售")]
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var modelContext
    @Query private let users: [User]
    @State private var role = rolesActions.first!.0
    @State private var name = ""
    @State private var email = ""
    @State private var password = ""
    @State private var confirmation = ""
    @State private var failure: String?
    @State private var success: String?
    
    func signUp() {
        guard !name.isEmpty else {
            failure = "姓名不可為空。"
            return
        }
        guard !email.isEmpty else {
            failure = "電子郵件不可為空。"
            return
        }
        guard !password.isEmpty else {
            failure = "密碼不可為空。"
            return
        }
        guard !confirmation.isEmpty else {
            failure = "確認密碼不可為空。"
            return
        }
        guard !users.contains(where: { $0.email == email }) else {
            failure = "電子郵件已被使用。"
            return
        }
        modelContext.insert(
            User(
                id: (users.map { $0.id }.max() ?? 0) + 1,
                role: role,
                name: name,
                email: email,
                password: password,
                cart: []
            )
        )
        success = "現在開始\(SignupScreen.rolesActions.first { $0.0 == role }!.1)吧！"
    }
    
    var body: some View {
        VStack {
            Text("註冊")
                .font(.largeTitle)
            Grid {
                GridRow {
                    Text("身分")
                        .font(.headline)
                        .gridColumnAlignment(.trailing)
                    Picker(selection: $role) {
                        ForEach(SignupScreen.rolesActions, id: \.0) {
                            Text($0.0)
                        }
                    } label: {}
                        .pickerStyle(.segmented)
                }
                GridRow {
                    Text("姓名")
                        .font(.headline)
                    TextField(text: $name) {}
                }
                GridRow {
                    Text("電子郵件")
                        .font(.headline)
                    TextField(text: $email) {}
                        .keyboardType(.emailAddress)
                        .textInputAutocapitalization(.never)
                }
                GridRow {
                    Text("密碼")
                        .font(.headline)
                    SecureField(text: $password) {}
                }
                GridRow {
                    Text("確認密碼")
                        .font(.headline)
                    SecureField(text: $confirmation) {}
                        .onSubmit(signUp)
                }
            }
            .textFieldStyle(.roundedBorder)
            Button("註冊", action: signUp)
                .buttonStyle(.borderedProminent)
            HStack {
                Text("已經有帳號嗎？")
                Button("登入") {
                    dismiss()
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
            Button("確認") {
                dismiss()
            }
        } message: {
            Text(success ?? "")
        }
    }
}
