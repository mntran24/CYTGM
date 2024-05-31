import SwiftUI

struct ContentView: View {
    @State private var showWelcomeMessage = false

    var body: some View {
        NavigationView {
            VStack {
                Spacer()
                
                if showWelcomeMessage {
                    Text("Welcome to Our App!")
                        .font(.custom("Helvetica Neue", size: 36))
                        .foregroundColor(.white)
                        .padding()
                        .background(LinearGradient(gradient: Gradient(colors: [.orange, .red]), startPoint: .topLeading, endPoint: .bottomTrailing))
                        .cornerRadius(15)
                        .shadow(color: .gray, radius: 10, x: 0, y: 5)
                        .transition(.opacity)
                        .animation(.easeInOut(duration: 1.5))
                }
                
                Spacer()
                
                NavigationLink(destination: VideosView()) {
                    Text("View Videos")
                        .font(.headline)
                        .foregroundColor(.white)
                        .padding()
                        .background(LinearGradient(gradient: Gradient(colors: [.blue, .purple]), startPoint: .leading, endPoint: .trailing))
                        .cornerRadius(15)
                        .shadow(color: .gray, radius: 10, x: 0, y: 5)
                        .scaleEffect(showWelcomeMessage ? 1.1 : 1.0)
                        .animation(.spring(response: 0.3, dampingFraction: 0.6, blendDuration: 0))
                }
                .padding()
                
                Spacer()
            }
            .navigationBarTitle("Home", displayMode: .inline)
            .background(LinearGradient(gradient: Gradient(colors: [.blue, .purple]), startPoint: .topLeading, endPoint: .bottomTrailing).edgesIgnoringSafeArea(.all))
            .onAppear {
                withAnimation {
                    self.showWelcomeMessage = true
                }
            }
        }
    }
}

struct VideosView: View {
    var body: some View {
        VStack {
            Spacer()
            Text("Videos Page")
                .font(.custom("Helvetica Neue", size: 36))
                .foregroundColor(.white)
                .padding()
                .background(LinearGradient(gradient: Gradient(colors: [.green, .blue]), startPoint: .topLeading, endPoint: .bottomTrailing))
                .cornerRadius(15)
                .shadow(color: .gray, radius: 10, x: 0, y: 5)
                .transition(.opacity)
                .animation(.easeInOut(duration: 1.5))
            Spacer()
        }
        .background(LinearGradient(gradient: Gradient(colors: [.purple, .blue]), startPoint: .topLeading, endPoint: .bottomTrailing).edgesIgnoringSafeArea(.all))
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
