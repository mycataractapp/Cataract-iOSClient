//
//  TimeModel.swift
//  Cataract
//
//  Created by Roseanne Choi on 6/29/18.
//  Copyright © 2018 Roseanne Choi. All rights reserved.
//

import UIKit

final class TimeModel : DynamicModel, Decodable
{
    private var _interval : Double!
    
    init(from decoder: Decoder) throws
    {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        self._interval = try values.decode(Double.self, forKey: TimeModel.CodingKeys.interval)
        
        let id = try values.decode(String.self, forKey: TimeModel.CodingKeys.id)
        super.init(id: id)
    }
    
    var interval : Double
    {
        get
        {
            let interval = self._interval!
            
            return interval
        }
    }
    
    enum CodingKeys: String, CodingKey
    {
        case id
        case interval
    }
}
