//
//  AppointmentModel.swift
//  Cataract
//
//  Created by Roseanne Choi on 6/11/18.
//  Copyright © 2018 Roseanne Choi. All rights reserved.
//

import UIKit

final class AppointmentModel : DynamicModel, Decodable
{
    private var _title : String!
    private var _date : String!
    private var _time : String!
    private var _timeModel : TimeModel!
    
    init(title: String, date: String, time: String, timeModel: TimeModel)
    {
        self._title = title
        self._date = date
        self._time = time
        self._timeModel = timeModel
        
        super.init()
    }
    
    required init(from decoder: Decoder) throws
    {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        
        let id = try values.decode(String.self, forKey: AppointmentModel.CodingKeys.id)
        
        self._title = try values.decode(String.self, forKey: AppointmentModel.CodingKeys.title)
        self._timeModel = try values.decode(TimeModel.self, forKey: AppointmentModel.CodingKeys.timeModel)
        
        super.init()
    }
    
    var title : String
    {
        get
        {
            let title = self._title!
                        
            return title
        }
    }
    
    var date : String
    {
        get
        {
            let date = self._date!
            
            return date
        }
    }
    
    var time : String
    {
        get
        {
            let time = self._time!
            
            return time
        }
    }
    
    var timeModel : TimeModel
    {
        get
        {
            let timeModel = self._timeModel!
            
            return timeModel
        }
    }
    
    enum CodingKeys: String, CodingKey
    {
        case id
        case title
        case timeModel
    }
}
