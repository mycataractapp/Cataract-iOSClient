//
//  NavigationViewModel.swift
//  Cataract
//
//  Created by Roseanne Choi on 6/9/18.
//  Copyright © 2018 Roseanne Choi. All rights reserved.
//

import UIKit

class NavigationViewModel : DynamicViewModel
{
    var imagePathByState : [String : String]
    
    init(imagePathByState: [String : String], isSelected: Bool)
    {
        self.imagePathByState = imagePathByState
        
        if (isSelected)
        {
            super.init(state: "On")
        }
        else
        {
            super.init(state: "Off")
        }
    }
    
    @objc func select()
    {
        self.transit(transition: "Select", to: "On")
    }
    
    @objc func deselect()
    {
        self.transit(transition: "Deselect", to: "Off")
    }
}
