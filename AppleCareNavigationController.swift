//
//  AppleCareNavigationController.swift
//  Cataract
//
//  Created by Rose Choi on 7/12/18.
//  Copyright © 2018 Rose Choi. All rights reserved.
//

//import UIKit
//import SwiftyJSON
//import SwiftMoment
//import CareKit
//
//class AppleCareNavigationController : DynamicController<AppleCareNavigationViewModel>, OCKCarePlanStoreDelegate
//{
//    private var _navigationController : UINavigationController!
//    private var _careCardViewController : OCKCareCardViewController!
//    private var _carePlanStore : CarePlanStore!
//    
//    override var navigationController: UINavigationController
//    {
//        get
//        {
//            if (self._navigationController == nil)
//            {
//                self._navigationController = UINavigationController()
//            }
//            
//            let navigationController = self._navigationController!
//            
//            return navigationController
//        }
//    }
//
//    var careCardViewController : OCKCareCardViewController
//    {
//        get
//        {
//            if (self._careCardViewController == nil)
//            {
//                self._careCardViewController = OCKCareCardViewController(carePlanStore: self.store)
//            }
//            
//            let careCardViewController = self._careCardViewController!
//            
//            return careCardViewController
//        }
//    }
//    
//    var carePlanStore : CarePlanStore
//    {
//        get
//        {
//            if (self._carePlanStore == nil)
//            {
//                self._carePlanStore = CarePlanStore()
//            }
//            
//            let carePlanStore = self._carePlanStore!
//            
//            return carePlanStore
//        }
//    }
//    
//    override func viewDidLoad()
//    {
//        self.view.addSubview(self.navigationController.view)
//    }
//    
//    override func render(size: CGSize)
//    {
//        super.render(size: size)
//        
//        self.navigationController.view.frame.size = self.view.frame.size
//    }
//    
//    override func bind(viewModel: AppleCareNavigationViewModel)
//    {
//        super.bind(viewModel: viewModel)
//        
//        self.carePlanStore.addObserver(self,
//                                       forKeyPath: "models",
//                                       options: NSKeyValueObservingOptions([NSKeyValueObservingOptions.new,
//                                                                            NSKeyValueObservingOptions.initial]),
//                                       context: nil)
//    }
//    
//    override func unbind()
//    {
//        super.unbind()
//    }
//    
//    override func shouldInsertKeyPath(_ keyPath: String?, ofObject object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?)
//    {
//        if (keyPath == "models")
//        {
//
//
//        }
//    }
//}
