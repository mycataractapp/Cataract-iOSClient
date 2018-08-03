//
//  AppointmentInputController.swift
//  Cataract
//
//  Created by Roseanne Choi on 7/10/18.
//  Copyright © 2018 Roseanne Choi. All rights reserved.
//

import UIKit

class AppointmentInputController : DynamicController<AppointmentInputViewModel>, DynamicViewModelDelegate
{
    private var _label : UILabel!
    
    var label : UILabel
    {
        get
        {
            if (self._label == nil)
            {
                self._label = UILabel()
                self._label.textAlignment = NSTextAlignment.center
            }
            
            let label = self._label!
            
            return label
        }
    }
    
    override func viewDidLoad()
    {
        self.view.backgroundColor = UIColor.white
        self.view.addSubview(self.label)
    }
    
    override func render(size: CGSize)
    {
        super.render(size: size)
        
        self.label.font = UIFont.systemFont(ofSize: 18)
        
        self.label.frame.size.width = self.view.frame.size.width - self.canvas.draw(tiles: 1)
        self.label.frame.size.height = self.canvas.draw(tiles: 2)
        self.label.frame.origin.x = (self.canvas.gridSize.width - self.label.frame.size.width) / 2
        self.label.frame.origin.y = (self.canvas.gridSize.height - self.label.frame.size.height) / 2
    }
    
    override func bind(viewModel: AppointmentInputViewModel)
    {
        super.bind(viewModel: viewModel)
        
        self.viewModel.delegate = self
        
        self.viewModel.addObserver(self,
                                   forKeyPath: "title",
                                   options: NSKeyValueObservingOptions([NSKeyValueObservingOptions.new,
                                                                        NSKeyValueObservingOptions.initial]),
                                   context: nil)
    }
    
    override func unbind()
    {
        self.viewModel.delegate = nil
        
        self.viewModel.removeObserver(self, forKeyPath: "title")
        
        super.unbind()
    }
    
    override func shouldSetKeyPath(_ keyPath: String?, ofObject object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?)
    {
        if (keyPath == "title")
        {
            let newValue = change![NSKeyValueChangeKey.newKey] as! String
            self.set(title: newValue)
        }
    }
    
    func set(title: String)
    {
        self._label.text = title
    }
    
    func viewModel(_ viewModel: DynamicViewModel, transition: String, from oldState: String, to newState: String)
    {
        if (newState == "On")
        {
            self.view.backgroundColor = UIColor(red: 51/255, green: 127/255, blue: 159/255, alpha: 1)
            self.label.textColor = UIColor.white
        }
        else if (newState == "Off")
        {
            self.view.backgroundColor = UIColor.white
            self.label.textColor = UIColor.black
        }
    }
}
