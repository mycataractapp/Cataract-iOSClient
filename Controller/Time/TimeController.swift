//
//  TimeController.swift
//  Cataract
//
//  Created by Rose Choi on 6/21/18.
//  Copyright © 2018 Rose Choi. All rights reserved.
//

import UIKit

class TimeController : DynamicController<TimeViewModel>
{
    private var _timeLabel : UILabel!
    private var _periodLabel : UILabel!
    private var _numberedLabel : UILabel!
    private var _borderView : UIView!
    
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
                self._periodLabel.textAlignment = NSTextAlignment.center
            }
            
            let periodLabel = self._periodLabel!
            
            return periodLabel
        }
    }
    
    var numberedLabel : UILabel
    {
        get
        {
            if (self._numberedLabel == nil)
            {
                self._numberedLabel = UILabel()
                self._numberedLabel.textAlignment = NSTextAlignment.center
            }
            
            let numberedLabel = self._numberedLabel!
            
            return numberedLabel
        }
    }
    
    var borderView : UIView
    {
        get
        {
            if (self._borderView == nil)
            {
                self._borderView = UIView()
                self._borderView.backgroundColor = UIColor.lightGray
                
            }
            
            let borderView = self._borderView!
            
            return borderView
        }
    }
    
    override func viewDidLoad()
    {
        self.view.addSubview(self.timeLabel)
        self.view.addSubview(self.periodLabel)
        self.view.addSubview(self.numberedLabel)
        self.view.addSubview(self.borderView)
    }
    
    override func render(size: CGSize)
    {
        super.render(size: size)
        
        self.timeLabel.font = UIFont.systemFont(ofSize: 24)
        self.periodLabel.font = UIFont.systemFont(ofSize: 24)
        
        self.timeLabel.sizeToFit()
        
        self.periodLabel.sizeToFit()
        
        
        
        self.borderView.frame.size.width = self.view.frame.size.width - self.canvas.draw(tiles: 1)
        self.borderView.frame.size.height = 1
        
        self.timeLabel.frame.origin.x = (self.view.frame.size.width - self.timeLabel.frame.size.width - self.canvas.draw(tiles: 1.15)) / 2
        self.timeLabel.frame.origin.y = (self.view.frame.size.height - self.timeLabel.frame.size.height) / 2
        
        self.periodLabel.frame.origin.x = self.timeLabel.frame.origin.x + self.timeLabel.frame.size.width + self.canvas.draw(tiles: 0.15)
        self.periodLabel.frame.origin.y = self.timeLabel.frame.origin.y
        
        self.borderView.frame.origin.x = self.canvas.draw(tiles: 1)
        self.borderView.frame.origin.y = self.view.frame.size.height - self.borderView.frame.size.height
    }
    
    override func bind(viewModel: TimeViewModel)
    {
        super.bind(viewModel: viewModel)
        
        self.viewModel.addObserver(self,
                                   forKeyPath: "time",
                                   options: NSKeyValueObservingOptions([NSKeyValueObservingOptions.new,
                                                                        NSKeyValueObservingOptions.initial]),
                                   context: nil)
        self.viewModel.addObserver(self,
                                   forKeyPath: "period",
                                   options: NSKeyValueObservingOptions([NSKeyValueObservingOptions.new,
                                                                        NSKeyValueObservingOptions.initial]),
                                   context: nil)
    }
    
    override func unbind()
    {
        self.viewModel.removeObserver(self, forKeyPath: "time")
        self.viewModel.removeObserver(self, forKeyPath: "period")
        
        super.unbind()
    }
    
    override func shouldSetKeyPath(_ keyPath: String?, ofObject object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?)
    {
        if (keyPath == "time")
        {
            let newValue = change![NSKeyValueChangeKey.newKey] as! String
            self.set(time: newValue)
        }
        else if (keyPath == "period")
        {
            let newValue = change![NSKeyValueChangeKey.newKey] as! String
            self.set(period: newValue)
        }
    }
    
    func set(time: String)
    {
        self.timeLabel.text = time
    }
    
    func set(period: String)
    {
        self.periodLabel.text = period
    }
}
