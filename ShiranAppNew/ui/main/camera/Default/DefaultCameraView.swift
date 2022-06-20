
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
    //let poseImageView = PoseImageView()
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
        let pose = PoseBuilder(output: predictions,configuration: PoseBuilderConfiguration(),inputImage: self.currentFrame!).pose
        
        if CameraModel.check(pose: pose, size: self.currentFrame!.size,isRecording: model.isRecording, jump: model.jump) {
            let poseImage = PoseImageView.showMiss(on: self.currentFrame!)
            let poseImageView = UIImageView(image: poseImage)
            poseImageView.layer.position = CGPoint(x: self.view.bounds.size.width/2, y:60 + poseImage.size.height/2)
            self.view.subviews.last?.removeFromSuperview()//直近のsubViewだけ、描画のリセット
            self.view.addSubview(poseImageView)
        }else{
            let poseImage: UIImage = PoseImageView.showDefault(
                model: model, prePose: model.prePose,
                pose: pose,
                on: self.currentFrame!)
            let size = self.view.bounds.size
            let poseImageView = UIImageView(image: poseImage)
            poseImageView.layer.position = CGPoint(x: size.width/2, y:60 + poseImage.size.height/2)
            self.view.subviews.last?.removeFromSuperview()
            self.view.addSubview(poseImageView)
            model.culculateScore(pose: pose)
        }
        
        
    }
    
    
}

