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
    
    override var data: JSON
    {
        get
        {
            let data = JSON(["name": self._name as Any])
            
            return data
        }
        
        set(newValue)
        {
            if (newValue != JSON.null)
            {
                self._name = newValue["name"].string
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
}
