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
    private var _dropStore : DynamicStore.Collection<DropModel>!

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
                self._careCardViewController = OCKCareCardViewController(carePlanStore: )
                self._careCardViewController.glyphType = .blood
                self._careCardViewController.glyphTintColor = UIColor(red: 51/255, green: 127/255, blue: 159/255, alpha: 1)
                self._careCardViewController.delegate = self
            }

            let careCardViewController = self._careCardViewController!

            return careCardViewController
        }
    }
    
    var dropStore : DynamicStore.Collection<DropModel>
    {
        get
        {
            if (self._dropStore == nil)
            {
                self._dropStore = DynamicStore.Collection<DropModel>()
            }
            
            let dropStore = self._dropStore!
            
            return dropStore
        }
    }
    
    @objc var dropStoreRepresentable : DynamicStore
    {
        get
        {
            let dropStoreRepresentable = self.dropStore
            
            return dropStoreRepresentable
        }
    }
    
    
}
