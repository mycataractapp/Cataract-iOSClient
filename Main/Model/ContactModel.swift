//
//  ContactModel.swift
//  Cataract
//
//  Created by Roseanne Choi on 7/26/18.
//  Copyright © 2018 Roseanne Choi. All rights reserved.
//

import UIKit
import CareKit

final class ContactModel : DynamicModel, Decodable
{
    private var _name : String!
    private var _relation : String! = ""
    private var _contactInfoModels = [ContactInfoModel]()
    private var _ockContact : OCKContact!
    
    convenience init(name: String, contactInfoModels: [ContactInfoModel])
    {
        self.init()

        self._name = name
        self._contactInfoModels = contactInfoModels
    }
    
    convenience init(from decoder: Decoder) throws
    {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        
        let id = try values.decode(String.self, forKey: ContactModel.CodingKeys.id)
        
        self.init(id: id)
        
        self._name = try values.decode(String.self, forKey: ContactModel.CodingKeys.name)
        self._relation = try values.decode(String.self, forKey: ContactModel.CodingKeys.relation)
        self._contactInfoModels = try values.decode([ContactInfoModel].self, forKey: ContactModel.CodingKeys.contactInfoModels)
    }
    
    var name : String
    {
        get
        {
            let name = self._name!
            
            return name
        }
    }
    
    var relation : String
    {
        get
        {
            let relation = self._relation!
            
            return relation
        }
    }
    
    var contactInfoModels : [ContactInfoModel]
    {
        get
        {
            let contactInfoModels = self._contactInfoModels
            
            return contactInfoModels
        }
    }
    
    var ockContact : OCKContact
    {
        get
        {
            if (self._ockContact == nil)
            {
                var contactInfoItems = [OCKContactInfo]()
                
                for contactInfoModel in self.contactInfoModels
                {
                    contactInfoItems.append(contactInfoModel.ockContactInfo)
                }
                
                self._ockContact = OCKContact(contactType: OCKContactType.careTeam,
                                              name: self.name,
                                              relation: self.relation,
                                              contactInfoItems: contactInfoItems,
                                              tintColor: nil,
                                              monogram: nil,
                                              image: nil)
            }
            
            let ockContact = self._ockContact!
            
            return ockContact
        }
    }
    
    enum CodingKeys: String, CodingKey
    {
        case id
        case name
        case relation
        case contactInfoModels
    }
}
