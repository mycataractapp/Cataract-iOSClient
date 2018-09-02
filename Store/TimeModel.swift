//
//  TimeModel.swift
//  MyCataractApp
//
//  Created by Roseanne Choi on 8/22/18.
//  Copyright © 2018 Rose Choi. All rights reserved.
//

import UIKit
import SwiftyJSON

class TimeModel : DynamicModel
{
    private var _identifier : String!
    private var _timeInterval : Double!
    
    override var data : JSON
    {
        get
        {
            let data = JSON(["identifier": self._identifier as Any,
                             "timeInterval": self._timeInterval as Any])
            
            return data
        }
        
        set(newValue)
        {
            if (newValue != JSON.null)
            {
                self._identifier = newValue["identifier"].string
                self._timeInterval = newValue["timeInterval"].double
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
