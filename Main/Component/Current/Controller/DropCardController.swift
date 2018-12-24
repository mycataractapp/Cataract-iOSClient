//
//  DropCardController.swift
//  Cataract
//
//  Created by Roseanne Choi on 11/5/18.
//  Copyright © 2018 Rose Choi. All rights reserved.
//

import UIKit
import CareKit

class DropCardController : DynamicController, OCKCarePlanStoreDelegate, OCKCareCardViewControllerDelegate
{
    private var _navigationController: UINavigationController!
    private var _careCardViewController : OCKCareCardViewController!
    private var _carePlanStore : CarePlanStore!
    
    override var navigationController: UINavigationController
    {
        get
        {
            if (self._navigationController == nil)
            {
                self._navigationController = UINavigationController()
                self._navigationController.pushViewController(self.careCardViewController, animated: false)
            }

            let navigationController = self._navigationController!

            return navigationController
        }
    }

    var careCardViewController : OCKCareCardViewController
    {
        get
        {
            if (self._careCardViewController == nil)
            {
                self._careCardViewController = OCKCareCardViewController(carePlanStore: self.carePlanStore.ockCarePlanStore)
                self._careCardViewController.glyphType = .blood
                self._careCardViewController.glyphTintColor = UIColor(red: 51/255, green: 127/255, blue: 159/255, alpha: 1)
                self._careCardViewController.delegate = self
            }

            let careCardViewController = self._careCardViewController!
            
            return careCardViewController
        }
    }
    
    var carePlanStore : CarePlanStore
    {
        get
        {
            if (self._carePlanStore == nil)
            {
                self._carePlanStore = CarePlanStore()
            }
            
            let carePlanStore = self._carePlanStore!
                        
            return carePlanStore
        }
    }
    
    override func viewDidLoad()
    {
        self.view.addSubview(self.navigationController.view)
    }
    
    func careCardViewController(_ viewController: OCKCareCardViewController, didSelectRowWithInterventionActivity interventionActivity: OCKCarePlanActivity)
    {
        
    }
}
