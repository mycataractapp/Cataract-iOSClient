//
//  AppointmentTimeOverviewController.swift
//  Cataract
//
//  Created by Roseanne Choi on 6/8/18.
//  Copyright © 2018 Roseanne Choi. All rights reserved.
//

import UIKit

class AppointmentTimeOverviewController : DynamicController<AppointmentTimeOverviewViewModel>, UIListViewDelegate, UIListViewDataSource
{
    private var _label : UILabel!
    private var _listView : UIListView!
    private var _appointmentTimeQueue : DynamicQueue<AppointmentTimeController>!
    
    var label : UILabel
    {
        get
        {
            if (self._label == nil)
            {
                self._label = UILabel()
                self._label.textColor = UIColor(red: 163/255, green: 163/255, blue: 164/255, alpha: 1)
                self._label.text = "No appointments"
            }
            
            let label = self._label!
            
            return label
        }
    }
    
    var listView : UIListView
    {
        get
        {
            if (self._listView == nil)
            {
                self._listView = UIListView()
                self._listView.delegate = self
                self._listView.dataSource = self
                self._listView.addSubview(self.label)
            }
            
            let listView = self._listView!
            
            return listView
        }
    }

    var appointmentTimeQueue : DynamicQueue<AppointmentTimeController>
    {
        get
        {
            if (self._appointmentTimeQueue == nil)
            {
                self._appointmentTimeQueue = DynamicQueue()
            }
            
            let appointmentTimeQueue = self._appointmentTimeQueue!
            
            return appointmentTimeQueue
        }
    }
    
    var appointmentTimeControllerSize : CGSize
    {
        get
        {
            var appointmentTimeControllerSize = CGSize.zero
            appointmentTimeControllerSize.width = self.listView.frame.size.width
            appointmentTimeControllerSize.height = self.canvas.draw(tiles: 9)
            
            return appointmentTimeControllerSize
        }
    }
    
    override func viewDidLoad()
    {
        self.view.addSubview(self.listView)
    }
    
    override func render(size: CGSize)
    {
        super.render(size: size)
        
        self.label.font = UIFont.systemFont(ofSize: 22)
        
        self.listView.frame.size = self.view.frame.size
        
        self.label.sizeToFit()
        self.label.frame.size.height = self.canvas.draw(tiles: 1)
        self.label.frame.origin.x = (self.view.frame.size.width - self.label.frame.size.width) / 2
        self.label.frame.origin.y = (self.view.frame.size.height - self.label.frame.size.height) / 2
    }
    
    override func bind(viewModel: AppointmentTimeOverviewViewModel)
    {
        super.bind(viewModel: viewModel)
    }

    override func unbind()
    {        
        self.appointmentTimeQueue.purge
        { (identifier, appointmentTimeController) in
                
            appointmentTimeController.unbind()
        }
        
        super.unbind()
    }
    
    func listView(_ listView: UIListView, numberOfItemsInSection section: Int) -> Int
    {
        return self.viewModel.appointmentTimeViewModels.count
    }
    
    func listView(_ listView: UIListView, sizeForItemAt indexPath: IndexPath) -> CGSize
    {
        var itemSize = CGSize(width: UIListViewAutomaticDimension, height: UIListViewAutomaticDimension)
        let appointmentTimeController = self.appointmentTimeQueue.retrieveElement(withIdentifier: String(indexPath.item))
        
        if (appointmentTimeController != nil)
        {
            itemSize.height = appointmentTimeController!.view.frame.height
        }
        
        return itemSize
    }
    
    func listView(_ listView: UIListView, cellForItemAt indexPath: IndexPath) -> UIListViewCell
    {
        let cell = UIListViewCell()
        
        let appointmentTimeController = self.appointmentTimeQueue.dequeueElement(withIdentifier: String(indexPath.item))
        { () -> AppointmentTimeController in
            
            let appointmentTimeController = AppointmentTimeController()
            
            return appointmentTimeController
        }
        
        let appointmentTimeViewModel = self.viewModel.appointmentTimeViewModels[indexPath.item]
        appointmentTimeController.bind(viewModel: appointmentTimeViewModel)
        appointmentTimeController.render(size: self.appointmentTimeControllerSize)

        cell.addSubview(appointmentTimeController.view)
        
        self.label.isHidden = true
        
        return cell
    }
    
    func listView(_ listView: UIListView, didEndDisplaying cell: UIListViewCell, forItemAt indexPath: IndexPath)
    {
        self.appointmentTimeQueue.enqueueElement(withIdentifier: String(indexPath.item))
        { (appointmentTimeController) in
            
            if (appointmentTimeController != nil)
            {
                appointmentTimeController!.unbind()
            }
        }
    }
}
