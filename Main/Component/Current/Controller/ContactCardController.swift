//
//  ContactCardController.swift
//  Cataract
//
//  Created by Roseanne Choi on 11/17/18.
//  Copyright © 2018 Rose Choi. All rights reserved.
//

import UIKit
import CareKit

class ContactCardController : DynamicController
{
    private var _navigationController : UINavigationController!
    private var _connectViewController : OCKConnectViewController!
    
    override var navigationController : UINavigationController
    {
        get
        {
            if (self._navigationController == nil)
            {
                self._navigationController = UINavigationController()
                self._navigationController.pushViewController(self.connectViewController, animated: false)
            }
            
            let navigationController = self._navigationController!
            
            return navigationController
        }
    }
    
    var connectViewController : OCKConnectViewController
    {
        get
        {
            if (self._connectViewController == nil)
            {
                self._connectViewController = OCKConnectViewController(contacts: nil)
            }
            
            let connectViewController = self._connectViewController!
            
            return connectViewController
        }
    }

    override func viewDidLoad()
    {
        self.view.addSubview(self.navigationController.view)
    }
}
