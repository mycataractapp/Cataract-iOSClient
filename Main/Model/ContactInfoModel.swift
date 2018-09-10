//
//  ContactInfoModel.swift
//  Cataract
//
//  Created by Roseanne Choi on 7/26/18.
//  Copyright © 2018 Roseanne Choi. All rights reserved.
//

import UIKit
import CareKit

final class ContactInfoModel : DynamicModel, Decodable
{
    private var _type : String!
    private var _label : String!
    private var _display : String!
    private var _ockContactInfo : OCKContactInfo!
    
    init(from decoder: Decoder) throws
    {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        self._type = try values.decode(String.self, forKey: ContactInfoModel.CodingKeys.type)
        self._label = try values.decode(String.self, forKey: ContactInfoModel.CodingKeys.type)
        self._display = try values.decode(String.self, forKey: ContactInfoModel.CodingKeys.type)
        
        let id = try values.decode(String.self, forKey: ContactInfoModel.CodingKeys.id)
        super.init(id: id)
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
    
    enum CodingKeys: String, CodingKey
    {
        case id
        case type
        case label
        case display
    }
}
