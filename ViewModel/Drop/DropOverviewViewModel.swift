//
//  DropOverviewViewModel.swift
//  Cataract
//
//  Created by Roseanne Choi on 6/6/18.
//  Copyright © 2018 Roseanne Choi. All rights reserved.
//

import UIKit

class DropOverviewViewModel : DynamicViewModel
{
    @objc func select()
    {
        self.transit(transition: "Select", to: self.state)
    }
    
    @objc func enterMenu()
    {
        self.transit(transition: "EnterMenu", to: self.state)
    }
}
