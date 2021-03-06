//
//  AppointmentOverviewController.swift
//  Cataract
//
//  Created by Minh Nguyen on 9/8/18.
//  Copyright © 2018 Rose Choi. All rights reserved.
//

import Foundation

class AppointmentTimeOverviewController : DynamicController, UIListViewDelegate, UIListViewDataSource
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
            appointmentTimeControllerSize.height = canvas.draw(tiles: 9)
            
            return appointmentTimeControllerSize
        }
    }
    
    override func viewDidLoad()
    {
        self.view.addSubview(self.listView)
    }
    
    override func render(canvas: DynamicCanvas) -> DynamicCanvas
    {
        super.render(canvas: canvas)
        self.view.frame.size = canvas.size
        
        self.label.font = UIFont.systemFont(ofSize: 22)
        
        self.listView.frame.size = self.view.frame.size
        
        self.label.sizeToFit()
        self.label.frame.size.height = canvas.draw(tiles: 1)
        self.label.frame.origin.x = (self.view.frame.size.width - self.label.frame.size.width) / 2
        self.label.frame.origin.y = (self.view.frame.size.height - self.label.frame.size.height) / 2
        
        return canvas
    }
    
    override func unbind()
    {
        super.unbind()
        
        self.appointmentTimeQueue.purge
            { (identifier, appointmentTimeController) in
                
                appointmentTimeController.unbind()
        }
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
        appointmentTimeController.bind()
        appointmentTimeViewModel.addObserver(self,
                                             forKeyPath: "event",
                                             options: NSKeyValueObservingOptions([NSKeyValueObservingOptions.new,
                                                                                  NSKeyValueObservingOptions.initial]),
                                             context: nil)
        cell.addSubview(appointmentTimeController.view)
        
        self.label.isHidden = true
        
        return cell
    }
    
    func listView(_ listView: UIListView, didEndDisplaying cell: UIListViewCell, forItemAt indexPath: IndexPath)
    {
        let appointmentTimeViewModel = self.viewModel.appointmentTimeViewModels[indexPath.item]
        
        self.appointmentTimeQueue.enqueueElement(withIdentifier: String(indexPath.item))
        { (appointmentTimeController) in
            
            if (appointmentTimeController != nil)
            {
                appointmentTimeViewModel.removeObserver(self, forKeyPath: "event")
                appointmentTimeController!.unbind()
            }
        }
    }
    
    override func shouldSetKeyPath(_ keyPath: String?, ofObject object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?)
    {
        let newValue = change![NSKeyValueChangeKey.newKey] as! String
        
        if (keyPath == "event")
        {
            if (newValue == "DidRemove")
            {
                let appointmentTimeViewModel = object as! AppointmentTimeViewModel
                self.viewModel.selectId = appointmentTimeViewModel.id
                self.viewModel.Delete()
            }
        }
    }
    
    func listView(_ listView: UIListView, willSelectItemAt indexPath: IndexPath) -> IndexPath?
    {
        self.viewModel.Delete()
        
        return indexPath
    }
}
