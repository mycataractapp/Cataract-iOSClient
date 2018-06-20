//
//  DropColorModel.swift
//  Cataract
//
//  Created by Rose Choi on 6/18/18.
//  Copyright © 2018 Rose Choi. All rights reserved.
//

import UIKit
import SwiftyJSON

class DropColorModel : DynamicModel
{
    private var _colorPathByState : [String : String]!
    private var _color : String!
    
    override var data: JSON
    {
        get
        {
            let data = JSON(["colorPathByState": self._colorPathByState as Any,
                             "color": self._color as Any])
            
            return data
        }
        
        set(newValue)
        {
            if (newValue != JSON.null)
            {
                self._colorPathByState = newValue["colorPathByState"].dictionaryObject as! [String : String]
                self._color = newValue["color"].string
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
    
    var color : String
    {
        get
        {
            let color = self._color!
            
            return color
        }
        
        set(newValue)
        {
            self._color = newValue
        }
    }
}
