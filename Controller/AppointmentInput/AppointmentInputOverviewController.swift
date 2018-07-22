//
//  AppointmentInputOverviewController.swift
//  Cataract
//
//  Created by Rose Choi on 7/12/18.
//  Copyright © 2018 Rose Choi. All rights reserved.
//

import UIKit

class AppointmentInputOverviewController : DynamicController<AppointmentInputOverviewViewModel>, UIListViewDelegate, UIListViewDataSource
{
    private var _listView : UIListView!
    private var _appointmentInputQueue : DynamicQueue<AppointmentInputController>!
    
    var listView : UIListView
    {
        get
        {
            if (self._listView == nil)
            {
                self._listView = UIListView()
                self._listView.delegate = self
                self._listView.dataSource = self
            }
            
            let listView = self._listView!
            
            return listView
        }
    }
    
    var appointmentInputQueue : DynamicQueue<AppointmentInputController>
    {
        get
        {
            if (self._appointmentInputQueue == nil)
            {
                self._appointmentInputQueue = DynamicQueue()
            }
            
            let appointmentInputQueue = self._appointmentInputQueue!
            
            return appointmentInputQueue
        }
    }
    
    var appointmentInputControllerSize : CGSize
    {
        get
        {
            var appointmentInputControllerSize = CGSize.zero
            appointmentInputControllerSize.width = self.view.frame.size.width - self.canvas.draw(tiles: 1)
            appointmentInputControllerSize.height = self.canvas.draw(tiles: 3)
            
            return appointmentInputControllerSize
        }
    }

    override func viewDidLoad()
    {
        self.view.addSubview(self.listView)
    }
    
    override func render(size: CGSize)
    {
        super.render(size: size)
        
        self.listView.frame.size = self.view.frame.size
    }
    
    override func unbind()
    {
        self.appointmentInputQueue.purge
        { (identifier, appointmentInputController) in
            
            appointmentInputController.unbind()
        }
        
        super.unbind()
    }
    
    func listView(_ listView: UIListView, numberOfItemsInSection section: Int) -> Int
    {
        return self.viewModel.appointmentInputViewModels.count
    }
    
    func listView(_ listView: UIListView, sizeForItemAt indexPath: IndexPath) -> CGSize
    {
        var itemSize = CGSize(width: UIListViewAutomaticDimension, height: UIListViewAutomaticDimension)
        let appointmentInputController = self.appointmentInputQueue.retrieveElement(withIdentifier: String(indexPath.item))
        
        if (appointmentInputController != nil)
        {
            itemSize.height = appointmentInputController!.view.frame.size.height + self.canvas.draw(tiles: 0.5)
        }
        
        return itemSize
    }
    
    func listView(_ listView: UIListView, cellForItemAt indexPath: IndexPath) -> UIListViewCell
    {
        let cell = UIListViewCell()
        
        let appointmentInputController = self.appointmentInputQueue.dequeueElement(withIdentifier: String(indexPath.item))
        { () -> AppointmentInputController in
            
            let appointmentInputController = AppointmentInputController()
            
            return appointmentInputController
        }
        
        let appointmentInputViewModel = self.viewModel.appointmentInputViewModels[indexPath.item]
        appointmentInputController.bind(viewModel: appointmentInputViewModel)
        appointmentInputController.render(size: self.appointmentInputControllerSize)
        appointmentInputController.view.frame.origin.x = self.canvas.draw(tiles: 0.5)
        appointmentInputController.view.frame.origin.y = self.canvas.draw(tiles: 0.5)
        
        cell.layer.masksToBounds = false
        cell.layer.shadowColor = UIColor.black.cgColor
        cell.layer.shadowOpacity = 0.10
        cell.layer.shadowRadius = 2
        
        cell.addSubview(appointmentInputController.view)
        
        return cell
    }
    
    func listView(_ listView: UIListView, didEndDisplaying cell: UIListViewCell, forItemAt indexPath: IndexPath)
    {
        self.appointmentInputQueue.enqueueElement(withIdentifier: String(indexPath.item))
        { (appointmentInputController) in
            
            if (appointmentInputController != nil)
            {
                appointmentInputController!.unbind()
            }
        }
    }
    
    func listView(_ listView: UIListView, willSelectItemAt indexPath: IndexPath) -> IndexPath?
    {
        
        self.viewModel.toggle(at: indexPath.item)
        
        return indexPath
    }
}
