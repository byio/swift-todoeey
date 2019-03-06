//
//  AppDelegate.swift
//  Todoeey
//
//  Created by BenYang on 2/26/19.
//  Copyright © 2019 BenYang. All rights reserved.
//

import UIKit
import RealmSwift

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    // this delegate method gets called when app first loads, even before the viewDidLoad in TodoListViewController
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        // WHERE IS THE REALM DATA SAVED?
//        print(Realm.Configuration.defaultConfiguration.fileURL!)
        
        // create new Realm at launch
        do {
            _ = try Realm()
        }
        catch {
            print("Error initializing Realm: \(error)")
        }
        
        // Override point for customization after application launch.
        return true
    }

}

