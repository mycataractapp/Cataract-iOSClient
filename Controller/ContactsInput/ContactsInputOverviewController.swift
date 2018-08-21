//
//  ContactsInputOverviewController.swift
//  Cataract
//
//  Created by Rose Choi on 7/30/18.
//  Copyright © 2018 Rose Choi. All rights reserved.
//

import UIKit

class ContactsInputOverviewController : DynamicController<ContactsInputOverviewViewModel>, UIListViewDataSource, UIListViewDelegate
{
    private var _listView : UIListView!
    private var _contactsInputQueue : DynamicQueue<ContactsInputController>!
    
    var listView : UIListView
    {
        get
        {
            if (self._listView == nil)
            {
                self._listView = UIListView()
                self._listView.dataSource = self
                self._listView.delegate = self
                self._listView.anchorPosition = UIListViewScrollPosition.middle
            }
            
            let listView = self._listView!
            
            return listView
        }
    }
    
    var contactsInputQueue : DynamicQueue<ContactsInputController>
    {
        get
        {
            if (self._contactsInputQueue == nil)
            {
                self._contactsInputQueue = DynamicQueue()
            }
            
            let contactsInputQueue = self._contactsInputQueue!
            
            return contactsInputQueue
        }
    }
    
    var contactsInputControllerSize : CGSize
    {
        get
        {
            var contactsInputControllerSize = CGSize.zero
            contactsInputControllerSize.width = self.listView.frame.size.width
            contactsInputControllerSize.height = self.canvas.draw(tiles: 5)
            
            return contactsInputControllerSize
        }
    }
    
    override func viewDidLoad()
    {
        self.view.addSubview(self.listView)
        
        self.listView.backgroundColor = UIColor.white
    }
    
    override func render(size: CGSize)
    {
        super.render(size: size)
                
        self.listView.frame.size = self.view.frame.size
    }
    
    override func unbind()
    {        
        self.contactsInputQueue.purge
        { (identifer, contactsInputController) in
            
            contactsInputController.unbind()
        }
    }
    
    func listView(_ listView: UIListView, numberOfItemsInSection section: Int) -> Int
    {
        return self.viewModel.contactsInputViewModels.count
    }
    
    func listView(_ listView: UIListView, sizeForItemAt indexPath: IndexPath) -> CGSize
    {
        var itemSize = CGSize(width: UIListViewAutomaticDimension, height: UIListViewAutomaticDimension)
        let contactsInputController = self.contactsInputQueue.retrieveElement(withIdentifier: String(indexPath.item))
        
        if (contactsInputController != nil)
        {
            itemSize.height = contactsInputController!.view.frame.size.height
        }
        
        return itemSize
    }
    
    func listView(_ listView: UIListView, cellForItemAt indexPath: IndexPath) -> UIListViewCell
    {
        let cell = UIListViewCell()
        
        let contactsInputController = self.contactsInputQueue.dequeueElement(withIdentifier: String(indexPath.item))
        { () -> ContactsInputController in
            
            let contactsInputController = ContactsInputController()
            
            return contactsInputController
        }
        
        let contactsInputViewModel = self.viewModel.contactsInputViewModels[indexPath.item]
        contactsInputController.bind(viewModel: contactsInputViewModel)
        contactsInputController.render(size: self.contactsInputControllerSize)
        cell.addSubview(contactsInputController.view)
        
        return cell
    }
    
    func listView(_ listView: UIListView, didEndDisplaying cell: UIListViewCell, forItemAt indexPath: IndexPath)
    {
        self.contactsInputQueue.enqueueElement(withIdentifier: String(indexPath.item))
        { (contactsInputController) in
            
            if (contactsInputController != nil)
            {
                contactsInputController?.unbind()
            }
        }
    }
}
