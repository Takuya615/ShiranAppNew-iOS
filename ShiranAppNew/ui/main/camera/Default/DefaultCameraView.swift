
import SwiftUI
import AVFoundation

struct DefaultCameraView: UIViewControllerRepresentable {
    @Binding var isVideo: Bool
    func makeUIViewController(context: Context) -> UIViewController {
        return DefaultCameraController(cameraView: self)
    }
    func updateUIViewController(_ uiViewController: UIViewController, context: Context) {
    }
}

class DefaultCameraController: UIViewController {
    private var model : DefaultCameraViewModel!
    let poseImageView = PoseImageView()
    private var poseNet: PoseNet!
    private var currentFrame: CGImage?
    private var camera: CameraModel!
    
    var cameraView:DefaultCameraView
    init(cameraView:DefaultCameraView) {
        self.cameraView = cameraView
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
            model = DefaultCameraViewModel(_self: self)
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
        if !model.countDown {
            //DataCounter().saveMyPose(poseList: myPoseList)　　　　　　　　　　　　　　　自分ポーズを保存！！
            //let save = SaveVideo().environmentObject(DataCounter())
            //SaveVideo().saveData(score: Int(score)/100)
            //self.cameraView.dataCounter.scoreCounter(score: Int(score * timesBonus)/100)
        }
        
    }
}

extension DefaultCameraController: AVCaptureVideoDataOutputSampleBufferDelegate{
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


extension DefaultCameraController: PoseNetDelegate {
    func poseNet(_ poseNet: PoseNet, didPredict predictions: PoseNetOutput) {
        defer { self.currentFrame = nil }
        if self.currentFrame == nil {return}
        let poseBuilder = PoseBuilder(output: predictions,
                                      configuration: PoseBuilderConfiguration(),
                                      inputImage: self.currentFrame!)
        let pose = poseBuilder.pose
        if model.check(pose: pose, size: self.currentFrame!.size){
            let poseImage = poseImageView.showMiss(on: self.currentFrame!)
            let poseImageView = UIImageView(image: poseImage)
            poseImageView.layer.position = CGPoint(x: self.view.bounds.size.width/2, y:60 + poseImage.size.height/2)
            //poseImageView.isOpaque = false
            self.view.subviews.last?.removeFromSuperview()//直近のsubViewだけ、描画のリセット
            self.view.addSubview(poseImageView)
            return
        }
        
        let poseImage: UIImage = poseImageView.showDefault(
            prePose: model.prePose,
            pose: pose,
            on: self.currentFrame!)
        let size = self.view.bounds.size
        let poseImageView = UIImageView(image: poseImage)
        poseImageView.layer.position = CGPoint(x: size.width/2, y:60 + poseImage.size.height/2)
        self.view.subviews.last?.removeFromSuperview()
        self.view.addSubview(poseImageView)
        
        model.culculateScore(pose: pose)//, prePose: model.prePose)
//        model.scoreBoad.text = str.score2.rawValue + String(Int(model.score))
//        model.prePose =
        //prePose = culculateScore(pose: pose, prePose: prePose)
        
    }
    
    
}

