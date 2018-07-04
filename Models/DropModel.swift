//
//  DropModel.swift
//  Cataract
//
//  Created by Rose Choi on 6/9/18.
//  Copyright © 2018 Rose Choi. All rights reserved.
//

import UIKit
import SwiftyJSON

class DropModel : DynamicModel
{
    private var _colorModel : ColorModel!
    private var _drop : String!
    private var _time : String!
    private var _period : String!
    
    override var data: JSON
    {
        get
        {
            let data = JSON(["colorModel": self._colorModel as Any,
                             "drop": self._drop as Any,
                             "time": self._time as Any,
                             "period": self._period as Any])
            
            return data
        }
        
        set(newValue)
        {
            if (newValue != JSON.null)
            {
                self._colorModel = ColorModel()
                self._colorModel.data = newValue["colorModel"]
                self._drop = newValue["drop"].string
                self._time = newValue["time"].string
                self._period = newValue["period"].string
            }
        }
    }
    
    var colorModel : ColorModel
    {
        get
        {
            let colorModel = self._colorModel!
            
            return colorModel
        }
        
        set(newValue)
        {
            self._colorModel = newValue
        }
    }
    
    var drop : String
    {
        get
        {
            let drop = self._drop!
            
            return drop
        }
        
        set(newValue)
        {
            self._drop = newValue
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
}
