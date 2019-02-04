//
//  TextFieldInputController.swift
//  Cataract
//
//  Created by Roseanne Choi on 9/10/18.
//  Copyright © 2018 Rose Choi. All rights reserved.
//

import UIKit

class TextFieldInputController : DynamicController, DynamicViewModelDelegate, UITextFieldDelegate
{
    private var _textField : UITextField!
    @objc dynamic var viewModel : TextFieldInputViewModel!
    
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
    
    override func render()
    {
        super.render()

        self.view.frame.size = self.viewModel.size
        
        self.textField.font = UIFont.systemFont(ofSize: 18)
        
        self.textField.frame.size.width = self.view.frame.size.width - 5
        self.textField.frame.size.height = 70
        self.textField.frame.origin.x = (self.view.frame.width - self.textField.frame.size.width) / 2
        self.textField.frame.origin.y = (self.view.frame.height - self.textField.frame.size.height) / 2
        
    }
    
    override func bind()
    {
        super.bind()
        
        self.addObserver(self,
                         forKeyPath: DynamicKVO.keyPath(\TextFieldInputController.viewModel.value),
                         options: NSKeyValueObservingOptions([NSKeyValueObservingOptions.new,
                                                              NSKeyValueObservingOptions.initial]),
                         context: nil)
        self.addObserver(self,
                         forKeyPath: DynamicKVO.keyPath(\TextFieldInputController.viewModel.placeHolder),
                         options: NSKeyValueObservingOptions([NSKeyValueObservingOptions.new,
                                                              NSKeyValueObservingOptions.initial]),
                         context: nil)
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(self._change(notification:)),
                                               name: NSNotification.Name.UITextFieldTextDidChange,
                                               object: nil)
    }
    
    override func unbind()
    {
        super.unbind()
        
        self.removeObserver(self, forKeyPath: DynamicKVO.keyPath(\TextFieldInputController.viewModel.value))
        self.removeObserver(self, forKeyPath: DynamicKVO.keyPath(\TextFieldInputController.viewModel.placeHolder))
        
        NotificationCenter.default.removeObserver(self,
                                                  name: NSNotification.Name.UITextFieldTextDidChange,
                                                  object: nil)

    }
    
    override func observeController(for controllerEvent: DynamicController.Event, kvoEvent: DynamicKVO.Event)
    {
        if (kvoEvent.keyPath == DynamicKVO.keyPath(\TextFieldInputController.viewModel))
        {
            if (controllerEvent.operation == DynamicController.Event.Operation.bind)
            {
                self.viewModel.delegate = self
            }
            else
            {
                self.viewModel.delegate = nil
            }
        }
    }
    
    override func observeKeyValue(for kvoEvent: DynamicKVO.Event)
    {
        if (kvoEvent.keyPath == DynamicKVO.keyPath(\TextFieldInputController.viewModel.value))
        {
            let newValue = kvoEvent.newValue as? String
            self.set(value: newValue)
        }
        else if (kvoEvent.keyPath == DynamicKVO.keyPath(\TextFieldInputController.viewModel.placeHolder))
        {
            let newValue = kvoEvent.newValue as? String
            self.set(placeHolder: newValue)
        }
    }
    
    @objc private func _change(notification: Notification)
    {
        if (self.viewModel != nil)
        {
            self.viewModel.change()
        }
    }
    
    func set(value: String?)
    {
        self.textField.text = value
    }
    
    func set(placeHolder: String?)
    {
        self.textField.placeholder = placeHolder
    }
    
    func viewModel(_ viewModel: DynamicViewModel, transitWith event: DynamicViewModel.Event)
    {
        if (event.transition == TextFieldInputViewModel.Transition.change)
        {
            self.viewModel.value = self.textField.text!
        }
    }
    
    class CollectionCell : UICollectionViewCell
    {
        private var _textFieldInputController : TextFieldInputController!
        
        var textFieldInputController : TextFieldInputController
        {
            get
            {
                if (self._textFieldInputController == nil)
                {
                    self._textFieldInputController = TextFieldInputController()
                    self._textFieldInputController.bind()
                    self.addSubview(self._textFieldInputController.view)
                    self.autoresizesSubviews = false
                }
                
                let textFieldInputController = self._textFieldInputController!
                
                return textFieldInputController
            }
        }
    }

}
