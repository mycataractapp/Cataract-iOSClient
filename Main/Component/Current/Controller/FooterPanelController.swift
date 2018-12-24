//
//  FooterPanelController.swift
//  MyCataractApp
//
//  Created by Roseanne Choi on 9/25/18.
//  Copyright © 2018 Rose Choi. All rights reserved.
//

import UIKit

class FooterPanelController : DynamicController, DynamicViewModelDelegate
{
    private var _backButton : UIButton!
    private var _nextButton : UIButton!
    @objc dynamic var viewModel : FooterPanelViewModel!
    
    var backButton : UIButton
    {
        get
        {
            if (self._backButton == nil)
            {
                self._backButton = UIButton()
                self._backButton.setTitle("Back", for: UIControlState.normal)
                self._backButton.layer.borderColor = UIColor.white.cgColor
                self._backButton.titleLabel?.textColor = UIColor.white
                self._backButton.backgroundColor = UIColor(red: 51/255, green: 127/255, blue: 159/255, alpha: 1)

            }
            
            let backButton = self._backButton!
            
            return backButton
        }
    }
    
    var nextButton : UIButton
    {
        get
        {
            if (self._nextButton == nil)
            {
                self._nextButton = UIButton()
                self._nextButton.setTitle("Next", for: UIControlState.normal)
                self._nextButton.layer.borderColor = UIColor.white.cgColor
                self._nextButton.backgroundColor = UIColor(red: 51/255, green: 127/255, blue: 159/255, alpha: 1)
            }
            
            let nextButton = self._nextButton!
            
            return nextButton
        }
    }
    
    override func viewDidLoad()
    {
        self.view.backgroundColor = UIColor.white
        
        self.view.addSubview(self.backButton)
        self.view.addSubview(self.nextButton)
    }
    
    override func render()
    {
        super.render()
        
        self.view.frame.size = self.viewModel.size
                
        self.backButton.titleLabel!.font = UIFont.systemFont(ofSize: 18)
        self.nextButton.titleLabel!.font = UIFont.systemFont(ofSize: 18)
        
        self.backButton.frame.size.width = self.view.frame.size.width / 2
        self.backButton.frame.size.height = 90
        
        self.nextButton.frame.size.width = self.view.frame.size.width / 2
        self.nextButton.frame.size.height = 90
        
        self.backButton.frame.origin.x = -0.5
        self.backButton.frame.origin.y = (self.view.frame.size.height - self.backButton.frame.size.height) / 2
        
        self.nextButton.frame.origin.x = self.nextButton.frame.size.width + 0.5
        self.nextButton.frame.origin.y = (self.view.frame.size.height - self.backButton.frame.size.height) / 2
    }
    
    override func bind()
    {
        super.bind()
        
        self.addObserver(self,
                         forKeyPath: DynamicKVO.keyPath(\FooterPanelController.viewModel),
                         options: NSKeyValueObservingOptions([NSKeyValueObservingOptions.new,
                                                              NSKeyValueObservingOptions.initial]),
                         context: nil)
        
        self.backButton.addTarget(self,
                                  action: #selector(self._back),
                                  for: UIControlEvents.touchDown)
        
        self.nextButton.addTarget(self,
                                  action: #selector(self._next),
                                  for: UIControlEvents.touchDown)
        
    }
    
    override func unbind()
    {
        super.unbind()
        
        self.removeObserver(self, forKeyPath: DynamicKVO.keyPath(\FooterPanelController.viewModel))
        self.backButton.removeTarget(self, action: #selector(self._back), for: UIControlEvents.touchDown)
        self.nextButton.removeTarget(self, action: #selector(self._next), for: UIControlEvents.touchDown)
    }
    
    override func observeController(for controllerEvent: DynamicController.Event, kvoEvent: DynamicKVO.Event)
    {
        if (kvoEvent.keyPath == DynamicKVO.keyPath(\FooterPanelController.viewModel))
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
    
    @objc private func _back()
    {
        if (self.viewModel != nil)
        {
            self.viewModel.back()
        }
    }
    
    @objc private func _next()
    {
        if (self.viewModel != nil)
        {
            self.viewModel.next()
        }
    }
    
    func viewModel(_ viewModel: DynamicViewModel, transitWith event: DynamicViewModel.Event)
    {
        if (event.newState == FooterPanelViewModel.State.left)
        {
        }
        else if (event.newState == FooterPanelViewModel.State.right)
        {
        }
    }
}
