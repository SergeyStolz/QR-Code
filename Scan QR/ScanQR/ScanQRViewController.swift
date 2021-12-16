//
//  ScanQRViewController.swift
//  Scan QR
//
//  Created by mac on 06.12.2021.
//

import UIKit
import EasyPeasy
import AVFoundation

class ScanQRViewController: UIViewController, AVCaptureMetadataOutputObjectsDelegate {
    
    //MARK: - Propiertis
    private var mainRequestModel = MainRequestModel()
    private var video = AVCaptureVideoPreviewLayer()
    private let session = AVCaptureSession()
    private var isFirstLunch: Bool = true
    
    //MARK: - Views
    private let rectangle = UIView()
    private lazy var headLabel: UILabel = {
        let label = UILabel()
        label.attributedText = getSumLabelAtributedString("Let's get started...\n",
                                                          "Scan the QR code on the bike")
        label.textAlignment = .left
        label.backgroundColor = .clear
        label.numberOfLines = 0
        return label
    }()
    
    private lazy var videoView: UIView = {
        let view = UIView()
        return view
    }()
    
    private lazy var helpMeLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = UIFont(name: "Arial", size: 13)
        label.backgroundColor = .clear
        label.textColor = .gray
        label.attributedText = getUnderline("Help me with my camera!")
        return label
    }()
    
    //MARK: - Life cycles
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupVideo()
        startRunning()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        startRunning()
        video.frame = view.bounds
        
        if isFirstLunch {
            let rectangle = createRect(frame: video.frame)
            videoView.addSubview(rectangle)
            isFirstLunch = false
        }
    }
    
    private func createRect(frame: CGRect) -> UIView {
        let rectangleView = UIView(frame: frame)
        rectangleView.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        let path = CGMutablePath()
        path.addRect(CGRect(x: videoView.frame.size.width/2-100,
                            y: videoView.frame.size.height/2-100,
                            width: 200,
                            height: 200))
        
        path.addRect(CGRect(origin: .zero, size: rectangleView.frame.size))
        let maskLayer = CAShapeLayer()
        maskLayer.backgroundColor = UIColor.black.cgColor
        maskLayer.path = path
        maskLayer.fillRule = CAShapeLayerFillRule.evenOdd
        maskLayer.fillRule = .evenOdd
        rectangleView.layer.mask = maskLayer
        rectangleView.clipsToBounds = true
        return rectangleView
    }
    
    private func setupVideo() {
        guard let captureDevice = AVCaptureDevice.default(for: AVMediaType.video) else { return }
        
        do {
            let input = try AVCaptureDeviceInput(device: captureDevice)
            session.addInput(input)
        } catch {
            fatalError(error.localizedDescription)
        }
        let output = AVCaptureMetadataOutput()
        session.addOutput(output)
        output.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
        output.metadataObjectTypes = [AVMetadataObject.ObjectType.qr]
        video = AVCaptureVideoPreviewLayer(session: session)
        videoView.layer.addSublayer(video)
        session.startRunning()
    }
    
    private func startRunning() {
        session.startRunning()
    }
    
    internal func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        guard metadataObjects.count > 0 else { return }
        if let object = metadataObjects.first as? AVMetadataMachineReadableCodeObject {
            if object.type == AVMetadataObject.ObjectType.qr {
                let alert = UIAlertController(title: "QR Code", message: object.stringValue, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Копировать", style: .default, handler: { (action) in
                    UIPasteboard.general.string = object.stringValue
                    self.mainRequestModel.qrCode = object.stringValue ?? ""
                    
                    let vc = TakePhotoViewController(model: self.mainRequestModel)
                    self.navigationController?.pushViewController(vc, animated: true)
                }))
                present(alert, animated: true, completion: nil)
                self.session.stopRunning()
            }
        }
    }
    
    private func setupView() {
        view.backgroundColor = .black
        
        guard let navigationBar = self.navigationController?.navigationBar else { return }
        navigationBar.topItem!.title = ""
        navigationBar.tintColor = UIColor.white
        
        view.addSubview(headLabel)
        headLabel.easy.layout(
            Top(35),
            Left(15),
            Right(25),
            Height(150)
        )
        view.addSubview(videoView)
        videoView.easy.layout(
            Top().to(headLabel),
            Width(view.frame.size.width),
            Bottom()
        )
        
        view.addSubview(helpMeLabel)
        helpMeLabel.easy.layout(
            Bottom(13),
            CenterX(),
            Height(30),
            Width(>=40)
        )
    }
}


