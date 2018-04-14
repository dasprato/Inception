//
//  SignUpPasswordViewController.swift
//  NoteShare
//
//  Created by Prato Das on 2018-01-12.
//  Copyright © 2018 Prato Das. All rights reserved.
//

import UIKit
import Firebase


class ColorForSignUpPassword {
    var gl:CAGradientLayer!
    
    init() {
        let colorTop = UIColor(red: (CGFloat(arc4random_uniform(255)))/255, green: (CGFloat(arc4random_uniform(255)))/255, blue: (CGFloat(arc4random_uniform(255)))/255, alpha: 1.0).cgColor
        let colorBottom = UIColor(red: (CGFloat(arc4random_uniform(255)))/255, green: (CGFloat(arc4random_uniform(255)))/255, blue: (CGFloat(arc4random_uniform(255)))/255, alpha: 1.0).cgColor
        
        self.gl = CAGradientLayer()
        self.gl.colors = [colorTop, colorBottom]
        self.gl.locations = [0.0, 0.5]
    }
}


class SignUpPasswordViewController: UIViewController {
    
    var emailAddress: String? {
        didSet {
            emailField.text = emailAddress
        }
    }
    

    
    let colors = ColorForSignUpPassword()
    var backgroundLayer = CAGradientLayer()
    
    func refresh() {
        view.backgroundColor = UIColor.clear
        backgroundLayer = colors.gl
        view.layer.insertSublayer(backgroundLayer, at: 0)
    }
    
    
    override func viewDidLayoutSubviews() {
        self.backgroundLayer.frame = view.frame
        signUpButton.addShadow()
        emailField.addShadow()
        passwordField.addShadow()
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        refresh()
        view.addSubview(emailField)
        view.addSubview(passwordField)
        view.addSubview(signUpButton)
        
        NSLayoutConstraint.activate([signUpButton.centerXAnchor.constraint(equalTo: view.centerXAnchor), signUpButton.centerYAnchor.constraint(equalTo: view.centerYAnchor), signUpButton.heightAnchor.constraint(equalToConstant: 40), signUpButton.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor, constant: -16), signUpButton.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor, constant: 16)])
        
        NSLayoutConstraint.activate([passwordField.centerXAnchor.constraint(equalTo: view.centerXAnchor), passwordField.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor, constant: -16), passwordField.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor, constant: 16), passwordField.bottomAnchor.constraint(equalTo: signUpButton.topAnchor, constant: -8), passwordField.heightAnchor.constraint(equalToConstant: 40)])
        
        NSLayoutConstraint.activate([emailField.centerXAnchor.constraint(equalTo: view.centerXAnchor), emailField.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor, constant: -16), emailField.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor, constant: 16), emailField.bottomAnchor.constraint(equalTo: passwordField.topAnchor, constant: -8), emailField.heightAnchor.constraint(equalToConstant: 40)])
    }
    
    var emailField: UITextField = {
        let ef = UITextField()
        ef.translatesAutoresizingMaskIntoConstraints = false
        ef.placeholder = "Your email"
        ef.layer.cornerRadius = 5.0
        ef.backgroundColor = UIColor.white
        ef.textColor = .darkGray
        ef.contentMode = .center
        ef.textAlignment = .center
        return ef
    }()

    @objc func handleSignUp() {
        guard let email = emailField.text else { return }
        guard let password = passwordField.text else { return }
        var title = ""
        var message = ""
        Auth.auth().createUser(withEmail: email, password: password, completion: { (User, error) in
            
            if error != nil {
                print(error.debugDescription ?? "")
                title = "Error"
                message = (error?.localizedDescription)!
                    
                self.createAlert(title: title, message: message)
                return
            }

            let userDictionary: [String: Any] = ["emailAddress": email, "fieldOfStudy": "", "name": "Prato Das", "profilePictureStorageReference": ""]
            let db = Firestore.firestore()
            db.collection("Users").document(User!.uid).setData(userDictionary)
            self.dismiss(animated: true, completion: nil)
            

        })
        
    }
    
    
    var signUpButton: CustomUIButton = {
        
        let lb = CustomUIButton(type: .system)
        lb.translatesAutoresizingMaskIntoConstraints = false
        lb.setTitleColor(.white, for: .normal)
        lb.backgroundColor = .green
        lb.setTitle("Sign Up", for: .normal)
        lb.addTarget(self, action: #selector(handleSignUp), for: .touchUpInside)
        lb.layer.cornerRadius = 5.0
        return lb
    }()
    
    var passwordField: UITextField = {
        let ef = UITextField()
        ef.translatesAutoresizingMaskIntoConstraints = false
        ef.placeholder = "Your password"
        ef.layer.cornerRadius = 5.0
        ef.backgroundColor = UIColor.white
        ef.textColor = .darkGray
        ef.contentMode = .center
        ef.textAlignment = .center
        ef.isSecureTextEntry = true
        return ef
    }()
    
    func createAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: { (action) in
            alert.dismiss(animated: true, completion: nil)
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
}

