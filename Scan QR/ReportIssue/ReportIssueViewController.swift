//
//  ViewController.swift
//  Scan QR
//
//  Created by mac on 06.12.2021.
//

import UIKit
import EasyPeasy

class ReportIssueViewController: UIViewController {
    
    private lazy var logoLabel: UILabel = {
        let label = UILabel()
        label.text = "logo"
        label.textColor = .black
        label.textAlignment = .center
        label.font = UIFont(name: "Arial", size: 33)
        label.font = label.font.bold
        label.backgroundColor = .white
        label.layer.borderWidth = 8
        label.layer.borderColor = UIColor.red.cgColor
        return label
    }()
    
    private lazy var greetingLabel: UILabel = {
        let label = UILabel()
        label.text = "Good morning!"
        label.textAlignment = .left
        label.font = UIFont(name: "Noteworthy Light", size: 24)
        label.backgroundColor = .clear
        label.textColor = .white
        return label
    }()
    
    private lazy var likeToDoLabel: UILabel = {
        let label = UILabel()
        label.text = "What would you like to do?"
        label.textAlignment = .left
        label.font = UIFont(name: "Noteworthy Light", size: 24)
        label.font = label.font.bold
        label.backgroundColor = .clear
        label.textColor = .white
        return label
    }()
    
    private lazy var reportIssueButton: ConnectButtom = {
        let btn = ConnectButtom(type: .system)
        btn.action = {
            let vc = ScanQRViewController()
            self.navigationController?.pushViewController(vc, animated: true)
        }
        return btn
    }()
    
    private lazy var betaButton: UIButton = {
        let button = UIButton()
        button.setTitle("Beta", for: .normal)
        button.backgroundColor = .clear
        button.setTitleColor(UIColor.white, for: .normal)
        button.layer.cornerRadius = 18
        button.layer.borderWidth = 0.5
        button.layer.borderColor = UIColor.gray.cgColor
        button.addTarget(self, action: #selector(beta), for: .touchUpInside)
        return button
    }()
    
    @objc func beta() {
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black
        setupView()
    }
    
    private func setupView(){
        view.addSubview(logoLabel)
        logoLabel.easy.layout(
            Top(100),
            CenterX(),
            Height(80),
            Width(130)
        )
        
        view.addSubview(greetingLabel)
        greetingLabel.easy.layout(
            Top(40).to(logoLabel),
            Left(25),
            Height(40)
        )
        
        view.addSubview(likeToDoLabel)
        likeToDoLabel.easy.layout(
            Top().to(greetingLabel),
            Left(25),
            Height(40)
        )
        
        view.addSubview(reportIssueButton)
        reportIssueButton.easy.layout(
            Top(70).to(likeToDoLabel),
            CenterX(),
            Width(210),
            Height(60)
        )
        
        view.addSubview(betaButton)
        betaButton.easy.layout(
            Bottom(45),
            CenterX(),
            Height(35),
            Width(100)
        )
    }
}
