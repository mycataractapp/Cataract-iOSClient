//
//  InputController.swift
//  Rose
//
//  Created by Rose Choi on 5/11/18.
//  Copyright © 2018 Rose Choi. All rights reserved.
//

import UIKit

class InputController : DynamicController<InputViewModel>, DynamicViewModelDelegate, UITextFieldDelegate
{
    private var _textField : UITextField!
    
    var textField : UITextField!
    {
        get
        {
            if (self._textField == nil)
            {
                self._textField = UITextField()
                self._textField.layer.borderWidth = 1
                self._textField.layer.cornerRadius = 25
                self._textField.layer.borderColor = UIColor.lightGray.cgColor
                self._textField.textAlignment = NSTextAlignment.center
                self._textField.clearButtonMode = UITextFieldViewMode.whileEditing
                
                self._textField.delegate = self
            }
            
            let textField = self._textField
            
            return textField
        }
    }
    
    override func viewDidLoad()
    {
        self.view.addSubview(self.textField)
        
        self.view.backgroundColor = UIColor.white
    }
    
    override func render(size: CGSize)
    {
        super.render(size: size)
        
        self.textField.font = UIFont.systemFont(ofSize: 32)
        
        self.textField.frame.size.width = self.canvas.gridSize.width - self.canvas.draw(tiles: 1)
        self.textField.frame.size.height = self.canvas.draw(tiles: 2.5)
        
        self.textField.frame.origin.x = (self.canvas.gridSize.width - self.textField.frame.size.width) / 2
        self.textField.frame.origin.y = (self.canvas.gridSize.height - self.textField.frame.size.height) / 2
    }
    
    override func bind(viewModel: InputViewModel)
    {
        super.bind(viewModel: viewModel)
        
        self.viewModel.delegate = self
        
        NotificationCenter.default.addObserver(self.viewModel,
                                               selector: #selector(self.viewModel.textFieldTextDidChange(notification:)),
                                               name: NSNotification.Name.UITextFieldTextDidChange,
                                               object: nil)
        self.viewModel.addObserver(self,
                                   forKeyPath: "value",
                                   options: NSKeyValueObservingOptions([NSKeyValueObservingOptions.new,
                                                                        NSKeyValueObservingOptions.initial]),
                                   context: nil)
        self.viewModel.addObserver(self,
                                   forKeyPath: "placeHolder",
                                   options: NSKeyValueObservingOptions([NSKeyValueObservingOptions.new,
                                                                        NSKeyValueObservingOptions.initial]),
                                   context: nil)
    }
    
    override func unbind()
    {
        self.viewModel.delegate = nil
        
        self.viewModel.removeObserver(self, forKeyPath: "value")
        self.viewModel.removeObserver(self, forKeyPath: "placeHolder")
        
        super.unbind()
    }
    
    override func shouldSetKeyPath(_ keyPath: String?, ofObject object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?)
    {
        if (keyPath == "value")
        {
            let newValue = change![NSKeyValueChangeKey.newKey] as! String
            self.set(value: newValue)
        }
        else if (keyPath == "placeHolder")
        {
            let newValue = change![NSKeyValueChangeKey.newKey] as! String
            self.set(placeHolder: newValue)
        }
    }
    
    func set(value: String)
    {
        self.textField.text = value
    }
    
    func set(placeHolder: String)
    {
        self.textField.placeholder = placeHolder
    }
    
    func viewModel(_ viewModel: DynamicViewModel, transition: String, from oldState: String, to newState: String)
    {
        if (transition == "TextFieldTextDidChange")
        {
            self.viewModel.value = self.textField.text!
        }
    }
    
}
