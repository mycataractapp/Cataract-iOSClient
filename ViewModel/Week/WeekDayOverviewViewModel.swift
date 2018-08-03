//
//  WeekDayOverviewViewModel.swift
//  Cataract
//
//  Created by Roseanne Choi on 6/19/18.
//  Copyright © 2018 Roseanne Choi. All rights reserved.
//

import UIKit

class WeekDayOverviewViewModel : DynamicViewModel
{
    private var _weekDayViewModels : [WeekDayViewModel]!
    
    var weekDayViewModels : [WeekDayViewModel]
    {
        get
        {
            if (self._weekDayViewModels == nil)
            {
                self._weekDayViewModels = [WeekDayViewModel]()
            }
            
            let weekDayViewModels = self._weekDayViewModels!
            
            return weekDayViewModels
        }
        
        set(newValue)
        {
            self._weekDayViewModels = newValue
        }
    }
}
