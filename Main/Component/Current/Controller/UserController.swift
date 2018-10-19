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
        private var _lineView : UIView!
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
        @objc dynamic var viewModel : UserViewModel.OverLayCardViewModel!

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

        var timeInputCell : DatePickerInputController.CollectionCell
        {
            get
            {
                if (self._timeInputCell == nil)
                {
                    self._timeInputCell = self.collectionViewController.collectionView?.dequeueReusableCell(withReuseIdentifier: DatePickerInputViewModel.description(), for: IndexPath(item: 0, section: 1)) as? DatePickerInputController.CollectionCell
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
                    self._intervalInputCell = self.collectionViewController.collectionView?.dequeueReusableCell(withReuseIdentifier: DatePickerInputViewModel.description(), for: IndexPath(item: 0, section: 1)) as? DatePickerInputController.CollectionCell
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
                    self._dayInputCell = self.collectionViewController.collectionView?.dequeueReusableCell(withReuseIdentifier: TextFieldInputViewModel.description(), for: IndexPath(item: 0, section: 1)) as? TextFieldInputController.CollectionCell
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
                    self._inputButtonCell = self.collectionViewController.collectionView?.dequeueReusableCell(withReuseIdentifier: UserViewModel.ButtonCardViewModel.description(), for: IndexPath(item: 0, section: 2)) as? UserController.ButtonController.CollectionCell
                }
                
                let inputButtonCell = self._inputButtonCell!
                
                return inputButtonCell
            }
        }
        
        override func viewDidLoad()
        {
            self.view.addSubview(self.collectionViewController.collectionView!)
            self.collectionViewController.collectionView!.backgroundColor = UIColor(red: 0/255, green: 0/255, blue: 0/255, alpha: 0.5)
        }
        
        override func render()
        {
            super.render()
            
            self.view.frame.size = self.viewModel.size
            
            self.viewModel.timeDatePickerInputViewModel.size.width = self.view.frame.size.width
            self.viewModel.timeDatePickerInputViewModel.size.height = 130
            
            self.viewModel.intervalDatePickerViewModel.size.width = self.view.frame.size.width
            self.viewModel.intervalDatePickerViewModel.size.height = 130
            
            self.viewModel.textFieldTimesPerdayViewModel.size.width = self.view.frame.size.width
            self.viewModel.textFieldTimesPerdayViewModel.size.height = 100
            
            self.viewModel.confirmButtonViewModel.size.width = self.view.frame.size.width
            self.viewModel.confirmButtonViewModel.size.height = 101
            
            self.timeInputCell.datePickerInputController.viewModel = self.viewModel.timeDatePickerInputViewModel
            self.intervalInputCell.datePickerInputController.viewModel = self.viewModel.intervalDatePickerViewModel
            self.dayInputCell.textFieldInputController.viewModel = self.viewModel.textFieldTimesPerdayViewModel
            self.inputButtonCell.buttonController.viewModel = self.viewModel.confirmButtonViewModel
        }
        
        override func bind()
        {
            super.bind()
            
            self.collectionViewController.collectionView!.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "UICollectionViewCell")
            self.collectionViewController.collectionView!.register(TextFieldInputController.CollectionCell.self,
                                                                   forCellWithReuseIdentifier: TextFieldInputViewModel.description())
            self.collectionViewController.collectionView!.register(DatePickerInputController.CollectionCell.self,
                                                                   forCellWithReuseIdentifier: DatePickerInputViewModel.description())
            self.collectionViewController.collectionView!.register(UserController.ButtonController.CollectionCell.self, forCellWithReuseIdentifier: UserViewModel.ButtonCardViewModel.description())
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
            var confirmButtonViewModelSizeWidth = self.viewModel.confirmButtonViewModel.size.width
            var confirmButtonViewModelSizeHeight = self.viewModel.confirmButtonViewModel.size.height
            
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
            
            cell = self.collectionViewController.collectionView?.dequeueReusableCell(withReuseIdentifier: "UICollectionViewCell",
                                                                                     for: indexPath)
            
            if (self.viewModel.state == UserViewModel.OverLayCardViewModel.State.timeCompletion)
            {
                if (indexPath.item == 0)
                {
                    cell = self.collectionViewController.collectionView?.dequeueReusableCell(withReuseIdentifier: "UICollectionViewCell",
                                                                                             for: indexPath)
                }
                else if (indexPath.item == 1)
                {
                    cell = self.timeInputCell
                }
                else
                {
                    cell = self.inputButtonCell
                }
            }
            else if (self.viewModel.state == UserViewModel.OverLayCardViewModel.State.intervalCompletion)
            {
                if (indexPath.item == 0)
                {
                    cell = self.collectionViewController.collectionView?.dequeueReusableCell(withReuseIdentifier: "UICollectionViewCell",
                                                                                             for: indexPath)
                }
                else if (indexPath.item == 1)
                {
                    cell = self.intervalInputCell
                }
                else
                {
                    cell = self.inputButtonCell
                }
            }
            else
            {
                if (indexPath.item == 0)
                {
                    cell = self.collectionViewController.collectionView?.dequeueReusableCell(withReuseIdentifier: "UICollectionViewCell",
                                                                                             for: indexPath)
                }
                else if (indexPath.item == 1)
                {
                    cell = self.dayInputCell
                }
                else
                {
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
                self.collectionViewController.collectionView?.reloadData()
            }
            else
            {
                self.dayInputCell.textFieldInputController.textField.resignFirstResponder()
            }
        }
        
        class EmptyCollectionCell : UICollectionViewCell
        {
            override init(frame: CGRect)
            {
                super.init(frame: frame)
            }
            
            required init?(coder aDecoder: NSCoder) {
                fatalError("init(coder:) has not been implemented")
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
            self.button.frame.size.height = 100
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
                print("confirmed")
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
    
    class AddButtonController : DynamicController
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
            
            self.button.frame.size.width = 10
            self.button.frame.size.height = self.button.frame.size.width
            self.button.frame.origin.x = (self.view.frame.size.width - self.button.frame.size.width) / 2
            self.button.frame.origin.y = (self.view.frame.size.height - self.button.frame.size.height) / 2
        }
        
        override func bind()
        {
            super.bind()
            
            self.addObserver(self,
                             forKeyPath: DynamicKVO.keyPath(\UserController.AddButtonController.viewModel),
                             options: NSKeyValueObservingOptions([NSKeyValueObservingOptions.new,
                                                                  NSKeyValueObservingOptions.initial]),
                             context: nil)
        }
        
        override func unbind()
        {
            super.unbind()
            
            self.removeObserver(self, forKeyPath: DynamicKVO.keyPath(\UserController.AddButtonController.viewModel))
        }
    }
}
