//
//  SignUpController.swift
//  NoteShare
//
//  Created by Prato Das on 2018-01-11.
//  Copyright © 2018 Prato Das. All rights reserved.
//

import UIKit
import Firebase

class SignUpController: UIViewController {

    var userEmail: String? {
        didSet {
            let viewControllerToPush = SignUpPasswordViewController()
            viewControllerToPush.emailAddress = userEmail
            if userEmail != "" {
                viewControllerToPush.emailTextField.isUserInteractionEnabled = false
                viewControllerToPush.emailTextField.backgroundColor = UIColor(red: 152/255, green: 204/255, blue: 232/255, alpha: 1)
            }
            self.navigationController?.pushViewController(viewControllerToPush, animated: true)
        }
    }
    
    let arrayOfUIImages = [UIImage(named: "email")]
    let arrayOfMediaNames = ["Email"]
    let signUpCollectionViewCellId = "signUpCollectionViewCellId"
    
    var animatedBackgroundView: AnimatedBackgroundView = {
        let animatedBackgroundView = AnimatedBackgroundView()
        return animatedBackgroundView
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(animatedBackgroundView)
        view.addSubview(signUpCollectionView)
        
        NSLayoutConstraint.activate([animatedBackgroundView.topAnchor.constraint(equalTo: view.topAnchor), animatedBackgroundView.bottomAnchor.constraint(equalTo: view.bottomAnchor), animatedBackgroundView.rightAnchor.constraint(equalTo: view.rightAnchor), animatedBackgroundView.leftAnchor.constraint(equalTo: view.leftAnchor)])
        
        
        NSLayoutConstraint.activate([
            signUpCollectionView.topAnchor.constraint(equalTo: view.topAnchor),
            signUpCollectionView.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor),
            signUpCollectionView.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor),
            signUpCollectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
            ])
        

        signUpCollectionView.delegate = self
        signUpCollectionView.dataSource = self
        signUpCollectionView.register(SignUpCollectionViewCell.self, forCellWithReuseIdentifier: signUpCollectionViewCellId)
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationController?.view.backgroundColor = UIColor.clear
        self.navigationController?.navigationBar.tintColor = UIColor.white
        navigationController?.navigationItem.title = ""
        navigationItem.title = ""
        
        

        

    }

    var signUpCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 8
        let ma = UICollectionView(frame: .zero, collectionViewLayout: layout)
        ma.translatesAutoresizingMaskIntoConstraints = false
        ma.backgroundColor = .clear
        ma.contentInset = UIEdgeInsets(top: 8, left: 0, bottom: 8, right: 0)
        ma.bounces = true
        ma.bouncesZoom = true
        ma.alwaysBounceVertical = true
        return ma
    }()
    

}

extension SignUpController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return arrayOfUIImages.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: signUpCollectionViewCellId, for: indexPath) as! SignUpCollectionViewCell
        cell.image = arrayOfUIImages[indexPath.row]
        cell.title = arrayOfMediaNames[indexPath.row]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width - 32, height: 40)
    }
    
    
}


extension SignUpController {
    func handleEmailLogin() {
        self.userEmail = ""
    }
}

extension SignUpController {

    func collectionView(_ collectionView: UICollectionView, didHighlightItemAt indexPath: IndexPath) {
        switch indexPath.row {
        case 0:
            handleEmailLogin()
        default:
            break
        }
    }
}



class SignUpCollectionViewCell: UICollectionViewCell {
    
    var image: UIImage? {
        didSet {
            button.setImage(image?.withRenderingMode(.alwaysOriginal), for: .normal)
        }
    }
    
    var title: String? {
        didSet {
            button.setTitle(title, for: .normal)
        }
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor(red: 152/255, green: 204/255, blue: 232/255, alpha: 1)
        layer.cornerRadius = 10.0
        contentView.addSubview(button)
        addShadow()
        
        NSLayoutConstraint.activate([button.centerXAnchor.constraint(equalTo: centerXAnchor), button.centerYAnchor.constraint(equalTo: centerYAnchor), button.widthAnchor.constraint(equalTo: widthAnchor), button.heightAnchor.constraint(equalTo: heightAnchor)])
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    lazy var button: UIButton = {
        let lb = UIButton(type: .system)
        lb.translatesAutoresizingMaskIntoConstraints = false
        lb.tintColor = UIColor.white
        lb.contentMode = .scaleAspectFit
        lb.isUserInteractionEnabled = false
        return lb
    }()
    
    override func layoutSubviews() {
        button.addShadow()
    }
}
