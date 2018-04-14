//
//  LoginController.swift
//  NoteShare
//
//  Created by Prato Das on 2018-01-11.
//  Copyright © 2018 Prato Das. All rights reserved.
//

import UIKit
import Firebase

class LoginController: UIViewController {

    
    let colors = ColorForLogin()
    var backgroundLayer = CAGradientLayer()
    
    func refresh() {
        view.backgroundColor = UIColor.clear
        backgroundLayer = colors.gl
        view.layer.insertSublayer(backgroundLayer, at: 0)
    }
    
    
    override func viewDidLayoutSubviews() {
        self.backgroundLayer.frame = view.frame
        loginButton.addShadow()
        signUpButton.addShadow()
        emailField.addShadow()
        passwordField.addShadow()
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        refresh()
        view.addSubview(loginButton)
        view.addSubview(signUpButton)
        view.addSubview(emailField)
        view.addSubview(passwordField)

        NSLayoutConstraint.activate([loginButton.centerXAnchor.constraint(equalTo: view.centerXAnchor), loginButton.centerYAnchor.constraint(equalTo: view.centerYAnchor), loginButton.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor, constant: -16), loginButton.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor, constant: 16), loginButton.heightAnchor.constraint(equalToConstant: 40)])
        
        NSLayoutConstraint.activate([signUpButton.centerXAnchor.constraint(equalTo: view.centerXAnchor), signUpButton.topAnchor.constraint(equalTo: loginButton.bottomAnchor, constant: 8), signUpButton.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor, constant: -16), signUpButton.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor, constant: 16), signUpButton.heightAnchor.constraint(equalToConstant: 40)])

        
        NSLayoutConstraint.activate([passwordField.centerXAnchor.constraint(equalTo: view.centerXAnchor), passwordField.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor, constant: -16), passwordField.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor, constant: 16), passwordField.bottomAnchor.constraint(equalTo: loginButton.topAnchor, constant: -8), passwordField.heightAnchor.constraint(equalToConstant: 40)])
        
        NSLayoutConstraint.activate([emailField.centerXAnchor.constraint(equalTo: view.centerXAnchor), emailField.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor, constant: -16), emailField.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor, constant: 16), emailField.bottomAnchor.constraint(equalTo: passwordField.topAnchor, constant: -8), emailField.heightAnchor.constraint(equalToConstant: 40)])
        navigationController?.navigationItem.title = ""
        navigationItem.title = ""
        // to completely get rid of the nav bar and status bar
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationController?.view.backgroundColor = UIColor.clear
        

    }
    override func viewDidAppear(_ animated: Bool) {
        }
    
    
    var loginButton: CustomUIButton = {
        let lb = CustomUIButton(type: .system)
        lb.translatesAutoresizingMaskIntoConstraints = false
        lb.setTitleColor(.white, for: .normal)
        lb.backgroundColor = .green
        lb.setTitle("Login", for: .normal)
        lb.addTarget(self, action: #selector(handleLogin), for: .touchUpInside)
        lb.layer.cornerRadius = 5.0
        return lb
    }()
    
    

    

    
    
    
    var signUpButton: UIButton = {
        let lb = CustomUIButton(type: .system)
        lb.translatesAutoresizingMaskIntoConstraints = false
        lb.setTitleColor(.white, for: .normal)
        lb.backgroundColor = .green
        lb.setTitle("Have not signed up? Sign up", for: .normal)
        lb.addTarget(self, action: #selector(handleSignUp), for: .touchUpInside)
        lb.layer.cornerRadius = 5.0
        return lb
    }()
    
    
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
    
    @objc func handleSignUp() {
        
        print("Trying to handle sign up")
        self.navigationController?.pushViewController(SignUpController(), animated: true)
    }
    
    @objc func handleLogin() {
        
        print("Trying to handle login")
        
        guard let email = emailField.text else { return }
        var password = ""
        if passwordField.text != "" {
            password = passwordField.text!
        }
        if email == "" {
            self.createAlert(title: "Empty, Empty", message: "Looks like one of the text fields are empty")
            return
        }
        
        Auth.auth().signIn(withEmail: email, password: password, completion: { (user, error) in
            var title = ""
            var message = ""
            if error != nil {
                print(error ?? "")
                if error.debugDescription.lowercased().range(of: "error_user_not_found") != nil {
                    title = "User Not Found"
                    message = "Looks like you never registered!"
                }
                else if error.debugDescription.lowercased().range(of: "error_wrong_password") != nil {
                    title = "Wrong Password"
                    message = "Please check your password and retry!"
                    
                }
                else if error.debugDescription.lowercased().range(of: "error_invalid_email") != nil {
                    title = "Invalid Email"
                    message = "That email is not a real one!"
                }
                self.createAlert(title: title, message: message)
                return
            }
            
            //successfully logged in our user

            self.dismiss(animated: true, completion: nil)
        })
        
        

    }
    

    
    func createAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: { (action) in
            alert.dismiss(animated: true, completion: nil)
        }))
        self.present(alert, animated: true, completion: nil)
    }

}


class ColorForLogin {
    var gl:CAGradientLayer!
    
    init() {
        let colorTop = UIColor(red: (CGFloat(arc4random_uniform(255)))/255, green: (CGFloat(arc4random_uniform(255)))/255, blue: (CGFloat(arc4random_uniform(255)))/255, alpha: 1.0).cgColor
        let colorBottom = UIColor(red: (CGFloat(arc4random_uniform(255)))/255, green: (CGFloat(arc4random_uniform(255)))/255, blue: (CGFloat(arc4random_uniform(255)))/255, alpha: 1.0).cgColor
        
        self.gl = CAGradientLayer()
        self.gl.colors = [colorTop, colorBottom]
        self.gl.locations = [0.0, 0.5]
    }
}
