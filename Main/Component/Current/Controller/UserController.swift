//
//  UserController.swift
//  MyCataractApp
//
//  Created by Roseanne Choi on 10/2/18.
//  Copyright © 2018 Rose Choi. All rights reserved.
//

import UIKit
import AVKit

final class UserController
{
    class Control : DynamicController, DynamicViewModelDelegate
    {
        private var _titleLabel : UILabel!
        private var _displayLabel : UILabel!
        private var _displayButton : UIButton!
        private var _lineView : UIView!
        @objc dynamic var viewModel : UserViewModel.ControlCard!

        var titleLabel : UILabel
        {
            get
            {
                if (self._titleLabel == nil)
                {
                    self._titleLabel = UILabel()
                    self._titleLabel.textColor = UIColor.gray
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
                    self._displayLabel.textColor = UIColor.black
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
                    self._displayButton.setImage(UIImage(contentsOfFile: Bundle.main.path(forResource: "EditArrow", ofType: "png")!),
                                                 for: UIControlState.normal)
                }
                
                let displayButton = self._displayButton!
                
                return displayButton
            }
        }
        
        var lineView : UIView
        {
            get
            {
                if (self._lineView == nil)
                {
                    self._lineView = UIView()
                    self._lineView.backgroundColor = UIColor(red: 234/255, green: 234/255, blue: 234/255, alpha: 1)
                }
                
                let lineView = self._lineView!
                
                return lineView
            }
        }
        
        override func viewDidLoad()
        {
            self.view.addSubview(self.titleLabel)
            self.view.addSubview(self.displayLabel)
            self.view.addSubview(self.displayButton)
            self.view.addSubview(self.lineView)
        }
        
        override func render()
        {
            super.render()
            
            self.view.frame.size = self.viewModel.size
            
            self.displayLabel.font = UIFont.systemFont(ofSize: 18)
            
            self.titleLabel.frame.size.width = 150
            self.titleLabel.frame.size.height = 50
            
            self.displayLabel.frame.size.width = 120
            self.displayLabel.frame.size.height = 50
            
            self.displayButton.frame.size.width = 25
            self.displayButton.frame.size.height = 25
            
            self.lineView.frame.size.width = self.view.frame.size.width
            self.lineView.frame.size.height = 1

            self.titleLabel.frame.origin.x = 15
            self.titleLabel.frame.origin.y = (self.view.frame.size.height - self.displayLabel.frame.size.height) / 2
            
            self.displayLabel.frame.origin.x = self.view.frame.size.width - self.displayLabel.frame.size.width - 50
            self.displayLabel.center.y = self.titleLabel.center.y
            
            self.displayButton.center.x = self.displayLabel.frame.origin.x + self.displayLabel.frame.size.width + 25
            self.displayButton.center.y = self.displayLabel.center.y
            
            self.lineView.frame.origin.y = self.view.frame.size.height - self.lineView.frame.size.height
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
    
    class OverLayController : DynamicController, DynamicViewModelDelegate, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout
    {
        private var _collectionViewController : UICollectionViewController!
        private var _collectionViewFlowLayout : UICollectionViewFlowLayout!
        private var _timeInputCell : DatePickerInputController.CollectionCell!
        private var _intervalInputCell : DatePickerInputController.CollectionCell!
        private var _dayInputCell : TextFieldInputController.CollectionCell!
        private var _inputButtonCell : UserController.ButtonController.CollectionCell!
        var textFieldInputControllers = [TextFieldInputViewModel:TextFieldInputController]()
        private var _buttonControllers = [UserViewModel.ButtonCardViewModel:UserController.ButtonController]()
        @objc dynamic var viewModel : UserViewModel.OverLayCardViewModel!

        var collectionViewController : UICollectionViewController
        {
            get
            {
                if (self._collectionViewController == nil)
                {
                    self._collectionViewController = UICollectionViewController(collectionViewLayout: self.collectionViewFlowLayout)
                    self._collectionViewController.collectionView!.isScrollEnabled = false
                    self._collectionViewController.collectionView!.dataSource = self
                    self._collectionViewController.collectionView!.delegate = self
                }
                
                let collectionViewController = self._collectionViewController!
                
                return collectionViewController
            }
        }
        
        var collectionViewFlowLayout : UICollectionViewFlowLayout
        {
            get
            {
                if (self._collectionViewFlowLayout == nil)
                {
                    self._collectionViewFlowLayout = UICollectionViewFlowLayout()
                    self._collectionViewFlowLayout.minimumLineSpacing = 0
                    self._collectionViewFlowLayout.minimumInteritemSpacing = 0
                }
                
                let collectionViewFlowLayout = self._collectionViewFlowLayout!
                
                return collectionViewFlowLayout
            }
        }

        var timeInputCell : DatePickerInputController.CollectionCell
        {
            get
            {
                if (self._timeInputCell == nil)
                {
                    self._timeInputCell = self.collectionViewController.collectionView?.dequeueReusableCell(withReuseIdentifier: DatePickerInputViewModel.description(),
                                                                                                            for: IndexPath(item: 1, section: 0)) as? DatePickerInputController.CollectionCell
                }

                let timeInputCell = self._timeInputCell!

                return timeInputCell
            }
        }

        var intervalInputCell : DatePickerInputController.CollectionCell
        {
            get
            {
                if (self._intervalInputCell == nil)
                {
                    self._intervalInputCell = self.collectionViewController.collectionView?.dequeueReusableCell(withReuseIdentifier: DatePickerInputViewModel.description(),
                                                                                                                for: IndexPath(item: 1, section: 0)) as? DatePickerInputController.CollectionCell
                }

                let intervalInputCell = self._intervalInputCell!

                return intervalInputCell
            }
        }

        var dayInputCell : TextFieldInputController.CollectionCell
        {
            get
            {
                if (self._dayInputCell == nil)
                {
                    self._dayInputCell = self.collectionViewController.collectionView?.dequeueReusableCell(withReuseIdentifier: TextFieldInputViewModel.description(),
                                                                                                           for: IndexPath(item: 1, section: 0)) as? TextFieldInputController.CollectionCell
                }

                let dayInputCell = self._dayInputCell!

                return dayInputCell
            }
        }

        var inputButtonCell : UserController.ButtonController.CollectionCell
        {
            get
            {
                if (self._inputButtonCell == nil)
                {
                    self._inputButtonCell = self.collectionViewController.collectionView?.dequeueReusableCell(withReuseIdentifier: UserViewModel.ButtonCardViewModel.description(),
                                                                                                              for: IndexPath(item: 2, section: 0)) as? UserController.ButtonController.CollectionCell
                }

                let inputButtonCell = self._inputButtonCell!

                return inputButtonCell
            }
        }
        
        override func viewDidLoad()
        {
            self.view.addSubview(self.collectionViewController.collectionView!)
            
            self.collectionViewController.collectionView!.backgroundColor = UIColor(red: 0/255,
                                                                                    green: 0/255,
                                                                                    blue: 0/255,
                                                                                    alpha: 0.5)
        }
    
        override func render()
        {
            super.render()

            self.view.frame.size = self.viewModel.size
  
            self.timeInputCell.datePickerInputController.viewModel = self.viewModel.timeDatePickerInputViewModel
            self.intervalInputCell.datePickerInputController.viewModel = self.viewModel.intervalDatePickerViewModel
            self.dayInputCell.textFieldInputController.viewModel = self.viewModel.textFieldTimesPerdayViewModel
            self.inputButtonCell.buttonController.viewModel = self.viewModel.confirmButtonViewModel
        }
        
        override func bind()
        {
            super.bind()
            
            self.collectionViewController.collectionView!.register(UICollectionViewCell.self,
                                                                   forCellWithReuseIdentifier: "UICollectionViewCell")
            self.collectionViewController.collectionView!.register(TextFieldInputController.CollectionCell.self,
                                                                   forCellWithReuseIdentifier: TextFieldInputViewModel.description())
            self.collectionViewController.collectionView!.register(DatePickerInputController.CollectionCell.self,
                                                                   forCellWithReuseIdentifier: DatePickerInputViewModel.description())
            self.collectionViewController.collectionView!.register(UserController.ButtonController.CollectionCell.self,
                                                                   forCellWithReuseIdentifier: UserViewModel.ButtonCardViewModel.description())
        }
        
        override func unbind()
        {
            super.unbind()
        }

        func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
        {
            if (self.viewModel != nil)
            {
                return 3
            }
            else
            {
                return 0
            }
        }
        
        func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize
        {
            var size = CGSize.zero
            
            let confirmButtonViewModelSizeWidth = self.viewModel.confirmButtonViewModel.size.width
            let confirmButtonViewModelSizeHeight = self.viewModel.confirmButtonViewModel.size.height
            
            if (self.viewModel.state == UserViewModel.OverLayCardViewModel.State.timeCompletion)
            {
                if (indexPath.item == 0)
                {
                    let width = self.view.frame.size.width
                    let height = self.view.frame.size.height - self.viewModel.timeDatePickerInputViewModel.size.height - self.viewModel.confirmButtonViewModel.size.height 
                    
                    size = CGSize(width: width,
                                  height: height)
                }
                else if (indexPath.item == 1)
                {
                    size.width = self.viewModel.timeDatePickerInputViewModel.size.width
                    size.height = self.viewModel.timeDatePickerInputViewModel.size.height
                }
                else
                {
                    size.width = confirmButtonViewModelSizeWidth
                    size.height = confirmButtonViewModelSizeHeight
                }
            }
            else if (self.viewModel.state == UserViewModel.OverLayCardViewModel.State.intervalCompletion)
            {
                if (indexPath.item == 0)
                {
                    let width = self.view.frame.size.width
                    let height = self.view.frame.size.height - self.viewModel.intervalDatePickerViewModel.size.height - self.viewModel.confirmButtonViewModel.size.height

                    size = CGSize(width: width,
                                  height: height)

                }
                else if (indexPath.item == 1)
                {
                    size.width = self.viewModel.intervalDatePickerViewModel.size.width
                    size.height = self.viewModel.intervalDatePickerViewModel.size.height
                }
                else
                {
                    size.width = confirmButtonViewModelSizeWidth
                    size.height = confirmButtonViewModelSizeHeight
                }
            }
            else
            {
                if (indexPath.item == 0)
                {
                    let width = self.view.frame.size.width
                    let height = self.view.frame.size.height - self.viewModel.textFieldTimesPerdayViewModel.size.height - self.viewModel.confirmButtonViewModel.size.height

                    size = CGSize(width: width,
                                  height: height)
                }
                else if (indexPath.item == 1)
                {
                    size.width = self.viewModel.textFieldTimesPerdayViewModel.size.width
                    size.height = self.viewModel.textFieldTimesPerdayViewModel.size.height
                }
                else
                {
                    size.width = confirmButtonViewModelSizeWidth
                    size.height = confirmButtonViewModelSizeHeight
                }
            }
            
            return size
        }
        
        func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
        {
            var cell : UICollectionViewCell! = nil
            
            if (self.viewModel.state == UserViewModel.OverLayCardViewModel.State.timeCompletion)
            {
                if (indexPath.item == 0)
                {
                    cell = self.collectionViewController.collectionView!.dequeueReusableCell(withReuseIdentifier: "UICollectionViewCell",
                                                                                             for: indexPath)
                }
                else if (indexPath.item == 1)
                {
                    cell = self.timeInputCell
                }
                else
                {
                    self._buttonControllers[self.viewModel.confirmButtonViewModel] = self.inputButtonCell.buttonController
                    
                    cell = self.inputButtonCell
                }
            }
            else if (self.viewModel.state == UserViewModel.OverLayCardViewModel.State.intervalCompletion)
            {
                if (indexPath.item == 0)
                {
                    cell = self.collectionViewController.collectionView!.dequeueReusableCell(withReuseIdentifier: "UICollectionViewCell",
                                                                                             for: indexPath)
                }
                else if (indexPath.item == 1)
                {
                    cell = self.intervalInputCell
                }
                else
                {
                    self._buttonControllers[self.viewModel.confirmButtonViewModel] = self.inputButtonCell.buttonController
                    
                    cell = self.inputButtonCell
                }
            }
            else
            {
                if (indexPath.item == 0)
                {
                    cell = self.collectionViewController.collectionView!.dequeueReusableCell(withReuseIdentifier: "UICollectionViewCell",
                                                                                             for: indexPath)
                }
                else if (indexPath.item == 1)
                {
                    cell = self.dayInputCell
                }
                else
                {
                    self._buttonControllers[self.viewModel.confirmButtonViewModel] = self.inputButtonCell.buttonController
                    
                    cell = self.inputButtonCell
                }
            }
            
            return cell
        }

        override func observeController(for controllerEvent: DynamicController.Event, kvoEvent: DynamicKVO.Event)
        {
            if (kvoEvent.keyPath == DynamicKVO.keyPath(\UserController.OverLayController.viewModel))
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
        
        func viewModel(_ viewModel: DynamicViewModel, transitWith event: DynamicViewModel.Event)
        {
            if (event.newState == UserViewModel.OverLayCardViewModel.State.timeCompletion ||
                event.newState == UserViewModel.OverLayCardViewModel.State.intervalCompletion ||
                event.newState == UserViewModel.OverLayCardViewModel.State.textFieldCompletion)
            {
                self.collectionViewController.modalPresentationStyle = UIModalPresentationStyle.overFullScreen
                self.collectionViewController.collectionView!.reloadData()
            }
            else
            {
                self.dayInputCell.textFieldInputController.textField.resignFirstResponder()
            }
        }
    }
    
    class AppointmentInputController : DynamicController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, DynamicViewModelDelegate
    {
        private var _collectionViewController : UICollectionViewController!
        private var _collectionViewFlowLayout : UICollectionViewFlowLayout!
        private var _textFieldInputCell : TextFieldInputController.CollectionCell!
        private var _buttonCell : UserController.ButtonController.CollectionCell!
        @objc dynamic var viewModel : UserViewModel.AppointmentInputViewModel!
        
        var collectionViewController : UICollectionViewController
        {
            get
            {
                if (self._collectionViewController == nil)
                {
                    self._collectionViewController = UICollectionViewController(collectionViewLayout: self.collectionViewFlowLayout)
                    self._collectionViewController.collectionView!.dataSource = self
                    self._collectionViewController.collectionView!.delegate = self
                }
                
                let collectionViewController = self._collectionViewController!
                
                return collectionViewController
            }
        }
        
        var collectionViewFlowLayout : UICollectionViewFlowLayout
        {
            get
            {
                if (self._collectionViewFlowLayout == nil)
                {
                    self._collectionViewFlowLayout = UICollectionViewFlowLayout()
                    self._collectionViewFlowLayout.minimumLineSpacing = 0
                    self._collectionViewFlowLayout.minimumInteritemSpacing = 0
                }
                
                let collectionViewFlowLayout = self._collectionViewFlowLayout!
                
                return collectionViewFlowLayout
            }
        }
        
        var textFieldInputCell : TextFieldInputController.CollectionCell
        {
            get
            {
                if (self._textFieldInputCell == nil)
                {
                    self._textFieldInputCell = self.collectionViewController.collectionView!.dequeueReusableCell(withReuseIdentifier: TextFieldInputViewModel.description(),
                                                                                                                 for: IndexPath(item: 1, section: 0)) as? TextFieldInputController.CollectionCell
                }
                
                let textFieldInputCell = self._textFieldInputCell!
                
                return textFieldInputCell
            }
        }

        var buttonCell : UserController.ButtonController.CollectionCell
        {
            get
            {
                if (self._buttonCell == nil)
                {
                    self._buttonCell = self.collectionViewController.collectionView!.dequeueReusableCell(withReuseIdentifier: UserViewModel.ButtonCardViewModel.description(),
                                                                                                         for: IndexPath(item: 2, section: 0)) as? UserController.ButtonController.CollectionCell
                }
                
                let buttonCell = self._buttonCell!
                
                return buttonCell
            }
        }
        
        override func viewDidLoad()
        {
            self.view.addSubview(self.collectionViewController.collectionView!)
            self.collectionViewController.collectionView!.backgroundColor = UIColor(red: 0/255,
                                                                                    green: 0/255,
                                                                                    blue: 0/255,
                                                                                    alpha: 0.5)
        }
        
        override func render()
        {
            super.render()
            
            self.view.frame.size = self.viewModel.size
            
            self.collectionViewController.collectionView!.reloadData()
            
            self.buttonCell.buttonController.viewModel = self.viewModel.buttonViewModel
            self.textFieldInputCell.textFieldInputController.viewModel = self.viewModel.textFieldInputViewModel
        }
        
        override func bind()
        {
            super.bind()

            self.collectionViewController.collectionView!.register(UICollectionViewCell.self,
                                                                   forCellWithReuseIdentifier: "UICollectionViewCell")
            self.collectionViewController.collectionView!.register(TextFieldInputController.CollectionCell.self,
                                                                   forCellWithReuseIdentifier: TextFieldInputViewModel.description())
            self.collectionViewController.collectionView!.register(UserController.ButtonController.CollectionCell.self,
                                                                   forCellWithReuseIdentifier: UserViewModel.ButtonCardViewModel.description())
        }
        
        override func unbind()
        {
            super.unbind()
        }
        
        func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
        {
            if (self.viewModel != nil)
            {
                return 3
            }
            else
            {
                return 0
            }
        }
        
        func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize
        {
            var size = CGSize.zero
            
            if (indexPath.item == 0)
            {
                let width = self.viewModel.size.width
                let height = self.viewModel.size.height - self.viewModel.buttonViewModel.size.height - self.viewModel.textFieldInputViewModel.size.height
                
                size = CGSize(width: width, height: height)
            }
            else if (indexPath.item == 1)
            {
                size = self.viewModel.textFieldInputViewModel.size
            }
            else if (indexPath.item == 2)
            {
                size = self.viewModel.buttonViewModel.size
            }
            
            return size
        }
        
        func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
        {
            var cell : UICollectionViewCell! = nil
            
            if (indexPath.item == 0)
            {
                cell = self.collectionViewController.collectionView!.dequeueReusableCell(withReuseIdentifier: "UICollectionViewCell",
                                                                                         for: indexPath) 
            }
            else if (indexPath.item == 1)
            {
                cell = self.textFieldInputCell
            }
            else if (indexPath.item == 2)
            {
                cell = self.buttonCell
            }

            return cell
        }

        override func observeController(for controllerEvent: DynamicController.Event, kvoEvent: DynamicKVO.Event)
        {
            if (kvoEvent.keyPath == DynamicKVO.keyPath(\AppointmentInputController.viewModel))
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
        
        func viewModel(_ viewModel: DynamicViewModel, transitWith event: DynamicViewModel.Event)
        {
            if (event.newState == UserViewModel.AppointmentInputViewModel.State.custom)
            {
                self.textFieldInputCell.textFieldInputController.textField.becomeFirstResponder()
                
                self.collectionViewController.modalPresentationStyle = UIModalPresentationStyle.overFullScreen
            }
            else
            {
                self.textFieldInputCell.textFieldInputController.textField.resignFirstResponder()
            }
        }
    }
    
    class ButtonController : DynamicController, DynamicViewModelDelegate
    {
        private var _button : UIButton!
        @objc dynamic var viewModel : UserViewModel.ButtonCardViewModel!

        var button : UIButton
        {
            get
            {
                if (self._button == nil)
                {
                    self._button = UIButton()
                    self._button.setTitle("Confirm", for: UIControlState.normal)
                    self._button.backgroundColor = UIColor(red: 51/255, green: 127/255, blue: 159/255, alpha: 1)
                }
                
                let button = self._button!
                
                return button
            }
        }
        
        override func viewDidLoad()
        {
            self.view.addSubview(self.button)
        }
        
        override func render()
        {
            super.render()
            
            self.view.frame.size = self.viewModel.size
            
            self.button.frame.size.width = self.view.frame.size.width
            self.button.frame.size.height = self.view.frame.size.height
            self.button.frame.origin.y = (self.view.frame.size.height - self.button.frame.size.height) / 2
        }
        
        override func bind()
        {
            super.bind()
            
            self.addObserver(self,
                             forKeyPath: DynamicKVO.keyPath(\ButtonController.viewModel),
                             options: NSKeyValueObservingOptions([NSKeyValueObservingOptions.new,
                                                                  NSKeyValueObservingOptions.initial]),
                             context: nil)
            
            self.button.addTarget(self,
                                  action: #selector(self._confirm),
                                  for: UIControlEvents.touchDown)
            
        }
        
        override func unbind()
        {
            super.unbind()
            
            self.removeObserver(self,
                                forKeyPath: DynamicKVO.keyPath(\ButtonController.viewModel),
                                context: nil)
            
            self.button.removeTarget(self,
                                     action: #selector(self._confirm),
                                     for: UIControlEvents.touchDown)
        }
        
        override func observeController(for controllerEvent: DynamicController.Event, kvoEvent: DynamicKVO.Event)
        {
            if (kvoEvent.keyPath == DynamicKVO.keyPath(\UserController.ButtonController.viewModel))
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
        
        @objc private func _confirm()
        {
            if (self.viewModel != nil)
            {
                self.viewModel.confirm()
            }
        }
        
        func viewModel(_ viewModel: DynamicViewModel, transitWith event: DynamicViewModel.Event)
        {
            if (event.transition == UserViewModel.ButtonCardViewModel.Transition.confirm)
            {
            }
        }
        
        class CollectionCell : UICollectionViewCell
        {
            private var _buttonController : UserController.ButtonController!
            
            var buttonController : UserController.ButtonController
            {
                get
                {
                    if (self._buttonController == nil)
                    {
                        self._buttonController = UserController.ButtonController()
                        self._buttonController.bind()
                        self.addSubview(self._buttonController.view)
                        self.autoresizesSubviews = false
                    }
                    
                    let buttonController = self._buttonController!
                    
                    return buttonController
                }
            }
        }
    }
    
    class AddButtonController : DynamicController, DynamicViewModelDelegate
    {
        private var _button : UIButton!
        @objc dynamic var viewModel : UserViewModel.AddButtonViewModel!
        
        var button : UIButton
        {
            get
            {
                if (self._button == nil)
                {
                    self._button = UIButton()
                    self._button.setImage(UIImage(contentsOfFile: Bundle.main.path(forResource: "Add", ofType: "png")!),
                                          for: UIControlState.normal)
                }
                
                let button = self._button!
                
                return button
            }
        }
        
        override func viewDidLoad()
        {
            self.view.addSubview(self.button)
        }
        
        override func render()
        {            
            super.render()
            
            self.view.frame.size = self.viewModel.size
                        
            self.button.frame.size.width = self.view.frame.size.width
            self.button.frame.size.height = self.view.frame.size.height
            self.button.frame.origin.x = (self.view.frame.size.width - self.button.frame.size.width) / 2
            self.button.frame.origin.y = (self.view.frame.size.height - self.button.frame.size.height) / 2
        }
        
        override func bind()
        {
            super.bind()
            
            self.addObserver(self,
                             forKeyPath: DynamicKVO.keyPath(\AddButtonController.viewModel),
                             options: NSKeyValueObservingOptions([NSKeyValueObservingOptions.new,
                                                                  NSKeyValueObservingOptions.initial]),
                             context: nil)
            self.button.addTarget(self,
                                  action: #selector(self._add),
                                  for: UIControlEvents.touchDown)
        }
        
        override func unbind()
        {
            super.unbind()
            
            self.removeObserver(self, forKeyPath: DynamicKVO.keyPath(\UserController.AddButtonController.viewModel))
        }
        
        @objc private func _add()
        {
            if (self.viewModel != nil)
            {
                self.viewModel.add()
            }
        }
        
        override func observeController(for controllerEvent: DynamicController.Event, kvoEvent: DynamicKVO.Event)
        {
            if (kvoEvent.keyPath == DynamicKVO.keyPath(\UserController.AddButtonController.viewModel))
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
        
        func viewModel(_ viewModel: DynamicViewModel, transitWith event: DynamicViewModel.Event)
        {
            if (event.transition == UserViewModel.AddButtonViewModel.Transition.add)
            {
            }
        }
        
        class CollectionCell : UICollectionViewCell
        {
            private var _addButtonController : UserController.AddButtonController!
            
            var addButtonController : UserController.AddButtonController
            {
                get
                {
                    if (self._addButtonController == nil)
                    {
                        self._addButtonController = UserController.AddButtonController()
                        self._addButtonController.bind()
                        self.addSubview(self._addButtonController.view)
                        self.autoresizesSubviews = false
                    }
                    
                    let addButtonController = self._addButtonController!
                    
                    return addButtonController
                }
            }
        }
    }
    
    class AppointmentFormLabelController : DynamicController, DynamicViewModelDelegate
    {
        private var _labelController : LabelController!
        @objc dynamic var viewModel : UserViewModel.AppointmentFormLabelViewModel!
        
        var labelController : LabelController
        {
            get
            {
                if (self._labelController == nil)
                {
                    self._labelController = LabelController()
                    self._labelController.view.backgroundColor = UIColor.white
                }
                
                let labelController = self._labelController!
                
                return labelController
            }
        }
        
        override func viewDidLoad()
        {
            self.view.addSubview(self.labelController.view)
        }
        
        override func render()
        {
            super.render()
            
            self.view.frame.size = self.viewModel.size
            
            self.viewModel.labelViewModel.size = self.viewModel.size
            self.labelController.viewModel = self.viewModel.labelViewModel
        }
        
        override func bind()
        {
            super.bind()
            
            self.labelController.bind()
            
            self.addObserver(self,
                             forKeyPath: DynamicKVO.keyPath(\AppointmentFormLabelController.viewModel),
                             options: NSKeyValueObservingOptions([NSKeyValueObservingOptions.initial,
                                                                  NSKeyValueObservingOptions.new]),
                             context: nil)
        }
        
        override func unbind()
        {
            super.unbind()
            
            self.removeObserver(self, forKeyPath: DynamicKVO.keyPath(\AppointmentFormLabelController.viewModel))
        }

        override func observeController(for controllerEvent: DynamicController.Event, kvoEvent: DynamicKVO.Event)
        {
            if (kvoEvent.keyPath == DynamicKVO.keyPath(\UserController.AppointmentFormLabelController.viewModel))
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
        
        func viewModel(_ viewModel: DynamicViewModel, transitWith event: DynamicViewModel.Event)
        {
            if (event.newState == UserViewModel.AppointmentFormLabelViewModel.State.on)
            {
                self.labelController.label.backgroundColor = UIColor(red: 51/255, green: 127/255, blue: 159/255, alpha: 1)
                self.labelController.label.textColor = UIColor.white
            }
            else if (event.newState == UserViewModel.AppointmentFormLabelViewModel.State.off)
            {
                self.labelController.label.backgroundColor = UIColor.white
                self.labelController.label.textColor = UIColor.black
            }
        }
        
        class CollectionCell : UICollectionViewCell
        {
            private var _appointmentLabelController : UserController.AppointmentFormLabelController!
            
            var appointmentLabelController : UserController.AppointmentFormLabelController
            {
                get
                {
                    if (self._appointmentLabelController == nil)
                    {
                        self._appointmentLabelController = UserController.AppointmentFormLabelController()
                        self._appointmentLabelController.bind()
                        self.addSubview(self._appointmentLabelController.view)
                        self.autoresizesSubviews = false
                    }
                    
                    let appointmentLabelController = self._appointmentLabelController!
                    
                    return appointmentLabelController
                }
            }
        }
    }
    
    class MenuOverlayController : DynamicController, DynamicViewModelDelegate
    {
        private var _label : UILabel!
        private var _deleteButton : UIButton!
        private var _editButton : UIButton!
        private var _cancelButton : UIButton!
        @objc dynamic var viewModel : UserViewModel.MenuOverlayViewModel!
        
        var label : UILabel
        {
            get
            {
                if (self._label == nil)
                {
                    self._label = UILabel()
                    self._label.text = "What would you like to do with this item?"
                    self._label.backgroundColor = UIColor.white
                    self._label.textColor = UIColor.black
                    self._label.textAlignment = .center
                }
                
                let label = self._label!
                
                return label
            }
        }
        
        var deleteButton : UIButton
        {
            get
            {
                if (self._deleteButton == nil)
                {
                    self._deleteButton = UIButton()
                    self._deleteButton.setTitle("Delete", for: UIControlState.normal)
                    self._deleteButton.titleLabel!.textColor = UIColor.white
                    self._deleteButton.backgroundColor = UIColor(red: 51/255,
                                                                  green: 127/255,
                                                                  blue: 159/255,
                                                                  alpha: 1)
                }
                
                let deleteButton = self._deleteButton!
                
                return deleteButton
            }
        }
        
        var editButton : UIButton
        {
            get
            {
                if (self._editButton == nil)
                {
                    self._editButton = UIButton()
                    self._editButton.setTitle("Edit", for: UIControlState.normal)
                    self._editButton.backgroundColor = UIColor(red: 51/255,
                                                               green: 127/255,
                                                               blue: 159/255,
                                                               alpha: 1)
                }
                
                let editButton = self._editButton!
                
                return editButton
            }
        }
        
        var cancelButton : UIButton
        {
            get
            {
                if (self._cancelButton == nil)
                {
                    self._cancelButton = UIButton()
                    self._cancelButton.setTitle("Cancel", for: UIControlState.normal)
                    self._cancelButton.titleLabel!.textColor = UIColor.white
                    self._cancelButton.backgroundColor = UIColor(red: 51/255,
                                                                 green: 127/255,
                                                                 blue: 159/255,
                                                                 alpha: 1)
                }
                
                let cancelButton = self._cancelButton!
                
                return cancelButton
            }
        }

        override func viewDidLoad()
        {
            self.view.backgroundColor = UIColor.white
            
            self.view.addSubview(self.label)
            self.view.addSubview(self.deleteButton)
            self.view.addSubview(self.editButton)
            self.view.addSubview(self.cancelButton)
        }
        
        override func render()
        {
            super.render()
            
            self.view.frame.size = self.viewModel.size
            
            self.label.frame.size.width = self.view.frame.size.width
            self.label.frame.size.height = 100
            
            self.deleteButton.frame.size.width = self.view.frame.size.width
            self.deleteButton.frame.size.height = 90
            
            self.editButton.frame.size.width = self.view.frame.size.width
            self.editButton.frame.size.height = 90
            
            self.cancelButton.frame.size.width = self.view.frame.size.width
            self.cancelButton.frame.size.height = 90
            
            self.label.frame.origin.y = (self.view.frame.size.height - self.label.frame.size.height - self.deleteButton.frame.size.height - self.editButton.frame.size.height - self.cancelButton.frame.size.height - 10) / 2
            
            self.deleteButton.frame.origin.y = self.label.frame.origin.y + self.label.frame.size.height
            
            self.editButton.frame.origin.y = self.deleteButton.frame.origin.y + self.deleteButton.frame.size.height + 5
            
            self.cancelButton.frame.origin.y = self.editButton.frame.origin.y + self.editButton.frame.size.height + 5
        }
        
        override func bind()
        {
            super.bind()
            
            self.deleteButton.addTarget(self,
                                         action: #selector(self._discontinue),
                                         for: UIControlEvents.touchDown)
            
            self.editButton.addTarget(self, action: #selector(self._modify),
                                      for: UIControlEvents.touchDown)
            
            self.cancelButton.addTarget(self,
                                        action: #selector(self._cancel),
                                        for: UIControlEvents.touchDown)
        }
        
        override func unbind()
        {
            super.unbind()
            
            self.deleteButton.removeTarget(self, action: #selector(self._discontinue), for: UIControlEvents.touchDown)
            self.editButton.removeTarget(self, action: #selector(self._modify), for: UIControlEvents.touchDown)
            self.cancelButton.removeTarget(self, action: #selector(self._cancel), for: UIControlEvents.touchDown)
        }
        
        @objc private func _discontinue()
        {
            if (self.viewModel != nil)
            {
                self.viewModel.discontinue()
            }
        }
        
        @objc private func _modify()
        {
            if (self.viewModel != nil)
            {
                self.viewModel.modify()
            }
        }
        
        @objc private func _cancel()
        {
            if (self.viewModel != nil)
            {
                self.viewModel.cancel()
            }
        }
        
        override func observeController(for controllerEvent: DynamicController.Event, kvoEvent: DynamicKVO.Event)
        {
            if (kvoEvent.keyPath == DynamicKVO.keyPath(\MenuOverlayController.viewModel))
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
        
        func viewModel(_ viewModel: DynamicViewModel, transitWith event: DynamicViewModel.Event)
        {
            if (event.newState == UserViewModel.MenuOverlayViewModel.State.revision)
            {
                print("REVISING")
            }
        }
    }
    
    class OnboardingViewController : DynamicController, DynamicViewModelDelegate, AVPlayerViewControllerDelegate
    {
        private var _player : AVPlayer!
        private var _button : UIButton!
        private var _playerViewController : AVPlayerViewController!
        @objc dynamic var viewModel : UserViewModel.OnboardingViewModel!
        
        @objc var player : AVPlayer
        {
            get
            {
                if (self._player == nil)
                {
                    self._player = AVPlayer(url: URL(fileURLWithPath: Bundle.main.path(forResource: "CataractInstructionVideo", ofType: "mov")!))
                }
                
                let player = self._player!
                
                return player
            }
        }
        
        var button : UIButton
        {
            get
            {
                if (self._button == nil)
                {
                    self._button = UIButton()
                    self._button.setTitle("Confirm", for: UIControlState.normal)
                    self._button.backgroundColor = UIColor(red: 51/255,
                                                           green: 127/255,
                                                           blue: 159/255,
                                                           alpha: 1)
                }
                
                let button = self._button!
                
                return button
            }
        }
        
        var playerViewController : AVPlayerViewController
        {
            get
            {
                if (self._playerViewController == nil)
                {
                    self._playerViewController = AVPlayerViewController()
                    self._playerViewController.player = self.player
                }
                
                let playerViewController = self._playerViewController!
                
                return playerViewController
            }
        }
        
        override func viewDidLoad()
        {            
            self.view.addSubview(self.playerViewController.view)
        }
        
        override func render()
        {
            super.render()
            
            self.view.frame.size = self.viewModel.size
  
            self.playerViewController.view.frame.size.width = self.view.frame.size.width
            self.playerViewController.view.frame.size.height = self.view.frame.size.height
        }
  
        override func bind()
        {            
            super.bind()
            
            NotificationCenter.default.addObserver(self,
                                                   selector: #selector(self.playerEnded(notification:)),
                                                   name: NSNotification.Name.AVPlayerItemDidPlayToEndTime,
                                                   object: player.currentItem)
            
            self.addObserver(self,
                             forKeyPath: "player.rate",
                             options: NSKeyValueObservingOptions([NSKeyValueObservingOptions.new,
                                                                  NSKeyValueObservingOptions.initial]),
                             context: nil)
            
            self.button.addTarget(self,
                                  action: #selector(self._leave),
                                  for: UIControlEvents.touchDown)
        }
        
        @objc func playerEnded(notification: Notification)
        {
            self.button.frame.size.width = self.view.frame.size.width
            self.button.frame.size.height = 100
            
            self.playerViewController.view.frame.size.height = self.view.frame.size.height - self.button.frame.size.height
            
            self.button.frame.origin.y = self.view.frame.size.height - self.button.frame.size.height
            
            self.view.addSubview(self.button)
        }
        
        @objc private func _leave()
        {
            if (self.viewModel != nil)
            {
                self.viewModel.leave()
            }
        }
        
        override func observeController(for controllerEvent: DynamicController.Event, kvoEvent: DynamicKVO.Event)
        {
            if (kvoEvent.keyPath == DynamicKVO.keyPath(\OnboardingViewController.viewModel))
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
            if (kvoEvent.keyPath == "player.rate")
            {
                if (player.rate == 1.0)
                {
                    self.playerViewController.view.frame.size.width = self.view.frame.size.width
                    self.playerViewController.view.frame.size.height = self.view.frame.size.height

                    self.button.removeFromSuperview()
                }
            }
        }
        
        func viewModel(_ viewModel: DynamicViewModel, transitWith event: DynamicViewModel.Event)
        {
        }
    }
}
