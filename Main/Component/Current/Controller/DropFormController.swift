//
//  DropFormController.swift
//  Cataract
//
//  Created by Roseanne Choi on 9/9/18.
//  Copyright © 2018 Roseanne Choi. All rights reserved.
//

import UIKit

class DropFormController : DynamicController
{
    private var _pageViewController : UIPageViewController!
    
    var pageViewController : UIPageViewController
    {
        get
        {
            if (self._pageViewController == nil)
            {
                self._pageViewController = UIPageViewController()
            }
            
            let pageViewController = self._pageViewController!
            
            return pageViewController
        }
    }
}

