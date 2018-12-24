//
//  AppointmentCardViewModel.swift
//  Cataract
//
//  Created by Roseanne Choi on 9/9/18.
//  Copyright © 2018 Roseanne Choi. All rights reserved.
//

import UIKit

class AppointmentCardViewModel : CardViewModel, Encodable, Decodable
{
    @objc dynamic var title : String
    @objc dynamic var date: String
    @objc dynamic var time : String
    
    init(title: String, date: String, time: String, id: String)
    {
        self.title = title
        self.date = date
        self.time = time
        
        super.init(id: id)
    }
    
    required init(from decoder: Decoder) throws
    {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        title = try values.decode(String.self, forKey: .title)
        date = try values.decode(String.self, forKey: .date)
        time = try values.decode(String.self, forKey: .time)
        
        super.init(id: "")
    }
    
    func encode(to encoder: Encoder) throws
    {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(title, forKey: .title)
        try container.encode(date, forKey: .date)
        try container.encode(time, forKey: .time)
    }
    
    enum CodingKeys : String, CodingKey
    {
        case title
        case date
        case time
    }
    
    class CollectionViewModel : DynamicViewModel
    {
        var selectId : String!
        var itemSize = CGSize.zero
        private var _appointmentCardViewModels : [AppointmentCardViewModel]

        init(appointmentCardViewModels : [AppointmentCardViewModel])
        {
            self._appointmentCardViewModels = appointmentCardViewModels
                        
            super.init()
        }
        
        var appointmentCardViewModels : [AppointmentCardViewModel]
        {
            get
            {
                let appointmentCardViewModels = self._appointmentCardViewModels
                
                return appointmentCardViewModels
            }
            set(newValue)
            {
                self._appointmentCardViewModels = newValue
            }
        }
        
        @objc func delete()
        {
            self.transit(transition: AppointmentCardViewModel.CollectionViewModel.Transition.delete,
                         to: AppointmentCardViewModel.CollectionViewModel.State.removed)
        }
        
        struct Transition
        {
            static let delete = DynamicViewModel.Transition(rawValue: "Delete")
        }
        
        struct State
        {
            static let removed = DynamicViewModel.State(rawValue: "Removed")
        }
    }
}
