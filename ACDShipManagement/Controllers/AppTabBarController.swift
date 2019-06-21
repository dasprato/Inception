//
//  CustomTabBarController.swift
//  ACDShipManagement
//
//  Created by Prato Das on 2018-01-27.
//  Copyright © 2018 Prato Das. All rights reserved.
//
import UIKit
import Firebase
import FirebaseMessaging

class AppTabBarController: UITabBarController, UITabBarControllerDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        checkIfUserIsLoggedIn()
        
        let shipViewController = UINavigationController(rootViewController: ShipViewController())
        shipViewController.title = "Ship"
        shipViewController.tabBarItem.image = UIImage(named: "ship")
        
        
        let accountViewController = UINavigationController(rootViewController: AccountViewController())
        accountViewController.title = "Account"
        accountViewController.tabBarItem.image = UIImage(named: "account")
        
        let notificationViewController = UINavigationController(rootViewController: NotificationViewController())
        notificationViewController.title = "Notification"
        notificationViewController.tabBarItem.image = UIImage(named: "notification")
        
        
        let menuViewController = UINavigationController(rootViewController: MenuViewController())
        menuViewController.title = "Menu"
        menuViewController.tabBarItem.image = UIImage(named: "menu")
        
        viewControllers = [menuViewController, shipViewController, notificationViewController, accountViewController]
        tabBar.backgroundColor = .gray
        tabBar.backgroundImage = UIImage()
        tabBar.unselectedItemTintColor = .white
        
        
        let changeColor = CATransition()
        changeColor.type = kCATransitionFade
        changeColor.duration = 0.2
        
        
        CATransaction.begin()
        tabBar.layer.shadowColor = UIColor.black.withAlphaComponent(0.5).cgColor
        tabBar.layer.add(changeColor, forKey: nil)
        CATransaction.setCompletionBlock {
        }
        CATransaction.commit()
        tabBar.layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
        tabBar.layer.shadowOpacity = 1.0
        tabBar.layer.masksToBounds = false
        
        
        
        
    }
    
    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        
        NotificationCenter.default.post(name: NSNotification.Name.init("didSelectADifferentTab"), object: self, userInfo: nil)
    }
    
    func checkIfUserIsLoggedIn() {
        if Auth.auth().currentUser?.uid == nil {
            perform(#selector(handleLogout), with: nil, afterDelay: 0)
        }
    }
    @objc func handleLogout() {
        do {
            try Auth.auth().signOut()
        } catch let logoutError {
            print(logoutError)
        }
        let viewControllerToPresent = LoginController()
        
        self.present(UINavigationController(rootViewController: viewControllerToPresent), animated: true, completion: nil)
    }
    
    
    
    
    
    
    
    
}
