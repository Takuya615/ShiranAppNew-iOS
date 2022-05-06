

import UIKit
import AVFoundation
import SwiftUI
import AVKit

struct VideoPlayerView: UIViewControllerRepresentable {
    @EnvironmentObject var appState: AppState
    func makeUIViewController(context: Context) -> UIViewController {
        return ViewController(videoPlayerView: self)//VideoViewController(videoCameraView: self)
    }
    func updateUIViewController(_ uiViewController: UIViewController, context: Context) {
    }
}

class ViewController: UIViewController {
    var videoPlayer: AVPlayer!
    var startButton: UIButton!
    var skipButton: UIButton!
    var videoPlayerView: VideoPlayerView
    init(videoPlayerView: VideoPlayerView) {
        self.videoPlayerView = videoPlayerView
        super.init(nibName: nil, bundle: nil)
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        guard let path = Bundle.main.path(forResource: "introduce", ofType: "mov") else {
            fatalError("Movie file can not find.")
        }
        let fileURL = URL(fileURLWithPath: path)
        let avAsset = AVURLAsset(url: fileURL)
        let playerItem: AVPlayerItem = AVPlayerItem(asset: avAsset)
        
        // Create AVPlayer
        videoPlayer = AVPlayer(playerItem: playerItem)
        
        // Add AVPlayer
        let layer = AVPlayerLayer()
        layer.videoGravity = AVLayerVideoGravity.resizeAspect
        layer.player = videoPlayer
        layer.frame = view.bounds
        view.layer.addSublayer(layer)
        
        // Observe
        NotificationCenter.default.addObserver(self, selector: #selector(playerDidFinishPlaying), name: .AVPlayerItemDidPlayToEndTime, object: playerItem)
        
        // Create Movie Start Button
        startButton = UIButton(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
        startButton.layer.position = CGPoint(x: self.view.bounds.midX, y: self.view.bounds.midY)
        startButton.layer.masksToBounds = true
        //startButton.layer.cornerRadius = 30//startButton.frame.midX
        //startButton.backgroundColor = UIColor.gray
        let image = UIImage(systemName: "play.circle")
        let reImage = image?.resize(size: CGSize(width: 100, height: 100))
        startButton.setImage(reImage, for: .normal)
        startButton.addTarget(self, action: #selector(onStartButtonTapped), for: UIControl.Event.touchUpInside)
        view.addSubview(startButton)
        
        /*skipButton = UIButton(frame: CGRect(x: 0, y: 0, width: 100, height: 50))
        skipButton.layer.position = CGPoint(x: self.view.bounds.midX, y: self.view.bounds.midY+10)
        skipButton.setTitle("スキップ", for: .normal)
        skipButton.setTitleColor(UIColor.black, for: .normal)
        skipButton.addTarget(self, action: #selector(onSkipButtonTapped), for: UIControl.Event.touchUpInside)
        view.addSubview(skipButton)*/
        
    }
    
    // Start Button Tapped
    @objc func onStartButtonTapped(){
        startButton.isHidden = true
        videoPlayer.seek(to: CMTimeMakeWithSeconds(0, preferredTimescale: Int32(NSEC_PER_SEC)))
        videoPlayer.play()
    }
    // Start Button Tapped
    @objc func onSkipButtonTapped(){
        startButton.isHidden = true
        videoPlayer.seek(to: CMTimeMakeWithSeconds(0, preferredTimescale: Int32(NSEC_PER_SEC)))
        videoPlayer.play()
    }
    // Movie Did Finish
    @objc func playerDidFinishPlaying() {
        self.videoPlayerView.appState.isVideoPlayer = false
        self.videoPlayerView.appState.coachMarkf = true
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}

extension UIImage {
    func resize(size _size: CGSize) -> UIImage? {
        let widthRatio = _size.width / size.width
        let heightRatio = _size.height / size.height
        let ratio = widthRatio < heightRatio ? widthRatio : heightRatio

        let resizedSize = CGSize(width: size.width * ratio, height: size.height * ratio)

        UIGraphicsBeginImageContextWithOptions(resizedSize, false, 0.0) // 変更
        draw(in: CGRect(origin: .zero, size: resizedSize))
        let resizedImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        return resizedImage
    }
}


struct PlayerView: View {
    @EnvironmentObject var appState: AppState
    let url = Bundle.main.path(forResource: "introduce", ofType: "mov")
    var body: some View {
        let player = AVPlayer(url: URL(fileURLWithPath: url!))
        VideoPlayer(player: player)
            .onDisappear(perform: {
                if !appState.coachMark1 {self.appState.isExplainView = false}
            })
        //.onAppear() {player.play()}
    }
}
struct PlayerView2: View {
    let url = Bundle.main.path(forResource: "fightEnemy", ofType: "MP4")
    var body: some View {
        let player = AVPlayer(url: URL(fileURLWithPath: url!))
        VideoPlayer(player: player)
            .onAppear() {player.play()}
    }
}
struct PlayerViewQuest: View {
    var page: Int
    var url = Bundle.main.path(forResource: "q_coin", ofType: "mp4")
    init(page: Int){
        self.page = page
        switch self.page {
        case 1: url = Bundle.main.path(forResource: "q_coin", ofType: "mp4")
        case 2: url = Bundle.main.path(forResource: "q_hiit", ofType: "mov")
        case 3: url = Bundle.main.path(forResource: "q_climb", ofType: "mp4")
        default: url = Bundle.main.path(forResource: "q_coin", ofType: "mp4")
        }
    }
    var body: some View {
        let player = AVPlayer(url: URL(fileURLWithPath: url!))
        VStack{
            Image(systemName: "chevron.compact.down")
                .resizable().frame(width: 100, height: 20, alignment: .top).padding().foregroundColor(.gray)
            VideoPlayer(player: player)
                .onAppear() {player.play()}
        }
        
    }
}
