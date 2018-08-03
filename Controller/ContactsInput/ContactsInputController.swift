//
//  ContactsInputController.swift
//  Cataract
//
//  Created by Rose Choi on 7/27/18.
//  Copyright © 2018 Rose Choi. All rights reserved.
//

import UIKit

class ContactsInputController : DynamicController<ContactsInputViewModel>, DynamicViewModelDelegate
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
                self._label.textColor = UIColor(red: 41/255, green: 128/255, blue: 185/255, alpha: 1)
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
            inputControllerSize.height = self.canvas.draw(tiles: 3)
            
            return inputControllerSize
        }
    }
    
    override func viewDidLoad()
    {
        self.view.addSubview(self.label)
        self.view.addSubview(self.inputController.view)
    }
    
    override func render(size: CGSize)
    {
        super.render(size: size)
        
        self.label.font = UIFont.systemFont(ofSize: 18)
        
        self.inputController.render(size: self.inputControllerSize)
        
        self.label.sizeToFit()
        self.label.frame.size.width = self.view.frame.size.width - self.canvas.draw(tiles: 1)
        self.label.frame.size.height = self.canvas.draw(tiles: 1)
        self.label.frame.origin.x = (self.view.frame.size.width - self.label.frame.size.width) / 2
        self.label.frame.origin.y = (self.view.frame.size.height - self.label.frame.size.height - self.inputController.view.frame.size.height - self.canvas.draw(tiles: 0.5)) / 2
        
        self.inputController.view.center.x = self.label.center.x
        self.inputController.view.frame.origin.y = self.label.frame.origin.y + self.label.frame.size.height + self.canvas.draw(tiles: 0.5)
    }
    
    override func bind(viewModel: ContactsInputViewModel)
    {
        super.bind(viewModel: viewModel)
        
        self.viewModel.delegate = self
        self.inputController.textField.delegate = self.viewModel
        self.inputController.bind(viewModel: self.viewModel.inputViewModel)
        
        self.viewModel.addObserver(self,
                                   forKeyPath: "title",
                                   options: NSKeyValueObservingOptions([NSKeyValueObservingOptions.new,
                                                                        NSKeyValueObservingOptions.initial]),
                                   context: nil)
    }
    
    override func unbind()
    {
        self.viewModel.delegate = nil
        
        self.inputController.unbind()
        self.viewModel.removeObserver(self, forKeyPath: "title")
        
        super.unbind()
    }
    
    func viewModel(_ viewModel: DynamicViewModel, transition: String, from oldState: String, to newState: String)
    {
        if (transition == "TextFieldShouldReturn")
        {
            self.inputController.textField.resignFirstResponder()
        }
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
