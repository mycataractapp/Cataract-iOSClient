//
//  ContactModel.swift
//  Cataract
//
//  Created by Rose Choi on 7/26/18.
//  Copyright © 2018 Rose Choi. All rights reserved.
//

import UIKit
import SwiftyJSON
import CareKit

class ContactModel : DynamicModel
{
    private var _contact : OCKContact!
    private var _contactInfoModels : [ContactInfoModel]!
    private var _name : String!
    private var _relation : String!
    
    override var data: JSON
    {
        get
        {
            var contactInfoModels = [JSON]()
            
            for contactInfoModel in self.contactInfoModels
            {
                contactInfoModels.append(contactInfoModel.data)
            }
            
            let data = JSON(["name": self._name as Any,
                             "relation": self._relation as Any,
                             "contactInfoModels": contactInfoModels as Any])
            return data
        }
        
        set(newValue)
        {
            if (newValue != JSON.null)
            {
                self.contactInfoModels = [ContactInfoModel]()
                
                for data in newValue["contactInfoModels"].array!
                {
                    let contactInfoModel = ContactInfoModel()
                    contactInfoModel.data = data
                    self.contactInfoModels.append(contactInfoModel)
                }
                
                self._name = newValue["name"].string
                self._relation = newValue["relation"].string
            }
        }
    }
    
    var contact : OCKContact
    {
        get
        {
            if (self._contact == nil)
            {
                var contactInfoItems = [OCKContactInfo]()
                
                for contactInfoModel in self._contactInfoModels
                {
                    contactInfoItems.append(contactInfoModel.contactInfo)
                }
                
                self._contact = OCKContact(contactType: OCKContactType.careTeam,
                                           name: self.name,
                                           relation: self.relation,
                                           contactInfoItems: contactInfoItems,
                                           tintColor: nil,
                                           monogram: nil,
                                           image: nil)
            }
            
            let contact = self._contact!
            
            return contact
        }
    }
    
    var contactInfoModels : [ContactInfoModel]
    {
        get
        {
            if (self._contactInfoModels == nil)
            {
                self._contactInfoModels = [ContactInfoModel]()
            }
            
            let contactInfoModels = self._contactInfoModels!
            
            return contactInfoModels
        }
        
        set(newValue)
        {
            self._contactInfoModels = newValue
        }
    }
    
    var name : String
    {
        get
        {
            let name = self._name!
            
            return name
        }
        
        set(newValue)
        {
            self._name = newValue
        }
    }
    
    var relation : String
    {
        get
        {
            let relation = self._relation!
            
            return relation
        }
        
        set(newValue)
        {
            self._relation = newValue
        }
    }
}
