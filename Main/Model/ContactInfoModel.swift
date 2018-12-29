//
//  ContactInfoModel.swift
//  Cataract
//
//  Created by Roseanne Choi on 7/26/18.
//  Copyright © 2018 Roseanne Choi. All rights reserved.
//

import UIKit
import CareKit

final class ContactInfoModel : DynamicModel, Encodable, Decodable
{
    private var _type : String!
    private var _label : String!
    private var _display : String!
    private var _ockContactInfo : OCKContactInfo!
    
    init(type: String, label: String, display: String)
    {
        self._type = type
        self._label = label
        self._display = display
        
        super.init()
    }
    
    required init(from decoder: Decoder) throws
    {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        self._type = try values.decode(String.self, forKey: .type)
        self._label = try values.decode(String.self, forKey: .label)
        self._display = try values.decode(String.self, forKey: .display)
        
        super.init()
    }
    
    var type : String
    {
        get
        {
            let type = self._type!

            return type
        }
    }

    var label : String
    {
        get
        {
            let label = self._label!

            return label
        }
    }

    var display : String
    {
        get
        {
            let display = self._display!

            return display
        }
    }
    
    var ockContactInfo : OCKContactInfo
    {
        get
        {
            if (self._ockContactInfo == nil)
            {
                var type : OCKContactInfoType! = nil
                
                if (self.type == "PhoneNumber")
                {
                    type = OCKContactInfoType.phone
                }
                else if (self.type == "Email")
                {
                    type = OCKContactInfoType.email
                }
                
                self._ockContactInfo = OCKContactInfo(type: type,
                                                      display: self.display,
                                                      actionURL: nil,
                                                      label: self.label,
                                                      icon: nil)
            }
            
            let ockContactInfo = self._ockContactInfo!
            
            return ockContactInfo
        }
    }
    
    func encode(to encoder: Encoder) throws
    {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(self._type, forKey: .type)
        try container.encode(self._label, forKey: .label)
        try container.encode(self._display, forKey: .display)
    }
    
    enum CodingKeys: String, CodingKey
    {
        case type
        case label
        case display
    }
}
