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
    private var _colorPathByState : [String : String]!
    private var _drop : String!
    private var _time : String!
    
    override var data: JSON
    {
        get
        {
            let data = JSON(["colorPathByState": self._colorPathByState as Any,
                             "drop": self._drop as Any,
                             "time": self._time as Any])
            
            return data
        }
        
        set(newValue)
        {
            if (newValue != JSON.null)
            {
                self._colorPathByState = newValue["colorPathByState"].dictionaryObject as! [String : String]
                self._drop = newValue["drop"].string
                self._time = newValue["time"].string
            }
        }
    }
    
    var colorPathByState : [String : String]
    {
        get
        {
            let colorPathByState = self._colorPathByState!
            
            return colorPathByState
        }
        
        set(newValue)
        {
            self._colorPathByState = newValue
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
}
