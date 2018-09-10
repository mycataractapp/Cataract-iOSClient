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
    private var _faqOverviewViewModel : FAQOverviewViewModel!
    private var _dropFormDetailViewModel : DropFormDetailViewModel!
    private var _contactsOverviewViewModel : ContactsOverviewViewModel!
    private var _editViewModel : MenuViewModel!
    private var _deleteViewModel : MenuViewModel!
    private var _cancelViewModel : MenuViewModel!
    private var _menuOverviewViewModel : MenuOverviewViewModel!

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
                self._navigationOverviewViewModel = NavigationOverviewViewModel(states: ["Drop", "Appointment", "FAQ", "Contacts"])
                
                var navigationViewModel : NavigationViewModel!

                for index in 0...3
                {
                    if (index == 0)
                    {
                        let imagePathByState = ["On": Bundle.main.path(forResource: "DropOn", ofType: "png")!,
                                                "Off": Bundle.main.path(forResource: "DropOff", ofType: "png")!]

                        navigationViewModel = NavigationViewModel(imagePathByState: imagePathByState, title: "Drops", isSelected: true)
                    }
                    else if (index == 1)
                    {
                        let imagePathByState = ["On": Bundle.main.path(forResource: "AppointmentOn", ofType: "png")!,
                                                "Off": Bundle.main.path(forResource: "AppointmentOff", ofType: "png")!]
                        
                        navigationViewModel = NavigationViewModel(imagePathByState: imagePathByState, title: "Appointments", isSelected: false)
                    }
                    else if (index == 2)
                    {
                        let imagePathByState = ["On": Bundle.main.path(forResource: "InformationOn", ofType: "png")!,
                                                "Off": Bundle.main.path(forResource: "InformationOff", ofType: "png")!]
                        navigationViewModel = NavigationViewModel(imagePathByState: imagePathByState, title: "Info", isSelected: false)
                    }
                    else if (index == 3)
                    {
                        let imagePathByState = ["On": Bundle.main.path(forResource: "ContactsOn", ofType: "png")!,
                                                "Off": Bundle.main.path(forResource: "ContactsOff", ofType: "png")!]
                        navigationViewModel = NavigationViewModel(imagePathByState: imagePathByState, title: "Contacts", isSelected: false)
                    }

                    self.navigationOverviewViewModel.navigationViewModels.append(navigationViewModel)
                }
            }
            
            let navigationOverviewViewModel = self._navigationOverviewViewModel!
            
            return navigationOverviewViewModel
        }
    }
    
    var faqOverviewViewModel : FAQOverviewViewModel
    {
        get
        {
            if (self._faqOverviewViewModel == nil)
            {
                self._faqOverviewViewModel = FAQOverviewViewModel()
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
    
    var editViewModel : MenuViewModel
    {
        get
        {
            if (self._editViewModel == nil)
            {
                self._editViewModel = MenuViewModel(title: "Edit")
            }

            let editViewModel = self._editViewModel!

            return editViewModel
        }
    }
    var deleteViewModel : MenuViewModel
    {
        get
        {
            if (self._deleteViewModel == nil)
            {
                self._deleteViewModel = MenuViewModel(title: "Delete")
            }

            let deleteViewModel = self._deleteViewModel!

            return deleteViewModel
        }
    }

    var cancelViewModel : MenuViewModel
    {
        get
        {
            if (self._cancelViewModel == nil)
            {
                self._cancelViewModel = MenuViewModel(title: "Cancel")
            }

            let cancelViewModel = self._cancelViewModel!

            return cancelViewModel
        }
    }

    var menuOverviewViewModel : MenuOverviewViewModel
    {
        get
        {
            if (self._menuOverviewViewModel == nil)
            {
                self._menuOverviewViewModel = MenuOverviewViewModel(states: ["Edit", "Delete", "Cancel"])
                self.menuOverviewViewModel.menuViewModels.append(self.editViewModel)
                self.menuOverviewViewModel.menuViewModels.append(self.deleteViewModel)
                self.menuOverviewViewModel.menuViewModels.append(self.cancelViewModel)
            }

            let menuOverviewViewModel = self._menuOverviewViewModel!

            return menuOverviewViewModel
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
    
    @objc func editDrops()
    {
        self.transit(transition: "EditDrops", to: "Menu")
    }
}
