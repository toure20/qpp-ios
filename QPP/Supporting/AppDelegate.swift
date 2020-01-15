//
//  AppDelegate.swift
//  QPP
//
//  Created by Toremurat on 4/1/19.
//  Copyright © 2019 STUDIO-X. All rights reserved.
//

import UIKit
import SnapKit
import SVProgressHUD

var serloc: ServiceLocator!
var cache = NSCache<NSString, User>()
var cacheContainer = NSCache<NSString, SizeAmountContainer>()

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        addServices()
        configureApperance()
        registerPushNotifications()
        return true
    }
    
    func configureApperance() {
        UITabBar.appearance().tintColor = UIColor(hex: "34343D")
        UINavigationBar.appearance().tintColor = UIColor.white
        UINavigationBar.appearance().titleTextAttributes = [
            NSAttributedString.Key.foregroundColor : UIColor.white,
            NSAttributedString.Key.font: UIFont.init(name: "Stolzl-Regular", size: 17) ?? UIFont.systemFont(ofSize: 17, weight: .medium)
        ]
        
        SVProgressHUD.setCornerRadius(12.0)
        SVProgressHUD.setBackgroundColor(UIColor.black.withAlphaComponent(0.8))
        SVProgressHUD.setFont(UIFont.systemFont(ofSize: 16.0))
        SVProgressHUD.setForegroundColor(UIColor.white)
        SVProgressHUD.setMinimumDismissTimeInterval(2.0)
        SVProgressHUD.setMaximumDismissTimeInterval(2.0)
        UINavigationBar.appearance().barTintColor = UIColor.black
//        UINavigationBar.appearance().backgroundColor = Constants.Color.deepBlue
        // required to disable blur effect & allow barTintColor to work
//        UINavigationBar.appearance().isTranslucent = false
    }
    
    func addServices() {
        let registry = LazyServiceLocator()
        serloc = registry
        registry.addService { CartRepository() as CartRepositoryProtocol }
        registry.addService { UserRepository() as UserRepositoryProtocol }
    }
    
    func gotoLogin() {
        let vc = LoginController.instantiate()
        self.window?.rootViewController = UINavigationController(rootViewController: vc)
    }
    
    func gotoTabbar() {
//        let vc = TabBarController.instantiate()
//        self.window?.rootViewController = vc
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
    
    func registerPushNotifications() {
        DispatchQueue.main.async {
            if #available(iOS 10.0, *) {
                let center = UNUserNotificationCenter.current()
                center.requestAuthorization(options: [.alert, .sound]) { (granted, error) in
                // actions based on whether notifications were authorized or not
                }
                UIApplication.shared.registerForRemoteNotifications()
            } else {
                let settings = UIUserNotificationSettings(types: [.sound, .alert, .badge], categories: nil)
                UIApplication.shared.registerUserNotificationSettings(settings)
                UIApplication.shared.registerForRemoteNotifications()
            }
            
        }
    }
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        let tokenString = deviceToken.reduce("", {$0 + String(format: "%02x", $1)})
        print(tokenString)
    }

    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print(error.localizedDescription)
    }
}

