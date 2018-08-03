//
//  ContactsFormDetailViewModel.swift
//  Cataract
//
//  Created by Rose Choi on 7/31/18.
//  Copyright © 2018 Rose Choi. All rights reserved.
//

import UIKit

class ContactsFormDetailViewModel : DynamicViewModel
{
    private var _contactsInputOverviewViewModel : ContactsInputOverviewViewModel!
    private var _contactsNameInputViewModel : ContactsInputViewModel!
    private var _contactsRelationInputViewModel : ContactsInputViewModel!
    private var _contactsPhoneNumberInputViewModel : ContactsInputViewModel!
    private var _contactsEmailInputViewModel : ContactsInputViewModel!
    private var _contactsAddressInputViewModel : ContactsInputViewModel!
    private var _footerPanelViewModel : FooterPanelViewModel!
    private var _keyboardViewModel : KeyboardViewModel!
    
    var contactsInputOverviewViewModel : ContactsInputOverviewViewModel
    {
        get
        {
            if (self._contactsInputOverviewViewModel == nil)
            {
                self._contactsInputOverviewViewModel = ContactsInputOverviewViewModel()
                self._contactsInputOverviewViewModel.contactsInputViewModels.append(self.contactsNameInputViewModel)
                self._contactsInputOverviewViewModel.contactsInputViewModels.append(self.contactsRelationInputViewModel)
                self._contactsInputOverviewViewModel.contactsInputViewModels.append(self.contactsPhoneNumberInputViewModel)
                self._contactsInputOverviewViewModel.contactsInputViewModels.append(self.contactsEmailInputViewModel)
                self._contactsInputOverviewViewModel.contactsInputViewModels.append(self.contactsAddressInputViewModel)
            }
            
            let contactsInputOverviewViewModel = self._contactsInputOverviewViewModel!
            
            return contactsInputOverviewViewModel
        }
    }

    var contactsNameInputViewModel : ContactsInputViewModel
    {
        get
        {
            if (self._contactsNameInputViewModel == nil)
            {
                self._contactsNameInputViewModel = ContactsInputViewModel(title: "Name")
            }
            
            let contactsNameInputViewModel = self._contactsNameInputViewModel!
            
            return contactsNameInputViewModel
        }
    }
    
    var contactsRelationInputViewModel : ContactsInputViewModel
    {
        get
        {
            if (self._contactsRelationInputViewModel == nil)
            {
                self._contactsRelationInputViewModel = ContactsInputViewModel(title: "Relation")
            }
            
            let contactsRelationInputViewModel = self._contactsRelationInputViewModel!
            
            return contactsRelationInputViewModel
        }
    }
    
    var contactsPhoneNumberInputViewModel : ContactsInputViewModel
    {
        get
        {
            if (self._contactsPhoneNumberInputViewModel == nil)
            {
                self._contactsPhoneNumberInputViewModel = ContactsInputViewModel(title: "Phone Number")
            }
            
            let contactsPhoneNumberInputViewModel = self._contactsPhoneNumberInputViewModel!
            
            return contactsPhoneNumberInputViewModel
        }
    }
    
    var contactsEmailInputViewModel : ContactsInputViewModel
    {
        get
        {
            if (self._contactsEmailInputViewModel == nil)
            {
                self._contactsEmailInputViewModel = ContactsInputViewModel(title: "Email")
            }
            
            let contactsEmailInputViewModel = self._contactsEmailInputViewModel!
            
            return contactsEmailInputViewModel
        }
    }
    
    var contactsAddressInputViewModel : ContactsInputViewModel
    {
        get
        {
            if (self._contactsAddressInputViewModel == nil)
            {
                self._contactsAddressInputViewModel = ContactsInputViewModel(title: "Address")
            }
            
            let contactsAddressInputViewModel = self._contactsAddressInputViewModel!
            
            return contactsAddressInputViewModel
        }
    }
    
    var footerPanelViewModel : FooterPanelViewModel
    {
        get
        {
            if (self._footerPanelViewModel == nil)
            {
                self._footerPanelViewModel = FooterPanelViewModel(leftTitle: "Back", rightTitle: "Create")
            }
            
            let footerPanelViewModel = self._footerPanelViewModel!
            
            return footerPanelViewModel
        }
    }
    
    var keyboardViewModel : KeyboardViewModel
    {
        get
        {
            if (self._keyboardViewModel == nil)
            {
                self._keyboardViewModel = KeyboardViewModel()
            }
            
            let keyboardViewModel = self._keyboardViewModel!
            
            return keyboardViewModel
        }
    }
    
    @objc func createContacts()
    {
        self.transit(transition: "CreateContacts", to: "Completion")
    }
    
    @objc func exitContacts()
    {
        self.transit(transition: "ExitContacts", to: "Cancellation")
    }
}
