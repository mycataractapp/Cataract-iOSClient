//
//  DropTimeController.swift
//  Cataract
//
//  Created by Rose Choi on 6/6/18.
//  Copyright © 2018 Rose Choi. All rights reserved.
//

import UIKit

class DropTimeController : DynamicController<DropTimeViewModel>, DynamicViewModelDelegate
{
    private var _button : UIButton!
    private var _dropLabel : UILabel!
    private var _timeLabel : UILabel!
    
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
    
    override func viewDidLoad()
    {
        self.view.backgroundColor = UIColor.white
        
        self.view.addSubview(self.button)
        self.view.addSubview(self.dropLabel)
        self.view.addSubview(self.timeLabel)
    }
    
    override func render(size: CGSize)
    {
        super.render(size: size)
        
        self.dropLabel.font = UIFont.systemFont(ofSize: 36)
        self.timeLabel.font = UIFont.systemFont(ofSize: 48)
        
        self.button.frame.size.width = self.canvas.draw(tiles: 2)
        self.button.frame.size.height = self.button.frame.size.width
        
        self.timeLabel.sizeToFit()
        self.timeLabel.frame.size.height = self.canvas.draw(tiles: 2)
        
        self.dropLabel.frame.size.width = self.canvas.gridSize.width - self.button.frame.size.width - self.canvas.draw(tiles: 0.45)
        self.dropLabel.frame.size.height = self.canvas.draw(tiles: 2)
        
        self.button.frame.origin.x = self.canvas.draw(tiles: 0.15)
        self.button.frame.origin.y = (self.canvas.gridSize.height - self.button.frame.size.height - self.dropLabel.frame.size.height - self.canvas.draw(tiles: 0.15)) / 2
        
        self.timeLabel.frame.origin.x = self.button.frame.origin.x + self.button.frame.size.width + self.canvas.draw(tiles: 0.15)
        self.timeLabel.center.y = self.button.center.y
        
        self.dropLabel.frame.origin.x = self.timeLabel.frame.origin.x
        self.dropLabel.frame.origin.y = self.button.frame.origin.y + self.button.frame.size.height + self.canvas.draw(tiles: 0.15)
    }
    
    override func bind(viewModel: DropTimeViewModel)
    {
        super.bind(viewModel: viewModel)
        
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
    }
    
    override func unbind()
    {
        self.viewModel.delegate = nil
        self.button.removeTarget(self.viewModel, action: #selector(self.viewModel.toggle), for: UIControlEvents.touchDown)
//        self.viewModel.removeObserver(self, forKeyPath: "colorPathByState")
        self.viewModel.removeObserver(self, forKeyPath: "drop")
        self.viewModel.removeObserver(self, forKeyPath: "time")

        super.unbind()
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
    
    func viewModel(_ viewModel: DynamicViewModel, transition: String, from oldState: String, to newState: String)
    {
        if (newState == "On" || newState == "Off")
        {
            let imagePath = self.viewModel.colorPathByState[newState]
            
            UIImage.load(contentsOfFile: imagePath!)
            { (image) in

                self.button.setImage(image, for: UIControlState.normal)
            }
        }
    }
}
