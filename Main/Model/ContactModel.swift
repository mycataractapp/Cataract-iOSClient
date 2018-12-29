//
//  ContactModel.swift
//  Cataract
//
//  Created by Roseanne Choi on 7/26/18.
//  Copyright © 2018 Roseanne Choi. All rights reserved.
//

import UIKit
import CareKit

final class ContactModel : DynamicModel, Encodable, Decodable
{
    private var _name : String!
    private var _relation : String! = ""
    private var _contactInfoModels = [ContactInfoModel]()
    private var _ockContact : OCKContact!

    init(name: String, contactInfoModels: [ContactInfoModel])
    {
        self._name = name
        self._contactInfoModels = contactInfoModels
        
        super.init()
    }

    required init(from decoder: Decoder) throws
    {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        self._name = try values.decode(String.self, forKey: ContactModel.CodingKeys.name)
        self._relation = try values.decode(String.self, forKey: ContactModel.CodingKeys.relation)
        self._contactInfoModels = try values.decode([ContactInfoModel].self, forKey: ContactModel.CodingKeys.contactInfoModels)
        
        super.init()
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
    
    func encode(to encoder: Encoder) throws
    {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(self._name, forKey: .name)
        try container.encode(self._relation, forKey: .relation)
        try container.encode(self._contactInfoModels, forKey: .contactInfoModels)
    }

    enum CodingKeys: String, CodingKey
    {
        case name
        case relation
        case contactInfoModels
    }
}
