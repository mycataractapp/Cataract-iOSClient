//
//  AppointmentInputViewModel.swift
//  Cataract
//
//  Created by Roseanne Choi on 7/10/18.
//  Copyright © 2018 Roseanne Choi. All rights reserved.
//

import UIKit

class AppointmentInputViewModel : DynamicViewModel
{
    @objc dynamic var title : String
    
    init(title: String, isSelected: Bool)
    {
        self.title  = title
        
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
