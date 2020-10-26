import UIKit
import AVFoundation

class ViewController: UIViewController {

    private var ndiWrapper: NDIWrapper?
    private var captureSession = AVCaptureSession()
    private var captureDeviceInput: AVCaptureDeviceInput!
    private var videoDataOutput: AVCaptureVideoDataOutput!
    private var device: AVCaptureDevice!
    private var isSending: Bool = false

    private var previewLayer: AVCaptureVideoPreviewLayer!
    private var sendButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()

        ndiWrapper = NDIWrapper()

        //captureSession.sessionPreset = .hd1280x720
        //captureSession.sessionPreset = .iFrame960x540
        captureSession.sessionPreset = .vga640x480
        device = AVCaptureDevice.default(for: .video)
        device.activeVideoMinFrameDuration = CMTimeMake(value: 1, timescale: 30)

        captureDeviceInput = try! AVCaptureDeviceInput(device: device)
        if captureSession.canAddInput(captureDeviceInput) {
            captureSession.addInput(captureDeviceInput)
        }

        videoDataOutput = AVCaptureVideoDataOutput()
        videoDataOutput.videoSettings = [kCVPixelBufferPixelFormatTypeKey : kCVPixelFormatType_32BGRA] as [String : Any]
        videoDataOutput.setSampleBufferDelegate(self, queue: DispatchQueue(label: "videoQueue"))
        videoDataOutput.alwaysDiscardsLateVideoFrames = true
        if captureSession.canAddOutput(videoDataOutput) {
            captureSession.addOutput(videoDataOutput)
        }

        previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        previewLayer.videoGravity = AVLayerVideoGravity.resizeAspectFill
        previewLayer.connection?.videoOrientation = .landscapeRight
        previewLayer.frame = view.frame
        view.layer.insertSublayer(previewLayer, at: 0)

        sendButton = UIButton(frame: CGRect(x: 0, y: 0, width: 120, height: 40))
        sendButton.backgroundColor = .gray
        sendButton.layer.masksToBounds = true
        sendButton.setTitle("Send", for: .normal)
        sendButton.layer.cornerRadius = 18
        sendButton.layer.position = CGPoint(x: view.bounds.width / 2, y: view.bounds.height - 60)
        sendButton.addTarget(self, action: #selector(sendButton_action(sender:)), for: .touchUpInside)
        view.addSubview(sendButton)
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        captureSession.startRunning()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        captureSession.stopRunning()
    }

    private func startSending() {
        guard let ndiWrapper = self.ndiWrapper else { return }
        ndiWrapper.start(UIDevice.current.name)
    }

    private func stopSending() {
        guard let ndiWrapper = self.ndiWrapper else { return }
        ndiWrapper.stop()
    }

    @objc private func sendButton_action(sender: UIButton!) {
        if !isSending {
            startSending()
            isSending = true
            sendButton.setTitle("Sending...", for: .normal)
            sendButton.backgroundColor = .blue
        } else {
            isSending = false
            sendButton.setTitle("Send", for: .normal)
            sendButton.backgroundColor = .gray
            stopSending()
        }
    }
}

extension ViewController : AVCaptureVideoDataOutputSampleBufferDelegate {

    func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        guard let ndiWrapper = self.ndiWrapper, isSending else { return }
        ndiWrapper.send(sampleBuffer)
    }
}
