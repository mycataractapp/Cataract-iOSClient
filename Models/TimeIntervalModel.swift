//
//  TimeIntervalModel.swift
//  MyCataractApp
//
//  Created by Roseanne Choi on 8/22/18.
//  Copyright © 2018 Rose Choi. All rights reserved.
//

import UIKit
import SwiftyJSON

class TimeIntervalModel : DynamicModel
{
    private var _identifier : String!
    private var _interval : Double!
    
    override var data : JSON
    {
        get
        {
            let data = JSON(["identifier": self._identifier as Any,
                             "interval": self._interval as Any])
            
            return data
        }
        
        set(newValue)
        {
            if (newValue != JSON.null)
            {
                self._identifier = newValue["identifier"].string
                self._interval = newValue["interval"].double
            }
        }
    }
    
    var identifier : String
    {
        get
        {
            let identifier = self._identifier!
            
            return identifier
        }
        
        set(newValue)
        {
            self._identifier = newValue
        }
    }
    
    var interval : Double
    {
        get
        {
            let interval = self._interval!
            
            return interval
        }
        
        set(newValue)
        {
            self._interval = newValue
        }
    }
}
