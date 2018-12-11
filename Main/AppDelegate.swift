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
class AppDelegate: UIResponder, UIApplicationDelegate, OCKCarePlanStoreDelegate, OCKCareCardViewControllerDelegate
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
            var rootControllerOrigin : CGPoint = CGPoint.zero
            rootControllerOrigin.x = self.window!.safeAreaInsets.left
            rootControllerOrigin.y = self.window!.safeAreaInsets.top
            
            if (rootControllerOrigin.y == 0)
            {
                rootControllerOrigin.y = UIApplication.shared.statusBarFrame.height
            }
            
            return rootControllerOrigin
        }
    }

    var rootController = MainDashboardController()
    
    class EmployeeViewModel : DynamicViewModel, Encodable, Decodable
    {
        var size = CGSize.zero
        @objc var name : String
        
        init(name: String)
        {
            self.name = name
            
            super.init()
        }
        
        required init(from decoder: Decoder) throws
        {
            let values = try decoder.container(keyedBy: CodingKeys.self)
            name = try values.decode(String.self, forKey: .name)

            super.init()
        }

        func encode(to encoder: Encoder) throws
        {
            var container = encoder.container(keyedBy: CodingKeys.self)
            try container.encode(name, forKey: .name)
        }

        enum CodingKeys : String, CodingKey
        {
            case name
        }
    }
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool
    {
//        let viewModel = EmployeeViewModel(name: "Rose")
        
        // Create url, write something
        
//        let fileManager = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0].appendingPathComponent("test").path
//        let url = URL(fileURLWithPath: fileManager)
//
//        let jsonEncoder = JSONEncoder()
//        let jsonData = try? jsonEncoder.encode(viewModel)
//
//        try? jsonData?.write(to: url)
//
        // Then comment out the above code, and write code to retrieve
    
//        let fileManager = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0].appendingPathComponent("test").path
//        let url = URL(fileURLWithPath: fileManager)
//
//        let data = try! Data(contentsOf: url)
//        let jsonDecoder = try? JSONDecoder().decode(EmployeeViewModel.self, from: data)
//        print(jsonDecoder, "AAAAAAA")
        
        self.window!.rootViewController = rootController

        self.window!.backgroundColor = UIColor.white
        self.window!.makeKeyAndVisible()

        self.rootController.loadAllStores()
        
//        let footerPanelViewModel = FooterPanelViewModel(id: "")
//        let firstPageViewModel = AppointmentFormViewModel.FirstPageViewModel()
//        let secondPageViewModel = AppointmentFormViewModel.SecondPageViewModel()
//        let appointmentInputViewModel = UserViewModel.AppointmentInputViewModel(id: "")

//        let dropAddButtonViewModel = UserViewModel.AddButtonViewModel(id: "")
//        let appointmentAddButtonViewModel = UserViewModel.AddButtonViewModel(id: "")
//        let appointmentFormViewModel = AppointmentFormViewModel(footerPanelViewModel: footerPanelViewModel,
//                                                                firstPageViewModel: firstPageViewModel,
//                                                                secondPageViewModel: secondPageViewModel,
//                                                                appointmentInputViewModel: appointmentInputViewModel)
        
        let viewModel = MainDashboardViewModel()
        viewModel.size = UIScreen.main.bounds.size

        self.rootController.viewModel = viewModel

        self.rootController.bind()
        self.rootController.render()
        
        self.rootController.read()
        
        return true
    }
}

