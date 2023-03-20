//
//  AppDelegate.swift
//  TelnyxSample
//
//  Created by Mostafa Elbaz on 16/03/2023.
//

import UIKit
//import CallKit
//import TelnyxRTC

import AVFoundation

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

//    var telnyxClient : TxClient?
//    var currentCall: Call?
//    var callKitUUID: UUID?
//    var callKitProvider: CXProvider?
//    let callKitCallController = CXCallController()

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        
        // Instantiate the Telnyx Client SDK
//        self.telnyxClient = TxClient()
//        self.telnyxClient?.delegate = self
//        self.initCallKit()

        window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = LoginViewController()
        window?.makeKeyAndVisible()
        
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }


}
