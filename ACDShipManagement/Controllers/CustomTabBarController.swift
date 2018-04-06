//
//  CustomTabBarController.swift
//  ACDShipManagement
//
//  Created by Prato Das on 2018-01-27.
//  Copyright © 2018 Prato Das. All rights reserved.
//

import UIKit

class CustomTabBarController: UITabBarController, UITabBarControllerDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let shipViewController = UINavigationController(rootViewController: ShipTrackViewController())
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
        
        
        
        
    
        viewControllers = [menuViewController, shipViewController, notificationViewController]
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
    
    


    
    

    

}

