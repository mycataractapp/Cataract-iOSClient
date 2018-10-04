//
//  MainDashboardViewModel.swift
//  Cataract
//
//  Created by Roseanne Choi on 9/9/18.
//  Copyright © 2018 Roseanne Choi. All rights reserved.
//

import UIKit

class MainDashboardViewModel : DynamicViewModel
{
    var size = CGSize.zero
        
    @objc dynamic var faqCardCollectionViewModel = FAQCardViewModel.CollectionViewModel(faqCardViewModels: [FAQCardViewModel]())
    @objc dynamic var appointmentCardCollectionViewModel = AppointmentCardViewModel.CollectionViewModel(appointmentCardViewModels: [AppointmentCardViewModel]())
}
