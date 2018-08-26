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
    private var _colorModel : ColorModel!
    private var _title : String!
    private var _timeModels : [TimeModel]!
    private var _startDate : TimeInterval!
    private var _endDate : TimeInterval!

    override var data : JSON
    {
        get
        {
            var timeModels = [JSON]()
            
            for timeModel in self.timeModels
            {
                timeModels.append(timeModel.data)
            }
            
            
            let data = JSON(["colorModel": self._colorModel!.data as Any,
                             "title": self._title as Any,
                             "timeModels": timeModels as Any,
                             "startDate": self._startDate as Any,
                             "endDate": self._endDate as Any])

            return data
        }

        set(newValue)
        {
            if (newValue != JSON.null)
            {
                self.timeModels = [TimeModel]()
                
                for data in newValue["timeModels"].array!
                {
                    let timeModel = TimeModel()
                    timeModel.data = data
                    self.timeModels.append(timeModel)
                }
                
                self._colorModel = ColorModel()
                self._colorModel.data = newValue["colorModel"]
                self._title = newValue["title"].string
                self._startDate = newValue["startDate"].double
                self._endDate = newValue["endDate"].double
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
                                                             occurrencesPerDay: UInt(self.timeModels.count),
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

    var timeModels : [TimeModel]
    {
        get
        {
            let timeModels = self._timeModels!

            return timeModels
        }
        
        set(newValue)
        {
            self._timeModels = newValue
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
