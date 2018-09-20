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

class DropOverviewController : DynamicController<DropOverviewViewModel>, OCKCarePlanStoreDelegate, OCKCareCardViewControllerDelegate
{
    private var _navigationController : UINavigationController!
    private var _careCardViewController : OCKCareCardViewController!
    private var _dropStore : DropStore!
    private var _dropLabel : UILabel!

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
    
    var dropLabel : UILabel
    {
        get
        {
            if (self._dropLabel == nil)
            {
                self._dropLabel = UILabel()
                self._dropLabel.text = "Press gray arrow to discontinue drop."
                self._dropLabel.textAlignment = NSTextAlignment.center
                self._dropLabel.textColor = UIColor(red: 51/255, green: 127/255, blue: 159/255, alpha: 1)
                self._dropLabel.backgroundColor = UIColor(red: 244/255, green: 244/255, blue: 245/255, alpha: 1)
            }
            
            let dropLabel = self._dropLabel!
            
            return dropLabel
        }
    }

    override func viewDidLoad()
    {
        self.view.addSubview(self.navigationController.view)
        self.view.addSubview(self.dropLabel)
    }

    override func render(size: CGSize)
    {
        super.render(size: size)

        self.navigationController.view.frame.size = self.view.frame.size
        
        self.dropLabel.frame.size.width = self.view.frame.size.width
        self.dropLabel.frame.size.height = self.canvas.draw(tiles: 1)
        
        self.dropLabel.frame.origin.y = self.canvas.draw(tiles: 0.30)
    }

    override func bind(viewModel: DropOverviewViewModel)
    {
        super.bind(viewModel: viewModel)
        
        
//        self.dropStore.addObserver(self,
//                                   forKeyPath: "models",
//                                   options: NSKeyValueObservingOptions([NSKeyValueObservingOptions.new,
//                                                                        NSKeyValueObservingOptions.initial]),
//                                    context: nil)
    }

    override func unbind()
    {
        super.unbind()
    }
    
    func careCardViewController(_ viewController: OCKCareCardViewController, didSelectRowWithInterventionActivity interventionActivity: OCKCarePlanActivity)
    {
        if (interventionActivity.identifier == interventionActivity.title)
        {
            self.dropStore.removeDrop(activity: interventionActivity)
        }
    }
}
