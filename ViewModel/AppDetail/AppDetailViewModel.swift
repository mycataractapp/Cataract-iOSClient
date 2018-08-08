//
//  AppDetailViewModel.swift
//  Cataract
//
//  Created by Roseanne Choi on 6/9/18.
//  Copyright © 2018 Roseanne Choi. All rights reserved.
//

import UIKit

class AppDetailViewModel : DynamicViewModel
{
    private var _dropOverviewViewModel : DropOverviewViewModel!
    private var _appointmentTimeOverviewViewModel : AppointmentTimeOverviewViewModel!
    private var _navigationOverviewViewModel : NavigationOverviewViewModel!
    private var _faqOverviewViewModel : FaqOverviewViewModel!
    private var _dropFormDetailViewModel : DropFormDetailViewModel!
    private var _contactsOverviewViewModel : ContactsOverviewViewModel!
    
    override init()
    {
        super.init(state: "Drops")
    }

    var dropOverviewViewModel : DropOverviewViewModel
    {
        get
        {
            if (self._dropOverviewViewModel == nil)
            {
                self._dropOverviewViewModel = DropOverviewViewModel()
            }
            
            let dropOverviewViewModel = self._dropOverviewViewModel!
            
            return dropOverviewViewModel
        }
    }

    var appointmentTimeOverviewViewModel : AppointmentTimeOverviewViewModel
    {
        get
        {
            if (self._appointmentTimeOverviewViewModel == nil)
            {
                self._appointmentTimeOverviewViewModel = AppointmentTimeOverviewViewModel()
            }
            
            let appointmentTimeOverviewViewModel = self._appointmentTimeOverviewViewModel!
            
            return appointmentTimeOverviewViewModel
        }
    }
    
    var navigationOverviewViewModel : NavigationOverviewViewModel
    {
        get
        {
            if (self._navigationOverviewViewModel == nil)
            {
                self._navigationOverviewViewModel = NavigationOverviewViewModel(states: ["Drop", "Appointment", "Faq", "Contacts"])
                
                var navigationViewModel : NavigationViewModel!

                for index in 0...3
                {
                    if (index == 0)
                    {
                        let imagePathByState = ["On": Bundle.main.path(forResource: "DropOn", ofType: "png")!,
                                                "Off": Bundle.main.path(forResource: "DropOff", ofType: "png")!]

                        navigationViewModel = NavigationViewModel(imagePathByState: imagePathByState, isSelected: true)
                    }
                    else if (index == 1)
                    {
                        let imagePathByState = ["On": Bundle.main.path(forResource: "AppointmentOn", ofType: "png")!,
                                                "Off": Bundle.main.path(forResource: "AppointmentOff", ofType: "png")!]
                        
                        navigationViewModel = NavigationViewModel(imagePathByState: imagePathByState, isSelected: false)
                    }
                    else if (index == 2)
                    {
                        let imagePathByState = ["On": Bundle.main.path(forResource: "InformationOn", ofType: "png")!,
                                                "Off": Bundle.main.path(forResource: "InformationOff", ofType: "png")!]
                        navigationViewModel = NavigationViewModel(imagePathByState: imagePathByState, isSelected: false)
                    }
                    else if (index == 3)
                    {
                        let imagePathByState = ["On": Bundle.main.path(forResource: "ContactsOn", ofType: "png")!,
                                                "Off": Bundle.main.path(forResource: "ContactsOff", ofType: "png")!]
                        navigationViewModel = NavigationViewModel(imagePathByState: imagePathByState, isSelected: false)
                    }

                    self.navigationOverviewViewModel.navigationViewModels.append(navigationViewModel)
                }
            }
            
            let navigationOverviewViewModel = self._navigationOverviewViewModel!
            
            return navigationOverviewViewModel
        }
    }
    
    var faqOverviewViewModel : FaqOverviewViewModel
    {
        get
        {
            if (self._faqOverviewViewModel == nil)
            {
                self._faqOverviewViewModel = FaqOverviewViewModel()
            }
            
            let faqOverviewViewModel = self._faqOverviewViewModel!
            
            return faqOverviewViewModel
        }
    }
    
    var dropFormDetailViewModel : DropFormDetailViewModel
    {
        get
        {
            if (self._dropFormDetailViewModel == nil)
            {
                self._dropFormDetailViewModel = DropFormDetailViewModel()
            }
            
            let dropFormDetailViewModel = self._dropFormDetailViewModel!
            
            return dropFormDetailViewModel
        }
    }

    var contactsOverviewViewModel : ContactsOverviewViewModel
    {
        get
        {
            if (self._contactsOverviewViewModel == nil)
            {
                self._contactsOverviewViewModel = ContactsOverviewViewModel()
            }
            
            let contactsOverviewViewModel = self._contactsOverviewViewModel!
            
            return contactsOverviewViewModel
        }
    }
    
    @objc func addDropForm()
    {
        self.transit(transition: "AddDropForm", to: self.state)
    }
    
    @objc func addAppointmentForm()
    {
        self.transit(transition: "AddAppointmentForm", to: self.state)
    }
    
    @objc func addContactsForm()
    {
        self.transit(transition: "AddContactsForm", to: self.state)
    }
}
