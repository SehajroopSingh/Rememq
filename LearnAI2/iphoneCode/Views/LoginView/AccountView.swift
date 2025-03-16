// 🔹 New Account View
struct AccountView: View {
    var body: some View {
        VStack {
            Text("User Account")
                .font(.largeTitle)
                .fontWeight(.bold)
            
            Text("This is where the user’s account details would be displayed.")
                .padding()
            
            Spacer()
        }
        .navigationTitle("Account")  // ✅ Shows title in navigation bar
    }
}// 🔹 New Card Section View with Two Horizontal Scroll Stacks 🔹