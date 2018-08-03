//
//  ContactInfoModel.swift
//  Cataract
//
//  Created by Rose Choi on 7/26/18.
//  Copyright © 2018 Rose Choi. All rights reserved.
//

import UIKit
import SwiftyJSON
import CareKit

class ContactInfoModel : DynamicModel
{
    private var _contactInfo : OCKContactInfo!
    private var _label : String!
    private var _display : String!
    
    override var data: JSON
    {
        get
        {
            let data = JSON(["label": self._label as Any,
                             "display": self._display as Any])
            return data
        }
        
        set(newValue)
        {
            if (newValue != JSON.null)
            {
                self._label = newValue["label"].string
                self._display = newValue["display"].string
            }
        }
    }
    
    var contactInfo : OCKContactInfo
    {
        get
        {
            if (self._contactInfo == nil)
            {
                self._contactInfo = OCKContactInfo(type: OCKContactInfoType.email,
                                                   display: self.display,
                                                   actionURL: nil,
                                                   label: self.label,
                                                   icon: nil)
            }
            
            let contactInfo = self._contactInfo!
            
            return contactInfo
        }
    }
    
    var label : String
    {
        get
        {
            let label = self._label!
            
            return label
        }
        
        set(newValue)
        {
            self._label = newValue
        }
    }
    
    var display : String
    {
        get
        {
            let display = self._display!
            
            return display
        }
        
        set(newValue)
        {
            self._display = newValue
        }
    }
}
