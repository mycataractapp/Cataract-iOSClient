//
//  AppointmentController.swift
//  Cataract
//
//  Created by Rose Choi on 6/9/18.
//  Copyright © 2018 Rose Choi. All rights reserved.
//

import UIKit

class AppointmentController : DynamicController<AppointmentViewModel>
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
                self._titleLabel.textAlignment = NSTextAlignment.center
                self._titleLabel.textColor = UIColor.white
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
                self._dateLabel.textAlignment = NSTextAlignment.center
                self._dateLabel.textColor = UIColor.white
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
                self._timeLabel.textColor = UIColor.white
            }
            
            let timeLabel = self._timeLabel!
            
            return timeLabel
        }
    }
    
    override func viewDidLoad()
    {
        self.view.backgroundColor = UIColor(red: 0/255, green: 0/255, blue: 144/255, alpha: 1)
        self.view.clipsToBounds = true
        
        self.view.addSubview(self.titleLabel)
        self.view.addSubview(self.dateLabel)
        self.view.addSubview(self.timeLabel)
    }
    
    override func render(size: CGSize)
    {
        super.render(size: size)
        
//        self.view.layer.cornerRadius = 15
        
        self.titleLabel.font = UIFont.boldSystemFont(ofSize: 36)
        self.dateLabel.font = UIFont.systemFont(ofSize: 36)
        self.timeLabel.font = UIFont.systemFont(ofSize: 36)
        
        self.titleLabel.frame.size.width = self.canvas.gridSize.width - self.canvas.draw(tiles: 1)
        self.titleLabel.frame.size.height = self.canvas.draw(tiles: 2)
        
        self.dateLabel.frame.size.width = self.canvas.gridSize.width - self.canvas.draw(tiles: 1)
        self.dateLabel.frame.size.height = self.canvas.draw(tiles: 2)
        
        self.timeLabel.frame.size.width = self.canvas.gridSize.width - self.canvas.draw(tiles: 1)
        self.timeLabel.frame.size.height = self.canvas.draw(tiles: 2)

        self.titleLabel.frame.origin.x = (self.canvas.gridSize.width - self.titleLabel.frame.size.width) / 2
        self.titleLabel.frame.origin.y = (self.canvas.gridSize.height - self.titleLabel.frame.size.height - self.dateLabel.frame.size.height - self.timeLabel.frame.size.height) / 2
        
        self.dateLabel.frame.origin.x = self.titleLabel.frame.origin.x
        self.dateLabel.frame.origin.y = self.titleLabel.frame.origin.y + self.titleLabel.frame.size.height + self.canvas.draw(tiles: 0.5)
        
        self.timeLabel.frame.origin.x = self.titleLabel.frame.origin.x
        self.timeLabel.frame.origin.y = self.dateLabel.frame.origin.y + self.dateLabel.frame.size.height + self.canvas.draw(tiles: 0.5)
    }
    
    override func bind(viewModel: AppointmentViewModel)
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
        self.dateLabel.text = date
    }
    
    func set(time: String)
    {
        self.timeLabel.text = time
    }
}
