import SwiftUI

struct ContentView: View {
    var body: some View {
        NavigationView {
            VStack {
                Text("Welcome to Our App!")
                    .font(.largeTitle)
                    .padding()
                
                NavigationLink(destination: VideosView()) {
                    Text("View Videos")
                        .foregroundColor(.white)
                        .padding()
                        .background(Color.blue)
                        .cornerRadius(10)
                }
                .padding()
            }
            .navigationBarTitle("Home", displayMode: .inline)
        }
    }
}

struct VideosView: View {
    var body: some View {
        Text("Videos Page")
            .font(.largeTitle)
            .navigationBarTitle("Videos", displayMode: .inline)
    }
}

struct MyApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
