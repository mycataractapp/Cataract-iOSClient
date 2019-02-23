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
    private var _button : UIButton!
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
            
            let titleLabel = self._titleLabel!
            
            return titleLabel
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
    
    @objc var button : UIButton
    {
        get
        {
            if (self._button == nil)
            {
                self._button = UIButton()
                self._button.setImage(UIImage(contentsOfFile: Bundle.main.path(forResource: "EditArrow", ofType: "png")!),
                                      for: UIControlState.normal)
            }
            
            let button = self._button!
            
            return button
        }
    }

    override func viewDidLoad()
    {
        self.view.backgroundColor = UIColor.white
        
        self.view.addSubview(self.titleLabel)
        self.view.addSubview(self.dateLabel)
        self.view.addSubview(self.timeLabel)
        self.view.addSubview(self.button)
    }
    
    override func render()
    {
        self.view.frame.size = self.viewModel.size
                                
        self.titleLabel.font = UIFont.boldSystemFont(ofSize: 24)
        self.dateLabel.font = UIFont.systemFont(ofSize: 18)
        self.timeLabel.font = UIFont.systemFont(ofSize: 18)
        
        self.titleLabel.frame.size.width = self.view.frame.size.width - 5
        self.titleLabel.frame.size.height = 70
        
        self.dateLabel.sizeToFit()
        self.dateLabel.frame.size.height = self.titleLabel.frame.size.height
        
        self.timeLabel.frame.size.width = self.titleLabel.frame.size.width
        self.timeLabel.frame.size.height = self.titleLabel.frame.size.height
        
        self.button.frame.size.width = 20
        self.button.frame.size.height = self.button.frame.size.width
        
        self.titleLabel.frame.origin.x = 2.5
        self.titleLabel.frame.origin.y = (self.view.frame.size.height - self.titleLabel.frame.size.height - self.dateLabel.frame.size.height - self.timeLabel.frame.size.height - 5) / 2
        
        self.dateLabel.frame.origin.x = (self.view.frame.size.width - self.dateLabel.frame.size.width) / 2
        self.dateLabel.frame.origin.y = self.titleLabel.frame.origin.y + self.titleLabel.frame.size.height + 2.5
        
        self.timeLabel.frame.origin.x =  self.titleLabel.frame.origin.x
        self.timeLabel.frame.origin.y = self.dateLabel.frame.origin.y + self.dateLabel.frame.size.height + 2.5
        
        self.button.frame.origin.x = self.view.frame.size.width - self.button.frame.size.width - 10
        self.button.center.y = self.dateLabel.center.y
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
    
    class CollectionController : DynamicController, UITableViewDelegate, UITableViewDataSource, DynamicViewModelDelegate
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
                    self._tableViewController.tableView.separatorStyle = .none
                    self._tableViewController.tableView.allowsSelection = false
                }
                
                let tableViewController = self._tableViewController!
                
                return tableViewController
            }
        }

        override func viewDidLoad()
        {
            self.tableViewController.tableView.backgroundColor = UIColor.white
            self.tableViewController.tableView.register(AppointmentCardController.Cell.self,
                                                        forCellReuseIdentifier: AppointmentCardViewModel.description())
            
            self.view.addSubview(self.tableViewController.tableView)
        }
        
        override func render()
        {
            self.tableViewController.tableView.reloadData()
        }

        override func unbind()
        {
            super.unbind()
            
            self.removeObserver(self, forKeyPath: "viewModel.appointmentMenuOverlayViewModel.event")
            
            for appointmentCardController in self._appointmentCardControllers
            {
                appointmentCardController.unbind()
            }
        }

        override func observeController(for controllerEvent: DynamicController.Event, kvoEvent: DynamicKVO.Event)
        {
            if (kvoEvent.keyPath == DynamicKVO.keyPath(\CollectionController.viewModel))
            {
                if (controllerEvent.operation == DynamicController.Event.Operation.bind)
                {
                    self.viewModel.delegate = self
                }
                else
                {
                    self.viewModel.delegate = nil
                }
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
            let cell = self.tableViewController.tableView.dequeueReusableCell(withIdentifier: AppointmentCardViewModel.description()) as! AppointmentCardController.Cell
            cell.appointmentCardController.viewModel = appointmentCardViewModel
            cell.appointmentCardController.button.addTarget(self,
                                                            action: #selector(self._deleteButton(sender:)),
                                                            for: UIControlEvents.touchDown)
            cell.appointmentCardController.button.layer.setValue(indexPath.row, forKey: "Index")
            
            self._appointmentCardControllers.insert(cell.appointmentCardController)
            
            return cell
        }
        
        func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
        {
            var heightForRowAt : CGFloat = 0
            let appointmentCardViewModel = self.viewModel.appointmentCardViewModels[indexPath.row]
            heightForRowAt = appointmentCardViewModel.size.height

            return heightForRowAt
        }
        
        @objc private func _deleteButton(sender: UIButton)
        {
            self.viewModel.buttonInt = sender.layer.value(forKey: "Index") as? Int
            
            self.viewModel.enterMenu()
        }
        
        func viewModel(_ viewModel: DynamicViewModel, transitWith event: DynamicViewModel.Event)
        {
        }
    }
}
