//
//  AppDelegate.swift
//  Cataract
//
//  Created by Roseanne Choi on 6/4/18.
//  Copyright © 2018 Roseanne Choi. All rights reserved.
//

import UIKit
import SwiftMoment
import SwiftyJSON

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate
{
    var window: UIWindow?
    
    var rootController = MainDashboardController()
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool
    {
        self.window!.rootViewController = rootController
        self.window!.backgroundColor = UIColor.white
        self.window!.makeKeyAndVisible()
        
        self.rootController.loadAllStores()
        
        let viewModel = MainDashboardViewModel()
        viewModel.size = UIScreen.main.bounds.size
        
        self.rootController.viewModel = viewModel
        
        self.rootController.bind()
        self.rootController.render()

        self.rootController.readDrops()
        self.rootController.readAppointments()
//        self.rootController.readContacts()
        
        return true
    }
}


