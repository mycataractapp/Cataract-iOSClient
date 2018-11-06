//
//  AppointmentCardController.swift
//  Cataract
//
//  Created by Roseanne Choi on 9/9/18.
//  Copyright © 2018 Roseanne Choi. All rights reserved.
//

import UIKit

class AppointmentCardController : DynamicController
{
    private var _titleLabel : UILabel!
    private var _dateLabel : UILabel!
    private var _timeLabel : UILabel!
    private var _lineView : UIView!
    @objc dynamic var viewModel : AppointmentCardViewModel!
    
    var titleLabel : UILabel
    {
        get
        {
            if (self._titleLabel == nil)
            {
                self._titleLabel = UILabel()
                self._titleLabel.textAlignment = NSTextAlignment.center
                self._titleLabel.textColor = UIColor(red: 51/255, green: 127/255, blue: 159/255, alpha: 1)
            }
            
            let titleLable = self._titleLabel!
            
            return titleLable
        }
    }
    
    var dateLabel : UILabel
    {
        get
        {
            if (self._dateLabel == nil)
            {
                self._dateLabel = UILabel()
                self.dateLabel.textAlignment = NSTextAlignment.center
            }
            
            let dateLabel = self._dateLabel!
            
            return dateLabel
        }
    }
    
    var timeLabel : UILabel
    {
        get
        {
            if (self._timeLabel == nil)
            {
                self._timeLabel = UILabel()
                self._timeLabel.textAlignment = NSTextAlignment.center
            }
            
            let timeLabel = self._timeLabel!
            
            return timeLabel
        }
    }

    var lineView : UIView
    {
        get
        {
            if (self._lineView == nil)
            {
                self._lineView = UIView()
                self._lineView.backgroundColor = UIColor(red: 234/255, green: 234/255, blue: 234/255, alpha: 1)
            }
            
            let lineView = self._lineView!
            
            return lineView
        }
    }

    override func viewDidLoad()
    {
        self.view.backgroundColor = UIColor.white
        
        self.view.addSubview(self.titleLabel)
        self.view.addSubview(self.dateLabel)
        self.view.addSubview(self.timeLabel)
//        self.view.addSubview(self.lineView)
    }
    
    override func render()
    {
        self.view.frame.size = self.viewModel.size
        
        self.titleLabel.font = UIFont.boldSystemFont(ofSize: 24)
        self.dateLabel.font = UIFont.systemFont(ofSize: 18)
        self.timeLabel.font = UIFont.systemFont(ofSize: 18)
        
        self.titleLabel.frame.size.width = self.view.frame.size.width - 5
        self.titleLabel.frame.size.height = 70
        
        self.dateLabel.frame.size.width = self.titleLabel.frame.size.width
        self.dateLabel.frame.size.height = self.titleLabel.frame.size.height
        
        self.timeLabel.frame.size.width = self.titleLabel.frame.size.width
        self.timeLabel.frame.size.height = self.titleLabel.frame.size.height

        self.lineView.frame.size.width = self.view.frame.size.width - 1
        self.lineView.frame.size.height = 1
        
        self.titleLabel.frame.origin.x = 2.5
        self.titleLabel.frame.origin.y = (self.view.frame.size.height - self.titleLabel.frame.size.height - self.dateLabel.frame.size.height - self.timeLabel.frame.size.height - 5) / 2
        
        self.dateLabel.frame.origin.x =  self.titleLabel.frame.origin.x
        self.dateLabel.frame.origin.y = self.titleLabel.frame.origin.y + self.titleLabel.frame.size.height + 2.5
        
        self.timeLabel.frame.origin.x =  self.titleLabel.frame.origin.x
        self.timeLabel.frame.origin.y = self.dateLabel.frame.origin.y + self.dateLabel.frame.size.height + 2.5
        
        self.lineView.frame.origin.x = 1
        self.lineView.frame.origin.y = self.view.frame.size.height - self.lineView.frame.size.height
    }
    
    override func bind()
    {
        super.bind()
        
        self.addObserver(self,
                         forKeyPath: DynamicKVO.keyPath(\AppointmentCardController.viewModel.title),
                         options: NSKeyValueObservingOptions([NSKeyValueObservingOptions.new,
                                                              NSKeyValueObservingOptions.initial]),
                         context: nil)
        self.addObserver(self,
                         forKeyPath: DynamicKVO.keyPath(\AppointmentCardController.viewModel.time),
                         options: NSKeyValueObservingOptions([NSKeyValueObservingOptions.new,
                                                              NSKeyValueObservingOptions.initial]),
                         context: nil)
        self.addObserver(self,
                         forKeyPath: DynamicKVO.keyPath(\AppointmentCardController.viewModel.date),
                         options: NSKeyValueObservingOptions([NSKeyValueObservingOptions.new,
                                                              NSKeyValueObservingOptions.initial]),
                         context: nil)
    }
    
    override func unbind()
    {
        super.unbind()
        
        self.removeObserver(self, forKeyPath: DynamicKVO.keyPath(\AppointmentCardController.viewModel.title))
        self.removeObserver(self, forKeyPath: DynamicKVO.keyPath(\AppointmentCardController.viewModel.time))
        self.removeObserver(self, forKeyPath: DynamicKVO.keyPath(\AppointmentCardController.viewModel.date))
    }
    
    override func observeKeyValue(for kvoEvent: DynamicKVO.Event)
    {
        if (kvoEvent.kind == DynamicKVO.Event.Kind.setting)
        {
            if (kvoEvent.keyPath == DynamicKVO.keyPath(\AppointmentCardController.viewModel.title))
            {
                let newValue = kvoEvent.newValue as? String
                self.set(title: newValue)
            }
            else if (kvoEvent.keyPath == DynamicKVO.keyPath(\AppointmentCardController.viewModel.time))
            {
                let newValue = kvoEvent.newValue as? String
                self.set(time: newValue)
            }
            else if (kvoEvent.keyPath == DynamicKVO.keyPath(\AppointmentCardController.viewModel.date))
            {
                let newValue = kvoEvent.newValue as? String
                self.set(date: newValue)
            }
        }
    }
    
    func set(title: String?)
    {
        self.titleLabel.text = title
    }
    
    func set(time: String?)
    {
        self.timeLabel.text = time
    }
    
    func set(date: String?)
    {
        self.dateLabel.text = date
    }
    
    class Cell : UITableViewCell
    {
        private var _appointmentCardController : AppointmentCardController!
        
        var appointmentCardController : AppointmentCardController
        {
            if (self._appointmentCardController == nil)
            {
                self._appointmentCardController = AppointmentCardController()
                self._appointmentCardController.bind()
                self.addSubview(self._appointmentCardController.view)
                self.autoresizesSubviews = false
            }
            
            let appointmentCardController = self._appointmentCardController!
            
            return appointmentCardController
        }
    }
    
    class CollectionController : DynamicController, UITableViewDelegate, UITableViewDataSource
    {
        private var _tableViewController : UITableViewController!
        private var _appointmentCardControllers = Set<AppointmentCardController>()
        @objc dynamic var viewModel : AppointmentCardViewModel.CollectionViewModel!
        
        var tableViewController : UITableViewController
        {
            get
            {
                if (self._tableViewController == nil)
                {
                    self._tableViewController = UITableViewController()
                    self._tableViewController.tableView.delegate = self
                    self._tableViewController.tableView.dataSource = self
                }
                
                let tableViewController = self._tableViewController!
                
                return tableViewController
            }
        }
        
        var tableView : UITableView
        {
            get
            {
                let tableView = self.tableViewController.tableView!
                
                return tableView
            }
        }
        
        override func viewDidLoad()
        {
            self.tableView.backgroundColor = UIColor.white
            self.tableView.register(AppointmentCardController.Cell.self, forCellReuseIdentifier: AppointmentCardViewModel.description())
            
            self.view.addSubview(self.tableView)
        }
        
        override func unbind()
        {
            super.unbind()
            
            for appointmentCardController in self._appointmentCardControllers
            {
                appointmentCardController.unbind()
            }
        }
        
        override func observeController(for controllerEvent: DynamicController.Event, kvoEvent: DynamicKVO.Event)
        {
            if (kvoEvent.keyPath == DynamicKVO.keyPath(\AppointmentCardController.viewModel))
            {
                self.tableView.reloadData()
            }
        }
        
        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
        {
            var numberOfRowsInSection = 0
            
            if (self.viewModel != nil)
            {
                numberOfRowsInSection = self.viewModel.appointmentCardViewModels.count
            }
            
            return numberOfRowsInSection
        }
        
        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
        {
            let appointmentCardViewModel = self.viewModel.appointmentCardViewModels[indexPath.row]
            let cell = self.tableView.dequeueReusableCell(withIdentifier: AppointmentCardViewModel.description()) as! AppointmentCardController.Cell
            appointmentCardViewModel.size = self.viewModel.itemSize
            cell.appointmentCardController.viewModel = appointmentCardViewModel
            
            return cell
        }
        
        func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
        {
            var heightForRowAt : CGFloat = 0
            let appointmentCardViewModel = self.viewModel.appointmentCardViewModels[indexPath.row]
            
            for appointmentCardController in self._appointmentCardControllers
            {
                if (appointmentCardController.viewModel === appointmentCardViewModel)
                {
                    heightForRowAt = appointmentCardController.view.frame.height
                    break
                }
            }
            
            return heightForRowAt
        }
    }
}
