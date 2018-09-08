//
//  AppointmentTimeController.swift
//  Cataract
//
//  Created by Roseanne Choi on 6/8/18.
//  Copyright © 2018 Roseanne Choi. All rights reserved.
//

import UIKit

class AppointmentTimeController : DynamicController<AppointmentTimeViewModel>, DynamicViewModelDelegate
{
    private var _titleLabel : UILabel!
    private var _dateLabel : UILabel!
    private var _timeLabel : UILabel!
    private var _periodLabel : UILabel!
    private var _lineView : UIView!
    private var _button : UIButton!
    
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
    
    var periodLabel : UILabel
    {
        get
        {
            if (self._periodLabel == nil)
            {
                self._periodLabel = UILabel()
                self._periodLabel.textColor = UIColor.gray
            }
            
            let periodLabel = self._periodLabel!
            
            return periodLabel
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
    
    var button : UIButton
    {
        get
        {
            if (self._button == nil)
            {
                self._button = UIButton()
                self._button.setImage(UIImage(contentsOfFile: Bundle.main.path(forResource: "Delete", ofType: "png")!), for: UIControlState.normal)
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
        self.view.addSubview(self.periodLabel)
        self.view.addSubview(self.lineView)
        self.view.addSubview(self.button)
    }
    
    override func render(size: CGSize)
    {
        super.render(size: size)
        
        self.titleLabel.font = UIFont.boldSystemFont(ofSize: 24)
        self.dateLabel.font = UIFont.systemFont(ofSize: 18)
        self.timeLabel.font = UIFont.systemFont(ofSize: 18)
        self.periodLabel.font = UIFont.systemFont(ofSize: 18)
        
        self.titleLabel.frame.size.width = self.canvas.gridSize.width - self.canvas.draw(tiles: 1)
        self.titleLabel.frame.size.height = self.canvas.draw(tiles: 2)
        
        self.dateLabel.frame.size.width = self.titleLabel.frame.size.width
        self.dateLabel.frame.size.height = self.titleLabel.frame.size.height
        
        self.timeLabel.frame.size.width = self.titleLabel.frame.size.width
        self.timeLabel.frame.size.height = self.titleLabel.frame.size.height
        
        self.periodLabel.sizeToFit()
        self.periodLabel.frame.size.height = self.timeLabel.frame.size.height
        
        self.button.frame.size.width = self.canvas.draw(tiles: 1)
        self.button.frame.size.height = self.button.frame.size.width
        
        self.lineView.frame.size.width = self.view.frame.size.width - self.canvas.draw(tiles: 1)
        self.lineView.frame.size.height = 1
        
        self.titleLabel.frame.origin.x = self.canvas.draw(tiles: 0.15)
        self.titleLabel.frame.origin.y = (self.canvas.gridSize.height - self.titleLabel.frame.size.height - self.dateLabel.frame.size.height - self.timeLabel.frame.size.height - self.canvas.draw(tiles: 1)) / 2
        
        self.dateLabel.frame.origin.x =  self.titleLabel.frame.origin.x
        self.dateLabel.frame.origin.y = self.titleLabel.frame.origin.y + self.titleLabel.frame.size.height + self.canvas.draw(tiles: 0.5)
        
        self.timeLabel.frame.origin.x =  self.titleLabel.frame.origin.x
        self.timeLabel.frame.origin.y = self.dateLabel.frame.origin.y + self.dateLabel.frame.size.height + self.canvas.draw(tiles: 0.5)
        
        self.periodLabel.frame.origin.x = self.timeLabel.frame.origin.x + self.timeLabel.frame.size.width + self.canvas.draw(tiles: 0.15)
        self.periodLabel.frame.origin.y = self.timeLabel.frame.origin.y
        
        self.lineView.frame.origin.x = self.canvas.draw(tiles: 1)
        self.lineView.frame.origin.y = self.view.frame.size.height - self.lineView.frame.size.height
        
        self.button.frame.origin.x = self.view.frame.size.width - self.button.frame.size.width - self.canvas.draw(tiles: 0.5)
        self.button.frame.origin.y = self.titleLabel.frame.origin.y
    }
    
    override func bind(viewModel: AppointmentTimeViewModel)
    {
        super.bind(viewModel: viewModel)
        
        self.viewModel.delegate = self
        
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
        self.button.addTarget(self.viewModel,
                              action: #selector(self.viewModel.remove),
                              for: UIControlEvents.touchDown)
    }
    
    override func unbind()
    {
        self.viewModel.delegate = nil
        
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
    
    func viewModel(_ viewModel: DynamicViewModel, transition: String, from oldState: String, to newState: String)
    {
        
    }
}
