//
//  AppDelegate.swift
//  RadiosPeru
//
//  Created by Jeans on 10/17/19.
//  Copyright © 2019 Jeans. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
  
  let appDIContainer = AppDIContainer()
  
  var window: UIWindow?
  
  func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
    
    AppAppearance.setupAppearance()
    
    window = UIWindow(frame: UIScreen.main.bounds)
    window?.rootViewController = InitialTabBarController(appDIContainer: appDIContainer)
    window?.makeKeyAndVisible()
    
    self.enableDebugMode(true)
    return true
  }
  
  // MARK: - Initial Navigation
  
  func initialTransition() {
    self.window?.rootViewController = MainNavigationController(appDIContainer: appDIContainer)
  }
  
  // MARK: - Debug
  
  fileprivate func enableDebugMode(_ shouldLog: Bool) {
    if shouldLog {
      //Debug - location of sqlite db file
      //.documentDirectory
      //.libraryDirectory
      let paths = NSSearchPathForDirectoriesInDomains(
        FileManager.SearchPathDirectory.libraryDirectory,
        FileManager.SearchPathDomainMask.userDomainMask, true)
      print("Debug - SQL File: [\(paths[0])]")
      print("Debug - SHIFT + CMD + G in finder")
    }
  }
  
}
