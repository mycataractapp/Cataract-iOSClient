//
//  IconViewModel.swift
//  Cataract
//
//  Created by Rose Choi on 6/15/18.
//  Copyright © 2018 Rose Choi. All rights reserved.
//

import UIKit

class IconViewModel : DynamicViewModel
{
    var title : String
    var colorPathByState : [String : String]
    
    init(title: String, colorPathByState: [String : String], isSelected: Bool)
    {
        self.title = title
        self.colorPathByState = colorPathByState
        
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
