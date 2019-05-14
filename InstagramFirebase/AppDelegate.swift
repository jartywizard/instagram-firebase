//
//  AppDelegate.swift
//  InstagramFirebase
//
//  Created by Joseph Clinch on 5/17/18.
//  Copyright © 2018 Joseph Clinch. All rights reserved.
//

import UIKit
import Firebase
import UserNotifications

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, MessagingDelegate, UNUserNotificationCenterDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        FirebaseApp.configure()
        
        // THIS CREATES THE TAB BAR CONTROLLER BELOW!!!
        // Then we create the MainTabBarViewController File and make it in that bitch
        
        window = UIWindow()
        window?.rootViewController = MainTabBarController()
        
        attemptRegisterForNotifications(application: application)
        
        // Override point for customization after application launch.
        return true
    }
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        print("Registered for notifications:", deviceToken)
    }
    
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String) {
        print("Registered with FCM with token:", fcmToken)
    }
    
    // listen for user notifications
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler(.alert)
    }
    
    // allows user to tap on notification and it will take them to user's profile that's now following them
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        
        let userInfo = response.notification.request.content.userInfo
        print(userInfo)
        
        if let followerId = userInfo["followerId"] as? String {
            print(followerId)
            
            // Pushes the UserProfileController for followerId
            
            let userProfileController = UserProfileController(collectionViewLayout: UICollectionViewFlowLayout())
            userProfileController.userId = followerId
            
            // accessing our main UI from AppDelegate
            if let mainTabBarController = window?.rootViewController as? MainTabBarController {
                
                // 0 reprents the number of the viewController we're using (this is for the first controller on the tab bar, so it's 0. the 4th one would be 3, etc.)
                mainTabBarController.selectedIndex = 0
                
                // this next line is in case the middle controller is open (since the controller goes over the tab bar
                mainTabBarController.presentedViewController?.dismiss(animated: true, completion: nil)
                
                // this handles the actual presenting of the viewcontroller for the userprofile of followerId
                if let homeNavigationController = mainTabBarController.viewControllers?.first as? UINavigationController {
                    
                    homeNavigationController.pushViewController(userProfileController, animated: true)
                }
            }
            
        }
        completionHandler()
    }
    
    private func attemptRegisterForNotifications(application: UIApplication) {
        print("Attempting to register APNS...")
        
        Messaging.messaging().delegate = self
        
        UNUserNotificationCenter.current().delegate = self

        // user notification auth
        // all of this works for ios10+
        let options: UNAuthorizationOptions = [.alert, .badge, .sound]
        UNUserNotificationCenter.current().requestAuthorization(options: options) { (granted, err) in
            if let err = err {
                print("Failed to request auth:", err)
                return
            }
            
            if granted {
                print("Auth granted!")
            } else {
                print("Auth denied")
            }
        }
        
        application.registerForRemoteNotifications()
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

