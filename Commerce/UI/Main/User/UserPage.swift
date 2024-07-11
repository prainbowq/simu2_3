import SwiftUI

struct UserPage: View {
    @State private var confirming = false
    
    var body: some View {
        VStack {
            Text(CommerceApp.user.name)
                .font(.largeTitle)
            Text(CommerceApp.user.email)
                .font(.title)
            Button("登出") {
                confirming = true
            }
            .buttonStyle(.borderedProminent)
        }
        .alert("確認", isPresented: $confirming) {
            Button("否") {}
            NavigationLink("是") {
                LoginScreen()
                    .navigationBarBackButtonHidden()
                    .onAppear {
                        CommerceApp.user = nil
                    }
            }
        } message: {
            Text("確定要登出嗎？")
        }
    }
}
