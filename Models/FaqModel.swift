//
//  FaqModel.swift
//  Cataract
//
//  Created by Rose Choi on 7/5/18.
//  Copyright © 2018 Rose Choi. All rights reserved.
//

import Foundation
import SwiftyJSON

class FaqModel : DynamicModel
{
    private var _heading : String!
    private var _info : String!
    
    override var data: JSON
    {
        get
        {
            let data = JSON(["heading" : self._heading as Any,
                             "info" : self._info as Any])
            return data
        }
        set(newValue)
        {
            if (newValue != JSON.null)
            {
                self._heading = newValue["heading"].string
                self._info = newValue["info"].string
            }
        }
    }
    
    var heading : String
    {
        get
        {
            let heading = self._heading!
            
            return heading
        }
        set(newValue)
        {
            self._heading = newValue
        }
    }
    
    var info : String
    {
        get
        {
            let info = self._info!
            
            return info
        }
        set(newValue)
        {
            self._info = newValue
        }
    }
}
