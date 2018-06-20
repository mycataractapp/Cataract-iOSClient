//
//  InputController.swift
//  Rose
//
//  Created by Rose Choi on 5/11/18.
//  Copyright © 2018 Rose Choi. All rights reserved.
//

import UIKit

class InputController : DynamicController<InputViewModel>
{
    private var _textField : UITextField!
    
    var textfield : UITextField!
    {
        get
        {
            if (self._textField == nil)
            {
                self._textField = UITextField()
                self._textField.layer.borderWidth = 1
                self._textField.layer.cornerRadius = 25
                self._textField.layer.borderColor = UIColor.black.cgColor
                self._textField.textAlignment = NSTextAlignment.center
                self._textField.clearButtonMode = UITextFieldViewMode.whileEditing
            }
            
            let textField = self._textField
            
            return textField
        }
    }
    
    override func viewDidLoad()
    {
        self.view.addSubview(self.textfield)
        
        self.view.backgroundColor = UIColor.white
    }
    
    override func render(size: CGSize)
    {
        super.render(size: size)
        
        self.textfield.font = UIFont.systemFont(ofSize: 32)
        
        self.textfield.frame.size.width = self.canvas.gridSize.width - self.canvas.draw(tiles: 1)
        self.textfield.frame.size.height = self.canvas.draw(tiles: 2.5)
        
        self.textfield.frame.origin.x = (self.canvas.gridSize.width - self.textfield.frame.size.width) / 2
        self.textfield.frame.origin.y = (self.canvas.gridSize.height - self.textfield.frame.size.height) / 2
    }
    
    override func bind(viewModel: InputViewModel)
    {
        super.bind(viewModel: viewModel)
        
        self.viewModel.addObserver(self,
                                   forKeyPath: "placeHolder",
                                   options: NSKeyValueObservingOptions([NSKeyValueObservingOptions.new,
                                                                        NSKeyValueObservingOptions.initial]),
                                   context: nil)
    }
    
    override func unbind()
    {
        self.viewModel.removeObserver(self, forKeyPath: "placeHolder")
        
        super.unbind()
    }
    
    override func shouldSetKeyPath(_ keyPath: String?, ofObject object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?)
    {
        if (keyPath == "placeHolder")
        {
            let newValue = change![NSKeyValueChangeKey.newKey] as! String
            self.set(placeHolder: newValue)
        }
    }
    
    func set(placeHolder: String)
    {
        self.textfield.placeholder = placeHolder
    }
}
