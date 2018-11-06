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
import SwiftyJSON

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

//    var rootController = ContactFormController()
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool
    {
        let fileName = "Test"
        let documentDirURL = try! FileManager.default.url(for: .documentDirectory,
                                                          in: .userDomainMask,
                                                          appropriateFor: nil,
                                                          create: true)
        let fileURL = documentDirURL.appendingPathComponent(fileName).appendingPathExtension("txt")
        
        print("File Path: \(fileURL.path)")
        
        let writeString = "Write this text to the file system."
        do
        {
            //write to file system
            try writeString.write(to: fileURL,
                              atomically: true,
                              encoding: String.Encoding.utf8)
        }catch let error as NSError
        {
            print("failed to write")
            print(error)
        }
        
//        self.window!.rootViewController = rootController
//
//        self.window!.backgroundColor = UIColor.white
//        self.window!.makeKeyAndVisible()
//
//        self.rootController.bind()
//
//        let footerPanelViewModel = FooterPanelViewModel(id: "")
//
//        let viewModel = ContactFormViewModel(footerPanelViewModel: footerPanelViewModel)
        
//        self.rootController.loadAllStores()
        
//        let footerPanelViewModel = FooterPanelViewModel(id: "")
//        let firstPageViewModel = DropFormViewModel.FirstPageViewModel()
//        let secondPageViewModel = DropFormViewModel.SecondPageViewModel()
//        let thirdPageViewModel = DropFormViewModel.ThirdPageViewModel()
//        let overlayCardViewModel = UserViewModel.OverLayCardViewModel(id: "")
//        let firstPageViewModel = AppointmentFormViewModel.FirstPageViewModel()
//        let secondPageViewModel = AppointmentFormViewModel.SecondPageViewModel()
//        let appointmentInputViewModel = UserViewModel.AppointmentInputViewModel(id: "")
//
//        let viewModel = AppointmentFormViewModel(footerPanelViewModel: footerPanelViewModel,
//                                                 firstPageViewModel: firstPageViewModel,
//                                                 secondPageViewModel: secondPageViewModel,
//                                                 appointmentInputViewModel: appointmentInputViewModel)
//        let viewModel = DropFormViewModel(firstPageViewModel: firstPageViewModel,
//                                          secondPageViewModel: secondPageViewModel,
//                                          thirdPageViewModel: thirdPageViewModel,
//                                          footerPanelViewModel: footerPanelViewModel,
//                                          overLayCardViewModel: overlayCardViewModel)

//        viewModel.size = UIScreen.main.bounds.size
//
//        self.rootController.viewModel = viewModel
        
        return true
    }
}
