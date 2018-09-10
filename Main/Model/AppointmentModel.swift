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
    private var _timeModel : TimeModel!
    
    init(from decoder: Decoder) throws
    {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        self._title = try values.decode(String.self, forKey: AppointmentModel.CodingKeys.title)
        self._timeModel = try values.decode(TimeModel.self, forKey: AppointmentModel.CodingKeys.timeModel)
        
        let id = try values.decode(String.self, forKey: AppointmentModel.CodingKeys.id)
        super.init(id: id)
    }
    
    var title : String
    {
        get
        {
            let title = self._title!
            
            return title
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
