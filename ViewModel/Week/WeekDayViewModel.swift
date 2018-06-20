//
//  WeekDayViewModel.swift
//  Cataract
//
//  Created by Rose Choi on 6/19/18.
//  Copyright © 2018 Rose Choi. All rights reserved.
//

import UIKit

class WeekDayViewModel : DynamicViewModel
{
    @objc dynamic var weekDay : String
    
    init(weekDay: String, isChecked: Bool)
    {
        self.weekDay = weekDay
        
        if (isChecked)
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
