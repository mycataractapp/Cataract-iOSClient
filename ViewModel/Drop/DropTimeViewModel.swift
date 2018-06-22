//
//  DropViewModel.swift
//  Cataract
//
//  Created by Rose Choi on 6/6/18.
//  Copyright © 2018 Rose Choi. All rights reserved.
//

import UIKit

class DropViewModel : DynamicViewModel
{
    var colorPathByState : [String : String]
    @objc var drop : String
    @objc var time : String
    
    init(colorPathByState: [String : String], drop: String, time: String, isSelected: Bool)
    {
        self.colorPathByState = colorPathByState
        self.drop = drop
        self.time = time
        
        if (isSelected)
        {
            super.init(state: "On")
        }
        else
        {
            super.init(state: "Off")
        }
    }

    @objc func toggle()
    {
        if (self.state == "On")
        {
            self.transit(transition: "Toggle", to: "Off")
        }
        else
        {
            self.transit(transition: "Toggle", to: "On")
        }
    }
}
