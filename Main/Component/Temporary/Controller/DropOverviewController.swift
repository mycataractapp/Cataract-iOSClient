//
//  DropOverviewController.swift
//  Cataract
//
//  Created by Roseanne Choi on 6/6/18.
//  Copyright © 2018 Roseanne Choi. All rights reserved.
//

import UIKit
import SwiftyJSON
import SwiftMoment
import CareKit

class DropOverviewController : DynamicController, OCKCarePlanStoreDelegate, OCKCareCardViewControllerDelegate
{
    private var _navigationController : UINavigationController!
    private var _careCardViewController : OCKCareCardViewController!
    private var _dropStore : DropStore!

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
                self._careCardViewController = OCKCareCardViewController(carePlanStore: self.dropStore.store)
                self._careCardViewController.glyphType = .blood
                self._careCardViewController.glyphTintColor = UIColor(red: 51/255, green: 127/255, blue: 159/255, alpha: 1)
                self._careCardViewController.delegate = self
            }

            let careCardViewController = self._careCardViewController!

            return careCardViewController
        }
    }

    var dropStore : DropStore
    {
        get
        {
            if (self._dropStore == nil)
            {
                self._dropStore = DropStore()

            }

            let dropStore = self._dropStore!

            return dropStore
        }

        set(newValue)
        {
            self._dropStore = newValue
        }
    }

    override func viewDidLoad()
    {
        self.view.addSubview(self.navigationController.view)
    }

    override func render(canvas: DynamicCanvas) -> DynamicCanvas
    {
        super.render(canvas: canvas)
        self.view.frame.size = canvas.size

        self.navigationController.view.frame.size = self.view.frame.size
        
        return canvas
    }
    
    func careCardViewController(_ viewController: OCKCareCardViewController, didSelectRowWithInterventionActivity interventionActivity: OCKCarePlanActivity)
    {
        if (interventionActivity.identifier == interventionActivity.title)
        {
            self.dropStore.removeDrop(activity: interventionActivity)
        }
    }
}
