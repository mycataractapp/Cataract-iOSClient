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
    private var _noAppointmentsLabelViewModel : LabelViewModel!
    private var _onboardingContentViewModel : OnboardingContentViewModel.CollectionViewModel!
    private var _dropAddButtonViewModel : UserViewModel.AddButtonViewModel!
    private var _appointmentAddButtonViewModel : UserViewModel.AddButtonViewModel!
    private var _contactAddButtonViewModel : UserViewModel.AddButtonViewModel!
    private var _dropCardViewModel : DropCardViewModel!
    private var _appointmentsMenuOverlayViewModel : UserViewModel.MenuOverlayViewModel!
    
    var noAppointmentsLabelViewModel : LabelViewModel
    {
        get
        {
            if (self._noAppointmentsLabelViewModel == nil)
            {
                let colorCardViewModel = ColorCardViewModel(redValue: 169,
                                                            greenValue: 169,
                                                            blueValue: 169,
                                                            alphaValue: 1)
                
                self._noAppointmentsLabelViewModel = LabelViewModel(text: "No Appointments",
                                                               textColor: colorCardViewModel,
                                                               numberOfLines: 1,
                                                               borderColor: colorCardViewModel,
                                                               borderWidth: 0,
                                                               size: CGSize.zero,
                                                               style: .truncate,
                                                               textAlignment: .center)
            }
            
            let noAppointmentsLabelViewModel = self._noAppointmentsLabelViewModel!
            
            return noAppointmentsLabelViewModel
        }
    }
    
    @objc var onboardingContentViewModel : OnboardingContentViewModel.CollectionViewModel!
    {
        get
        {
            if (self._onboardingContentViewModel == nil)
            {
                self._onboardingContentViewModel = OnboardingContentViewModel.CollectionViewModel()
            }
            
            let onboardingContentViewModel = self._onboardingContentViewModel!
            
            return onboardingContentViewModel
        }
    }

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
    
    @objc var dropCardViewModel : DropCardViewModel
    {
        get
        {
            if (self._dropCardViewModel == nil)
            {
                self._dropCardViewModel = DropCardViewModel(id: "")
            }
            
            let dropCardViewModel = self._dropCardViewModel!
            
            return dropCardViewModel
        }
    }
    
    @objc var appointmentsMenuOverlayViewModel : UserViewModel.MenuOverlayViewModel
    {
        get
        {
            if (self._appointmentsMenuOverlayViewModel == nil)
            {
                self._appointmentsMenuOverlayViewModel = UserViewModel.MenuOverlayViewModel()
            }
            
            let appointmentsMenuOverlayViewModel = self._appointmentsMenuOverlayViewModel!
            
            return appointmentsMenuOverlayViewModel
        }
    }

    @objc dynamic var faqCardCollectionViewModel = FAQCardViewModel.CollectionViewModel(faqCardViewModels: [FAQCardViewModel]())
    @objc dynamic var appointmentCardCollectionViewModel = AppointmentCardViewModel.CollectionViewModel(appointmentCardViewModels: [AppointmentCardViewModel]())
}
