import SwiftUI
import AVKit
import Combine

struct ContentView: View {
    @State private var showWelcomeMessage = false

    var body: some View {
        NavigationView {
            ZStack {
                VStack {
                    Spacer()

                    if showWelcomeMessage {
                        Text("Corrupt you-tuber gets Mind-controlled!")
                            .font(.custom("Helvetica Neue", size: 36))
                            .foregroundColor(.white)
                            .padding()
                            .background(AnimatedGradient())
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

                // Animated stars
                ForEach(0..<20) { _ in
                    StarView()
                }
            }
        }
    }
}

struct AnimatedGradient: View {
    @State private var gradientOffset = -1.0

    var body: some View {
        LinearGradient(gradient: Gradient(colors: [.orange, .red, .yellow]), startPoint: .topLeading, endPoint: .bottomTrailing)
            .offset(x: gradientOffset, y: 0)
            .animation(Animation.linear(duration: 5).repeatForever(autoreverses: false))
            .onAppear {
                gradientOffset = 1.0
            }
    }
}

struct StarView: View {
    @State private var position: CGPoint = CGPoint(x: .random(in: 0...UIScreen.main.bounds.width), y: .random(in: 0...UIScreen.main.bounds.height))
    @State private var starSize: CGFloat = .random(in: 10...30)
    
    var body: some View {
        Image(systemName: "star.fill")
            .resizable()
            .frame(width: starSize, height: starSize)
            .foregroundColor(.white)
            .position(position)
            .animation(Animation.easeInOut(duration: .random(in: 2...5)).repeatForever(autoreverses: true))
            .onAppear {
                position = CGPoint(x: .random(in: 0...UIScreen.main.bounds.width), y: .random(in: 0...UIScreen.main.bounds.height))
            }
    }
}

class VideoPlayerViewModel: ObservableObject {
    @Published var currentVideoIndex = 0
    @Published var player: AVPlayer?
    @Published var isPlaying = false
    @Published var isFullscreen = false
    @Published var transitionDirection: TransitionDirection = .none
    @Published var showNextPlayer = false
    @Published var currentTime: Double = 0.0
    @Published var duration: Double = 0.0
    @Published var volume: Float = 0.5
    @Published var playbackRate: Float = 1.0
    
    private var timeObserverToken: Any?
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
        player?.volume = volume
        player?.rate = playbackRate
        observePlayerStatus(player!)
        addPeriodicTimeObserver()
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
            transitionDirection = .right
            showNextPlayer = true
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                self.currentVideoIndex += 1
                self.player = AVPlayer(url: self.videoURLs[self.currentVideoIndex])
                self.player?.play()
                self.isPlaying = true
                self.observePlayerStatus(self.player!)
                self.addPeriodicTimeObserver()
                self.showNextPlayer = false
            }
        }
    }
    
    func previousVideo() {
        if currentVideoIndex > 0 {
            transitionDirection = .left
            showNextPlayer = true
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                self.currentVideoIndex -= 1
                self.player = AVPlayer(url: self.videoURLs[self.currentVideoIndex])
                self.player?.play()
                self.isPlaying = true
                self.observePlayerStatus(self.player!)
                self.addPeriodicTimeObserver()
                self.showNextPlayer = false
            }
        }
    }
    
    func toggleFullscreen() {
        withAnimation(.easeInOut(duration: 0.5)) {
            isFullscreen.toggle()
        }
    }
    
    func updateVolume(_ volume: Float) {
        player?.volume = volume
        self.volume = volume
    }
    
    func updatePlaybackRate(_ rate: Float) {
        player?.rate = rate
        playbackRate = rate
    }
    
    private func observePlayerStatus(_ player: AVPlayer) {
        playerStatusObserver = player.publisher(for: \.timeControlStatus)
            .receive(on: RunLoop.main)
            .sink { [weak self] status in
                // Handle player status changes if needed
            }
    }
    
    private func addPeriodicTimeObserver() {
        let interval = CMTime(seconds: 1, preferredTimescale: 600)
        timeObserverToken = player?.addPeriodicTimeObserver(forInterval: interval, queue: .main) { [weak self] time in
            self?.currentTime = time.seconds
            if let duration = self?.player?.currentItem?.duration.seconds, duration > 0 {
                self?.duration = duration
            }
        }
    }
    
    deinit {
        if let token = timeObserverToken {
            player?.removeTimeObserver(token)
            timeObserverToken = nil
        }
    }
}

enum TransitionDirection {
    case left, right, none
}

struct VideosView: View {
    @StateObject private var viewModel = VideoPlayerViewModel()
    
    var body: some View {
        ZStack {
            LinearGradient(gradient: Gradient(colors: [.purple, .blue]), startPoint: .topLeading, endPoint: .bottomTrailing)
                .edgesIgnoringSafeArea(.all)
            
            VStack {
                ZStack {
                    if !viewModel.showNextPlayer {
                        VideoPlayerView(player: viewModel.player, transitionDirection: viewModel.transitionDirection)
                            .frame(height: viewModel.isFullscreen ? UIScreen.main.bounds.height : 300)
                            .cornerRadius(15)
                            .shadow(radius: 10)
                            .padding(.top, 50)  // Adjust padding to move content further down
                            .background(Color.black.opacity(0.7))
                            .clipShape(Rectangle())
                    } else {
                        VideoPlayerView(player: AVPlayer(url: viewModel.videoURLs[viewModel.currentVideoIndex]), transitionDirection: viewModel.transitionDirection)
                            .frame(height: viewModel.isFullscreen ? UIScreen.main.bounds.height : 300)
                            .cornerRadius(15)
                            .shadow(radius: 10)
                            .padding(.top, 50)  // Adjust padding to move content further down
                            .background(Color.black.opacity(0.7))
                            .clipShape(Rectangle())
                    }
                }
                .animation(.easeInOut(duration: 0.5))
                .onAppear {
                    viewModel.player?.play()
                }
                .onDisappear {
                    viewModel.player?.pause()
                }
                
                VideoControlsView(viewModel: viewModel)
                
                HStack {
                    CreativeButton(imageName: "backward.fill", action: {
                        viewModel.previousVideo()
                    }, buttonSize: 25)
                    .disabled(viewModel.currentVideoIndex == 0)
                    
                    Spacer()
                    
                    Button(action: {
                        viewModel.playPause()
                    }) {
                        Image(systemName: viewModel.isPlaying ? "pause.fill" : "play.fill")
                            .foregroundColor(.white)
                            .padding()
                            .background(Circle().fill(Color.blue))
                            .shadow(color: .gray, radius: 5, x: 0, y: 5)
                    }
                    
                    Spacer()
                    
                    CreativeButton(imageName: "forward.fill", action: {
                        viewModel.nextVideo()
                    }, buttonSize: 25)
                    .disabled(viewModel.currentVideoIndex == viewModel.videoURLs.count - 1)
                }
                .padding()
                
                Button(action: {
                    viewModel.toggleFullscreen()
                }) {
                    Text(viewModel.isFullscreen ? "Exit Fullscreen" : "Fullscreen")
                        .foregroundColor(.white)
                        .padding()
                        .background(Capsule().fill(Color.blue))
                        .shadow(color: .gray, radius: 5, x: 0, y: 5)
                }
                .padding(.bottom)
            }
        }
        .navigationBarTitle("Videos", displayMode: .inline)
        .foregroundColor(Color(red: 153 / 255, green: 102 / 255, blue: 204 / 255))  // Amethyst color
    }
}

struct VideoPlayerView: View {
    let player: AVPlayer?
    let transitionDirection: TransitionDirection
    
    var body: some View {
        ZStack {
            if transitionDirection == .none {
                VideoPlayer(player: player)
                    .transition(.identity)
            } else {
                GeometryReader { geometry in
                    ZStack {
                        if transitionDirection == .right {
                            VideoPlayer(player: player)
                                .frame(width: geometry.size.width, height: geometry.size.height)
                                .rotation3DEffect(
                                    .degrees(90),
                                    axis: (x: 0, y: 1, z: 0),
                                    perspective: 0.5
                                )
                        } else if transitionDirection == .left {
                            VideoPlayer(player: player)
                                .frame(width: geometry.size.width, height: geometry.size.height)
                                .rotation3DEffect(
                                    .degrees(-90),
                                    axis: (x: 0, y: 1, z: 0),
                                    perspective: 0.5
                                )
                        }
                    }
                    .transition(AnyTransition.asymmetric(insertion: .identity, removal: .move(edge: .trailing)))
                }
                .animation(.easeInOut(duration: 0.5))
            }
        }
    }
}

struct VideoControlsView: View {
    @ObservedObject var viewModel: VideoPlayerViewModel
    
    var body: some View {
        VStack {
            Slider(value: $viewModel.currentTime, in: 0...viewModel.duration)
                .accentColor(.blue)
                .padding(.horizontal)
            HStack {
                Text(formatTime(viewModel.currentTime))
                Spacer()
                Text(formatTime(viewModel.duration))
            }
            .font(.footnote)
            .foregroundColor(.white)
            .padding(.horizontal)
            
            HStack {
                Text("Volume")
                    .foregroundColor(.white)
                Slider(value: Binding(get: {
                    Double(viewModel.volume)
                }, set: { newValue in
                    viewModel.updateVolume(Float(newValue))
                }), in: 0...1)
                    .accentColor(.blue)
                    .padding(.horizontal)
                    .onChange(of: viewModel.volume) { _ in
                        withAnimation(.easeInOut(duration: 0.5)) {
                            viewModel.volume += 0.01
                        }
                    }
            }
            .padding(.vertical)
            .background(Color.black.opacity(0.7))
            .cornerRadius(15)
            .padding(.horizontal)
            
            HStack {
                Text("Playback Speed")
                    .foregroundColor(.white)
                Slider(value: Binding(get: {
                    Double(viewModel.playbackRate)
                }, set: { newValue in
                    viewModel.updatePlaybackRate(Float(newValue))
                }), in: 0.5...2, step: 0.5)
                    .accentColor(.blue)
                    .padding(.horizontal)
                    .onChange(of: viewModel.playbackRate) { _ in
                        withAnimation(.easeInOut(duration: 0.5)) {
                            viewModel.playbackRate += 0.1
                        }
                    }
                Text("\(viewModel.playbackRate, specifier: "%.1f")x")
                    .foregroundColor(.white)
            }
            .padding(.vertical)
            .background(Color.black.opacity(0.7))
            .cornerRadius(15)
            .padding(.horizontal)
        }
        .padding()
        .background(Color.black.opacity(0.7))
        .cornerRadius(15)
        .shadow(radius: 10)
    }
    
    private func formatTime(_ time: Double) -> String {
        let minutes = Int(time) / 60
        let seconds = Int(time) % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }
}

struct CreativeButton: View {
    let imageName: String
    let action: () -> Void
    let buttonSize: CGFloat
    
    var body: some View {
        Button(action: action) {
            Image(systemName: imageName)
                .resizable()
                .frame(width: buttonSize, height: buttonSize)
                .foregroundColor(.white)
                .padding()
                .background(Circle().fill(LinearGradient(gradient: Gradient(colors: [.purple, .blue]), startPoint: .top, endPoint: .bottom)))
                .shadow(radius: 10)
        }
    }
}

struct MyApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
