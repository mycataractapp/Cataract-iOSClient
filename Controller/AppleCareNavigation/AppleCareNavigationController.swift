//
//  AppleCareNavigationController.swift
//  Cataract
//
//  Created by Rose Choi on 7/12/18.
//  Copyright © 2018 Rose Choi. All rights reserved.
//

import UIKit
import SwiftyJSON
import SwiftMoment
import CareKit

class AppleCareNavigationController : DynamicController<AppleCareNavigationViewModel>, OCKCarePlanStoreDelegate
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
                self._navigationController.pushViewController(self.careCardViewController, animated: true)
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
    
    override func render(size: CGSize)
    {
        super.render(size: size)
        
        self.navigationController.view.frame.size = self.view.frame.size
    }
    
    override func bind(viewModel: AppleCareNavigationViewModel)
    {
        super.bind(viewModel: viewModel)
        
        self.dropStore.addObserver(self,
                                       forKeyPath: "models",
                                       options: NSKeyValueObservingOptions([NSKeyValueObservingOptions.new,
                                                                            NSKeyValueObservingOptions.initial]),
                                       context: nil)
    }
    
    override func unbind()
    {
        super.unbind()
    }
    
    override func shouldInsertKeyPath(_ keyPath: String?, ofObject object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?)
    {
        if (keyPath == "models")
        {


        }
    }
    
    func update()
    {
        
//            print("AA", self.dropStore.models.count)
            self._careCardViewController = nil
            self.navigationController.pushViewController(self.careCardViewController, animated: true)
//                self.careCardViewController.tableView.reloadData()
        
    }
}
