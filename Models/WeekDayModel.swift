//
//  WeekDayModel.swift
//  Cataract
//
//  Created by Roseanne Choi on 6/19/18.
//  Copyright © 2018 Roseanne Choi. All rights reserved.
//

import UIKit
import SwiftyJSON

class WeekDayModel : DynamicModel
{
    private var _weekDay : String!
    private var _isChecked : Bool!
    
    override var data: JSON
    {
        get
        {
            let data = JSON(["weekDay": self._weekDay as Any,
                             "isChecked": self._isChecked as Bool])
            
            return data
        }
        
        set(newValue)
        {
            if (newValue != JSON.null)
            {
                self._weekDay = newValue["weekDay"].string
                self._isChecked = newValue["isChecked"].bool
            }
        }
    }
    
    var weekDay : String
    {
        get
        {
            let weekDay = self._weekDay!
            
            return weekDay
        }
        
        set(newValue)
        {
            self._weekDay = newValue
        }
    }
    
    var isChecked : Bool
    {
        get
        {
            let isChecked = self._isChecked!
            
            return isChecked
        }
        
        set(newValue)
        {
            self._isChecked = newValue
        }
    }
}
