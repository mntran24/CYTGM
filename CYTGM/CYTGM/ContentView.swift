import SwiftUI
import AVKit
import Combine

struct ContentView: View {
    @State private var showWelcomeMessage = false

    var body: some View {
        NavigationView {
            VStack {
                Spacer()
                
                if showWelcomeMessage {
                    Text("Corrupt you-tuber gets Mind-controlled!")
                        .font(.custom("Helvetica Neue", size: 36))
                        .foregroundColor(.white)
                        .padding()
                        .background(LinearGradient(gradient: Gradient(colors: [.orange, .red]), startPoint: .topLeading, endPoint: .bottomTrailing))
                        .cornerRadius(15)
                        .shadow(color: .gray, radius: 10, x: 0, y: 5)
                        .transition(AnyTransition.scale.combined(with: .opacity))
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

class VideoPlayerViewModel: ObservableObject {
    @Published var currentVideoIndex = 0
    @Published var player: AVPlayer?
    @Published var isPlaying = false
    @Published var isFullscreen = false
    @Published var isBuffering = true
    
    private var playerStatusObserver: AnyCancellable?
    let videoURLs = [
        URL(string: "https://www.example.com/video1.mp4")!,
        URL(string: "https://www.example.com/video2.mp4")!,
        URL(string: "https://www.example.com/video3.mp4")!
    ]
    
    init() {
        setupPlayer()
    }
    
    private func setupPlayer() {
        player = AVPlayer(url: videoURLs[currentVideoIndex])
        observePlayerStatus(player!)
    }
    
    func playPause() {
        if isPlaying {
            player?.pause()
        } else {
            player?.play()
        }
        isPlaying.toggle()
    }
    
    func nextVideo() {
        if currentVideoIndex < videoURLs.count - 1 {
            currentVideoIndex += 1
            player = AVPlayer(url: videoURLs[currentVideoIndex])
            player?.play()
            isPlaying = true
            observePlayerStatus(player!)
        }
    }
    
    func previousVideo() {
        if currentVideoIndex > 0 {
            currentVideoIndex -= 1
            player = AVPlayer(url: videoURLs[currentVideoIndex])
            player?.play()
            isPlaying = true
            observePlayerStatus(player!)
        }
    }
    
    private func observePlayerStatus(_ player: AVPlayer) {
        playerStatusObserver = player.publisher(for: \.timeControlStatus)
            .receive(on: RunLoop.main)
            .sink { [weak self] status in
                self?.isBuffering = status != .playing
            }
    }
}

struct VideosView: View {
    @StateObject private var viewModel = VideoPlayerViewModel()
    
    var body: some View {
        VStack {
            if viewModel.isBuffering {
                ProgressView("Loading...")
                    .progressViewStyle(CircularProgressViewStyle(tint: .white))
                    .scaleEffect(1.5)
                    .padding()
            }
            
            VideoPlayer(player: viewModel.player)
                .frame(height: viewModel.isFullscreen ? UIScreen.main.bounds.height : 300)
                .cornerRadius(10)
                .shadow(radius: 10)
                .padding()
                .transition(AnyTransition.scale.combined(with: .opacity))
                .animation(.easeInOut(duration: 1.0))
                .onAppear {
                    viewModel.player?.play()
                }
                .onDisappear {
                    viewModel.player?.pause()
                }
            
            HStack {
                Button(action: {
                    viewModel.previousVideo()
                }) {
                    Image(systemName: "backward.fill")
                        .foregroundColor(.white)
                        .padding()
                        .background(Color.blue)
                        .cornerRadius(10)
                        .shadow(color: .gray, radius: 5, x: 0, y: 5)
                }
                .disabled(viewModel.currentVideoIndex == 0)
                
                Spacer()
                
                Button(action: {
                    viewModel.playPause()
                }) {
                    Image(systemName: viewModel.isPlaying ? "pause.fill" : "play.fill")
                        .foregroundColor(.white)
                        .padding()
                        .background(Color.blue)
                        .cornerRadius(10)
                        .shadow(color: .gray, radius: 5, x: 0, y: 5)
                }
                
                Spacer()
                
                Button(action: {
                    viewModel.nextVideo()
                }) {
                    Image(systemName: "forward.fill")
                        .foregroundColor(.white)
                        .padding()
                        .background(Color.blue)
                        .cornerRadius(10)
                        .shadow(color: .gray, radius: 5, x: 0, y: 5)
                }
                .disabled(viewModel.currentVideoIndex == viewModel.videoURLs.count - 1)
            }
            .padding()
            
            Button(action: {
                viewModel.isFullscreen.toggle()
            }) {
                Text(viewModel.isFullscreen ? "Exit Fullscreen" : "Fullscreen")
                    .foregroundColor(.white)
                    .padding()
                    .background(Color.blue)
                    .cornerRadius(10)
                    .shadow(color: .gray, radius: 5, x: 0, y: 5)
            }
            .padding(.bottom)
        }
        .navigationBarTitle("Videos", displayMode: .inline)
        .background(LinearGradient(gradient: Gradient(colors: [.purple, .blue]), startPoint: .topLeading, endPoint: .bottomTrailing).edgesIgnoringSafeArea(.all))
    }
}

struct MyApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
