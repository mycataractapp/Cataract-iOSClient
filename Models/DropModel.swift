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
    private var _button : String!
    private var _drop : String!
    private var _time : String!
    
    override var data: JSON
    {
        get
        {
            let data = JSON(["button": self._button as Any,
                             "drop": self._drop as Any,
                             "time": self._time as Any])
            
            return data
        }
        
        set(newValue)
        {
            if (newValue != JSON.null)
            {
                self._button = newValue["button"].string
                self._drop = newValue["drop"].string
                self._time = newValue["time"].string
            }
        }
    }
    
    var button : String
    {
        get
        {
            let button = self._button!
            
            return button
        }
        
        set(newValue)
        {
            self._button = newValue
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
