import SwiftUI

struct iPhoneHomeView: View {
    @State private var name: String = ""
    var body: some View {

        NavigationView {

            VStack(spacing: 20) {
                Color.red.grayscale(0.5)
                Text("Welcome")
                    .font(.largeTitle)
                    .padding()
                    .background(Color.green.gradient.opacity(0.9))
                    .cornerRadius(100)
                
                TextField("Enter your name", text: $name)
                    .padding()
                    .background(Color.blue.gradient.opacity(0.9))
                    .cornerRadius(100)
                    .padding()
                Text("Hello, \(name)")
                ZStack {
                    Text("Hello, world!")
                    Text("This is inside a stack")
                    Spacer()
                    Spacer()
                }
                VStack {
                    Spacer()
                    Text("First")
                    Text("Second")
                    Text("Thirds")
                    Spacer()
                    Spacer()
                }
                
                Text("Hello, World!")
                    .font(.headline)
                    .foregroundColor(.blue)
                    .padding()
                Form {
                    Text( "Hello, world!").font(.headline)
                    
                        .foregroundColor(.blue)
                    Text("Hello, world!").font(.headline)
                        .foregroundColor(.blue)
                    Section {
                        Text("Hello, world!")
                    }
                }
                
                NavigationLink(destination: DetailView()) {
                    Text("Go to Details Page")
                        .font(.headline)
                        .padding()
                        .foregroundColor(.white)
                        .background(Color.blue)
                        .cornerRadius(10)
                }
                
                
                Button("Save Test Data") {
                    saveTestData()
                }
                .font(.headline)
                .padding()
                .foregroundColor(.white)
                .background(Color.green)
                .cornerRadius(10)
                
                Text("This is the iOS home page.")
                    .font(.subheadline)
                    .padding()
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color.green.opacity(0.3))
            .navigationTitle("reMEMQ")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
    
    private func saveTestData() {
        if let userDefaults = UserDefaults(suiteName: "group.learnai2") {
            let sharedTextModel = SharedTextModel(text: "Testasdf Shared Text", tags: ["test", "example"])
            do {
                let encoder = JSONEncoder()
                let data = try encoder.encode(sharedTextModel)
                userDefaults.set(data, forKey: "sharedTextModel")
                userDefaults.synchronize()
                print("SharedTextModel saved to UserDefaults")
            } catch {
                print("Error saving SharedTextModel: \(error)")
            }
        } else {
            print("Error: Unable to access UserDefaults for App Group.")
        }
    }
}

#Preview{
    ContentView()
}
