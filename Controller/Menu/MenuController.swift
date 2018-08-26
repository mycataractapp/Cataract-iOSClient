//
//  MenuController.swift
//  MyCataractApp
//
//  Created by Roseanne Choi on 8/26/18.
//  Copyright © 2018 Rose Choi. All rights reserved.
//

import UIKit

class MenuController : DynamicController<MenuViewModel>
{
    private var _label : UILabel!
    private var _view : UIView!
    
    var label : UILabel
    {
        get
        {
            if (self._label == nil)
            {
                self._label = UILabel()
            }
            
            let label = self._label!
            
            return label
        }
    }
}
