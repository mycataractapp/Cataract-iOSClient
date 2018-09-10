//
//  InformationController.swift
//  Cataract
//
//  Created by Roseanne Choi on 7/24/18.
//  Copyright © 2018 Roseanne Choi. All rights reserved.
//

import UIKit

class InformationController : DynamicController
{
    private var _label : UILabel!
    private var _inputController : InputController!
    
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
    
    var inputController : InputController
    {
        get
        {
            if (self._inputController == nil)
            {
                self._inputController = InputController()
            }
            
            let inputController = self._inputController!
            
            return inputController
        }
    }
    
    var inputControllerSize : CGSize
    {
        get
        {
            var inputControllerSize = CGSize.zero
            inputControllerSize.width = self.view.frame.size.width
            inputControllerSize.height = canvas.draw(tiles: 3)
            
            return inputControllerSize
        }
    }
    
    override func viewDidLoad()
    {
        self.view.addSubview(self.label)
        self.view.addSubview(self.inputController.view)
    }
    
    override func render(canvas: DynamicCanvas) -> DynamicCanvas
    {
        super.render(canvas: canvas)
        self.view.frame.size = canvas.size
        
        self.label.font = UIFont.systemFont(ofSize: 32)

        
        self.label.sizeToFit()
        self.label.frame.size.width = self.view.frame.size.width - canvas.draw(tiles: 1)
        self.label.frame.size.height = canvas.draw(tiles: 2)
                
        self.label.frame.origin.x = (self.view.frame.size.width - self.label.frame.size.width) / 2
        self.label.frame.origin.y = (self.view.frame.size.height - self.label.frame.size.height - canvas.draw(tiles: 0.25)) / 2
        
        self.inputController.view.center.x = self.label.center.x
        self.inputController.view.frame.origin.y = self.label.frame.origin.y + self.label.frame.size.height + canvas.draw(tiles: 0.25)
        
        return canvas
    }
    
    override func bind()
    {
        super.bind()
        
        self.viewModel.addObserver(self,
                                   forKeyPath: "title",
                                   options: NSKeyValueObservingOptions([NSKeyValueObservingOptions.new,
                                                                        NSKeyValueObservingOptions.initial]),
                                   context: nil)
    }
    
    override func unbind()
    {
        super.unbind()
        
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
}
