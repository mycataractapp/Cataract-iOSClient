//
//  ContactsFormDetailController.swift
//  Cataract
//
//  Created by Rose Choi on 7/30/18.
//  Copyright © 2018 Rose Choi. All rights reserved.
//

import UIKit

class ContactsFormDetailController : DynamicController, DynamicViewModelDelegate
{
    private var _label : UILabel!
    private var _contactsInputOverviewController : ContactsInputOverviewController!
    private var _footerPanelController : FooterPanelController!
    private var _contactStore : ContactStore!

    var label : UILabel
    {
        get
        {
            if (self._label == nil)
            {
                self._label = UILabel()
                self.label.text = "Add Emergency Contact"
                self.label.textAlignment = NSTextAlignment.center
                self.label.textColor = UIColor(red: 51/255, green: 128/255, blue: 185/255, alpha: 1)
            }
            
            let label = self._label!
            
            return label
        }
    }
    
    var contactsInputOverviewController : ContactsInputOverviewController
    {
        get
        {
            if (self._contactsInputOverviewController == nil)
            {
                self._contactsInputOverviewController = ContactsInputOverviewController()
                self._contactsInputOverviewController.listView.listHeaderView = self.label
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
            contactsInputOverviewControllerSize.height = self.view.frame.size.height
            
            return contactsInputOverviewControllerSize
        }
    }
    
    var footerPanelControllerSize : CGSize
    {
        get
        {
            var footerPanelControllerSize = CGSize.zero
            footerPanelControllerSize.width = self.view.frame.size.width
            footerPanelControllerSize.height = canvas.draw(tiles: 3)
            
            return footerPanelControllerSize
        }
    }
    
    override func viewDidLoad()
    {
        self.view.addSubview(self.contactsInputOverviewController.view)
        self.view.addSubview(self.footerPanelController.view)
    }
    
    override func render(canvas: DynamicCanvas) -> DynamicCanvas
    {
        super.render(canvas: canvas)
        self.view.frame.size = canvas.size

        self.label.font = UIFont.systemFont(ofSize: 24)

        self.label.frame.size.width = self.contactsInputOverviewController.view.frame.size.width - canvas.draw(tiles: 1)
        self.label.frame.size.height = canvas.draw(tiles: 2)
        self.label.frame.origin.x = canvas.draw(tiles: 0.5)

        self.footerPanelController.view.frame.origin.y = self.contactsInputOverviewController.view.frame.size.height - self.footerPanelController.view.frame.size.height
        
        return canvas
    }
    
    override func bind()
    {
        super.bind()
        
        self.viewModel.delegate = self
        self.viewModel.keyboardViewModel.delegate = self
        
        
        NotificationCenter.default.addObserver(self.viewModel.keyboardViewModel,
                                               selector: #selector(self.viewModel.keyboardViewModel.keyboardWillShow(notification:)),
                                               name: NSNotification.Name.UIKeyboardWillShow,
                                               object: nil)
        self.contactsInputOverviewController.bind()
        self.footerPanelController.bind()
        
        self.viewModel.footerPanelViewModel.addObserver(self,
                                               forKeyPath: "event",
                                               options: NSKeyValueObservingOptions([NSKeyValueObservingOptions.new,
                                                                                    NSKeyValueObservingOptions.initial]),
                                               context: nil)
    }
    
    override func unbind()
    {
        super.unbind()
        
        self.viewModel.delegate = nil
        
        self.contactsInputOverviewController.unbind()
        self.footerPanelController.unbind()
        
        self.viewModel.footerPanelViewModel.removeObserver(self, forKeyPath: "event")
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
                self.footerPanelController.view.frame.origin.y = self.contactsInputOverviewController.listView.frame.size.height - (keyboardFrame?.height)! - self.footerPanelController.view.frame.size.height
                let keyboardFrameInListView = self.contactsInputOverviewController.listView.convert(keyboardFrame!, from: nil)
                let keyboardIntersection = keyboardFrameInListView.intersection(self.contactsInputOverviewController.listView.bounds)
                let contentInsets = UIEdgeInsetsMake(0, 0, keyboardIntersection.height + self.footerPanelController.view.frame.size.height, 0)
                self.contactsInputOverviewController.listView.scrollIndicatorInsets = contentInsets
                self.contactsInputOverviewController.listView.contentInset = contentInsets
            }
        }
        
        else if (viewModel === self.viewModel)
        {
            if (newState == "Completion")
            {
                var contactInfoModels = [ContactInfoModel]()
                
                let contactInfoNameModel = ContactInfoModel()
                contactInfoNameModel.type = "PhoneNumber"
                contactInfoNameModel.label = self.viewModel.contactsPhoneNumberInputViewModel.title
                contactInfoNameModel.display = self.viewModel.contactsPhoneNumberInputViewModel.inputViewModel.value
                contactInfoModels.append(contactInfoNameModel)
                
                let contactInfoEmailModel = ContactInfoModel()
                contactInfoEmailModel.type = "Email"
                contactInfoEmailModel.label = self.viewModel.contactsEmailInputViewModel.title
                contactInfoEmailModel.display = self.viewModel.contactsEmailInputViewModel.inputViewModel.value
                contactInfoModels.append(contactInfoEmailModel)
                
                let contactModel = ContactModel()
                contactModel.name = self.viewModel.contactsNameInputViewModel.inputViewModel.value
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

