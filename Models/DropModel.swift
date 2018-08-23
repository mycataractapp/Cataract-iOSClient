//
//  DropModel.swift
//  Cataract
//
//  Created by Roseanne Choi on 6/9/18.
//  Copyright © 2018 Roseanne Choi. All rights reserved.
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
    private var _timeIntervalModels : [TimeIntervalModel]!
    private var _startDate : TimeInterval!
    private var _endDate : TimeInterval!
    private var _period : String!

    override var data : JSON
    {
        get
        {
            var timeIntervalModels = [JSON]()
            
            for timeIntervalModel in self.timeIntervalModels
            {
                timeIntervalModels.append(timeIntervalModel.data)
            }
            
            
            let data = JSON(["colorModel": self._colorModel!.data as Any,
                             "title": self._title as Any,
                             "time": self._time as Any,
                             "timeIntervalModels": timeIntervalModels as Any,
                             "startDate": self._startDate as Any,
                             "endDate": self._endDate as Any,
                             "period": self._period as Any])

            return data
        }

        set(newValue)
        {
            if (newValue != JSON.null)
            {
                self.timeIntervalModels = [TimeIntervalModel]()
                
                for data in newValue["timeIntervalModels"].array!
                {
                    let timeIntervalModel = TimeIntervalModel()
                    timeIntervalModel.data = data
                    self.timeIntervalModels.append(timeIntervalModel)
                }
                
                self._colorModel = ColorModel()
                self._colorModel.data = newValue["colorModel"]
                self._title = newValue["title"].string
                self._time = newValue["time"].string
                self._startDate = newValue["startDate"].double
                self._endDate = newValue["endDate"].double
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
                let endDate = Calendar.current.dateComponents([.year, .month, .day], from: Date(timeIntervalSince1970: self.endDate))
                let schedule = OCKCareSchedule.dailySchedule(withStartDate: startDate,
                                                             occurrencesPerDay: UInt(self.timeIntervalModels.count),
                                                             daysToSkip: 0,
                                                             endDate: endDate)
                self._activity = OCKCarePlanActivity(identifier: self.title,
                                                     groupIdentifier: nil,
                                                     type: .intervention,
                                                     title: self.title,
                                                     text: "",
                                                     tintColor: UIColor(red: CGFloat(self.colorModel.redValue / 255),
                                                                        green: CGFloat(self.colorModel.greenValue / 255),
                                                                        blue: CGFloat(self.colorModel.blueValue / 255),
                                                                        alpha: CGFloat(self.colorModel.alphaValue)),
                                                     instructions: self.instructions,
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

    var timeIntervalModels : [TimeIntervalModel]
    {
        get
        {
            let timeIntervalModels = self._timeIntervalModels!

            return timeIntervalModels
        }
        
        set(newValue)
        {
            self._timeIntervalModels = newValue
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
    
    var endDate : TimeInterval
    {
        get
        {
            let endDate = self._endDate!
            
            return endDate
        }
        
        set(newValue)
        {
            self._endDate = newValue
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
    
    var instructions : String
    {
        get
        {
//            let instructions = "Use \(self.title) \(self.timeIntervals.count) a day from \(self.startDate) to "
            let instructions = "Hello"

            return instructions
        }
    }
}
