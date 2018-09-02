//
//  MenuViewModel.swift
//  MyCataractApp
//
//  Created by Roseanne Choi on 8/26/18.
//  Copyright © 2018 Rose Choi. All rights reserved.
//

import UIKit

class MenuViewModel : DynamicViewModel
{
    @objc dynamic var title : String
    
    init(title: String)
    {
        self.title = title
        
        super.init()
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
