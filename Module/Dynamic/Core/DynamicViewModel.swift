//
//  DynamicViewModel.swift
//  Pacific
//
//  Created by Minh Nguyen on 8/22/17.
//  Copyright © 2017 Langtutheky. All rights reserved.
//

import Foundation

class DynamicViewModel :  NSObject
{
    private var _events = [DynamicViewModel.Event]()
    private var _isTransitioning = false
    private var _event : DynamicViewModel.Event!
    private var _previousState : DynamicViewModel.State?
    private var _state : DynamicViewModel.State!
    private weak var _delegate : DynamicViewModelDelegate?

    override init()
    {
        super.init()
        
        self._event = DynamicViewModel.Event(transition: DynamicViewModel.Transition.initialize,
                                             oldState: DynamicViewModel.State.default,
                                             newState: DynamicViewModel.State.default)
    }
    
    init(state: DynamicViewModel.State)
    {
        super.init()
        
        self._state = state
        self._event = DynamicViewModel.Event(transition: DynamicViewModel.Transition.initialize,
                                             oldState: state,
                                             newState: state)
    }
    
    @objc var event : DynamicViewModel.Event!
    {
        get
        {
            let event = self._event
            
            return event
        }
    }
    
    var previousState : DynamicViewModel.State?
    {
        get
        {
            let previousState = self._previousState
            
            return previousState
        }
    }
    
    var state : DynamicViewModel.State
    {
        get
        {
            if (self._state == nil)
            {
                self._state = DynamicViewModel.State.default
            }
            
            let state = self._state!
            
            return state
        }
    }
    
    var delegate : DynamicViewModelDelegate?
    {
        get
        {
            let delegate = self._delegate
            
            return delegate
        }
        
        set(newValue)
        {
            self._delegate = newValue
            
            if (newValue != nil)
            {
                self.transit(transition: DynamicViewModel.Transition.delegate, to: self.state)
            }
        }
    }
    
    func transit(transition: DynamicViewModel.Transition, from oldState: DynamicViewModel.State, to newState: DynamicViewModel.State)
    {
        let event = DynamicViewModel.Event(transition: transition, oldState: oldState, newState: newState)
        self._events.append(event)
        
        if (!self._isTransitioning)
        {
            self._isTransitioning = true

            var counter = 0

            while (counter < self._events.count)
            {
                self._transitIfNeeded(event: self._events[counter])
                counter += 1
            }

            self._events = [DynamicViewModel.Event]()
            self._isTransitioning = false
        }
    }
    
    func transit(transition: DynamicViewModel.Transition, to newState: DynamicViewModel.State)
    {
        self.transit(transition: transition, from: self.state, to: newState)
    }
    
    private func _transitIfNeeded(event: DynamicViewModel.Event)
    {
        if (self._state != event.oldState)
        {
            fatalError("DynamicViewModel: Cannot Transition From Invalid State \(event.oldState.rawValue) To \(event.newState.rawValue)")
        }
        
        self.willChangeValue(forKey: "event")
        
        self._previousState = self._state
        self._state = event.newState
        
        if (self.delegate != nil)
        {
            self.delegate!.viewModel(self, transitWith: event)
        }
        
        self._event = event
        
        self.didChangeValue(forKey: "event")
    }
    
    struct Transition : RawRepresentable, Equatable, Hashable
    {
        typealias RawValue = String
        private var _rawValue: String
        
        init(rawValue: String)
        {
            self._rawValue = rawValue
        }
        
        var rawValue : String
        {
            get
            {
                let rawValue = self._rawValue
                
                return rawValue
            }
        }
        
        var hashValue : Int
        {
            get
            {
                let hashValue = self._rawValue.hashValue
                
                return hashValue
            }
        }
        
        static let initialize = DynamicViewModel.Transition(rawValue: "Initialize")
        static let delegate = DynamicViewModel.Transition(rawValue: "Delegate")
    }
    
    struct State : RawRepresentable, Equatable, Hashable
    {
        typealias RawValue = String
        private var _rawValue: String
        
        init(rawValue: String)
        {
            self._rawValue = rawValue
        }
        
        var rawValue : String
        {
            get
            {
                let rawValue = self._rawValue
                
                return rawValue
            }
        }
        
        var hashValue : Int
        {
            get
            {
                let hashValue = self._rawValue.hashValue
                
                return hashValue
            }
        }
        
        static let `default` = DynamicViewModel.State(rawValue: "Default")
    }
    
    class Event : NSObject
    {
        private var _transition : DynamicViewModel.Transition
        private var _oldState : DynamicViewModel.State
        private var _newState : DynamicViewModel.State
        
        init(transition: DynamicViewModel.Transition, oldState: DynamicViewModel.State, newState: DynamicViewModel.State)
        {
            self._transition = transition
            self._oldState = oldState
            self._newState = newState
        }
        
        var transition : DynamicViewModel.Transition
        {
            get
            {
                let transition = self._transition
                
                return transition
            }
        }
        
        var oldState : DynamicViewModel.State
        {
            get
            {
                let oldState = self._oldState
                
                return oldState
            }
        }
        
        var newState : DynamicViewModel.State
        {
            get
            {
                let newState = self._newState
                
                return newState
            }
        }
    }
}
