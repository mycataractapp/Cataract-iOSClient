//
//  AppointmentTimeOverviewController.swift
//  Cataract
//
//  Created by Rose Choi on 6/8/18.
//  Copyright © 2018 Rose Choi. All rights reserved.
//

import UIKit

class AppointmentTimeOverviewController : DynamicController<AppointmentTimeOverviewViewModel>, UIListViewDelegate, UIListViewDataSource, DynamicViewModelDelegate
{
    private var _listView : UIListView!
    private var _button : UIButton!
    private var _appointmentTimeQueue : DynamicQueue<AppointmentTimeController>!
    
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
    
    var button : UIButton
    {
        get
        {
            if (self._button == nil)
            {
                self._button = UIButton()
                self._button.setImage(UIImage(contentsOfFile: Bundle.main.path(forResource: "Add", ofType: "png")!),
                                      for: UIControlState.normal)
            }
            
            let button = self._button!
            
            return button
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
            appointmentTimeControllerSize.width = self.listView.frame.size.width - self.canvas.draw(tiles: 0.5)
            appointmentTimeControllerSize.height = self.canvas.draw(tiles: 9)
            
            return appointmentTimeControllerSize
        }
    }
    
    override func viewDidLoad()
    {
        self.view.addSubview(self.listView)
        self.view.addSubview(self.button)
    }
    
    override func render(size: CGSize)
    {
        super.render(size: size)
        
        self.button.frame.size.width = self.canvas.draw(tiles: 2)
        self.button.frame.size.height = self.button.frame.size.width
        self.button.frame.origin.x = self.view.frame.size.width - self.button.frame.size.width - self.canvas.draw(tiles: 1)
        self.button.frame.origin.y = self.view.frame.size.height - self.button.frame.size.height - self.canvas.draw(tiles: 0.5)
        
        self.listView.frame.size.width = self.view.frame.size.width
        self.listView.frame.size.height = self.view.frame.size.height - self.button.frame.size.height - self.canvas.draw(tiles: 0.75)
    }
    
    override func bind(viewModel: AppointmentTimeOverviewViewModel)
    {
        super.bind(viewModel: viewModel)
        
        self.viewModel.delegate = self
        
        self.button.addTarget(self.viewModel,
                              action: #selector(self.viewModel.addAppointment),
                              for: UIControlEvents.touchDown)
    }

    override func unbind()
    {
        self.viewModel.delegate = nil
        
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
            itemSize.height = appointmentTimeController!.view.frame.height + self.canvas.draw(tiles: 0.5)
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
        appointmentTimeController.view.frame.origin.x = self.canvas.draw(tiles: 0.25)
        appointmentTimeController.view.frame.origin.y = self.canvas.draw(tiles: 0.25)
        
        cell.layer.masksToBounds = false
        cell.layer.shadowColor = UIColor.black.cgColor
        cell.layer.shadowOpacity = 0.10
        cell.layer.shadowRadius = 2
        
        cell.addSubview(appointmentTimeController.view)
        
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
    
    func viewModel(_ viewModel: DynamicViewModel, transition: String, from oldState: String, to newState: String)
    {
        if (transition == "AddAppointment")
        {
        }
    }
}
