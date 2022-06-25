import UIKit
import AVFoundation
import AVKit

class PlayerView: UIView {
    override class var layerClass: AnyClass {
        AVCaptureVideoPreviewLayer.self
    }
}

class ViewController: UIViewController, AVCaptureVideoDataOutputSampleBufferDelegate {

    @IBOutlet var smileLabel: UILabel!
    @IBOutlet var previewView: PlayerView!

    var session: AVCaptureSession!
    var videoPreviewLayer: AVCaptureVideoPreviewLayer!
    var term: Int = 0
    let interval: Int = 100
    var bestValue: Float = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        initCamera()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)


        self.session.stopRunning()

        for output in self.session.outputs {
            self.session.removeOutput(output as AVCaptureOutput)
        }
        for input in self.session.inputs {
            self.session.removeInput(input as AVCaptureInput)
        }
        self.session = nil
    }

    private func initCamera() {

        guard let caputureDevice = AVCaptureDevice.default(
            .builtInWideAngleCamera,
            for: AVMediaType.video,
            position: .front
        ) else {
            print("カメラにアクセスできません")
            return
        }

        caputureDevice.activeVideoMinFrameDuration = CMTimeMake(value: 1, timescale: 30)

        do {
            let input = try AVCaptureDeviceInput(device: caputureDevice)
            let output: AVCaptureVideoDataOutput = AVCaptureVideoDataOutput()
            output.videoSettings = [
                kCVPixelBufferPixelFormatTypeKey : kCVPixelFormatType_32BGRA
            ] as [String : Any]
            output.setSampleBufferDelegate(self, queue: DispatchQueue(label: "videoQueue"))
            output.alwaysDiscardsLateVideoFrames = true

            self.session = AVCaptureSession()
            self.session.sessionPreset = .medium

            if self.session.canAddInput(input) && self.session.canAddOutput(output) {
                self.session.addInput(input)
                self.session.addOutput(output)

                self.startPreview()
            }
        }
        catch _ {
            print("error occurd")
        }
    }

    private func startPreview() {

        self.videoPreviewLayer = AVCaptureVideoPreviewLayer(session: self.session)

        self.videoPreviewLayer.videoGravity = AVLayerVideoGravity.resizeAspectFill

        self.videoPreviewLayer.connection?.videoOrientation = .portrait


        self.view.layer.addSublayer(videoPreviewLayer)

        DispatchQueue.global(qos: .userInitiated).async {
            self.session.startRunning()
            DispatchQueue.main.async {
                self.videoPreviewLayer.frame = self.previewView.bounds
            }
        }
    }

    func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        print("1フレームごとの処理をここに書く")
        guard let buffer = CMSampleBufferGetImageBuffer(sampleBuffer) else {
            return
        }
        let image = CIImage(cvImageBuffer: buffer)
        let imageRect = CGRect(
            origin: .zero,
            size: CGSize(
                width: CVPixelBufferGetWidth(buffer),
                height: CVPixelBufferGetHeight(buffer)
            )
        )
        let context = CIContext()
        guard let image = context.createCGImage(image, from: imageRect) else {
            return
        }
        term += 1
        if term % interval == 0 {
            bestValue = 0
            term = 0
        }
        checkSmile(image: image) { smileConfidence in
            self.bestValue = max(smileConfidence, self.bestValue)
            let smile = String(format: "%.2f", self.bestValue)
            DispatchQueue.main.async {
                self.smileLabel.text = smile
            }
        }
    }

}
