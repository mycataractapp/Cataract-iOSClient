//
//  ContactsOverviewController.swift
//  Cataract
//
//  Created by Rose Choi on 7/26/18.
//  Copyright © 2018 Rose Choi. All rights reserved.
//

import UIKit
import CareKit

class ContactsOverviewController : DynamicController<ContactsOverviewViewModel>, UITableViewDelegate
{
    private var _navigationController : UINavigationController!
    private var _connectViewController : OCKConnectViewController!
    private var _contactStore : ContactStore!
    
    override var navigationController: UINavigationController
    {
        get
        {
            if (self._navigationController == nil)
            {
                self._navigationController = UINavigationController()
                self._navigationController.pushViewController(self.connectViewController, animated: false)
//                self.connectViewController.navigationItem.setRightBarButton(UIBarButtonItem(title: "delete", style: UIBarButtonItemStyle.plain, target: nil, action: nil), animated: false)
                

            }
            
            let navigationController = self._navigationController!
            
            return navigationController
        }
    }
    
    var connectViewController : OCKConnectViewController
    {
        get
        {
            if (self._connectViewController == nil)
            {
                let buttonItem = UIBarButtonItem(title: "hey", style: UIBarButtonItemStyle.plain, target: nil, action: nil)
                self._connectViewController = OCKConnectViewController(contacts: nil)
//                self._connectViewController.tableView.delegate = self
//                self._connectViewController.navigationItem.setRightBarButton(buttonItem, animated: false)
//                self._connectViewController.tableView.register(<#T##cellClass: AnyClass?##AnyClass?#>, forCellReuseIdentifier: <#T##String#>)
            }
            
            let connectViewController = self._connectViewController!
            
            return connectViewController
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
 
    override func viewDidLoad()
    {
        self.view.addSubview(self.navigationController.view)
    }
    
    override func render(size: CGSize)
    {
        super.render(size: size)
        
        self.navigationController.view.frame.size = self.view.frame.size
    }
    
    override func bind(viewModel: ContactsOverviewViewModel)
    {
        super.bind(viewModel: viewModel)
        
        self.contactStore.addObserver(self,
                                      forKeyPath: "models",
                                      options: NSKeyValueObservingOptions([NSKeyValueObservingOptions.new,
                                                                           NSKeyValueObservingOptions.initial]),
                                      context: nil)
    }
    
    override func unbind()
    {
        super.unbind()
    }
}
