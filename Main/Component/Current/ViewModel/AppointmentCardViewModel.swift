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
    private var _timeModel : TimeModel!
    
    init(title: String, date: String, time: String, timeModel: TimeModel, id: String)
    {
        self.title = title
        self.date = date
        self.time = time
        self._timeModel = timeModel
        
        super.init(id: id)
    }
    
    required init(from decoder: Decoder) throws
    {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        title = try values.decode(String.self, forKey: .title)
        date = try values.decode(String.self, forKey: .date)
        time = try values.decode(String.self, forKey: .time)
        self._timeModel = try values.decode(TimeModel.self, forKey: .timeModel)
        
        super.init(id: "")
    }
    
    func encode(to encoder: Encoder) throws
    {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(title, forKey: .title)
        try container.encode(date, forKey: .date)
        try container.encode(time, forKey: .time)
        try container.encode(timeModel, forKey: .timeModel)
    }
    
    enum CodingKeys : String, CodingKey
    {
        case title
        case date
        case time
        case timeModel
    }
    
    var timeModel : TimeModel
    {
        get
        {
            let timeModel = self._timeModel!
            
            return timeModel
        }
    }

    class CollectionViewModel : DynamicViewModel
    {
        var buttonInt : Int!
        var selectId : String!
        var itemSize = CGSize.zero
        private var _appointmentMenuOverlayViewModel : UserViewModel.MenuOverlayViewModel!
        private var _appointmentCardViewModels : [AppointmentCardViewModel]

        init(appointmentCardViewModels : [AppointmentCardViewModel])
        {
            self._appointmentCardViewModels = appointmentCardViewModels
                        
            super.init()
        }
        
        @objc var appointmentMenuOverlayViewModel : UserViewModel.MenuOverlayViewModel
        {
            get
            {
                if (self._appointmentMenuOverlayViewModel == nil)
                {
                    self._appointmentMenuOverlayViewModel = UserViewModel.MenuOverlayViewModel()
                }
                
                let appointmentMenuOverlayViewModel = self._appointmentMenuOverlayViewModel!
                
                return appointmentMenuOverlayViewModel
            }
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
        
        @objc func enterMenu()
        {
            self.transit(transition: AppointmentCardViewModel.CollectionViewModel.Transition.enterMenu,
                         to: AppointmentCardViewModel.CollectionViewModel.State.options)
        }

        struct Transition
        {
            static let enterMenu = DynamicViewModel.Transition(rawValue: "EnterMenu")
        }

        struct State
        {
            static let options = DynamicViewModel.State(rawValue: "Options")
        }
    }
}
