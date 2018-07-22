//
//  AppointmentInputController.swift
//  Cataract
//
//  Created by Rose Choi on 7/10/18.
//  Copyright © 2018 Rose Choi. All rights reserved.
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
        
        self.label.font = UIFont.systemFont(ofSize: 24)
        
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
            self.view.backgroundColor = UIColor(red: 41/255, green: 128/255, blue: 185/255, alpha: 1)
        }
        else if (newState == "Off")
        {
            self.view.backgroundColor = UIColor.white
        }
    }
}
