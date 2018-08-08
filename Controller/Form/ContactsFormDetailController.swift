//
//  ContactsFormDetailController.swift
//  Cataract
//
//  Created by Rose Choi on 7/30/18.
//  Copyright © 2018 Rose Choi. All rights reserved.
//

import UIKit

class ContactsFormDetailController : DynamicController<ContactsFormDetailViewModel>, DynamicViewModelDelegate
{
    private var _contactsInputOverviewController : ContactsInputOverviewController!
    private var _footerPanelController : FooterPanelController!
    private var _contactStore : ContactStore!

    var contactsInputOverviewController : ContactsInputOverviewController
    {
        get
        {
            if (self._contactsInputOverviewController == nil)
            {
                self._contactsInputOverviewController = ContactsInputOverviewController()
            }
            
            let contactsInputOverviewController = self._contactsInputOverviewController!
            
            return contactsInputOverviewController
        }
    }
    
    var footerPanelController : FooterPanelController
    {
        get
        {
            if (self._footerPanelController == nil)
            {
                self._footerPanelController = FooterPanelController()
            }
            
            let footerPanelController = self._footerPanelController!
            
            return footerPanelController
        }
    }
    
    var contactStore : ContactStore
    {
        get
        {
            if (self._contactStore == nil)
            {
                self._contactStore = ContactStore()
            }
            
            let contactStore = self._contactStore!
            
            return contactStore
        }
        set (newValue)
        {
            self._contactStore = newValue
        }
    }
    
    var contactsInputOverviewControllerSize : CGSize
    {
        get
        {
            var contactsInputOverviewControllerSize = CGSize.zero
            contactsInputOverviewControllerSize.width = self.view.frame.size.width
            contactsInputOverviewControllerSize.height = self.view.frame.size.height - self.footerPanelController.view.frame.size.height
            
            return contactsInputOverviewControllerSize
        }
    }
    
    var footerPanelControllerSize : CGSize
    {
        get
        {
            var footerPanelControllerSize = CGSize.zero
            footerPanelControllerSize.width = self.view.frame.size.width
            footerPanelControllerSize.height = self.canvas.draw(tiles: 3)
            
            return footerPanelControllerSize
        }
    }
    
    override func viewDidLoad()
    {
        self.view.addSubview(self.footerPanelController.view)
        self.view.addSubview(self.contactsInputOverviewController.view)
    }
    
    override func render(size: CGSize)
    {
        super.render(size: size)

        self.footerPanelController.render(size: self.footerPanelControllerSize)
        self.contactsInputOverviewController.render(size: self.contactsInputOverviewControllerSize)
        
        self.footerPanelController.view.frame.origin.y = self.contactsInputOverviewController.view.frame.size.height
    }
    
    override func bind(viewModel: ContactsFormDetailViewModel)
    {
        super.bind(viewModel: viewModel)
        
        self.viewModel.delegate = self
        self.viewModel.keyboardViewModel.delegate = self
        
        
        NotificationCenter.default.addObserver(self.viewModel.keyboardViewModel,
                                               selector: #selector(self.viewModel.keyboardViewModel.keyboardWillShow(notification:)),
                                               name: NSNotification.Name.UIKeyboardWillShow,
                                               object: nil)
        NotificationCenter.default.addObserver(self.viewModel.keyboardViewModel,
                                               selector: #selector(self.viewModel.keyboardViewModel.keyboardWillResign(notification:)),
                                               name: NSNotification.Name.UIKeyboardWillHide,
                                               object: nil)
        self.contactsInputOverviewController.bind(viewModel: self.viewModel.contactsInputOverviewViewModel)
        self.footerPanelController.bind(viewModel: self.viewModel.footerPanelViewModel)
        
        self.viewModel.footerPanelViewModel.addObserver(self,
                                               forKeyPath: "event",
                                               options: NSKeyValueObservingOptions([NSKeyValueObservingOptions.new,
                                                                                    NSKeyValueObservingOptions.initial]),
                                               context: nil)
    }
    
    override func unbind()
    {
        self.viewModel.delegate = nil
        
        self.contactsInputOverviewController.unbind()
        self.footerPanelController.unbind()
        
        self.viewModel.footerPanelViewModel.removeObserver(self, forKeyPath: "event")
        
        super.unbind()
    }
    
    override func shouldSetKeyPath(_ keyPath: String?, ofObject object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?)
    {
        if (keyPath == "event")
        {
            let newValue = change![NSKeyValueChangeKey.newKey] as! String
            
            if (self.viewModel.footerPanelViewModel === object as! NSObject)
            {
                if (newValue == "DidConfirm")
                {
                    self.viewModel.createContacts()
                }
                else if (newValue == "DidCancel")
                {
                    self.viewModel.exitContacts()
                }
            }
        }
    }
    
    func viewModel(_ viewModel: DynamicViewModel, transition: String, from oldState: String, to newState: String)
    {
        if (viewModel === self.viewModel.keyboardViewModel)
        {
            if (transition == "KeyboardWillShow")
            {
                let keyboardFrame = self.viewModel.keyboardViewModel.keyboardFrame
                let contentInsets = UIEdgeInsetsMake(0, 0, self.contactsInputOverviewController.listView.convert(keyboardFrame!, from: nil).intersection(self.contactsInputOverviewController.listView.bounds).height, 0)
                self.contactsInputOverviewController.listView.scrollIndicatorInsets = contentInsets
                self.contactsInputOverviewController.listView.contentInset = contentInsets
            }
            else if (transition == "KeyboardWillResign")
            {
                let contentInsets = UIEdgeInsetsMake(0, 0, 0, 0)
                self.contactsInputOverviewController.listView.scrollIndicatorInsets = contentInsets
                self.contactsInputOverviewController.listView.contentInset = contentInsets
            }
        }
        
        else if (viewModel === self.viewModel)
        {
            if (newState == "Completion")
            {
                var contactInfoModels = [ContactInfoModel]()
                
                let contactInfoName = ContactInfoModel()
                contactInfoName.label = self.viewModel.contactsPhoneNumberInputViewModel.title
                contactInfoName.display = self.viewModel.contactsPhoneNumberInputViewModel.inputViewModel.value
                contactInfoModels.append(contactInfoName)
                
                let contactInfoEmail = ContactInfoModel()
                contactInfoEmail.label = self.viewModel.contactsEmailInputViewModel.title
                contactInfoEmail.display = self.viewModel.contactsEmailInputViewModel.inputViewModel.value
                contactInfoModels.append(contactInfoEmail)
                
                let contactInfoAddress = ContactInfoModel()
                contactInfoAddress.label = self.viewModel.contactsAddressInputViewModel.title
                contactInfoAddress.display = self.viewModel.contactsAddressInputViewModel.inputViewModel.value
                contactInfoModels.append(contactInfoAddress)
                
                let contactModel = ContactModel()
                contactModel.name = self.viewModel.contactsNameInputViewModel.inputViewModel.value
                contactModel.relation = self.viewModel.contactsRelationInputViewModel.inputViewModel.value
                contactModel.contactInfoModels = contactInfoModels
                
                self.contactStore.push(contactModel, isNetworkEnabled: false)
                .then
                { (value) -> Any? in
                    
                    self.contactStore.encodeModels()
                    
                    return nil
                }
            }
        }
    }
}

