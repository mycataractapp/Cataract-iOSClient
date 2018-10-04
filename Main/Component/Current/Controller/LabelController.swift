//
//  LabelController.swift
//  Cataract
//
//  Created by Minh Nguyen on 9/10/18.
//  Copyright © 2018 Rose Choi. All rights reserved.
//

import UIKit

class LabelController : DynamicController
{
    private var _label : UILabel!
    @objc dynamic var viewModel : LabelViewModel!

    var label : UILabel
    {
        get
        {
            if (self._label == nil)
            {
                self._label = UILabel()
            }
            
            let label = self._label!
            
            return label
        }
    }
    
    override func viewDidLoad()
    {
        self.view.addSubview(self.label)
    }
    
    override func render()
    {
        super.render()
        
        self.view.frame.size = self.viewModel.size
            
        self.label.font = UIFont.systemFont(ofSize: 18)

        if (self.viewModel.style == LabelViewModel.Style.truncate)
        {
            self.label.frame.size = self.view.frame.size
        }
        else
        {
            self.label.frame.size.width = self.view.frame.size.width
            self.label.sizeToFit()
            
            self.view.frame.size.height = self.label.frame.height
        }
        
        self.label.frame.origin.x = (self.view.frame.size.width - self.label.frame.size.width) / 2
        self.label.frame.origin.y = (self.view.frame.size.height - self.label.frame.size.height) / 2
    }
    
    override func bind()
    {
        super.bind()
        
        self.addObserver(self,
                         forKeyPath: DynamicKVO.keyPath(\LabelController.viewModel.text),
                         options: NSKeyValueObservingOptions([NSKeyValueObservingOptions.new,
                                                              NSKeyValueObservingOptions.initial]),
                         context: nil)
        self.addObserver(self,
                         forKeyPath: DynamicKVO.keyPath(\LabelController.viewModel.textColor),
                         options: NSKeyValueObservingOptions([NSKeyValueObservingOptions.new,
                                                              NSKeyValueObservingOptions.initial]),
                         context: nil)
        self.addObserver(self,
                         forKeyPath: DynamicKVO.keyPath(\LabelController.viewModel.numberOfLines),
                         options: NSKeyValueObservingOptions([NSKeyValueObservingOptions.new,
                                                              NSKeyValueObservingOptions.initial]),
                         context: nil)
        self.addObserver(self,
                         forKeyPath: DynamicKVO.keyPath(\LabelController.viewModel.borderColor),
                         options: NSKeyValueObservingOptions([NSKeyValueObservingOptions.new,
                                                              NSKeyValueObservingOptions.initial]),
                         context: nil)
        self.addObserver(self,
                         forKeyPath: DynamicKVO.keyPath(\LabelController.viewModel.borderWidth),
                         options: NSKeyValueObservingOptions([NSKeyValueObservingOptions.new,
                                                              NSKeyValueObservingOptions.initial]),
                         context: nil)
        self.addObserver(self,
                         forKeyPath: DynamicKVO.keyPath(\LabelController.viewModel.textAlignment),
                         options: NSKeyValueObservingOptions([NSKeyValueObservingOptions.new,
                                                              NSKeyValueObservingOptions.initial]),
                         context: nil)
    }
    
    override func unbind()
    {
        super.unbind()
        
        self.removeObserver(self, forKeyPath: DynamicKVO.keyPath(\LabelController.viewModel.text))
        self.removeObserver(self, forKeyPath: DynamicKVO.keyPath(\LabelController.viewModel.numberOfLines))
        self.removeObserver(self, forKeyPath: DynamicKVO.keyPath(\LabelController.viewModel.textColor))
        self.removeObserver(self, forKeyPath: DynamicKVO.keyPath(\LabelController.viewModel.borderColor))
        self.removeObserver(self, forKeyPath: DynamicKVO.keyPath(\LabelController.viewModel.borderWidth))
        self.removeObserver(self, forKeyPath: DynamicKVO.keyPath(\LabelController.viewModel.textAlignment))
    }
    
    override func observeKeyValue(for kvoEvent: DynamicKVO.Event)
    {
        if (kvoEvent.keyPath == DynamicKVO.keyPath(\LabelController.viewModel.text))
        {
            let newValue = kvoEvent.newValue as? String
            self.set(text: newValue)
        }
        else if (kvoEvent.keyPath == DynamicKVO.keyPath(\LabelController.viewModel.textColor))
        {
            let newValue = kvoEvent.newValue as? ColorCardViewModel
            self.set(textColor: newValue)
        }
        else if (kvoEvent.keyPath == DynamicKVO.keyPath(\LabelController.viewModel.numberOfLines))
        {
            let newValue = kvoEvent.newValue as? Int
            self.set(numberOfLines: newValue)
        }
        else if (kvoEvent.keyPath == DynamicKVO.keyPath(\LabelController.viewModel.borderColor))
        {
            let newValue = kvoEvent.newValue as? ColorCardViewModel
            self.set(borderColor: newValue)
        }
        else if (kvoEvent.keyPath == DynamicKVO.keyPath(\LabelController.viewModel.borderWidth))
        {
            let newValue = kvoEvent.newValue as? CGFloat
            self.set(borderWidth: newValue)
        }
        else if (kvoEvent.keyPath == DynamicKVO.keyPath(\LabelController.viewModel.textAlignment))
        {
            let newValue = kvoEvent.newValue as? Int
            
            if (newValue != nil)
            {
                let textAlignment = LabelViewModel.TextAlignment(rawValue: newValue!)
                self.set(textAlignment: textAlignment)
            }
        }
    }
    
    func set(text: String?)
    {
        self.label.text = text
        
       //The property, text, is optional by default.
    }
    
    func set(textColor: ColorCardViewModel?)
    {
        if (textColor != nil)
        {
            self.label.textColor = textColor!.uicolor
        }
    }
    
    func set(numberOfLines: Int?)
    {
        if (numberOfLines != nil)
        {
            self.label.numberOfLines = numberOfLines!
        }
    }
    
    func set(borderColor: ColorCardViewModel?)
    {
        if (borderColor != nil)
        {
            self.label.layer.borderColor = borderColor!.uicolor.cgColor
        }
    }
    
    func set(borderWidth: CGFloat?)
    {
        if (borderWidth != nil)
        {
            self.label.layer.borderWidth = borderWidth!
            
            //The property, borderWidth, expects a value.
            //The application will crash if no value is stored, so a condition check is necessary.
        }
    }
    
    func set(textAlignment: LabelViewModel.TextAlignment?)
    {
        if (textAlignment == LabelViewModel.TextAlignment.left)
        {
            self.label.textAlignment = NSTextAlignment.left
        }
        else if (textAlignment == LabelViewModel.TextAlignment.right)
        {
            self.label.textAlignment = NSTextAlignment.right
        }
        else if (textAlignment == LabelViewModel.TextAlignment.center)
        {
            self.label.textAlignment = NSTextAlignment.center
        }
        else if (textAlignment == LabelViewModel.TextAlignment.justified)
        {
            self.label.textAlignment = NSTextAlignment.justified
        }
        else if (textAlignment == LabelViewModel.TextAlignment.natural)
        {
            self.label.textAlignment = NSTextAlignment.natural
        }
    }
    
    class CollectionCell : UICollectionViewCell
    {
        private var _labelController : LabelController!
     
        var labelController : LabelController
        {
            get
            {
                if (self._labelController == nil)
                {
                    self._labelController = LabelController()
                    self._labelController.bind()
                    self.addSubview(self._labelController.view)
                    self.autoresizesSubviews = false
                }
                
                let labelController = self._labelController!
                
                return labelController
            }
        }
    }
}
