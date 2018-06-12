//
//  AppointmentTimeController.swift
//  Cataract
//
//  Created by Rose Choi on 6/8/18.
//  Copyright © 2018 Rose Choi. All rights reserved.
//

import UIKit

class AppointmentTimeController : DynamicController<AppointmentTimeViewModel>
{
    private var _titleLabel : UILabel!
    private var _dateLabel : UILabel!
    private var _timeLabel : UILabel!
    
    var titleLabel : UILabel
    {
        get
        {
            if (self._titleLabel == nil)
            {
                self._titleLabel = UILabel()
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
                self.dateLabel.textColor = UIColor.gray
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
                self._timeLabel.textColor = UIColor.gray
            }
            
            let timeLabel = self._timeLabel!
            
            return timeLabel
        }
    }
    
    override func viewDidLoad()
    {
        self.view.backgroundColor = UIColor.white
        
        self.view.addSubview(self.titleLabel)
        self.view.addSubview(self.dateLabel)
        self.view.addSubview(self.timeLabel)
    }
    
    override func render(size: CGSize)
    {
        super.render(size: size)
        
        self.titleLabel.font = UIFont.systemFont(ofSize: 48)
        self.dateLabel.font = UIFont.systemFont(ofSize: 36)
        self.timeLabel.font = UIFont.systemFont(ofSize: 36)
        
        self.titleLabel.frame.size.width = self.canvas.gridSize.width - self.canvas.draw(tiles: 1)
        self.titleLabel.frame.size.height = self.canvas.draw(tiles: 2)
        
        self.dateLabel.sizeToFit()
        self.dateLabel.frame.size.height = self.titleLabel.frame.size.height
        
        self.timeLabel.sizeToFit()
        self.timeLabel.frame.size.height = self.titleLabel.frame.size.height
        
        self.titleLabel.frame.origin.x = self.canvas.draw(tiles: 0.15)
        self.titleLabel.frame.origin.y = (self.canvas.gridSize.height - self.titleLabel.frame.size.height - self.dateLabel.frame.size.height - self.timeLabel.frame.size.height - self.canvas.draw(tiles: 1)) / 2
        
        self.dateLabel.frame.origin.x =  self.titleLabel.frame.origin.x
        self.dateLabel.frame.origin.y = self.titleLabel.frame.origin.y + self.titleLabel.frame.size.height + self.canvas.draw(tiles: 0.5)
        
        self.timeLabel.frame.origin.x =  self.titleLabel.frame.origin.x
        self.timeLabel.frame.origin.y = self.dateLabel.frame.origin.y + self.dateLabel.frame.size.height + self.canvas.draw(tiles: 0.5)
    }
    
    override func bind(viewModel: AppointmentTimeViewModel)
    {
        super.bind(viewModel: viewModel)
        
        viewModel.addObserver(self,
                              forKeyPath: "title",
                              options: NSKeyValueObservingOptions([NSKeyValueObservingOptions.new,
                                                                   NSKeyValueObservingOptions.initial]),
                              context: nil)
        viewModel.addObserver(self,
                              forKeyPath: "date",
                              options: NSKeyValueObservingOptions([NSKeyValueObservingOptions.new,
                                                                   NSKeyValueObservingOptions.initial]),
                              context: nil)
        viewModel.addObserver(self,
                              forKeyPath: "time",
                              options: NSKeyValueObservingOptions([NSKeyValueObservingOptions.new,
                                                                   NSKeyValueObservingOptions.initial]),
                              context: nil)
    }
    
    override func unbind()
    {
        self.viewModel.removeObserver(self, forKeyPath: "title")
        self.viewModel.removeObserver(self, forKeyPath: "date")
        self.viewModel.removeObserver(self, forKeyPath: "time")

        super.unbind()
    }
    
    override func shouldSetKeyPath(_ keyPath: String?, ofObject object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?)
    {
        if (keyPath == "title")
        {
            let newValue = change![NSKeyValueChangeKey.newKey] as! String
            self.set(title: newValue)
        }
        else if (keyPath == "date")
        {
            let newValue = change![NSKeyValueChangeKey.newKey] as! String
            self.set(date: newValue)
        }
        else if (keyPath == "time")
        {
            let newValue = change![NSKeyValueChangeKey.newKey] as! String
            self.set(time: newValue)
        }
    }
    
    func set(title: String)
    {
        self.titleLabel.text = title
    }
    
    func set(date: String)
    {
        self.dateLabel.text = "Date: " + date
    }
    
    func set(time: String)
    {
        self.timeLabel.text = "Time: " + time
    }
}
