//
//  TestModel.swift
//  MyCataractApp
//
//  Created by Roseanne Choi on 8/30/18.
//  Copyright © 2018 Rose Choi. All rights reserved.
//

import Foundation
import SwiftyJSON

class TestModel : DynamicModel
{
    private var _name : String!

    override var data: JSON
    {
        get
        {
            let data = JSON(["name": self._name as Any])

            return data
        }

        set (newValue)
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
}
