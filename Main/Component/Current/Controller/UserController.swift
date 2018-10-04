//
//  UserController.swift
//  MyCataractApp
//
//  Created by Roseanne Choi on 10/2/18.
//  Copyright © 2018 Rose Choi. All rights reserved.
//

import UIKit

final class UserController
{
    class Control : DynamicController, DynamicViewModelDelegate
    {
        private var _colorCardViewModel : ColorCardViewModel!
        private var _titleLabel : UILabel!
        private var _displayLabel : UILabel!
        private var _displayButton : UIButton!
        @objc dynamic var viewModel : UserViewModel.ControlCard!
        
        var colorCardViewModel : ColorCardViewModel
        {
            get
            {
                if (self._colorCardViewModel == nil)
                {
                    self._colorCardViewModel = ColorCardViewModel(redValue: 51,
                                                                  greenValue: 127,
                                                                  blueValue: 159,
                                                                  alphaValue: 1)
                }
                
                let colorCardViewModel = self._colorCardViewModel!
                
                return colorCardViewModel
            }
        }
        
        var titleLabel : UILabel
        {
            get
            {
                if (self._titleLabel == nil)
                {
                    self._titleLabel = UILabel()
                    self._titleLabel.textColor = self.colorCardViewModel.uicolor
                }
                
                let titleLabel = self._titleLabel!
                
                return titleLabel
            }
        }
        
        var displayLabel : UILabel
        {
            get
            {
                if (self._displayLabel == nil)
                {
                    self._displayLabel = UILabel()
                    self._displayLabel.textColor = self.colorCardViewModel.uicolor
                    self._displayLabel.textAlignment = NSTextAlignment.center
                }
                
                let displayLabel = self._displayLabel!
                
                return displayLabel
            }
        }
        
        var displayButton : UIButton
        {
            get
            {
                if (self._displayButton == nil)
                {
                    self._displayButton = UIButton()
                    self._displayButton.layer.borderWidth = 1
                    self._displayButton.layer.cornerRadius = 20
                    self._displayButton.layer.borderColor = UIColor.black.cgColor
                }
                
                let displayButton = self._displayButton!
                
                return displayButton
            }
        }
        
        override func viewDidLoad()
        {
            self.view.addSubview(self.titleLabel)
            self.view.addSubview(self.displayLabel)
            self.view.addSubview(self.displayButton)
        }
        
        override func render()
        {
            super.render()
            
            self.view.frame.size = self.viewModel.size
            
            self.titleLabel.frame.size.width = 150
            self.titleLabel.frame.size.height = 50
            
            self.displayLabel.frame.size.width = 120
            self.displayLabel.frame.size.height = 50
            
            self.displayButton.frame.size.width = self.displayLabel.frame.size.width + 5
            self.displayButton.frame.size.height = self.displayLabel.frame.size.height + 5
            
            self.titleLabel.frame.origin.x = 15
            self.titleLabel.frame.origin.y = (self.view.frame.size.height - self.displayLabel.frame.size.height) / 2
            
            self.displayLabel.frame.origin.x = self.view.frame.size.width - self.displayLabel.frame.size.width - 15
            self.displayLabel.center.y = self.titleLabel.center.y
            
            self.displayButton.center.x = self.displayLabel.center.x
            self.displayButton.center.y = self.displayLabel.center.y
        }
        
        override func bind()
        {
            super.bind()

            self.addObserver(self,
                             forKeyPath: DynamicKVO.keyPath(\UserController.Control.viewModel.title),
                             options: NSKeyValueObservingOptions([NSKeyValueObservingOptions.new,
                                                                  NSKeyValueObservingOptions.initial]),
                             context: nil)
            
            self.addObserver(self,
                             forKeyPath: DynamicKVO.keyPath(\UserController.Control.viewModel.display),
                             options: NSKeyValueObservingOptions([NSKeyValueObservingOptions.new,
                                                                  NSKeyValueObservingOptions.initial]),
                             context: nil)
            
            self.displayButton.addTarget(self,
                                         action: #selector(self._edit),
                                         for: UIControlEvents.touchDown)
        }
        
        override func unbind()
        {
            super.unbind()

            self.removeObserver(self, forKeyPath: DynamicKVO.keyPath(\UserController.Control.viewModel.title))
            self.removeObserver(self, forKeyPath: DynamicKVO.keyPath(\UserController.Control.viewModel.display))
            self.displayButton.removeTarget(self, action: #selector(self._edit), for: UIControlEvents.touchDown)
        }
        
        override func observeKeyValue(for kvoEvent: DynamicKVO.Event)
        {
            if (kvoEvent.kind == DynamicKVO.Event.Kind.setting)
            {
                if (kvoEvent.keyPath == DynamicKVO.keyPath(\UserController.Control.viewModel.title))
                {
                    let newValue = kvoEvent.newValue as? String
                    self.set(title: newValue)
                }
                else if (kvoEvent.keyPath == DynamicKVO.keyPath(\UserController.Control.viewModel.display))
                {
                    let newValue = kvoEvent.newValue as? String
                    self.set(display: newValue)
                }
            }
        }
        
        func set(title: String?)
        {
            self.titleLabel.text = title
        }
        
        func set(display: String?)
        {
            self.displayLabel.text = display
        }
        
        override func observeController(for controllerEvent: DynamicController.Event, kvoEvent: DynamicKVO.Event)
        {
            if (kvoEvent.keyPath == DynamicKVO.keyPath(\UserController.Control.viewModel))
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
        
        @objc private func _edit()
        {
            if (self.viewModel != nil)
            {
                self.viewModel.edit()
            }
        }
        
        func viewModel(_ viewModel: DynamicViewModel, transitWith event: DynamicViewModel.Event)
        {
            if (event.transition == UserViewModel.ControlCard.Transition.edit)
            {
                print("Edit")
            }
        }
        
        class CollectionCell : UICollectionViewCell
        {
            private var _control : UserController.Control!
            
            var control : UserController.Control
            {
                get
                {
                    if (self._control == nil)
                    {
                        self._control = UserController.Control()
                        self._control.bind()
                        self.addSubview(self._control.view)
                        self.autoresizesSubviews = false
                    }
                    
                    let control = self._control!
                    
                    return control
                }
            }
        }
    }
}
