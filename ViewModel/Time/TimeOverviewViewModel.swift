//
//  TimeOverviewViewModel.swift
//  Cataract
//
//  Created by Rose Choi on 6/21/18.
//  Copyright © 2018 Rose Choi. All rights reserved.
//

import UIKit

class TimeOverviewViewModel : DynamicViewModel
{
    private var _timeViewModels : [TimeViewModel]!
    
    var timeViewModels : [TimeViewModel]
    {
        get
        {
            if (self._timeViewModels == nil)
            {
                self._timeViewModels = [TimeViewModel]()
            }
            
            let timeViewModels = self._timeViewModels!
            
            return timeViewModels
        }
        
        set(newValue)
        {
            self._timeViewModels = newValue
        }
    }
}
