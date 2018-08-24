//
//  AppointmentModel.swift
//  Cataract
//
//  Created by Roseanne Choi on 6/11/18.
//  Copyright © 2018 Roseanne Choi. All rights reserved.
//

import UIKit
import SwiftyJSON

class AppointmentModel : DynamicModel
{
    private var _id : String!
    private var _title : String!
    private var _date : String!
    private var _time : String!
//    private var _period : String!
    
    override var data: JSON
    {
        get
        {
            let data = JSON(["id": self._id as Any,
                             "title": self._title as Any,
                             "date": self._date as Any,
                             "time": self._time as Any])
            
            return data
        }
        
        set(newValue)
        {
            if (newValue != JSON.null)
            {
                self._id = newValue["id"].string
                self._title = newValue["title"].string
                self._date = newValue["date"].string
                self._time = newValue["time"].string
            }
        }
    }
    
    var id : String
    {
        get
        {
            let id = self._id!
            
            return id
        }
        
        set(newValue)
        {
            self._id  = newValue
        }
    }

    var title : String
    {
        get
        {
            let title = self._title!
            
            return title
        }
        
        set(newValue)
        {
            self._title = newValue
        }
    }
    
    var date : String
    {
        get
        {
            let date = self._date!
            
            return date
        }
        
        set(newValue)
        {
            self._date = newValue
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
    
//    var period : String
//    {
//        get
//        {
//            let period = self._period!
//
//            return period
//        }
//
//        set(newValue)
//        {
//            self._period = newValue
//        }
//    }
}
