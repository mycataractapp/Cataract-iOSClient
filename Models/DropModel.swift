//
//  DropModel.swift
//  Cataract
//
//  Created by Rose Choi on 6/9/18.
//  Copyright © 2018 Rose Choi. All rights reserved.
//

import UIKit
import SwiftyJSON
import CareKit

class DropModel : DynamicModel
{
    private var _activity : OCKCarePlanActivity!
    private var _id : String!
    private var _colorModel : ColorModel!
    private var _title : String!
    private var _time : String!
    private var _timeIntervals : [Double]!
    private var _startDate : TimeInterval!
    private var _period : String!

    override var data: JSON
    {
        get
        {
            let data = JSON(["colorModel": self._colorModel!.data as Any,
                             "title": self._title as Any,
                             "time": self._time as Any,
                             "timeIntervals": self._timeIntervals as Array,
                             "startDate": self._startDate as Any,
                             "period": self._period as Any])

            return data
        }

        set(newValue)
        {
            if (newValue != JSON.null)
            {
                self._colorModel = self.colorModel
                self._colorModel.data = newValue["colorModel"]
                self._title = newValue["title"].string
                self._time = newValue["time"].string
                self._timeIntervals = newValue["timeIntervals"].arrayObject as! [Double]
                self._startDate = newValue["startDate"].double
                self._period = newValue["period"].string
            }
        }
    }

    var activity : OCKCarePlanActivity
    {
        get
        {
            if (self._activity == nil)
            {
                let startDate = Calendar.current.dateComponents([.year, .month, .day], from: Date(timeIntervalSince1970: self.startDate))
                let schedule = OCKCareSchedule.dailySchedule(withStartDate: startDate,
                                                             occurrencesPerDay: UInt(self.timeIntervals.count))
                print("self.title", self.title)
                self._activity = OCKCarePlanActivity(identifier: self.title,
                                                     groupIdentifier: nil,
                                                     type: .intervention,
                                                     title: self.title,
                                                     text: "",
                                                     tintColor: UIColor(red: CGFloat(self.colorModel.redValue),
                                                                        green: CGFloat(self.colorModel.greenValue),
                                                                        blue: CGFloat(self.colorModel.blueValue),
                                                                        alpha: CGFloat(self.colorModel.alphaValue)),
                                                     instructions: "",
                                                     imageURL: nil,
                                                     schedule: schedule,
                                                     resultResettable: true,
                                                     userInfo: nil)
            }

            let activity = self._activity!

            return activity
        }
    }

    var colorModel : ColorModel
    {
        get
        {
            if (self._colorModel == nil)
            {
                self._colorModel = ColorModel()
            }

            let colorModel = self._colorModel!
            
            return colorModel
        }

        set(newValue)
        {
            self._colorModel = newValue
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

    var timeIntervals : [Double]
    {
        get
        {
            let timeIntervals = self._timeIntervals!

            return timeIntervals
        }
        
        set(newValue)
        {
            self._timeIntervals = newValue
        }
    }

    var startDate : TimeInterval
    {
        get
        {
            let startDate = self._startDate!

            return startDate
        }
        
        set(newValue)
        {
            self._startDate = newValue
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
