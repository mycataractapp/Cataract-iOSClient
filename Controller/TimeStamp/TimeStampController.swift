//
//  TimeStampController.swift
//  Cataract
//
//  Created by Rose Choi on 6/25/18.
//  Copyright © 2018 Rose Choi. All rights reserved.
//

import UIKit

class TimeStampController : DynamicController<TimeStampViewModel>, DynamicViewModelDelegate
{
    private var _titleLabel : UILabel!
    private var _displayLabel : UILabel!
    private var _button : UIButton!
    
    var titleLabel : UILabel
    {
        get
        {
            if (self._titleLabel == nil)
            {
                self._titleLabel = UILabel()
            }
            
            let titleLabel = self._titleLabel!
            
            return titleLabel
        }
    }
    
    var displayLabel : UILabel
    {
        get
        {
            if (self._displayLabel == nil)
            {
                self._displayLabel = UILabel()
                self._displayLabel.textAlignment = NSTextAlignment.center
            }
            
            let displayLabel = self._displayLabel!
            
            return displayLabel
        }
    }
    
    var button : UIButton
    {
        get
        {
            if (self._button == nil)
            {
                self._button = UIButton()
                self._button.layer.borderWidth = 1
                self._button.layer.cornerRadius = 20
                self._button.layer.borderColor = UIColor.black.cgColor
            }
            
            let button = self._button!
            
            return button
        }
    }
    
    override func viewDidLoad()
    {
        self.view.addSubview(self.titleLabel)
        self.view.addSubview(self.displayLabel)
        self.view.addSubview(self.button)
    }
    
    override func render(size: CGSize)
    {
        super.render(size: size)
        
        self.titleLabel.frame.size.width = self.canvas.draw(tiles: 10)
        self.titleLabel.frame.size.height = self.canvas.draw(tiles: 2)
        
        self.button.frame.size.width = self.canvas.draw(tiles: 3.5)
        self.button.frame.size.height = self.canvas.draw(tiles: 2)
        
        self.displayLabel.frame.size.width = self.canvas.draw(tiles: 3)
        self.displayLabel.frame.size.height = self.button.frame.size.height
        
        self.titleLabel.frame.origin.x = self.canvas.draw(tiles: 0.5)
        self.titleLabel.frame.origin.y = (self.view.frame.size.height - self.titleLabel.frame.size.height) / 2
        
        self.button.frame.origin.x = self.view.frame.size.width - self.button.frame.size.width - self.canvas.draw(tiles: 1)
        self.button.frame.origin.y = self.titleLabel.frame.origin.y
        
        self.displayLabel.center.x = self.button.center.x
        self.displayLabel.frame.origin.y = self.button.frame.origin.y
    }
    
    override func bind(viewModel: TimeStampViewModel)
    {
        super.bind(viewModel: viewModel)
        
        self.viewModel.delegate = self
        
        self.viewModel.addObserver(self,
                                   forKeyPath: "title",
                                   options: NSKeyValueObservingOptions([NSKeyValueObservingOptions.new,
                                                                        NSKeyValueObservingOptions.initial]),
                                   context: nil)
        self.viewModel.addObserver(self,
                                   forKeyPath: "display",
                                   options: NSKeyValueObservingOptions([NSKeyValueObservingOptions.new,
                                                                        NSKeyValueObservingOptions.initial]),
                                   context: nil)
        self.button.addTarget(self.viewModel,
                              action: #selector(self.viewModel.edit),
                              for: UIControlEvents.touchDown)
        
    }
    
    override func unbind()
    {
        super.unbind()
        
        self.viewModel.removeObserver(self, forKeyPath: "title")
        self.viewModel.removeObserver(self, forKeyPath: "display")
        self.button.removeTarget(self.viewModel,
                                 action: #selector(self.viewModel.edit),
                                 for: UIControlEvents.touchDown)
    }
    
    override func shouldSetKeyPath(_ keyPath: String?, ofObject object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?)
    {
        if (keyPath == "title")
        {
            let newValue = change![NSKeyValueChangeKey.newKey] as! String
            self.set(title: newValue)
            
        }
        else if (keyPath == "display")
        {
            let newValue = change![NSKeyValueChangeKey.newKey] as! String
            self.set(display: newValue)
        }
    }
    
    func set(title: String)
    {
        self.titleLabel.text = title
    }
    
    func set(display: String)
    {
        self.displayLabel.text = display
    }
    
    func viewModel(_ viewModel: DynamicViewModel, transition: String, from oldState: String, to newState: String)
    {
        if (transition == "Edit")
        {
        }
    }
}
