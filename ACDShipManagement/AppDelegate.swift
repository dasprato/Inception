//
//  AppDelegate.swift
//  ACDShipManagement
//
//  Created by Prato Das on 2018-01-25.
//  Copyright © 2018 Prato Das. All rights reserved.
//

import UIKit
import CoreData
import IQKeyboardManagerSwift
import CoreData
import Firebase
import UserNotifications
import UserNotificationsUI
import FirebaseMessaging

import UIKit
import CoreData
import FirebaseInstanceID
import UserNotifications
import Firebase
import FBSDKCoreKit
import FirebaseMessaging
import GoogleSignIn


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, MessagingDelegate, UNUserNotificationCenterDelegate {

    
    
    
    let gcmMessageIDKey = "gcm.message_id"
    let gcmVesselIdKey = "data.gcm.vessel_id"
    let apsKey = "aps"
    var window: UIWindow?
    
    
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
    
        FirebaseApp.configure() 
        // Basics of the UI Declared here including the intitial launch View Controller
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.makeKeyAndVisible()
        window?.rootViewController = AppTabBarController()
        UINavigationBar.appearance().barTintColor = .gray
        UINavigationBar.appearance().tintColor = .white
        UINavigationBar.appearance().barStyle = .black
        
        
        // Checking the network connectibitty for a better UX overall
        do {
            Network.reachability = try Reachability(hostname: "www.google.com")
            do {
                try Network.reachability?.start()
            } catch let error as Network.Error {
                print(error)
            } catch {
                print(error)
            }
        } catch {
            print(error)
        }
        

        if #available(iOS 10.0, *) {
            // For iOS 10 display notification (sent via APNS)
            UNUserNotificationCenter.current().delegate = self
            
            let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
            UNUserNotificationCenter.current().requestAuthorization(
                options: authOptions,
                completionHandler: {_, _ in })
        } else {
            let settings: UIUserNotificationSettings =
                UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
            application.registerUserNotificationSettings(settings)
        }
        
        application.registerForRemoteNotifications()

        Messaging.messaging().delegate = self
        
        IQKeyboardManager.sharedManager().enable = true
        IQKeyboardManager.sharedManager().keyboardDistanceFromTextField = 40
        
        
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {

    }

    func applicationDidEnterBackground(_ application: UIApplication) {

    }

    func applicationWillEnterForeground(_ application: UIApplication) {

    }

    func applicationDidBecomeActive(_ application: UIApplication) {

    }

    func applicationWillTerminate(_ application: UIApplication) {

        self.saveContext()
    }

    // MARK: - Core Data stack

    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "ACDShipManagement")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {

                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    // MARK: - Core Data Saving support

    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {

                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    
    //
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String) {
//        print("Firebase registration token: \(fcmToken)")
        
        // TODO: If necessary send token to application server.
        // Note: This callback is fired at each app startup and whenever a new token is generated.
        Messaging.messaging().subscribe(toTopic: "pushNotifications")
    }
    
    func application(application: UIApplication,
                     didRegisterForRemoteNotificationsWithDeviceToken deviceToken: NSData) {
        Messaging.messaging().apnsToken = deviceToken as Data
    }
    
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any]) {
        // If you are receiving a notification message while your app is in the background,
        // this callback will not be fired till the user taps on the notification launching the application.
        // TODO: Handle data of notification
        
        // With swizzling disabled you must let Messaging know about the message, for Analytics
        // Messaging.messaging().appDidReceiveMessage(userInfo)
        
        // Print message ID.
        if let messageID = userInfo[gcmMessageIDKey] {
            print("Message ID: \(messageID)")
        }
        
        
        print("Function 1 called")
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        // If you are receiving a notification message while your app is in the background,
        // this callback will not be fired till the user taps on the notification launching the application.
        // TODO: Handle data of notification
        
        // With swizzling disabled you must let Messaging know about the message, for Analytics
        // Messaging.messaging().appDidReceiveMessage(userInfo)
        
        // Print message ID.
        if let messageID = userInfo[gcmMessageIDKey] {
            print("Message ID: \(messageID)")
        }
        if let vesselId = userInfo[gcmVesselIdKey] {
            print("Vessel ID: \(vesselId)")
        }
        
        if let aps = userInfo[apsKey] as? [AnyHashable: [AnyHashable: Any]] {
            if let notificiation = aps["alert"] {
                if let title = notificiation["title"] {
                    print(title)
                }
                if let body = notificiation["body"] {
                    print(body)
                }
            }
        }
        
        print("Function 2 called")
        completionHandler(UIBackgroundFetchResult.newData)
    }

}





