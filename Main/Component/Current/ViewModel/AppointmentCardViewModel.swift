//
//  AppointmentCardViewModel.swift
//  Cataract
//
//  Created by Roseanne Choi on 9/9/18.
//  Copyright © 2018 Roseanne Choi. All rights reserved.
//

import UIKit

class AppointmentCardViewModel : CardViewModel
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
    
    class CollectionViewModel : DynamicViewModel
    {
        var selectId : String!
        var itemSize = CGSize.zero
        private var _appointmentCardViewModels : [AppointmentCardViewModel]!

        init(appointmentCardViewModels : [AppointmentCardViewModel])
        {
            self._appointmentCardViewModels = appointmentCardViewModels
            
            super.init()
        }
        
        var appointmentCardViewModels : [AppointmentCardViewModel]
        {
            get
            {
                let appointmentCardViewModels = [AppointmentCardViewModel]()
                
                return appointmentCardViewModels
            }
        }
    }
}
