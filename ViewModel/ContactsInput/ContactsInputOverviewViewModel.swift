//
//  ContactsInputOverviewViewModel.swift
//  Cataract
//
//  Created by Rose Choi on 7/30/18.
//  Copyright © 2018 Rose Choi. All rights reserved.
//

import UIKit

class ContactsInputOverviewViewModel : DynamicViewModel
{
    private var _contactsInputViewModels : [ContactsInputViewModel]!
    
    var contactsInputViewModels : [ContactsInputViewModel]
    {
        get
        {
            if (self._contactsInputViewModels == nil)
            {
                self._contactsInputViewModels = [ContactsInputViewModel]()
            }
            
            let contactsInputViewModels = self._contactsInputViewModels!
            
            return contactsInputViewModels
        }
        
        set(newValue)
        {
            self._contactsInputViewModels = newValue
        }
    }
}
