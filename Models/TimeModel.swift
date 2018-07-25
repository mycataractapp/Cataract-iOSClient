//
//  TimeModel.swift
//  Cataract
//
//  Created by Rose Choi on 6/29/18.
//  Copyright © 2018 Rose Choi. All rights reserved.
//

import UIKit
import SwiftyJSON

class TimeModel : DynamicModel
{
    private var _time : String!
    private var _period : String!
    private var _timeInterval : Double!
    
    override var data: JSON
    {
        get
        {
            let data = JSON(["time": self._time as Any,
                             "period": self._period as Any,
                             "timeInterval": self._timeInterval as Any])
            
            return data
        }
        set(newValue)
        {
            if (newValue != JSON.null)
            {
                self._time = newValue["time"].string
                self._period = newValue["period"].string
                self._timeInterval = newValue["timeInterval"].double
            }
        }
    }
    
    var time : String
    {
        get
        {
            let time = self._time!
            
            return time
        }
        set(newValue)
        {
            self._time = newValue
        }
    }
    
    var period : String
    {
        get
        {
            let period = self._period!
            
            return period
        }
        set(newValue)
        {
            self._period = newValue
        }
    }
    
    var timeInterval : Double
    {
        get
        {
            let timeInterval = self._timeInterval!
            
            return timeInterval
        }
        set(newValue)
        {
            self._timeInterval = newValue
        }
    }
}
