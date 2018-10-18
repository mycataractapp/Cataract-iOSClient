//
//  UserViewModel.swift
//  MyCataractApp
//
//  Created by Roseanne Choi on 10/2/18.
//  Copyright © 2018 Rose Choi. All rights reserved.
//

import UIKit

final class UserViewModel 
{
    class ControlCard : CardViewModel
    {
        @objc dynamic var title: String!
        @objc dynamic var display: String!
        
        init(title: String, display: String, id: String)
        {
            self.title = title
            self.display = display
            
            super.init(id: id)
        }
        
        @objc func edit()
        {
            self.transit(transition: UserViewModel.ControlCard.Transition.edit,
                         to: UserViewModel.ControlCard.State.editor)
        }
        
        struct Transition
        {
            static let edit = DynamicViewModel.Transition(rawValue: "Edit")
        }
        
        struct State
        {
            static let editor = DynamicViewModel.State(rawValue: "Editor")
        }
        
        class CollectionViewModel : DynamicViewModel
        {
            var itemSize = CGSize.zero
            private var _controlCards : [ControlCard]!
            
            init(controlCards: [ControlCard])
            {
                self._controlCards = controlCards
                
                super.init()
            }
            
            var controlCards : [ControlCard]
            {
                get
                {
                    let controlCards = self._controlCards!
                    
                    return controlCards
                }
            }
        }
    }
    
    class OverLayCardViewModel : CardViewModel
    {
        private var _textFieldTimesPerdayViewModel: TextFieldInputViewModel!
        private var _timeDatePickerInputViewModel : DatePickerInputViewModel!
        private var _intervalDatePickerInputViewModel : DatePickerInputViewModel!
        private var _confirmButtonViewModel : UserViewModel.ButtonCardViewModel!
        
        override init(id: String)
        {
            super.init(id: id)
        }

        var textFieldTimesPerdayViewModel : TextFieldInputViewModel
        {
            get
            {
                if (self._textFieldTimesPerdayViewModel == nil)
                {
                    self._textFieldTimesPerdayViewModel = TextFieldInputViewModel(placeHolder: "",
                                                                                  value: "4",
                                                                                  id: "")
                }
                
                let textFieldTimesPerdayViewModel = self._textFieldTimesPerdayViewModel!
                
                return textFieldTimesPerdayViewModel
            }
        }
        
        @objc var timeDatePickerInputViewModel : DatePickerInputViewModel
        {
            get
            {
                if (self._timeDatePickerInputViewModel == nil)
                {
                    let calendar = NSCalendar.current
                    var components = DateComponents()
                    components.hour = 8
                    components.minute = 0
                    
                    let date = calendar.date(from: components)
                
                    self._timeDatePickerInputViewModel = DatePickerInputViewModel(mode: DatePickerInputViewModel.Mode.time,
                                                                                  timeInterval: date!.timeIntervalSince1970)
                }
                
                let timeDatePickerInputViewModel = self._timeDatePickerInputViewModel!
                
                return timeDatePickerInputViewModel
            }
        }
        
        var intervalDatePickerViewModel : DatePickerInputViewModel
        {
            get
            {
                if (self._intervalDatePickerInputViewModel == nil)
                {                    
                    self._intervalDatePickerInputViewModel = DatePickerInputViewModel(mode: DatePickerInputViewModel.Mode.interval,
                                                                                      timeInterval: 16200)
                }
                
                let intervalDatePickerViewModel = self._intervalDatePickerInputViewModel!
                
                return intervalDatePickerViewModel
            }
        }
        
        @objc var confirmButtonViewModel : UserViewModel.ButtonCardViewModel!
        {
            get
            {
                if (self._confirmButtonViewModel == nil)
                {
                    self._confirmButtonViewModel = ButtonCardViewModel(id: "")
                }
                
                let confirmButtonViewModel = self._confirmButtonViewModel!
                
                return confirmButtonViewModel
            }
        }
        
        @objc func Idle()
        {
            self.transit(transition: UserViewModel.OverLayCardViewModel.Transition.idle,
                         to: DynamicViewModel.State.default)
        }

        @objc func LoadTime()
        {
            self.transit(transition: UserViewModel.OverLayCardViewModel.Transition.loadTime, to: UserViewModel.OverLayCardViewModel.State.timeCompletion)
        }
        
        @objc func LoadInterval()
        {
            self.transit(transition: UserViewModel.OverLayCardViewModel.Transition.loadInterval, to: UserViewModel.OverLayCardViewModel.State.intervalCompletion)
        }
        
        @objc func LoadTextField()
        {
            self.transit(transition: UserViewModel.OverLayCardViewModel.Transition.loadTextField, to: UserViewModel.OverLayCardViewModel.State.textFieldCompletion)
        }
        
        struct Transition
        {
            static let idle = DynamicViewModel.Transition(rawValue: "Idle")
            static let loadTime = DynamicViewModel.Transition(rawValue: "LoadTime")
            static let loadInterval = DynamicViewModel.Transition(rawValue: "LoadInterval")
            static let loadTextField = DynamicViewModel.Transition(rawValue: "LoadTextField")
        }
        
        struct State
        {
            static let timeCompletion = DynamicViewModel.State(rawValue: "TimeCompletion")
            static let intervalCompletion = DynamicViewModel.State(rawValue: "IntervalCompletion")
            static let textFieldCompletion = DynamicViewModel.State(rawValue: "TextFiedCompletion")
        }
    }
    
    class ButtonCardViewModel : CardViewModel
    {
        override init(id: String)
        {
            super.init(id: id)
        }
        
        @objc func confirm()
        {
            self.transit(transition: UserViewModel.ButtonCardViewModel.Transition.confirm,
                         to: UserViewModel.ButtonCardViewModel.State.approval)
        }
        
        struct Transition
        {
            static let confirm = DynamicViewModel.Transition(rawValue: "Confirm")
        }

        struct State
        {
            static let approval = DynamicViewModel.State(rawValue: "Approval")
        }
    }
    
    class AddButtonViewModel : CardViewModel
    {
        override init(id: String)
        {
            super.init(id: id)
        }
    }
}
