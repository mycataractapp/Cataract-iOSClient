//
//  TimeStampController.swift
//  Cataract
//
//  Created by Roseanne Choi on 6/25/18.
//  Copyright © 2018 Roseanne Choi. All rights reserved.
//

import UIKit

class TimeStampController : DynamicController, DynamicViewModelDelegate
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
                self._titleLabel.textColor = UIColor(red: 51/255, green: 127/255, blue: 159/255, alpha: 1)
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
                self._displayLabel.textColor = UIColor(red: 51/255, green: 127/255, blue: 159/255, alpha: 1)
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
    
    override func render(canvas: DynamicCanvas) -> DynamicCanvas
    {
        super.render(canvas: canvas)
        self.view.frame.size = canvas.size
        
        self.titleLabel.font = UIFont.systemFont(ofSize: 18)
        
        self.titleLabel.frame.size.width = canvas.draw(tiles: 10)
        self.titleLabel.frame.size.height = canvas.draw(tiles: 2)
        
        self.button.frame.size.width = canvas.draw(tiles: 5.5)
        self.button.frame.size.height = canvas.draw(tiles: 2)
        
        self.displayLabel.frame.size.width = canvas.draw(tiles: 5)
        self.displayLabel.frame.size.height = self.button.frame.size.height
        
        self.titleLabel.frame.origin.x = canvas.draw(tiles: 0.5)
        self.titleLabel.frame.origin.y = (self.view.frame.size.height - self.titleLabel.frame.size.height) / 2
        
        self.button.frame.origin.x = self.view.frame.size.width - self.button.frame.size.width - canvas.draw(tiles: 1)
        self.button.frame.origin.y = self.titleLabel.frame.origin.y
        
        self.displayLabel.center.x = self.button.center.x
        self.displayLabel.frame.origin.y = self.button.frame.origin.y
        
        return canvas
    }
    
    override func bind()
    {
        super.bind()
        
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
