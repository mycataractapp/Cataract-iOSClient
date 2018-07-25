//
//  ColorModel.swift
//  Cataract
//
//  Created by Rose Choi on 7/2/18.
//  Copyright © 2018 Rose Choi. All rights reserved.
//

import Foundation
import SwiftyJSON

class ColorModel : DynamicModel
{
    private var _name : String!
    private var _redValue : Double!
    private var _greenValue : Double!
    private var _blueValue : Double!
    private var _alphaValue = 1.0
    
    override var data: JSON
    {
        get
        {
            let data = JSON(["name": self._name as Any,
                             "redValue": self._redValue as Any,
                             "greenValue": self._greenValue as Any,
                             "blueValue": self._blueValue as Any,
                             "alphaValue": self._alphaValue as Any])
            
            return data
        }
        
        set(newValue)
        {
            if (newValue != JSON.null)
            {
                self._name = newValue["name"].string!
                self._redValue = newValue["redValue"].double!
                self._greenValue = newValue["greenValue"].double!
                self._blueValue = newValue["blueValue"].double!
            }
        }
    }
    
    var name : String
    {
        get
        {
            let name = self._name!
            
            return name
        }
        
        set(newValue)
        {
            self._name = newValue
        }
    }
    
    var filledCircleName : String
    {
        get
        {
            let filledName = "FilledCircle" + self.name
            
            return filledName
        }
    }
    
    var emptyCircleName : String
    {
        get
        {
            let emptyCircleName = "EmptyCircle" + self.name
            
            return emptyCircleName
        }
    }
    
    var redValue : Double
    {
        get
        {
            let redValue = self._redValue!
            
            return redValue
        }
        set(newValue)
        {
            self._redValue = newValue
        }
    }
    
    var greenValue : Double
    {
        get
        {
            let greenValue = self._greenValue!
            
            return greenValue
        }
        set(newValue)
        {
            self._greenValue = newValue
        }
    }
    
    var blueValue : Double
    {
        get
        {
            let blueValue = self._blueValue!
            
            return blueValue
        }
        set(newValue)
        {
            self._blueValue = newValue
        }
    }
    
    var alphaValue : Double
    {
        get
        {
            let alphaValue = self._alphaValue
            
            return alphaValue
        }
        set(newValue)
        {
            self._alphaValue = newValue
        }
        
    }
}
