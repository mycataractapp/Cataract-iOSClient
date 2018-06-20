//
//  FooterPanelController.swift
//  Rose
//
//  Created by Rose Choi on 5/11/18.
//  Copyright © 2018 Rose Choi. All rights reserved.
//

import UIKit

class FooterPanelController : DynamicController<FooterPanelViewModel>, DynamicViewModelDelegate
{
    private var _confirmButton : UIButton!
    private var _cancelButton : UIButton!
    
    var confirmButton : UIButton!
    {
        get
        {
            if (self._confirmButton == nil)
            {
                self._confirmButton = UIButton()
                self._confirmButton.layer.borderWidth = 1
                self._confirmButton.layer.cornerRadius = 20
                self._confirmButton.setTitleColor(UIColor.white, for: UIControlState.normal)
                self._confirmButton.backgroundColor = UIColor(red: 0/255, green: 0/255, blue: 144/255, alpha: 1)
            }
            
            let confirmButton = self._confirmButton
            
            return confirmButton
        }
    }
    
    var cancelButton : UIButton!
    {
        get
        {
            if (self._cancelButton == nil)
            {
                self._cancelButton = UIButton()
                self._cancelButton.layer.borderWidth = 1
                self._cancelButton.layer.cornerRadius = 20
                self._cancelButton.setTitleColor(UIColor.white, for: UIControlState.normal)
                self._cancelButton.backgroundColor = UIColor(red: 0/255, green: 0/255, blue: 144/255, alpha: 1)
            }
            
            let cancelButton = self._cancelButton
            
            return cancelButton
        }
    }
    
    override func viewDidLoad()
    {
        self.view.addSubview(self.confirmButton)
        self.view.addSubview(self.cancelButton)
        
        self.view.backgroundColor = UIColor.white
    }
    
    override func render(size: CGSize)
    {
        super.render(size: size)
        
        self.confirmButton.titleLabel!.font = UIFont.systemFont(ofSize: 30)
        self.cancelButton.titleLabel!.font = UIFont.systemFont(ofSize: 30)
        
        self.confirmButton.frame.size.width = (self.canvas.gridSize.width - self.canvas.draw(tiles: 0.5)) / 2
        self.confirmButton.frame.size.height = self.canvas.draw(tiles: 2.5)
        
        self.cancelButton.frame.size.width = (self.canvas.gridSize.width - self.canvas.draw(tiles: 0.5)) / 2
        self.cancelButton.frame.size.height = self.canvas.draw(tiles: 2.5)
 
        self.cancelButton.frame.origin.x = (self.canvas.gridSize.width - self.confirmButton.frame.size.width - self.cancelButton.frame.size.width - self.canvas.draw(tiles: 0.15)) / 2
        self.cancelButton.frame.origin.y = (self.canvas.gridSize.height - self.confirmButton.frame.size.height) / 2
        
        self.confirmButton.frame.origin.x = self.cancelButton.frame.origin.x + self.cancelButton.frame.size.width + self.canvas.draw(tiles: 0.15)
        self.confirmButton.frame.origin.y = self.cancelButton.frame.origin.y
    }
    
    override func bind(viewModel: FooterPanelViewModel)
    {
        super.bind(viewModel: viewModel)
        
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
        self.viewModel.delegate = nil
        
        self.viewModel.removeObserver(self, forKeyPath: "leftTitle")
        self.viewModel.removeObserver(self, forKeyPath: "rightTitle")
        self.confirmButton.removeTarget(self.viewModel,
                                        action: #selector(self.viewModel.confirm),
                                        for: UIControlEvents.touchDown)
        self.cancelButton.removeTarget(self.viewModel,
                                       action: #selector(self.viewModel.cancel),
                                       for: UIControlEvents.touchDown)
        
        super.unbind()
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
