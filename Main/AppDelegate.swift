//
//  AppDelegate.swift
//  Cataract
//
//  Created by Roseanne Choi on 6/4/18.
//  Copyright © 2018 Roseanne Choi. All rights reserved.
//

import UIKit
import SwiftMoment
import CareKit
import UserNotifications

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate
{
    var window: UIWindow?
    
    var rootControllerSize : CGSize
    {
        get
        {
            var rootControllerSize = UIScreen.main.bounds.size
            
            rootControllerSize.width -= (self.window!.safeAreaInsets.left + self.window!.safeAreaInsets.right)
            rootControllerSize.height -= (self.window!.safeAreaInsets.top + self.window!.safeAreaInsets.bottom)
            
            if (rootControllerSize.height == UIScreen.main.bounds.size.height)
            {
                rootControllerSize.height -= UIApplication.shared.statusBarFrame.height
            }
                        
            return rootControllerSize
        }
    }
    
    var rootControllerOrigin : CGPoint
    {
        get
        {
            var rootControllerOrigin = CGPoint.zero
            rootControllerOrigin.x = self.window!.safeAreaInsets.left
            rootControllerOrigin.y = self.window!.safeAreaInsets.top
            
            if (rootControllerOrigin.y == 0)
            {
                rootControllerOrigin.y = UIApplication.shared.statusBarFrame.height
            }
            
            return rootControllerOrigin
        }
    }
    
    var rootController = LabelController()
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool
    {
        self.window!.rootViewController = self.rootController

        self.window!.backgroundColor = UIColor.white
        self.window!.makeKeyAndVisible()
        
        self.rootController.bind()
        self.rootController.viewModel = LabelViewModel(text: "HELLO", color: ColorCardViewModel(redValue: 51, greenValue: 127, blueValue: 159, alphaValue: 1, isSelected: true, id: "A", size: CGSize(width: 0, height: 0)), size: CGSize(width: 100, height: 50))
        
        return true
    }
}



