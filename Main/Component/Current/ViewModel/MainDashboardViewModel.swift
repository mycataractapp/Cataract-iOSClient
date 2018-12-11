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
    private var _dropAddButtonViewModel : UserViewModel.AddButtonViewModel!
    private var _appointmentAddButtonViewModel : UserViewModel.AddButtonViewModel!
    private var _contactAddButtonViewModel : UserViewModel.AddButtonViewModel!

    @objc var dropAddButtonViewModel : UserViewModel.AddButtonViewModel
    {
        get
        {
            if (self._dropAddButtonViewModel == nil)
            {
                self._dropAddButtonViewModel = UserViewModel.AddButtonViewModel(id: "")
            }
            
            let dropAddButtonViewModel = self._dropAddButtonViewModel!
            
            return dropAddButtonViewModel
        }
    }
    
    @objc var appointmentAddButtonViewModel : UserViewModel.AddButtonViewModel
    {
        get
        {
            if (self._appointmentAddButtonViewModel == nil)
            {
                self._appointmentAddButtonViewModel = UserViewModel.AddButtonViewModel(id: "")
            }
            
            let appointmentAddButtonViewModel = self._appointmentAddButtonViewModel!
            
            return appointmentAddButtonViewModel
        }
    }
    
    @objc var contactAddButtonViewModel : UserViewModel.AddButtonViewModel
    {
        get
        {
            if (self._contactAddButtonViewModel == nil)
            {
                self._contactAddButtonViewModel = UserViewModel.AddButtonViewModel(id: "")
            }
            
            let contactAddButtonViewModel = self._contactAddButtonViewModel!
            
            return contactAddButtonViewModel
        }
    }
        
    @objc dynamic var faqCardCollectionViewModel = FAQCardViewModel.CollectionViewModel(faqCardViewModels: [FAQCardViewModel]())
    @objc dynamic var appointmentCardCollectionViewModel = AppointmentCardViewModel.CollectionViewModel(appointmentCardViewModels: [AppointmentCardViewModel]())
}
