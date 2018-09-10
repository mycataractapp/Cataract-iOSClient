//
//  TimeController.swift
//  Cataract
//
//  Created by Roseanne Choi on 6/21/18.
//  Copyright © 2018 Roseanne Choi. All rights reserved.
//

import UIKit

class TimeController : DynamicController
{
    private var _timeLabel : UILabel!
    private var _periodLabel : UILabel!
    private var _lineView : UIView!
    
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

    var lineView : UIView
    {
        get
        {
            if (self._lineView == nil)
            {
                self._lineView = UIView()
                self._lineView.backgroundColor = UIColor(red: 234/255, green: 234/255, blue: 235/255, alpha: 1)
                
            }
            
            let lineView = self._lineView!
            
            return lineView
        }
    }
    
    override func viewDidLoad()
    {
        self.view.addSubview(self.timeLabel)
        self.view.addSubview(self.periodLabel)
        self.view.addSubview(self.lineView)
    }
    
    override func render(canvas: DynamicCanvas) -> DynamicCanvas
    {
        super.render(canvas: canvas)
        self.view.frame.size = canvas.size
        
        self.timeLabel.font = UIFont.systemFont(ofSize: 24)
        self.periodLabel.font = UIFont.systemFont(ofSize: 24)
        
        self.timeLabel.sizeToFit()
        
        self.periodLabel.sizeToFit()
        
        self.lineView.frame.size.width = self.view.frame.size.width - canvas.draw(tiles: 1)
        self.lineView.frame.size.height = 1
        
        self.timeLabel.frame.origin.x = (self.view.frame.size.width - self.timeLabel.frame.size.width - canvas.draw(tiles: 1.15)) / 2
        self.timeLabel.frame.origin.y = (self.view.frame.size.height - self.timeLabel.frame.size.height) / 2
        
        self.periodLabel.frame.origin.x = self.timeLabel.frame.origin.x + self.timeLabel.frame.size.width + canvas.draw(tiles: 0.15)
        self.periodLabel.frame.origin.y = self.timeLabel.frame.origin.y
        
        self.lineView.frame.origin.x = canvas.draw(tiles: 1)
        self.lineView.frame.origin.y = self.view.frame.size.height - self.lineView.frame.size.height
        
        return canvas
    }
    
    override func bind()
    {
        super.bind()
        
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
        super.unbind()
        
        self.viewModel.removeObserver(self, forKeyPath: "time")
        self.viewModel.removeObserver(self, forKeyPath: "period")
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
