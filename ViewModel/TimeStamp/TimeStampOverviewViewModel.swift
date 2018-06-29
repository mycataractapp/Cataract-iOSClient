//
//  TimeStampOverviewViewModel.swift
//  Cataract
//
//  Created by Rose Choi on 6/25/18.
//  Copyright © 2018 Rose Choi. All rights reserved.
//

import UIKit

class TimeStampOverviewViewModel : DynamicViewModel
{
    private var _timeStampViewModels : [TimeStampViewModel]!
    
    var timeStampViewModels : [TimeStampViewModel]
    {
        get
        {
            if (self._timeStampViewModels == nil)
            {
                self._timeStampViewModels = [TimeStampViewModel]()
            }
            
            let timeStampViewModels = self._timeStampViewModels!
            
            return timeStampViewModels
        }
        
        set(newValue)
        {
            self._timeStampViewModels = newValue
        }
    }
}
