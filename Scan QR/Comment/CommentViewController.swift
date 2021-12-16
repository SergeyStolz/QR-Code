//
//  RequestViewController.swift
//  Scan QR
//
//  Created by mac on 08.12.2021.
//

import UIKit
import EasyPeasy
import NotificationCenter

class CommentViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UITextViewDelegate {
    //MARK: - Propiertis
    private var mainRequestModel: MainRequestModel
    private var networkService = NetworkService()
    let taskList = ["First Handlebar",
                    "Second Handlebar",
                    "Third Handlebar"
    ]
    let damageList = ["Damaged handlebar",
                      "Broken handlebar",
                      "Damaged or broken handlebar"
    ]
    
    //MARK: - Views
    private lazy var submitButton: SubmitButton = {
        let button = SubmitButton(type: .system)
        button.action = { [self] in
            self.mainRequestModel.comment = self.commentTextView.text
            postRequest()
        }
        return button
    }()
    
    private lazy var likeToDoLabel: UILabel = {
        let label = UILabel()
        label.text = "Anything else?"
        label.textAlignment = .left
        label.font = UIFont(name: "Noteworthy Light", size: 24)
        label.font = label.font.bold
        label.backgroundColor = .clear
        label.textColor = .white
        return label
    }()
    
    private lazy var commentTextView:  UITextView = {
        let textView = UITextView()
        textView.text = "Click to type ..."
        textView.textColor = .gray
        textView.font = UIFont(name: "Arial", size: 16)?.italic
        textView.backgroundColor = .darkGray
        textView.layer.cornerRadius = 13
        textView.delegate = self
        return textView
    }()
    
    private lazy var layout: UICollectionViewFlowLayout = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.itemSize = CGSize(width: view.frame.width ,
                                 height: 80
        )
        return layout
    }()
    
    private lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(
            frame: .zero,
            collectionViewLayout: layout
        )
        collectionView.register(
            CommentCollectionViewCell.self,
            forCellWithReuseIdentifier: CommentCollectionViewCell.identifier
        )
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.backgroundColor = .systemBackground
        collectionView.alwaysBounceVertical = true
        return collectionView
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
        notificationCenter()
        endEditingTapGesture()
    }
    
    private func notificationCenter() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    private func endEditingTapGesture() {
        let endEditingTapGesture = UITapGestureRecognizer(target: view, action: #selector(UIView.endEditing(_:)))
        endEditingTapGesture.cancelsTouchesInView = false
        view.addGestureRecognizer(endEditingTapGesture)
    }
    
    @objc private func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y == 0 {
                self.view.frame.origin.y -= keyboardSize.height
            }
        }
    }
    
    @objc private func keyboardWillHide(notification: NSNotification) {
        if self.view.frame.origin.y != 0 {
            self.view.frame.origin.y = 0
        }
    }
    
    internal func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == .gray {
            textView.text = nil
            textView.textColor = .white
        }
    }
    
    internal func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = "Click to type ..."
            textView.textColor = .gray
        }
    }
    
    private func postRequest() {
        networkService.postRequest(item: mainRequestModel)
    }
    
    private func setupView() {
        view.backgroundColor = .black
        
        view.addSubview(collectionView)
        collectionView.easy.layout(
            Edges()
        )
        
        view.addSubview(submitButton)
        submitButton.easy.layout(
            Bottom(50),
            Height(60),
            Width(210),
            CenterX()
        )
        
        view.addSubview(likeToDoLabel)
        likeToDoLabel.easy.layout(
            Left(30),
            Width(>=150),
            Height(40),
            Bottom(190).to(submitButton)
        )
        
        view.addSubview(commentTextView)
        commentTextView.easy.layout(
            Top(10).to(likeToDoLabel),
            Left(20),
            Right(20),
            Bottom(25).to(submitButton)
        )
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return taskList.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CommentCollectionViewCell.identifier, for: indexPath) as! CommentCollectionViewCell
        
        cell.headLabel.text = taskList[indexPath.row]
        cell.bottomLabel.text = damageList[indexPath.row]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        mainRequestModel.name = "\(taskList[indexPath.row])" + ", " + "\(damageList[indexPath.row])"
        
    }

}
