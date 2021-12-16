//
//  ConnectButtom.swift
//  Scan QR
//
//  Created by mac on 06.12.2021.
//
import UIKit
import EasyPeasy

class ConnectButtom: UIButton {
    
    var action: (() -> ())? = nil
    
    private lazy var reportIssueWifiImageView: UIImageView = {
        let imageView = UIImageView()
        let image = UIImage(systemName: "wifi")?.withTintColor(.black, renderingMode: .alwaysOriginal)
        imageView.image = image
        return imageView
    }()
    
    private lazy var reportIssueNextImageView: UIImageView = {
        let imageView = UIImageView()
        let image = UIImage(systemName: "chevron.compact.right")?.withTintColor(.black, renderingMode: .alwaysOriginal)
        imageView.image = image
        return imageView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setTitle("Report Issue", for: .normal)
        setTitleColor(.black, for: .normal)
        backgroundColor = .yellow
        layer.cornerRadius = 30
        addTarget(self, action: #selector(toPhotoQR), for: .touchUpInside)
        setupViews()
    }
    
    @objc func toPhotoQR() {
        action?()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupViews()
    }
    
    private func setupViews() {
        addSubview(reportIssueWifiImageView)
        reportIssueWifiImageView.easy.layout(
            Left(13),
            Top(17),
            Width(30),
            Height(25)
        )
        addSubview(reportIssueNextImageView)
        reportIssueNextImageView.easy.layout(
            Right(13),
            Top(20),
            Width(20),
            Height(20)
        )
    }
}
