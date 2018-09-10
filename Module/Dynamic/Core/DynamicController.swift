//
//  DynamicController.swift
//  Pacific
//
//  Created by Minh Nguyen on 2/25/18.
//  Copyright © 2018 Langtutheky. All rights reserved.
//

import UIKit

class DynamicController :  UIViewController
{
    private var _isBound = false
    private static var viewModelContext = "viewModelContext"
    private static var controllerEventContext = "controllerEventContext"
    private static var viewModelEventContext = "viewModelEventContext"
    private static var storeEventContext = "storeEventContext"
    
    init()
    {
        super.init(nibName: nil, bundle: nil)
        
        self.view.autoresizesSubviews = false
    }
    
    required init?(coder aDecoder: NSCoder)
    {
        fatalError("init(coder:) has not been implemented")
    }
    
    var isBound : Bool
    {
        get
        {
            let isBound = self._isBound
            
            return isBound
        }
    }
    
    var viewModelKeyPath : String
    {
        get
        {
            let viewModelKeyPath = "viewModel"
            
            return viewModelKeyPath
        }
    }
    
    var controllerEventKeyPaths : Set<String>
    {
        get
        {
            let controllerEventKeyPaths = Set<String>()
            
            return controllerEventKeyPaths
        }
    }
    
    var viewModelEventKeyPaths : Set<String>
    {
        get
        {
            let viewModelEventKeyPaths = Set<String>()
            
            return viewModelEventKeyPaths
        }
    }
    
    var storeEventKeyPaths : Set<String>
    {
        get
        {
            let storeEventKeyPaths = Set<String>()
            
            return storeEventKeyPaths
        }
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator)
    {
        super.viewWillTransition(to: size, with: coordinator)
        
        coordinator.animate(alongsideTransition: nil)
        { (UIViewControllerTransitionCoordinatorContext) in
            
            self.resize(to: size)
        }
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?)
    {
        let kvoEvent = self._getKVOEvent(forKeyPath: keyPath, of: object, change: change, context: context)
        
        if (kvoEvent.context == &DynamicController.viewModelContext)
        {
            if (self.isBound)
            {
                let canvas = DynamicCanvas()
                self.render(canvas: canvas)
            }
        }
        else if (kvoEvent.context == &DynamicController.controllerEventContext)
        {
            var controllerEvent : DynamicController.Event? = nil
            
            if (kvoEvent.isPriorNotification)
            {
                if (kvoEvent.oldValue != nil)
                {
                    controllerEvent = DynamicController.Event(operation: DynamicController.Event.Operation.unbind,
                                                              viewModel: kvoEvent.oldValue as! DynamicViewModel)
                }
            }
            else
            {
                if (kvoEvent.newValue != nil)
                {
                    controllerEvent = DynamicController.Event(operation: DynamicController.Event.Operation.bind,
                                                              viewModel: kvoEvent.newValue as! DynamicViewModel)
                }
            }
            
            if (controllerEvent != nil)
            {
                self.observeController(for: controllerEvent!, kvoEvent: kvoEvent)
            }
        }
        else if (kvoEvent.context == &DynamicController.viewModelEventContext)
        {
            let viewModelEvent = kvoEvent.newValue as? DynamicViewModel.Event
            
            if (viewModelEvent != nil)
            {
                self.observeViewModel(for: viewModelEvent!, kvoEvent: kvoEvent)
            }
        }
        else if (kvoEvent.context == &DynamicController.storeEventContext)
        {
            let storeEvent = kvoEvent.newValue as? DynamicStore.Event
            
            if (storeEvent != nil)
            {
                self.observeStore(for: storeEvent!, kvoEvent: kvoEvent)
            }
        }
        else
        {
            self.observeKeyValue(for: kvoEvent)
        }
    }
    
    func observeKeyValue(for kvoEvent: DynamicKVO.Event){}
    func observeController(for controllerEvent: DynamicController.Event, kvoEvent: DynamicKVO.Event){}
    func observeViewModel(for viewModelEvent: DynamicViewModel.Event, kvoEvent: DynamicKVO.Event){}
    func observeStore(for storeEvent: DynamicStore.Event, kvoEvent: DynamicKVO.Event){}
    func resize(to size: CGSize){}
    
    @discardableResult
    func render(canvas: DynamicCanvas) -> DynamicCanvas
    {
        return canvas
    }
    
    func bind()
    {
        if (self._isBound)
        {
            fatalError("DynamicController: Controller Is Already Bound")
        }
        
        self._addObserver(for: self.viewModelKeyPath, context: &DynamicController.viewModelContext)
        self._addObserver(for: self.viewModelKeyPath, context: &DynamicController.controllerEventContext)
        
        for controllerEventKeyPath in self.controllerEventKeyPaths
        {
            if (controllerEventKeyPath != self.viewModelKeyPath)
            {
                self._addObserver(for: controllerEventKeyPath, context: &DynamicController.controllerEventContext)
            }
        }
        
        for viewModelEventKeyPath in self.viewModelEventKeyPaths
        {
            self._addObserver(for: viewModelEventKeyPath, context: &DynamicController.viewModelEventContext)
        }
        
        for storeEventKeyPath in self.storeEventKeyPaths
        {
            self._addObserver(for: storeEventKeyPath, context: &DynamicController.storeEventContext)
        }
        
        self._isBound = true
    }
    
    func unbind()
    {
        if (!self._isBound)
        {
            fatalError("DynamicController: Controller Is Already Unbound")
        }
        
        self._removeObserver(for: self.viewModelKeyPath, context: &DynamicController.viewModelContext)
        self._removeObserver(for: self.viewModelKeyPath, context: &DynamicController.controllerEventContext)
        
        for controllerEventKeyPath in self.controllerEventKeyPaths
        {
            if (controllerEventKeyPath != self.viewModelKeyPath)
            {
                self._removeObserver(for: controllerEventKeyPath, context: &DynamicController.controllerEventContext)
            }
        }
        
        for viewModelEventKeyPath in self.viewModelEventKeyPaths
        {
            self._removeObserver(for: viewModelEventKeyPath, context: &DynamicController.viewModelEventContext)
        }
        
        for storeEventKeyPath in self.storeEventKeyPaths
        {
            self._removeObserver(for: storeEventKeyPath, context: &DynamicController.storeEventContext)
        }
        
        self._isBound = false
    }
    
    private func _addObserver(for keyPath: String, context: UnsafeMutableRawPointer?)
    {
        if (context == &DynamicController.controllerEventContext)
        {
            self.addObserver(self,
                             forKeyPath: keyPath,
                             options: NSKeyValueObservingOptions([NSKeyValueObservingOptions.prior,
                                                                  NSKeyValueObservingOptions.initial,
                                                                  NSKeyValueObservingOptions.old,
                                                                  NSKeyValueObservingOptions.new]),
                             context: context)
        }
        else
        {
            self.addObserver(self,
                             forKeyPath: keyPath,
                             options: NSKeyValueObservingOptions([NSKeyValueObservingOptions.initial,
                                                                  NSKeyValueObservingOptions.new]),
                             context: context)
        }
    }
    
    private func _removeObserver(for keyPath: String, context: UnsafeMutableRawPointer?)
    {
        self.removeObserver(self, forKeyPath: keyPath, context: context)
    }
    
    private func _getKVOEvent(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) -> DynamicKVO.Event
    {
        let keyValueChange = NSKeyValueChange(rawValue: change![NSKeyValueChangeKey.kindKey] as! UInt)!
        var isPriorNotification : Bool! = change![NSKeyValueChangeKey.notificationIsPriorKey] as? Bool
        
        if (isPriorNotification == nil)
        {
            isPriorNotification = false
        }
        
        let oldValue = change![NSKeyValueChangeKey.oldKey]
        let newValue = change![NSKeyValueChangeKey.newKey]
        let indexes = change![NSKeyValueChangeKey.indexesKey] as? IndexSet
        var kind : DynamicKVO.Event.Kind! = nil
        
        if (keyValueChange == NSKeyValueChange.setting)
        {
            kind = DynamicKVO.Event.Kind.setting
        }
        else if (keyValueChange == NSKeyValueChange.insertion)
        {
            kind = DynamicKVO.Event.Kind.insertion
        }
        else if (keyValueChange == NSKeyValueChange.removal)
        {
            kind = DynamicKVO.Event.Kind.removal
        }
        else if (keyValueChange == NSKeyValueChange.replacement)
        {
            kind = DynamicKVO.Event.Kind.replacement
        }
        
        let event = DynamicKVO.Event(kind: kind,
                                     keyPath: keyPath!,
                                     isPriorNotification: isPriorNotification,
                                     object: object,
                                     oldValue: oldValue,
                                     newValue: newValue,
                                     indexes: indexes,
                                     context: context)
        
        return event
    }
    
    class Event : NSObject
    {
        private var _operation : DynamicController.Event.Operation
        private var _viewModel : DynamicViewModel
        
        init(operation: DynamicController.Event.Operation, viewModel: DynamicViewModel)
        {
            self._operation = operation
            self._viewModel = viewModel
        }
        
        var operation : DynamicController.Event.Operation
        {
            get
            {
                let operation = self._operation
                
                return operation
            }
        }
        
        var viewModel : DynamicViewModel
        {
            get
            {
                let viewModel = self._viewModel
                
                return viewModel
            }
        }
        
        enum Operation
        {
            case bind
            case unbind
        }
    }
}
