//
//  DropController.swift
//  Cataract
//
//  Created by Roseanne Choi on 6/6/18.
//  Copyright © 2018 Roseanne Choi. All rights reserved.
//

import UIKit

class DropController : DynamicController, DynamicViewModelDelegate
{
    private var _button : UIButton!
    private var _dropLabel : UILabel!
    private var _timeLabel : UILabel!
    private var _periodLabel : UILabel!
    
    var button : UIButton
    {
        get
        {
            if (self._button == nil)
            {
                self._button = UIButton()
            }
            
            let button = self._button!
            
            return button
        }
    }
    
    var dropLabel : UILabel
    {
        get
        {
            if (self._dropLabel == nil)
            {
                self._dropLabel = UILabel()
                self._dropLabel.textAlignment = NSTextAlignment.left
                self._dropLabel.textColor = UIColor.gray
            }
            
            let dropLabel = self._dropLabel!
            
            return dropLabel
        }
    }
    
    var timeLabel : UILabel
    {
        get
        {
            if (self._timeLabel == nil)
            {
                self._timeLabel = UILabel()
                self._timeLabel.textColor = UIColor.black
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
                self._periodLabel.textColor = UIColor.black
            }
            
            let periodLabel = self._periodLabel!
            
            return periodLabel
        }
    }
    
    override func viewDidLoad()
    {
        self.view.backgroundColor = UIColor.white
        
        self.view.addSubview(self.button)
        self.view.addSubview(self.dropLabel)
        self.view.addSubview(self.timeLabel)
        self.view.addSubview(self.periodLabel)
    }
    
    override func render(canvas: DynamicCanvas) -> DynamicCanvas
    {
        super.render(canvas: canvas)
        self.view.frame.size = canvas.size
        
        self.dropLabel.font = UIFont.systemFont(ofSize: 36)
        self.timeLabel.font = UIFont.systemFont(ofSize: 48)
        self.periodLabel.font = UIFont.systemFont(ofSize: 36)
        
        self.button.frame.size.width = canvas.draw(tiles: 2)
        self.button.frame.size.height = self.button.frame.size.width
        
        self.timeLabel.sizeToFit()
        self.timeLabel.frame.size.height = canvas.draw(tiles: 2)
        
        self.periodLabel.frame.size.width = canvas.draw(tiles: 3)
        self.periodLabel.frame.size.height = canvas.draw(tiles: 2)
        
        self.dropLabel.frame.size.width = canvas.size.width - self.button.frame.size.width - canvas.draw(tiles: 0.45)
        self.dropLabel.frame.size.height = canvas.draw(tiles: 2)
        
        self.button.frame.origin.x = canvas.draw(tiles: 0.15)
        self.button.frame.origin.y = (canvas.size.height - self.button.frame.size.height - self.dropLabel.frame.size.height - canvas.draw(tiles: 0.15)) / 2
        
        self.timeLabel.frame.origin.x = self.button.frame.origin.x + self.button.frame.size.width + canvas.draw(tiles: 0.15)
        self.timeLabel.center.y = self.button.center.y
        
        self.periodLabel.frame.origin.x = self.timeLabel.frame.origin.x + self.timeLabel.frame.size.width + canvas.draw(tiles: 0.15)
        self.periodLabel.center.y = self.timeLabel.center.y
        
        self.dropLabel.frame.origin.x = self.timeLabel.frame.origin.x
        self.dropLabel.frame.origin.y = self.button.frame.origin.y + self.button.frame.size.height + canvas.draw(tiles: 0.15)
        
        return canvas
    }
    
    override func bind()
    {
        super.bind()
        
        self.viewModel.delegate = self
        
        self.button.addTarget(self.viewModel,
                              action: #selector(self.viewModel.toggle),
                              for: UIControlEvents.touchDown)
        viewModel.addObserver(self,
                              forKeyPath: "drop",
                              options: NSKeyValueObservingOptions([NSKeyValueObservingOptions.new,
                                                                   NSKeyValueObservingOptions.initial]),
                              context: nil)
        viewModel.addObserver(self,
                              forKeyPath: "time",
                              options: NSKeyValueObservingOptions([NSKeyValueObservingOptions.new,
                                                                   NSKeyValueObservingOptions.initial]),
                              context: nil)
        viewModel.addObserver(self,
                              forKeyPath: "period",
                              options: NSKeyValueObservingOptions([NSKeyValueObservingOptions.new,
                                                                   NSKeyValueObservingOptions.initial]),
                              context: nil)
    }
    
    override func unbind()
    {
        super.unbind()
        
        self.viewModel.delegate = nil
        self.button.removeTarget(self.viewModel, action: #selector(self.viewModel.toggle), for: UIControlEvents.touchDown)
        self.viewModel.removeObserver(self, forKeyPath: "drop")
        self.viewModel.removeObserver(self, forKeyPath: "time")
        self.viewModel.removeObserver(self, forKeyPath: "period")
    }
    
    override func shouldSetKeyPath(_ keyPath: String?, ofObject object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?)
    {
        if (keyPath == "colorPathByState")
        {
            let newValue = change![NSKeyValueChangeKey.newKey] as! String
            self.set(colorPathByState: newValue)
        }
        else if (keyPath == "drop")
        {
            let newValue = change![NSKeyValueChangeKey.newKey] as! String
            self.set(drop: newValue)
        }
        else if (keyPath == "time")
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

    func set(colorPathByState: String)
    {
        UIImage.load(contentsOfFile: colorPathByState)
        { (image) in
            
            self.button.setImage(image, for: UIControlState.normal)
        }
    }
    
    func set(drop: String)
    {
        self.dropLabel.text = drop
    }
    
    func set(time: String)
    {
        self.timeLabel.text = time
    }
    
    func set(period: String)
    {
        self.periodLabel.text = period
    }
    
    func viewModel(_ viewModel: DynamicViewModel, transition: String, from oldState: String, to newState: String)
    {
        if (newState == "On" || newState == "Off")
        {
            let imagePath = self.viewModel.colorPathByState[newState]

            UIImage.load(contentsOfFile: Bundle.main.path(forResource: imagePath, ofType: "png")!)
            { (image) in

                self.button.setImage(image, for: UIControlState.normal)
            }
        }
    }
}
