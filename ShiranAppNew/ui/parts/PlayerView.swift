

import UIKit
import AVFoundation
import SwiftUI
import AVKit

struct VideoPlayerView: UIViewControllerRepresentable {
    @EnvironmentObject var appState: AppState
    func makeUIViewController(context: Context) -> UIViewController {
        return ViewController(videoPlayerView: self)
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
        guard let path = Bundle.main.path(forResource: "introduce", ofType: "MP4") else {return}
        let fileURL = URL(fileURLWithPath: path)
        let avAsset = AVURLAsset(url: fileURL)
        let playerItem: AVPlayerItem = AVPlayerItem(asset: avAsset)
        
        // Create AVPlayer
        videoPlayer = AVPlayer(playerItem: playerItem)
        
        // Add AVPlayer
        let layer = AVPlayerLayer()
        layer.videoGravity = AVLayerVideoGravity.resizeAspect
        layer.player = videoPlayer
        layer.frame = CGRect(x: view.bounds.width/8, y: view.bounds.height/8, width: view.bounds.width*6/8, height: view.bounds.height*6/8)
        view.layer.addSublayer(layer)
        
        // Observe
        NotificationCenter.default.addObserver(self, selector: #selector(playerDidFinishPlaying), name: .AVPlayerItemDidPlayToEndTime, object: playerItem)
        
        view.layer.backgroundColor = Colors.cgGray
        // Create Movie Start Button
        startButton = UIButton(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
        startButton.layer.position = CGPoint(x: self.view.bounds.midX, y: self.view.bounds.midY)
        startButton.layer.masksToBounds = true
        let image = UIImage(systemName: "play.circle")
        let reImage = image?.resize(size: CGSize(width: 100, height: 100))
        startButton.setImage(reImage, for: .normal)
        startButton.addTarget(self, action: #selector(onStartButtonTapped), for: UIControl.Event.touchUpInside)
        view.addSubview(startButton)
        
        skipButton = UIButton(frame: CGRect(x: view.bounds.width/8, y: view.bounds.height/8-50, width: 100, height: 50))
        skipButton.setTitle("スキップ", for: .normal)
        skipButton.setTitleColor(UIColor.blue, for: .normal)
        skipButton.addTarget(self, action: #selector(playerDidFinishPlaying), for: UIControl.Event.touchUpInside)
        view.addSubview(skipButton)
    }
    
    @objc func onStartButtonTapped(){
        //videoPlayer.seek(to: CMTimeMakeWithSeconds(0, preferredTimescale: Int32(NSEC_PER_SEC)))
        videoPlayer.play()
        startButton.isHidden = true
    }
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
    let url = Bundle.main.path(forResource: "introduce", ofType: "MP4")
    var body: some View {
        let player = AVPlayer(url: URL(fileURLWithPath: url!))
        VideoPlayer(player: player)
            .onDisappear(perform: {
                if !appState.coachMark1 {self.appState.isExplainView = false}
            })
        //.onAppear() {player.play()}
    }
}
//struct PlayerView2: View {
//    let url = Bundle.main.path(forResource: "fightEnemy", ofType: "MP4")
//    var body: some View {
//        let player = AVPlayer(url: URL(fileURLWithPath: url!))
//        VideoPlayer(player: player)
//            .onAppear() {player.play()}
//    }
//}
struct PlayerViewQuest: View {
    var url = Bundle.main.path(forResource: "q_coin", ofType: "mp4")
    init(url: String?){
        self.url = url
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
