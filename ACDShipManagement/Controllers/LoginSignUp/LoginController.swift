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
    
    
    var override = true
    
    let colors = ColorForLogin()
    var backgroundLayer = CAGradientLayer()
    
    func refresh() {
        view.backgroundColor = UIColor.clear
        backgroundLayer = colors.gl
        view.layer.insertSublayer(backgroundLayer, at: 0)
    }
    
    
    var loginButtonConstraints = [NSLayoutConstraint]()
    var signUpButtonConstraints = [NSLayoutConstraint]()
    var passwordTextFieldConstraints = [NSLayoutConstraint]()
    var emailTextFieldConstraints = [NSLayoutConstraint]()
    override func viewDidLayoutSubviews() {
        self.backgroundLayer.frame = view.frame
        loginButton.addShadow()
        signUpButton.addShadow()
        emailTextField.addShadow()
        passwordTextField.addShadow()
        
        if override { 
        self.emailTextField.center.x = self.view.frame.width * 2
        self.passwordTextField.center.x = self.view.frame.width * -2
        }
    }
    
    

    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        self.emailTextField.center.x = self.view.frame.width / 2
        self.passwordTextField.center.x = self.view.frame.width / 2


    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        refresh()
        view.addSubview(loginButton)
        view.addSubview(signUpButton)
        view.addSubview(emailTextField)
        view.addSubview(passwordTextField)
        
        
        self.signUpButton.alpha = 0
        self.loginButton.alpha = 0


        loginButtonConstraints = [loginButton.centerXAnchor.constraint(equalTo: view.centerXAnchor), loginButton.centerYAnchor.constraint(equalTo: view.centerYAnchor), loginButton.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor, constant: -16), loginButton.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor, constant: 16), loginButton.heightAnchor.constraint(equalToConstant: 40)]
        
        signUpButtonConstraints = [signUpButton.centerXAnchor.constraint(equalTo: view.centerXAnchor), signUpButton.topAnchor.constraint(equalTo: loginButton.bottomAnchor, constant: 8), signUpButton.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor, constant: -16), signUpButton.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor, constant: 16), signUpButton.heightAnchor.constraint(equalToConstant: 40)]

        
        passwordTextFieldConstraints = [passwordTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor), passwordTextField.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor, constant: -16), passwordTextField.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor, constant: 16), passwordTextField.bottomAnchor.constraint(equalTo: loginButton.topAnchor, constant: -8), passwordTextField.heightAnchor.constraint(equalToConstant: 40)]
        
        emailTextFieldConstraints = [emailTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor), emailTextField.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor, constant: -16), emailTextField.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor, constant: 16), emailTextField.bottomAnchor.constraint(equalTo: passwordTextField.topAnchor, constant: -8), emailTextField.heightAnchor.constraint(equalToConstant: 40)]
        
        loginButtonConstraints.forEach { (constraint) in constraint.isActive = true }
        signUpButtonConstraints.forEach { (constraint) in constraint.isActive = true }
        passwordTextFieldConstraints.forEach { (constraint) in constraint.isActive = true }
        emailTextFieldConstraints.forEach { (constraint) in constraint.isActive = true }

        
        navigationController?.navigationItem.title = ""
        navigationItem.title = ""
        // to completely get rid of the nav bar and status bar
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationController?.view.backgroundColor = UIColor.clear
        

    }

    
    override func viewDidAppear(_ animated: Bool) {

        
        UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 25, initialSpringVelocity: 5, options: .curveEaseOut, animations: {
            self.emailTextField.center.x = self.view.frame.width / 2
            self.passwordTextField.center.x = self.view.frame.width / 2
            self.override = false
            self.signUpButton.alpha = 1
            self.loginButton.alpha = 1
        }, completion: nil)
        

    }
    

    override func viewWillAppear(_ animated: Bool) {
        
        override = true
    }
    
    
    var loginButton: CustomUIButton = {
        let lb = CustomUIButton(type: .system)
        lb.translatesAutoresizingMaskIntoConstraints = false
        lb.setTitleColor(.white, for: .normal)
        lb.backgroundColor = .green
        lb.setTitle("Login", for: .normal)
        lb.addTarget(self, action: #selector(handleLogin), for: .touchUpInside)
        lb.layer.cornerRadius = 10.0
        return lb
    }()
    
    

    

    
    
    
    var signUpButton: UIButton = {
        let lb = CustomUIButton(type: .system)
        lb.translatesAutoresizingMaskIntoConstraints = false
        lb.setTitleColor(.white, for: .normal)
        lb.backgroundColor = .green
        lb.setTitle("Have not signed up? Sign up", for: .normal)
        lb.addTarget(self, action: #selector(handleSignUp), for: .touchUpInside)
        lb.layer.cornerRadius = 10.0
        return lb
    }()
    
    
    var emailTextField: UITextField = {
        let ef = UITextField()
        ef.translatesAutoresizingMaskIntoConstraints = false
        ef.placeholder = "Your email"
        ef.layer.cornerRadius = 10.0
        ef.backgroundColor = UIColor.white
        ef.textColor = .darkGray
        ef.contentMode = .center
        ef.textAlignment = .center
        return ef
    }()
    
    
    var passwordTextField: UITextField = {
        let ef = UITextField()
        ef.translatesAutoresizingMaskIntoConstraints = false
        ef.placeholder = "Your password"
        ef.layer.cornerRadius = 10.0
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
        
        guard let email = emailTextField.text else { return }
        guard let password = passwordTextField.text else { return }
        if email == "" || password == ""{
            self.createAlert(title: "Error", message: "Looks like one of the text fields are empty.")
            return
        }
        
        Auth.auth().signIn(withEmail: email, password: password, completion: { (user, error) in
            var title = ""
            var message = ""
            if error != nil {

                title = "Error"
                message = (error?.localizedDescription)!
                
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
