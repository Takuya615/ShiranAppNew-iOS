
import SwiftUI
import AVFoundation

struct VideoCameraView: UIViewControllerRepresentable {
    @Binding var isVideo: Bool
    @EnvironmentObject var dataCounter: DataCounter
    func makeUIViewController(context: Context) -> UIViewController {
        return VideoViewController(videoCameraView: self)
    }
    func updateUIViewController(_ uiViewController: UIViewController, context: Context) {
    }
}

class VideoViewController: UIViewController {
    private var model : VideoCameraViewModel!
    //let poseImageView = PoseImageView()
    private var poseNet: PoseNet!
    private var currentFrame: CGImage?
    private var camera: CameraModel!
    
    var videoCameraView:VideoCameraView
    init(videoCameraView:VideoCameraView) {
        self.videoCameraView = videoCameraView
        super.init(nibName: nil, bundle: nil)
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        do {
            poseNet = try PoseNet()
            poseNet.delegate = self
            camera = CameraModel(delegate: self)
            model = VideoCameraViewModel(_self: self)
            /*let db = Firestore.firestore().collection("users").whereField("name", isEqualTo: "つむ")
             db.getDocuments() { (querySnapshot, err) in
             if err != nil {return}
             guard let poseList: [Int] = querySnapshot!.documents[0].data()["poseList"] as? [Int] else{print("フレンドリストなし");return}
             self.friPoseList = poseList
             }*/
            
            model.timesBonus = CharacterModel.useTaskHelper()
        } catch {
            fatalError("Failed to load model. \(error.localizedDescription)")
        }
    }
    override func viewWillAppear(_ animated: Bool) {
      super.viewWillAppear(animated)
        camera.setViewWillAppear()
        model.setUpCaptureButton()
    }
    override func viewWillDisappear(_ animated: Bool) {
      super.viewWillDisappear(animated)
        camera.setViewWillDisappear()
    }
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        camera.setViewDidDisappear()
        model.isRecording = false
        model.timer.invalidate()
        //if !model.countDown {
            //DataCounter().saveMyPose(poseList: myPoseList)　　　　　　　　　　　　　　　自分ポーズを保存！！
            //let save = SaveVideo().environmentObject(DataCounter())
            //SaveVideo().saveData(score: Int(score)/100)
            //self.videoCameraView.dataCounter.scoreCounter(score: Int(score * timesBonus)/100)
        //}
        
    }
}

extension VideoViewController: AVCaptureVideoDataOutputSampleBufferDelegate{
    func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {

        connection.videoOrientation = .portrait//UpsideDown
        connection.isVideoMirrored = true

        guard let imageBuffer = CMSampleBufferGetImageBuffer(sampleBuffer) else {return}
        let ciimage : CIImage = CIImage(cvPixelBuffer: imageBuffer)
        let context:CIContext = CIContext.init(options: nil)
        let cgImage:CGImage = context.createCGImage(ciimage, from: ciimage.extent)!
        DispatchQueue.main.sync {
            guard currentFrame == nil else {
                return
            }
            //if cgImage == nil {print("image取得できていない");return}
            currentFrame = cgImage
            poseNet.predict(cgImage)
        }

    }
}


extension VideoViewController: PoseNetDelegate {
    func poseNet(_ poseNet: PoseNet, didPredict predictions: PoseNetOutput) {
        defer { self.currentFrame = nil }
        if self.currentFrame == nil {return}
        let poseBuilder = PoseBuilder(output: predictions,
                                      configuration: PoseBuilderConfiguration(),
                                      inputImage: self.currentFrame!)
        let pose = poseBuilder.pose
        if model.check(pose: pose, size: self.currentFrame!.size) {
            let poseImage = model.poseImageView.showMiss(on: self.currentFrame!)
            let poseImageView = UIImageView(image: poseImage)
            poseImageView.layer.position = CGPoint(x: self.view.bounds.size.width/2, y:60 + poseImage.size.height/2)
            //poseImageView.isOpaque = false
            self.view.subviews.last?.removeFromSuperview()//直近のsubViewだけ、描画のリセット
            self.view.addSubview(poseImageView)
            return
        }
        //フレンドの描画部分
        let fPose = Pose()
        if !model.countDown{
            let namelist = Pose().joints2
            //自分のポーズを保存
            for i in 0 ... namelist.count-1 {
                if pose[namelist[i]].isValid {
                    model.myPoseList.append(Int(pose[namelist[i]].position.x))
                    model.myPoseList.append(Int(pose[namelist[i]].position.y))
                }else{
                    model.myPoseList.append(-1); model.myPoseList.append(-1)
                }
            }
            //友達のポーズを引っ張ってきてプレイ！
            if !model.friPoseList.isEmpty {
                var n = 0
                for i in stride(from: 0, to: 26, by: 2) {
                    if model.friPoseList[i] > -1 {
                        fPose[namelist[n]].isValid = true
                        fPose[namelist[n]].position = CGPoint(x: model.friPoseList[i], y: model.friPoseList[i+1])
                        if model.isRecording {//フレンドのスコアを追加する
                            model.score += Float(abs(model.friPoseList[i] - model.friPoseList[i+26])) / 100
                        }
                        
                    }
                    n += 1
                }
                model.friPoseList.removeFirst(26)
            }
        }
        //自分とフレンドの動きを描画
        let poseImage: UIImage = model.poseImageView.showDayly(
            prePose: model.prePose,
            pose: pose,//自分のポーズ
            friPose: fPose,//フレンドのポーズ
            on: self.currentFrame!)
        let size = self.view.bounds.size
        let poseImageView = UIImageView(image: poseImage)
        poseImageView.layer.position = CGPoint(x: size.width/2, y:60 + poseImage.size.height/2)
        //poseImageView.isOpaque = false
        self.view.subviews.last?.removeFromSuperview()//直近のsubViewだけ、描画のリセット
        self.view.addSubview(poseImageView)
        
//        if !isRecording {
//            self.view.subviews.last?.removeFromSuperview()//直近のsubViewだけ、描画のリセット
//        }
        
        //スコアやボスの表示
        let damage: Float = UserDefaults.standard.float(forKey: Keys.damage.rawValue)
        model.bossHPbar.progress = Float((model.score + damage) / model.exiteBoss!.maxHp)
        //モンスターを倒した
        if (model.score + damage) > model.exiteBoss!.maxHp{
            SystemSounds.attack()
            model.killList.append(model.exiteBoss!)
            model.score = 0
            model.exiteBoss = BOSS().newBoss()
            model.bossImage.image = UIImage(named: model.exiteBoss!.image)// = UIImageView(image: UIImage(named: exiteBoss!.image))
        }
        //self.bossHPbar.setProgress(self.bossHPbar.progress, animated: true)
        
        model.prePose = model.culculateScore(pose: pose, prePose: model.prePose)
        //model.prePose = pose
        //prePose = culculateScore(pose: pose, prePose: prePose)
        
    }
    
    
}

