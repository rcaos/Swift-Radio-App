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
    
    var storyBoard: UIStoryboard!

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = InitialTabBarController(appDIContainer: appDIContainer)
        window?.makeKeyAndVisible()
        
        self.enableDebugMode(true)
        return true
    }
    
    //MARK: - Initial Navigation
    
    func initialTransition() {
        storyBoard = UIStoryboard(name: "MainTabBar", bundle: nil)
        guard let mainTabBarController = storyBoard.instantiateViewController(withIdentifier: "MainTabBarController") as? InitialNavigationController else {
            fatalError()
        }
        self.window?.rootViewController = mainTabBarController
    }

    //MARK: - Debug
    
    fileprivate func enableDebugMode(_ shouldLog: Bool) {
        if shouldLog {
            //Debug - location of sqlite db file
            //.documentDirectory
            //.libraryDirectory
            var paths = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.libraryDirectory, FileManager.SearchPathDomainMask.userDomainMask, true)
            print("Debug - SQL File: [\(paths[0])]")
            print("Debug - SHIFT + CMD + G in finder")
        }
    }


}

