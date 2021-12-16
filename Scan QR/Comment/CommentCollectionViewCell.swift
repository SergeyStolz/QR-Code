//
//  RequestTableViewCell.swift
//  Scan QR
//
//  Created by mac on 13.12.2021.
//

import UIKit
import EasyPeasy

class CommentCollectionViewCell: UICollectionViewCell {
    static let identifier = "RequestTableViewCell"
    
    lazy var wifiButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .gray
        button.clipsToBounds = true
        button.layer.masksToBounds = true
        let image = UIImage(systemName: "wifi")?.withTintColor(.white, renderingMode: .alwaysOriginal)
        button.setImage(image, for: .normal)
        return button
    }()
    
    var headLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = UIFont(name: "Hoefler Text", size: 24)
        label.backgroundColor = .clear
        label.textAlignment = .left
        label.numberOfLines = 0
        return label
    }()
    
    var bottomLabel: UILabel = {
        let label = UILabel()
        label.textColor = .gray
        label.font = UIFont(name: "Hoefler Text", size: 20)
        label.backgroundColor = .clear
        label.textAlignment = .left
        label.numberOfLines = 0
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(wifiButton)
        addSubview(headLabel)
        addSubview(bottomLabel)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        wifiButton.layer.cornerRadius = wifiButton.frame.size.width/2
    }
    
    private func setupView() {
        wifiButton.easy.layout(
            CenterY(),
            Left(50),
            Width(60).with(.required),
            Height(60).with(.required)
        )
        
        headLabel.easy.layout(
            Top(15),
            Left(20).to(wifiButton),
            Height(<=30),
            Width(<=300)
        )
        bottomLabel.easy.layout(
            Top(5).to(headLabel),
            Left(20).to(wifiButton),
            Height(<=30),
            Width(<=300)
        )
    }
    
    override var isSelected: Bool {
        didSet {
            let imageBlack = UIImage(systemName: "wifi")?.withTintColor(.black, renderingMode: .alwaysOriginal)
            let imageWhite = UIImage(systemName: "wifi")?.withTintColor(.white, renderingMode: .alwaysOriginal)
            
            if isSelected {
                wifiButton.setImage(imageBlack, for: .normal)
                wifiButton.backgroundColor = .yellow
            } else {
                wifiButton.setImage(imageWhite, for: .normal)
                wifiButton.backgroundColor = .gray
            }
        }
    }
}
