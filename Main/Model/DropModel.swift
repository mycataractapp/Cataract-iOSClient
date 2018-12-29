//
//  DropModel.swift
//  Cataract
//
//  Created by Roseanne Choi on 6/9/18.
//  Copyright © 2018 Roseanne Choi. All rights reserved.
//

import UIKit
import CareKit

final class DropModel : DynamicModel, Encodable, Decodable
{
    private var _title : String!
    private var _colorModel : ColorModel!
    private var _startTimeModel : TimeModel!
    private var _endTimeModel : TimeModel!
    private var _frequencyTimeModels : [TimeModel]!
    private var _ockCarePlanActivity : OCKCarePlanActivity!
    
    init(title: String, colorModel: ColorModel, startTimeModel: TimeModel, endTimeModel: TimeModel, frequencyTimeModels: [TimeModel])
    {
        self._title = title
        self._colorModel = colorModel
        self._startTimeModel = startTimeModel
        self._endTimeModel = endTimeModel
        self._frequencyTimeModels = frequencyTimeModels
        
        super.init()
    }

    required init(from decoder: Decoder) throws
    {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        
//        let id = try values.decode(String.self, forKey: DropModel.CodingKeys.id)
        
//        self.init(id: id)
        
        self._title = try? values.decode(String.self, forKey: DropModel.CodingKeys.title)
        self._frequencyTimeModels = try? values.decode([TimeModel].self, forKey: .frequencyTimeModels)
        
        super.init()
    }
    
    func encode(to encoder: Encoder) throws
    {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(self._title, forKey: .title)
        try container.encode(self._frequencyTimeModels, forKey: .frequencyTimeModels)
    }
    
    enum CodingKeys: String, CodingKey
    {
//        case id
        case title
//        case colorModel
//        case startTimeModel
//        case endTimeModel
        case frequencyTimeModels
    }
    
    var ockCarePlanActivity : OCKCarePlanActivity
    {
        get
        {
            if (self._ockCarePlanActivity == nil)
            {
                let startDate = Calendar.current.dateComponents([.year, .month, .day],
                                                                from: Date(timeIntervalSince1970: self.startTimeModel.interval))
                let endDate = Calendar.current.dateComponents([.year, .month, .day],
                                                              from: Date(timeIntervalSince1970: self.endTimeModel.interval))
                let schedule = OCKCareSchedule.dailySchedule(withStartDate: startDate,
                                                             occurrencesPerDay: UInt(self.frequencyTimeModels.count),
                                                             daysToSkip: 0,
                                                             endDate: endDate)
                self._ockCarePlanActivity = OCKCarePlanActivity(identifier: self.title,
                                                                groupIdentifier: nil,
                                                                type: .intervention,
                                                                title: self.title,
                                                                text: "",
                                                                tintColor: self.colorModel.uiColor,
                                                                instructions: "",
                                                                imageURL: nil,
                                                                schedule: schedule,
                                                                resultResettable: true,
                                                                userInfo: nil)
            }

            let ockCarePlanActivity = self._ockCarePlanActivity!
            
            return ockCarePlanActivity
        }
    }

    var title : String
    {
        get
        {
            let title = self._title!
                        
            return title
        }
    }
    
    var colorModel : ColorModel
    {
        get
        {
            let colorModel = self._colorModel!
            
            return colorModel
        }

        set(newValue)
        {
            self._colorModel = newValue
        }
    }
    
    var startTimeModel : TimeModel
    {
        get
        {
            let startTimeModel = self._startTimeModel!
            
            return startTimeModel
        }
    }
    
    var endTimeModel : TimeModel
    {
        get
        {
            let endTimeModel = self._endTimeModel!
            
            return endTimeModel
        }
    }

    var frequencyTimeModels : [TimeModel]
    {
        get
        {
            let frequencyTimeModels = self._frequencyTimeModels!
            
            return frequencyTimeModels
        }
    }
}
