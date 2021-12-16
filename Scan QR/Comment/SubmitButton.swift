//
//  SubmitButton.swift
//  Scan QR
//
//  Created by mac on 08.12.2021.
//

import UIKit
import EasyPeasy

class SubmitButton: UIButton {
    
    var action: (() -> ())? = nil
    
    private lazy var reportIssueNextImageView: UIImageView = {
        let imageView = UIImageView()
        let image = UIImage(systemName: "chevron.compact.right")?.withTintColor(.black, renderingMode: .alwaysOriginal)
        imageView.image = image
        return imageView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setTitle("Submit", for: .normal)
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
        addSubview(reportIssueNextImageView)
        reportIssueNextImageView.easy.layout(
            Right(60),
            Top(22),
            Width(17),
            Height(17)
        )
    }
}
