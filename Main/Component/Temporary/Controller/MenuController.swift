//
//  MenuController.swift
//  MyCataractApp
//
//  Created by Roseanne Choi on 8/26/18.
//  Copyright © 2018 Rose Choi. All rights reserved.
//

import UIKit

class MenuController : DynamicController, DynamicViewModelDelegate
{
    private var _label : UILabel!
    private var _lineView : UIView!
    
    var label : UILabel
    {
        get
        {
            if (self._label == nil)
            {
                self._label = UILabel()
                self._label.textAlignment = NSTextAlignment.center
                self._label.textColor = UIColor(red: 51/255, green: 127/255, blue: 159/255, alpha: 1)
            }
            
            let label = self._label!
            
            return label
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
    
    override func viewDidLoad()
    {
        self.view.backgroundColor = UIColor.white
        
        self.view.addSubview(self.label)
        self.view.addSubview(self.lineView)
    }
    
    override func render(canvas: DynamicCanvas) -> DynamicCanvas
    {
        super.render(canvas: canvas)
        self.view.frame.size = canvas.size
        
        self.label.font = UIFont.systemFont(ofSize: 24)
        
        self.label.frame.size.width = self.view.frame.size.width
        self.label.frame.size.height = canvas.draw(tiles: 2)
        
        self.lineView.frame.size.width = self.view.frame.size.width
        self.lineView.frame.size.height = 1
        
        self.label.frame.origin.y = (self.view.frame.size.height - self.label.frame.size.height - self.lineView.frame.size.height) / 2
        
        self.lineView.frame.origin.y = self.view.frame.size.height - self.lineView.frame.size.height
        
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
    }
    
    override func unbind()
    {
        super.unbind()
        
        self.viewModel.delegate = nil
        self.viewModel.removeObserver(self, forKeyPath: "title")
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
        self.label.text = title
    }
    
    func viewModel(_ viewModel: DynamicViewModel, transition: String, from oldState: String, to newState: String)
    {
        if (newState == "On")
        {
            self.label.textColor = UIColor.white
            self.view.backgroundColor = UIColor(red: 51/255, green: 127/255, blue: 159/255, alpha: 1)
        }
        else if (newState == "Off")
        {
            self.label.textColor = UIColor(red: 51/255, green: 127/255, blue: 159/255, alpha: 1)
            self.view.backgroundColor = UIColor.white
        }
    }
}
