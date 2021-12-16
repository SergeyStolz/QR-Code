//
//  ViewController.swift
//  Scan QR
//
//  Created by mac on 06.12.2021.
//

import UIKit
import EasyPeasy
import AVFoundation

class TakePhotoViewController: UIViewController, AVCapturePhotoCaptureDelegate {
    //MARK: - Propiertis
    private var mainRequestModel: MainRequestModel
    private var session = AVCaptureSession()
    private var stillImageOutput = AVCapturePhotoOutput()
    private var video = AVCaptureVideoPreviewLayer()
    private var isFirstLunch: Bool = true
    
    //MARK: - Views
    private let rectangle = UIView()
    private lazy var headLabel: UILabel = {
        let label = UILabel()
        label.attributedText = getSumLabelAtributedString("Awesome!\n",
                                                          "Take a photo of the problem")
        label.textAlignment = .left
        label.backgroundColor = .clear
        label.numberOfLines = 0
        return label
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
    
    private lazy var photoView: UIView = {
        let view = UIView()
        view.isHidden = false
        return view
    }()
    
    private lazy var captureImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()
    
    private lazy var takePhotoButton: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = .yellow
        button.layer.cornerRadius = 43
        button.layer.borderWidth = 0.5
        button.addTarget(self, action: #selector(takePhoto), for: .touchUpInside)
        return button
    }()
    
    @objc func takePhoto() {
        let settings = AVCapturePhotoSettings(format: [AVVideoCodecKey: AVVideoCodecType.jpeg])
        stillImageOutput.capturePhoto(with: settings, delegate: self)
        session.stopRunning()
        
        captureImageView.isHidden = true
        confirmButton.isHidden = false
    }
    
    private lazy var blackButtonView: UIView = {
        let view = UIView()
        view.backgroundColor = .black
        view.layer.cornerRadius = 12
        view.isUserInteractionEnabled = false
        return view
    }()
    
    private lazy var skipButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Skip", for: .normal)
        button.setTitleColor(.gray, for: .normal)
        button.backgroundColor = .darkGray
        button.layer.cornerRadius = 25
        button.addTarget(self, action: #selector(skip), for: .touchUpInside)
        return button
    }()
    
    @objc func skip() {
        session.startRunning()
        confirmButton.isHidden = true
        captureImageView.removeFromSuperview()
    }
    
    private lazy var confirmButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Confirm", for: .normal)
        button.setTitleColor(.gray, for: .normal)
        button.backgroundColor = .yellow
        button.layer.cornerRadius = 25
        button.isHidden = true
        button.addTarget(self, action: #selector(showToRequestVC), for: .touchUpInside)
        return button
    }()
    
    
    init(model: MainRequestModel) {
        self.mainRequestModel = model
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Life cycles
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupVideo()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        startRunning()
        video.frame = photoView.bounds
        
        if isFirstLunch {
            let rectangle = createRect(frame: photoView.bounds)
            photoView.addSubview(rectangle)
            isFirstLunch = false
        }
    }
    
    func setupVideo() {
        session = AVCaptureSession()
        guard let captureDevice = AVCaptureDevice.default(for: AVMediaType.video) else { return }
        do {
            let input = try AVCaptureDeviceInput(device: captureDevice)
            
            stillImageOutput = AVCapturePhotoOutput()
            if session.canAddInput(input) && session.canAddOutput(stillImageOutput) {
                session.addInput(input)
                session.addOutput(stillImageOutput)
                video = AVCaptureVideoPreviewLayer(session: session)
                video.videoGravity = .resizeAspectFill
                photoView.layer.addSublayer(video)
                session.startRunning()
            }
        } catch {
            fatalError(error.localizedDescription)
        }
    }
    
    private func startRunning() {
        session.startRunning()
    }
    
    internal func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
        guard let imageData = photo.fileDataRepresentation() else { return }
        guard let image = UIImage(data: imageData) else { return }
        captureImageView.image = image
        
        guard let convertImageToBace64 = image.jpegData(compressionQuality: 0.75)?.base64EncodedString() else { return }
        mainRequestModel.photoBase64 = convertImageToBace64
    }
    
    @objc func showToRequestVC() {
        captureImageView.removeFromSuperview()
        confirmButton.isHidden = true
        let vc = CommentViewController(model: self.mainRequestModel)
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    private func createRect(frame: CGRect) -> UIView {
        let rectangleView = UIView(frame: photoView.bounds)
        rectangleView.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        let path = CGMutablePath()
        path.addRect(CGRect(x: photoView.frame.size.width/2-180,
                            y: photoView.frame.size.height/2-110,
                            width: 360,
                            height: 220))
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
        
        view.addSubview(photoView)
        photoView.easy.layout(
            Top(50).to(headLabel),
            Width(view.frame.size.width),
            Height(300)
        )
        
        photoView.addSubview(captureImageView)
        captureImageView.easy.layout(
            Edges()
        )
        
        
        view.addSubview(takePhotoButton)
        takePhotoButton.easy.layout(
            Top(50).to(photoView),
            CenterX(),
            Height(86),
            Width(86)
        )
        
        takePhotoButton.addSubview(blackButtonView)
        blackButtonView.easy.layout(
            CenterX(),
            CenterY(),
            Height(35),
            Width(35)
        )
        
        view.addSubview(skipButton)
        skipButton.easy.layout(
            Top(65).to(photoView),
            Left(35).to(takePhotoButton),
            Height(65),
            Width(105)
        )
        
        view.addSubview(confirmButton)
        confirmButton.easy.layout(
            Right(35).to(takePhotoButton),
            Top(65).to(photoView),
            Width(105),
            Height(65)
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

