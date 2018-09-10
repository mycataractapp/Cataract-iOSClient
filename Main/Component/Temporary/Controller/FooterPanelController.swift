//
//  FooterPanelController.swift
//  Rose
//
//  Created by Roseanne Choi on 5/11/18.
//  Copyright © 2018 Roseanne Choi. All rights reserved.
//

import UIKit

class FooterPanelController : DynamicController, DynamicViewModelDelegate
{
    private var _confirmButton : UIButton!
    private var _cancelButton : UIButton!
    
    var confirmButton : UIButton
    {
        get
        {
            if (self._confirmButton == nil)
            {
                self._confirmButton = UIButton()
                self._confirmButton.layer.borderWidth = 1
                self._confirmButton.layer.borderColor = UIColor.white.cgColor
                self._confirmButton.setTitleColor(UIColor.white, for: UIControlState.normal)
                self._confirmButton.backgroundColor = UIColor(red: 51/255, green: 127/255, blue: 159/255, alpha: 1)
            }
            
            let confirmButton = self._confirmButton!
            
            return confirmButton
        }
    }
    
    var cancelButton : UIButton
    {
        get
        {
            if (self._cancelButton == nil)
            {
                self._cancelButton = UIButton()
                self._cancelButton.layer.borderWidth = 1
                self._cancelButton.layer.borderColor = UIColor.white.cgColor
                self._cancelButton.setTitleColor(UIColor.white, for: UIControlState.normal)
                self._cancelButton.backgroundColor = UIColor(red: 51/255, green: 127/255, blue: 159/255, alpha: 1)
            }
            
            let cancelButton = self._cancelButton!
            
            return cancelButton
        }
    }
    
    override func viewDidLoad()
    {
        self.view.addSubview(self.confirmButton)
        self.view.addSubview(self.cancelButton)
        
        self.view.backgroundColor = UIColor.white
    }
    
    override func render(canvas: DynamicCanvas) -> DynamicCanvas
    {
        super.render(canvas: canvas)
        self.view.frame.size = canvas.size
        
        self.confirmButton.titleLabel!.font = UIFont.systemFont(ofSize: 24)
        self.cancelButton.titleLabel!.font = UIFont.systemFont(ofSize: 24)
        
        self.confirmButton.frame.size.width = canvas.size.width / 2
        self.confirmButton.frame.size.height = canvas.draw(tiles: 3)
        
        self.cancelButton.frame.size.width = canvas.size.width / 2
        self.cancelButton.frame.size.height = canvas.draw(tiles: 3)
 
        self.cancelButton.frame.origin.x = (canvas.size.width - self.confirmButton.frame.size.width - self.cancelButton.frame.size.width) / 2
        self.cancelButton.frame.origin.y = (canvas.size.height - self.confirmButton.frame.size.height) / 2
        
        self.confirmButton.frame.origin.x = self.cancelButton.frame.origin.x + self.cancelButton.frame.size.width
        self.confirmButton.frame.origin.y = self.cancelButton.frame.origin.y
        
        return canvas
    }
    
    override func bind()
    {
        super.bind()
        
        self.viewModel.delegate = self
        
        self.viewModel.addObserver(self,
                                   forKeyPath: "leftTitle",
                                   options: NSKeyValueObservingOptions([NSKeyValueObservingOptions.new,
                                                                       NSKeyValueObservingOptions.initial]),
                                   context: nil)
        self.viewModel.addObserver(self,
                                   forKeyPath: "rightTitle",
                                   options: NSKeyValueObservingOptions([NSKeyValueObservingOptions.new,
                                                                       NSKeyValueObservingOptions.initial]),
                                   context: nil)
        self.confirmButton.addTarget(self.viewModel,
                                     action: #selector(self.viewModel.confirm),
                                     for: UIControlEvents.touchDown)
        self.cancelButton.addTarget(self.viewModel,
                                    action: #selector(self.viewModel.cancel),
                                    for: UIControlEvents.touchDown)
    }
    
    override func unbind()
    {
        super.unbind()
        
        self.viewModel.delegate = nil
        
        self.viewModel.removeObserver(self, forKeyPath: "leftTitle")
        self.viewModel.removeObserver(self, forKeyPath: "rightTitle")
        self.confirmButton.removeTarget(self.viewModel,
                                        action: #selector(self.viewModel.confirm),
                                        for: UIControlEvents.touchDown)
        self.cancelButton.removeTarget(self.viewModel,
                                       action: #selector(self.viewModel.cancel),
                                       for: UIControlEvents.touchDown)
    }
    
    override func shouldSetKeyPath(_ keyPath: String?, ofObject object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?)
    {
        if (keyPath == "leftTitle")
        {
            let newValue = change![NSKeyValueChangeKey.newKey] as! String
            self.set(leftTitle: newValue)
        }
        else if (keyPath == "rightTitle")
        {
            let newValue = change![NSKeyValueChangeKey.newKey] as! String
            self.set(rightTitle: newValue)
        }
    }
    
    func set(leftTitle: String)
    {
        self.cancelButton.setTitle(leftTitle, for: UIControlState.normal)
    }
    
    func set(rightTitle: String)
    {
        self.confirmButton.setTitle(rightTitle, for: UIControlState.normal)
    }
    
    func viewModel(_ viewModel: DynamicViewModel, transition: String, from oldState: String, to newState: String)
    {
        if (transition == "Confirm")
        {
        }
        else if (transition == "Cancel")
        {
        }
    }
}
