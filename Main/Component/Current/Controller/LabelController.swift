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
    
    override func render(canvas: DynamicCanvas) -> DynamicCanvas
    {
        super.render(canvas: canvas)
        
        let canvas = DynamicCanvas(size: self.viewModel.size)
        self.view.frame.size = canvas.size
        
        self.label.font = UIFont.systemFont(ofSize: 18)

        self.label.sizeToFit()
        
        self.label.frame.origin.x = (self.view.frame.size.width - self.label.frame.size.width) / 2
        self.label.frame.origin.y = (self.view.frame.size.height - self.label.frame.size.height) / 2
        
        return canvas
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
                         forKeyPath: DynamicKVO.keyPath(\LabelController.viewModel.color),
                         options: NSKeyValueObservingOptions([NSKeyValueObservingOptions.new,
                                                              NSKeyValueObservingOptions.initial]),
                         context: nil)
    }
    
    override func unbind()
    {
        super.unbind()
        
        self.removeObserver(self, forKeyPath: DynamicKVO.keyPath(\LabelController.viewModel.text))
        self.removeObserver(self, forKeyPath: DynamicKVO.keyPath(\LabelController.viewModel.color))
    }
    
    override func observeKeyValue(for kvoEvent: DynamicKVO.Event)
    {
        if (kvoEvent.keyPath == DynamicKVO.keyPath(\LabelController.viewModel.text))
        {
            let newValue = kvoEvent.newValue as? String
            self.set(value: newValue)
        }
        else if (kvoEvent.keyPath == DynamicKVO.keyPath(\LabelController.viewModel.color))
        {
            let newValue = kvoEvent.newValue as? ColorCardViewModel
            self.set(colorCardViewModel: newValue)
        }
    }
    
    func set(value: String?)
    {
        print("Bin", value)
        self.label.text = value
    }
    
    func set(colorCardViewModel: ColorCardViewModel?)
    {
        if (colorCardViewModel != nil)
        {
            self.label.textColor = colorCardViewModel!.uicolor
        }
    }
}
