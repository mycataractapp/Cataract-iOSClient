//
//  DropFormViewModel.swift
//  Cataract
//
//  Created by Roseanne Choi on 9/9/18.
//  Copyright © 2018 Roseanne Choi. All rights reserved.
//

import UIKit

class DropFormViewModel : DynamicViewModel
{
    var size = CGSize.zero
    var firstPageViewModel : DropFormViewModel.FirstPageViewModel!
    var secondPageViewModel : DropFormViewModel.SecondPageViewModel!
    @objc var thirdPageViewModel : DropFormViewModel.ThirdPageViewModel!
    @objc var footerPanelViewModel : FooterPanelViewModel!
    @objc var overLayCardViewModelTime : UserViewModel.OverLayCardViewModel!

    init(firstPageViewModel: DropFormViewModel.FirstPageViewModel, secondPageViewModel: SecondPageViewModel, thirdPageViewModel: DropFormViewModel.ThirdPageViewModel, footerPanelViewModel: FooterPanelViewModel, overLayCardViewModel: UserViewModel.OverLayCardViewModel)
    {
        self.firstPageViewModel = DropFormViewModel.FirstPageViewModel()
        self.secondPageViewModel = DropFormViewModel.SecondPageViewModel()
        self.thirdPageViewModel = DropFormViewModel.ThirdPageViewModel()
        self.footerPanelViewModel = FooterPanelViewModel(id: "")
        self.overLayCardViewModelTime = UserViewModel.OverLayCardViewModel(id: "")

        super.init(state: DropFormViewModel.State.drop)
    }

    @objc func inputDrop()
    {
        self.transit(transition: DropFormViewModel.Transition.inputDrop,
                     to: DropFormViewModel.State.drop)
    }
    
    @objc func inputDate()
    {
        if (self.state == DropFormViewModel.State.drop || self.state == DropFormViewModel.State.schedule)
        {
            self.transit(transition: DropFormViewModel.Transition.inputDate,
                         to: DropFormViewModel.State.date)
        }
    }
    
    @objc func setSchedule()
    {
        if (self.state == DropFormViewModel.State.date || self.state == UserViewModel.ButtonCardViewModel.State.approval)
        {
            self.transit(transition: DropFormViewModel.Transition.setSchedule,
                         to: DropFormViewModel.State.schedule)
        }
    }
    
    struct  Transition
    {
        static let inputDrop = DynamicViewModel.Transition(rawValue: "InputDrop")
        static let inputDate = DynamicViewModel.Transition(rawValue: "InputDate")
        static let setSchedule = DynamicViewModel.Transition(rawValue: "SetSchedule")
    }
    
    struct State
    {
        static let drop = DynamicViewModel.State(rawValue: "Drop")
        static let date = DynamicViewModel.State(rawValue: "Date")
        static let schedule = DynamicViewModel.State(rawValue: "Schedule")
    }
    
    class FirstPageViewModel : DynamicViewModel
    {
        private var _textColor : ColorCardViewModel!
        private var _nameLabelViewModel : LabelViewModel!
        private var _colorLabelViewModel : LabelViewModel!
        private var _textFieldInputViewModel : TextFieldInputViewModel!
        private var _colorCardViewModels : [ColorCardViewModel]!
        
        override init()
        {
            super.init()
        }
        
        var textColor : ColorCardViewModel
        {
            get
            {
                if (self._textColor == nil)
                {
                    self._textColor = ColorCardViewModel(redValue: 51,
                                                         greenValue: 127,
                                                         blueValue: 159,
                                                         alphaValue: 1)
                }
                
                let textColor = self._textColor!
                
                return textColor
            }
        }
        
        var nameLabelViewModel : LabelViewModel
        {
            get
            {
                if (self._nameLabelViewModel == nil)
                {
                    self._nameLabelViewModel = LabelViewModel(text: "Name of your drop",
                                                              textColor: self.textColor,
                                                              numberOfLines: 1,
                                                              borderColor: self.textColor,
                                                              borderWidth: 0,
                                                              size: CGSize.zero,
                                                              style: .truncate,
                                                              textAlignment: .center)
                }
                
                let nameLabelViewModel = self._nameLabelViewModel!
                
                return nameLabelViewModel
            }
        }
        
        var colorLabelViewModel : LabelViewModel
        {
            get
            {
                if (self._colorLabelViewModel == nil)
                {
                    self._colorLabelViewModel = LabelViewModel(text: "Choose your color",
                                                               textColor: self.textColor,
                                                               numberOfLines: 1,
                                                               borderColor: textColor,
                                                               borderWidth: 0,
                                                               size: CGSize.zero,
                                                               style: .truncate,
                                                               textAlignment: .center)
                }
                
                let colorLabelViewModel = self._colorLabelViewModel!
                
                return colorLabelViewModel
            }
        }
        
        @objc var textFieldInputViewModel: TextFieldInputViewModel
        {
            get
            {
                if (self._textFieldInputViewModel == nil)
                {
                    self._textFieldInputViewModel = TextFieldInputViewModel(placeHolder: "e.g. Pink Top",
                                                                            value: "",
                                                                            id: "")
                }
                
                let textFieldInputViewModel = self._textFieldInputViewModel!
                
                return textFieldInputViewModel
            }
        }
        
        var colorCardViewModels : [ColorCardViewModel]
        {
            get
            {
                if (self._colorCardViewModels == nil)
                {
                    self._colorCardViewModels = [ColorCardViewModel]()
                    
                    var colorCardViewModel : ColorCardViewModel!
                    
                    for index in 0...7
                    {
                        if (index == 0)
                        {
                            let pinkColorViewModel = ColorCardViewModel(redValue: 247,
                                                                        greenValue: 202,
                                                                        blueValue: 201,
                                                                        alphaValue: 1,
                                                                        isSelected: false,
                                                                        id: "",
                                                                        size: CGSize.zero)
                            colorCardViewModel = pinkColorViewModel
                        }
                        else if (index == 1)
                        {
                            let grayColorViewModel = ColorCardViewModel(redValue: 128,
                                                                        greenValue: 128,
                                                                        blueValue: 128,
                                                                        alphaValue: 1,
                                                                        isSelected: false,
                                                                        id: "",
                                                                        size: CGSize.zero)
                            colorCardViewModel = grayColorViewModel
                        }
                        else if (index == 2)
                        {
                            let tanColorViewModel = ColorCardViewModel(redValue: 210,
                                                                       greenValue: 180,
                                                                       blueValue: 140,
                                                                       alphaValue: 1,
                                                                       isSelected: false,
                                                                       id: "",
                                                                       size: CGSize.zero)
                            colorCardViewModel = tanColorViewModel
                        }
                        else if (index == 3)
                        {
                            let yellowColorViewModel = ColorCardViewModel(redValue: 255,
                                                                          greenValue: 255,
                                                                          blueValue: 0,
                                                                          alphaValue: 1,
                                                                          isSelected: false,
                                                                          id: "",
                                                                          size: CGSize.zero)
                            colorCardViewModel = yellowColorViewModel
                        }
                        else if (index == 4)
                        {
                            let blueColorViewModel = ColorCardViewModel(redValue: 0,
                                                                          greenValue: 0,
                                                                          blueValue: 255,
                                                                          alphaValue: 1,
                                                                          isSelected: false,
                                                                          id: "",
                                                                          size: CGSize.zero)
                            colorCardViewModel = blueColorViewModel
                        }
                        else if (index == 5)
                        {
                            let orangeColorViewModel = ColorCardViewModel(redValue: 255,
                                                                          greenValue: 165,
                                                                          blueValue: 0,
                                                                          alphaValue: 1,
                                                                          isSelected: false,
                                                                          id: "",
                                                                          size: CGSize.zero)
                            colorCardViewModel = orangeColorViewModel
                        }
                        else if (index == 6)
                        {
                            let purpleColorViewModel = ColorCardViewModel(redValue: 128,
                                                                          greenValue: 0,
                                                                          blueValue: 128,
                                                                          alphaValue: 1,
                                                                          isSelected: false,
                                                                          id: "",
                                                                          size: CGSize.zero)
                            colorCardViewModel = purpleColorViewModel
                        }
                        else if (index == 7)
                        {
                            let greenColorViewModel = ColorCardViewModel(redValue: 0,
                                                                          greenValue: 128,
                                                                          blueValue: 0,
                                                                          alphaValue: 1,
                                                                          isSelected: false,
                                                                          id: "",
                                                                          size: CGSize.zero)
                            colorCardViewModel = greenColorViewModel
                        }
                        
                        self._colorCardViewModels.append(colorCardViewModel)
                    }
                }
                
                let colorCardViewModels = self._colorCardViewModels!
                
                return colorCardViewModels
            }
        }
        
        func toggle(at index: Int)
        {
            var color : String! = nil
            
            for (counter, iconViewModel) in self.colorCardViewModels.enumerated()
            {
                if (counter != index)
                {
                    iconViewModel.deselect()
                }
                else
                {
                    iconViewModel.select()
                }
            }
        }
    }
    
    class SecondPageViewModel : DynamicViewModel
    {
        private var _textColor : ColorCardViewModel!
        private var _startDateLabelViewModel : LabelViewModel!
        private var _endDateLabelViewModel : LabelViewModel!
        private var _startDatePickerInputViewModel : DatePickerInputViewModel!
        private var _endDatePickerInputViewModel : DatePickerInputViewModel!
        
        override init()
        {
            super.init()
        }
        
        var textColor : ColorCardViewModel
        {
            get
            {
                if (self._textColor == nil)
                {
                    self._textColor = ColorCardViewModel(redValue: 51,
                                                         greenValue: 127,
                                                         blueValue: 159,
                                                         alphaValue: 1)
                }
                
                let textColor = self._textColor!
                
                return textColor
            }
        }
        
        var startDateLabelViewModel : LabelViewModel
        {
            get
            {
                if (self._startDateLabelViewModel == nil)
                {
                    self._startDateLabelViewModel = LabelViewModel(text: "Start Date",
                                                                   textColor: self.textColor,
                                                                   numberOfLines: 1,
                                                                   borderColor: self.textColor,
                                                                   borderWidth: 0,
                                                                   size: CGSize.zero,
                                                                   style: .truncate,
                                                                   textAlignment: .center)
                }
                
                let startDateLabelViewModel = self._startDateLabelViewModel!
                
                return startDateLabelViewModel
            }
        }
        
        var endDateLabelViewModel : LabelViewModel
        {
            get
            {
                if (self._endDateLabelViewModel == nil)
                {
                    self._endDateLabelViewModel = LabelViewModel(text: "End Date",
                                                                 textColor: self.textColor,
                                                                 numberOfLines: 1,
                                                                 borderColor: self.textColor,
                                                                 borderWidth: 0,
                                                                 size: CGSize.zero,
                                                                 style: .truncate,
                                                                 textAlignment: .center)
                }
                
                let endDateLabelViewModel = self._endDateLabelViewModel!
                
                return endDateLabelViewModel
            }
        }
        
        var startDatePickerInputViewModel : DatePickerInputViewModel
        {
            get
            {
                if (self._startDatePickerInputViewModel == nil)
                {
                    self._startDatePickerInputViewModel = DatePickerInputViewModel(mode: DatePickerInputViewModel.Mode.date,
                                                                                   timeInterval: Date().timeIntervalSince1970)
                }
                
                let startDatePickerInputViewModel = self._startDatePickerInputViewModel!
                
                return startDatePickerInputViewModel
            }
        }
        
        var endDatePickerInputViewModel : DatePickerInputViewModel
        {
            get
            {
                if (self._endDatePickerInputViewModel == nil)
                {
                    self._endDatePickerInputViewModel = DatePickerInputViewModel(mode: DatePickerInputViewModel.Mode.date,
                                                                                 timeInterval: Date().timeIntervalSince1970)
                }
                
                let endDatePickerInputViewModel = self._endDatePickerInputViewModel!
                
                return endDatePickerInputViewModel
            }
        }
    }
    
    class ThirdPageViewModel : DynamicViewModel
    {
        private var _controlCardStartTime : UserViewModel.ControlCard!
        private var _controlCardInterval : UserViewModel.ControlCard!
        private var _controlCardTimesPerDay : UserViewModel.ControlCard!
        private var _labelViewModels : [LabelViewModel]!

        @objc var controlCardStartTime : UserViewModel.ControlCard!
        {
            get
            {
                if (self._controlCardStartTime == nil)
                {
                    self._controlCardStartTime = UserViewModel.ControlCard(title: "Drop start time",
                                                                           display: "08:00 AM",
                                                                           id: "")
                }

                let controlCardStarTime = self._controlCardStartTime!

                return controlCardStarTime
            }
        }

        @objc var controlCardInterval : UserViewModel.ControlCard!
        {
            get
            {
                if (self._controlCardInterval == nil)
                {
                    self._controlCardInterval = UserViewModel.ControlCard(title: "Hours between",
                                                                          display: "4 hrs 30 mins",
                                                                          id: "")
                }

                let controlCardInterval = self._controlCardInterval!

                return controlCardInterval
            }
        }

        @objc var controlCardTimesPerDay : UserViewModel.ControlCard!
        {
            get
            {
                if (self._controlCardTimesPerDay == nil)
                {
                    self._controlCardTimesPerDay = UserViewModel.ControlCard(title: "Times per day",
                                                                             display: "4x's",
                                                                             id: "")
                }

                let controlCardTimesPerDay = self._controlCardTimesPerDay!

                return controlCardTimesPerDay
            }
        }
        
        var labelViewModels : [LabelViewModel]
        {
            get
            {
                if (self._labelViewModels == nil)
                {
                    self._labelViewModels = [LabelViewModel]()
                }
                
                let labelViewModels = self._labelViewModels!
                
                return labelViewModels
            }
            set(newValue)
            {
                self._labelViewModels = newValue
            }
        }
        
        @objc func editStartTime()
        {
            self.transit(transition: DropFormViewModel.ThirdPageViewModel.Transition.editStartTime,
                         to: DropFormViewModel.ThirdPageViewModel.State.time)
        }
        
        @objc func editInterval()
        {
            self.transit(transition: DropFormViewModel.ThirdPageViewModel.Transition.editInterval,
                         to: DropFormViewModel.ThirdPageViewModel.State.interval)
        }
        
        @objc func editPerDay()
        {
            self.transit(transition: DropFormViewModel.ThirdPageViewModel.Transition.editPerDay,
                         to: DropFormViewModel.ThirdPageViewModel.State.day)
        }
        
        struct Transition
        {
            static let editStartTime = DynamicViewModel.Transition(rawValue: "EditStartTime")
            static let editInterval = DynamicViewModel.Transition(rawValue: "EditInterval")
            static let editPerDay = DynamicViewModel.Transition(rawValue: "EditPerDay")
        }
        
        struct State
        {
            static let time = DynamicViewModel.State(rawValue: "Time")
            static let interval = DynamicViewModel.State(rawValue: "Interval")
            static let day = DynamicViewModel.State(rawValue: "Day")
        }
    }
}
