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
    var colorCode : [String : Double]
    var colorPathByState : [String : String]
    
    init(title: String, colorPathByState: [String : String], colorCode: [String : Double], isSelected: Bool)
    {
        self.title = title
        self.colorPathByState = colorPathByState
        self.colorCode = colorCode
        
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
