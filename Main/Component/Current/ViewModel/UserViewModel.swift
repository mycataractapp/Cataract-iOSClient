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
        private var _labelViewModel : LabelViewModel!
        private var _textFieldTimesPerdayViewModel: TextFieldInputViewModel!
        private var _timeDatePickerInputViewModel : DatePickerInputViewModel!
        private var _intervalDatePickerInputViewModel : DatePickerInputViewModel!
        private var _confirmButtonViewModel : UserViewModel.ButtonCardViewModel!
        
        override init(id: String)
        {
            super.init(id: "")
        }

        var labelViewModel : LabelViewModel
        {
            get
            {
                if (self._labelViewModel == nil)
                {
                    self._labelViewModel =  LabelViewModel(text: "HELLO",
                                                           textColor: ColorCardViewModel(redValue: 51,
                                                                                        greenValue: 127,
                                                                                        blueValue: 159,
                                                                                        alphaValue: 1),
                                                           numberOfLines: 1,
                                                           borderColor: ColorCardViewModel(redValue: 234,
                                                                                          greenValue: 234,
                                                                                          blueValue: 234,
                                                                                          alphaValue: 1),
                                                           borderWidth: 2,
                                                           size: CGSize.zero,
                                                           style: LabelViewModel.Style.truncate,
                                                           textAlignment: LabelViewModel.TextAlignment.right)
                }
                
                let labelViewModel = self._labelViewModel!
                
                return labelViewModel
            }
        }
        
        @objc var textFieldTimesPerdayViewModel : TextFieldInputViewModel
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
                    let date = Calendar.current.date(bySettingHour: 8, minute: 0, second: 0, of: Date())!
                    
                    self._timeDatePickerInputViewModel = DatePickerInputViewModel(mode: DatePickerInputViewModel.Mode.time,
                                                                                  timeInterval: date.timeIntervalSince1970)
                }
                
                let timeDatePickerInputViewModel = self._timeDatePickerInputViewModel!
                
                return timeDatePickerInputViewModel
            }
        }
        
        @objc var intervalDatePickerViewModel : DatePickerInputViewModel
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
    
    class AppointmentInputViewModel : CardViewModel
    {
        private var _buttonViewModel : UserViewModel.ButtonCardViewModel!
        private var _textFieldInputViewModel : TextFieldInputViewModel!
        
        override init(id: String)
        {
            super.init(id: id)
        }

        @objc var buttonViewModel : UserViewModel.ButtonCardViewModel!
        {
            get
            {
                if (self._buttonViewModel == nil)
                {
                    self._buttonViewModel = UserViewModel.ButtonCardViewModel(id: "")
                }
                
                let buttonViewModel = self._buttonViewModel!
                
                return buttonViewModel
            }
        }
        
        @objc var textFieldInputViewModel : TextFieldInputViewModel
        {
            get
            {
                if (self._textFieldInputViewModel == nil)
                {
                    self._textFieldInputViewModel = TextFieldInputViewModel(placeHolder: "e.g. Follow-up",
                                                                            value: "", id: "")
                }
                
                let textFieldInputViewModel = self._textFieldInputViewModel!
                
                return textFieldInputViewModel
            }
        }
        
        @objc func idle()
        {
            self.transit(transition: AppointmentInputViewModel.Transition.idle,
                         to: AppointmentInputViewModel.State.default)
        }
        
        @objc func customize()
        {
            self.transit(transition: AppointmentInputViewModel.Transition.customize,
                         to: AppointmentInputViewModel.State.custom)
        }
        
        struct Transition
        {
            static let idle = DynamicViewModel.Transition(rawValue: "Idle")
            static let customize = DynamicViewModel.Transition(rawValue: "Customize")
        }
        
        struct State
        {
            static let custom = DynamicViewModel.State(rawValue: "Custom")
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
        
        @objc func add()
        {
            self.transit(transition: UserViewModel.AddButtonViewModel.Transition.add,
                         to: UserViewModel.AddButtonViewModel.State.computation)
        }
        
        struct Transition
        {
            static let add = DynamicViewModel.Transition(rawValue: "Add")
        }
        
        struct State
            
        {
            static let computation = DynamicViewModel.State(rawValue: "Computation")
        }
    }
    
    class AppointmentFormLabelViewModel : DynamicViewModel
    {
        var size = CGSize.zero
        var labelViewModel : LabelViewModel!
        let colorCardViewModel = ColorCardViewModel(redValue: 0,
                                                    greenValue: 0,
                                                    blueValue: 255,
                                                    alphaValue: 1)
        
        init(labelViewModel: LabelViewModel)
        {
            self.labelViewModel = labelViewModel
                        
            super.init()
        }
        
        @objc func select()
        {
            self.transit(transition: AppointmentFormLabelViewModel.Transition.select,
                         to: AppointmentFormLabelViewModel.State.on)
        }
        
        @objc func deselect()
        {
            self.transit(transition: AppointmentFormLabelViewModel.Transition.deselect,
                         to: AppointmentFormLabelViewModel.State.off)
        }
        
        struct Transition
        {
            static let select = DynamicViewModel.Transition(rawValue: "Select")
            static let deselect = DynamicViewModel.Transition(rawValue: "Deselect")
        }
        
        struct State
        {
            static let on = DynamicViewModel.State(rawValue: "On")
            static let off = DynamicViewModel.State(rawValue: "Off")
        }
    }
    
    class MenuOverlayViewModel : DynamicViewModel
    {
        var size = CGSize.zero
        
        @objc func discontinue()
        {
            self.transit(transition: UserViewModel.MenuOverlayViewModel.Transition.discontinue,
                         to: UserViewModel.MenuOverlayViewModel.State.end)
        }
        
        @objc func modify()
        {
            self.transit(transition: UserViewModel.MenuOverlayViewModel.Transition.modify,
                         to: UserViewModel.MenuOverlayViewModel.State.revision)
        }
        
        @objc func cancel()
        {
            self.transit(transition: UserViewModel.MenuOverlayViewModel.Transition.cancel,
                         to: UserViewModel.MenuOverlayViewModel.State.idle)
        }
        
        struct Transition
        {
            static let discontinue = DynamicViewModel.Transition(rawValue: "Discontinue")
            static let modify = DynamicViewModel.Transition(rawValue: "Modify")
            static let cancel = DynamicViewModel.Transition(rawValue: "Cancel")
        }
        
        struct State
        {
            static let end = DynamicViewModel.State(rawValue: "End")
            static let revision = DynamicViewModel.State(rawValue: "Revision")
            static let idle = DynamicViewModel.State(rawValue: "Idle")
        }
    }
}
