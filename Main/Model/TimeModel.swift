//
//  TimeModel.swift
//  Cataract
//
//  Created by Roseanne Choi on 6/29/18.
//  Copyright © 2018 Roseanne Choi. All rights reserved.
//

import UIKit

final class TimeModel : DynamicModel, Encodable, Decodable
{
    private var _interval : Double!
    private var _identifier : String!
    
    init(interval: Double, identifier: String)
    {
        self._interval = interval
        self._identifier = identifier
        
        super.init()
    }
    
    required init(from decoder: Decoder) throws
    {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        
        self._interval = try? values.decode(Double.self, forKey: TimeModel.CodingKeys.interval)
        self._identifier = try? values.decode(String.self, forKey: .identifier)
        
        super.init()
    }
    
    var interval : Double
    {
        get
        {
            let interval = self._interval!
                        
            return interval
        }
    }
    
    var identifier : String
    {
        get
        {
            let identifier = self._identifier!
            
            return identifier
        }
    }
    
    func encode(to encoder: Encoder) throws
    {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(self._interval, forKey: .interval)
        try container.encode(self._identifier, forKey: .identifier)
    }
    
    enum CodingKeys: String, CodingKey
    {
        case interval
        case identifier
    }
}
