//
//  AppointmentFormViewModel.swift
//  Cataract
//
//  Created by Roseanne Choi on 9/9/18.
//  Copyright © 2018 Roseanne Choi. All rights reserved.
//

import UIKit

class AppointmentFormViewModel : DynamicViewModel
{
    var size = CGSize.zero
    @objc var footerPanelViewModel : FooterPanelViewModel!
    @objc var firstPageViewModel : AppointmentFormViewModel.FirstPageViewModel!
    @objc var secondPageViewModel : AppointmentFormViewModel.SecondPageViewModel!
    @objc var appointmentInputViewModel : UserViewModel.AppointmentInputViewModel!
    
    init(footerPanelViewModel: FooterPanelViewModel, firstPageViewModel: AppointmentFormViewModel.FirstPageViewModel, secondPageViewModel: AppointmentFormViewModel.SecondPageViewModel, appointmentInputViewModel: UserViewModel.AppointmentInputViewModel)
    {
        self.footerPanelViewModel = FooterPanelViewModel(id: "")
        self.firstPageViewModel = FirstPageViewModel()
        self.secondPageViewModel = SecondPageViewModel()
        self.appointmentInputViewModel = UserViewModel.AppointmentInputViewModel(id: "")
        
        super.init(state: AppointmentFormViewModel.State.appointment)
    }
    
    @objc func exit()
    {
        if (self.state == AppointmentFormViewModel.State.appointment)
        {
            self.transit(transition: AppointmentFormViewModel.Transition.exit,
                         to: AppointmentFormViewModel.State.cancellation)
        }
    }
    
    @objc func inputAppointment()
    {
        if (self.state == AppointmentFormViewModel.State.cancellation || self.state == AppointmentFormViewModel.State.date)
        {
            self.transit(transition: AppointmentFormViewModel.Transition.inputAppointment,
                         to: AppointmentFormViewModel.State.appointment)
        }
    }
    
    @objc func inputDate()
    {
        if (self.state == AppointmentFormViewModel.State.appointment)
        {
            self.transit(transition: AppointmentFormViewModel.Transition.inputDate,
                     to: AppointmentFormViewModel.State.date)
        }
    }
    
    @objc func create()
    {
        if (self.state == AppointmentFormViewModel.State.date)
        {
            self.transit(transition: AppointmentFormViewModel.Transition.create,
                         to: AppointmentFormViewModel.State.completion)
        }
    }
    
    struct Transition
    {
        static let exit = DynamicViewModel.Transition(rawValue: "Exit")
        static let inputAppointment = DynamicViewModel.Transition(rawValue: "InputAppointment")
        static let inputDate = DynamicViewModel.Transition(rawValue: "InputDate")
        static let create = DynamicViewModel.Transition(rawValue: "Create")
    }
    
    struct State
    {
        static let cancellation = DynamicViewModel.State(rawValue: "Cancellation")
        static let appointment = DynamicViewModel.State(rawValue: "Appointment")
        static let date = DynamicViewModel.State(rawValue: "Date")
        static let completion = DynamicViewModel.State(rawValue: "Completion")
    }
    
    class FirstPageViewModel : DynamicViewModel
    {
        private var _colorCardViewModel : ColorCardViewModel!
        private var _selectLabelViewModel : LabelViewModel!
        private var _addLabelViewModel : LabelViewModel!
        private var _addButtonViewModel : UserViewModel.AddButtonViewModel!
        private var _appointmentFormLabelViewModels : [UserViewModel.AppointmentFormLabelViewModel]!
        private var _labelViewModels : [LabelViewModel]!
        
        var colorCardViewModel : ColorCardViewModel
        {
            get
            {
                if (self._colorCardViewModel == nil)
                {
                    self._colorCardViewModel = ColorCardViewModel(redValue: 0,
                                                                  greenValue: 0,
                                                                  blueValue: 0,
                                                                  alphaValue: 1)
                }
                
                let colorCardViewModel = self._colorCardViewModel!
                
                return colorCardViewModel
            }
        }
        
        var selectLabelViewModel : LabelViewModel
        {
            get
            {
                if (self._selectLabelViewModel == nil)
                {
                    self._selectLabelViewModel = LabelViewModel(text: "Select an Appointment from the list:",
                                                          textColor: self.colorCardViewModel,
                                                          numberOfLines: 1,
                                                          borderColor: self.colorCardViewModel,
                                                          borderWidth: 0,
                                                          size: CGSize.zero,
                                                          style: .truncate,
                                                          textAlignment: .center)
                }
                
                let selectLabelViewModel = self._selectLabelViewModel!
                
                return selectLabelViewModel
            }
        }
        
        var addLabelViewModel : LabelViewModel
        {
            get
            {
                if (self._addLabelViewModel == nil)
                {
                    self._addLabelViewModel = LabelViewModel(text: "Add more Appointments",
                                                             textColor: self.colorCardViewModel,
                                                             numberOfLines: 1,
                                                             borderColor: self.colorCardViewModel,
                                                             borderWidth: 0,
                                                             size: CGSize.zero,
                                                             style: .truncate,
                                                             textAlignment: .center)
                }
                
                let addLabelViewModel = self._addLabelViewModel!
                
                return addLabelViewModel
            }
        }
        
        @objc var addButtonViewModel : UserViewModel.AddButtonViewModel
        {
            get
            {
                if (self._addButtonViewModel == nil)
                {
                    self._addButtonViewModel = UserViewModel.AddButtonViewModel(id: "")
                }
                
                let addButtonViewModel = self._addButtonViewModel!
                
                return addButtonViewModel
            }
        }
        
        var appointmentFormLabelViewModels : [UserViewModel.AppointmentFormLabelViewModel]
        {
            get
            {
                if (self._appointmentFormLabelViewModels == nil)
                {
                    self._appointmentFormLabelViewModels = [UserViewModel.AppointmentFormLabelViewModel]()
                    
                    var appointmentFormLabelViewModel : UserViewModel.AppointmentFormLabelViewModel!
                    var fixedLabelViewModel : LabelViewModel!
                    
                    for index in 0...4
                    {
                        if (index == 0)
                        {
                            fixedLabelViewModel = LabelViewModel(text: "Pre-Op Clinic",
                                                                 textColor: self.colorCardViewModel,
                                                                 numberOfLines: 1,
                                                                 borderColor: self.colorCardViewModel,
                                                                 borderWidth: 1,
                                                                 size: CGSize.zero,
                                                                 style: .truncate,
                                                                 textAlignment: .center)
                            
                            appointmentFormLabelViewModel = UserViewModel.AppointmentFormLabelViewModel(labelViewModel: fixedLabelViewModel)
                        }
                        else if (index == 1)
                        {
                            fixedLabelViewModel = LabelViewModel(text: "First Eye Surgery",
                                                                 textColor: self.colorCardViewModel,
                                                                 numberOfLines: 1,
                                                                 borderColor: self.colorCardViewModel,
                                                                 borderWidth: 1,
                                                                 size: CGSize.zero,
                                                                 style: .truncate,
                                                                 textAlignment: .center)
                            
                            appointmentFormLabelViewModel = UserViewModel.AppointmentFormLabelViewModel(labelViewModel: fixedLabelViewModel)
                        }
                        else if (index == 2)
                        {
                            fixedLabelViewModel = LabelViewModel(text: "Post-Op 1",
                                                                 textColor: self.colorCardViewModel,
                                                                 numberOfLines: 1,
                                                                 borderColor: self.colorCardViewModel,
                                                                 borderWidth: 1,
                                                                 size: CGSize.zero,
                                                                 style: .truncate,
                                                                 textAlignment: .center)
                            
                            appointmentFormLabelViewModel = UserViewModel.AppointmentFormLabelViewModel(labelViewModel: fixedLabelViewModel)
                        }
                        else if (index == 3)
                        {
                            fixedLabelViewModel = LabelViewModel(text: "Second Eye Surgery",
                                                                 textColor: self.colorCardViewModel,
                                                                 numberOfLines: 1,
                                                                 borderColor: self.colorCardViewModel,
                                                                 borderWidth: 1,
                                                                 size: CGSize.zero,
                                                                 style: .truncate,
                                                                 textAlignment: .center)
                            
                            appointmentFormLabelViewModel = UserViewModel.AppointmentFormLabelViewModel(labelViewModel: fixedLabelViewModel)
                        }
                        else
                        {
                            fixedLabelViewModel = LabelViewModel(text: "Post-Op 2",
                                                                 textColor: self.colorCardViewModel,
                                                                 numberOfLines: 1,
                                                                 borderColor: self.colorCardViewModel,
                                                                 borderWidth: 1,
                                                                 size: CGSize.zero,
                                                                 style: .truncate,
                                                                 textAlignment: .center)
                            
                            appointmentFormLabelViewModel = UserViewModel.AppointmentFormLabelViewModel(labelViewModel: fixedLabelViewModel)
                        }
                        
                        self._appointmentFormLabelViewModels.append(appointmentFormLabelViewModel)
                    }
                }
                
                let appointmentFormLabelViewModels = self._appointmentFormLabelViewModels!
                                
                return appointmentFormLabelViewModels
            }
        }
        
        var labelViewModels : [LabelViewModel]
        {
            get
            {
                if (self._labelViewModels == nil)
                {
                    self._labelViewModels = [LabelViewModel]()
                    
                    for appointmentLabelViewModel in self.appointmentFormLabelViewModels
                    {
                        self._labelViewModels.append(appointmentLabelViewModel.labelViewModel)
                    }
                }
                
                let labelViewModels = self._labelViewModels!
                
                return labelViewModels
            }
        }
        
        @objc func toggle(at index: Int)
        {
            for (counter, appointmentFormLabelViewModel) in self.appointmentFormLabelViewModels.enumerated()
            {
                if (counter != index)
                {
                    appointmentFormLabelViewModel.deselect()
                }
                else
                {
                    appointmentFormLabelViewModel.select()
                }
            }
        }
    }
    
    class SecondPageViewModel : DynamicViewModel
    {
        private var _labelViewModel : LabelViewModel!
        private var _colorCardViewModel : ColorCardViewModel!
        private var _datePickerInputViewModel : DatePickerInputViewModel!
        
        var colorCardViewModel : ColorCardViewModel
        {
            get
            {
                if (self._colorCardViewModel == nil)
                {
                    self._colorCardViewModel = ColorCardViewModel(redValue: 0,
                                                                  greenValue: 0,
                                                                  blueValue: 0,
                                                                  alphaValue: 1)
                }
                
                let colorCardViewModel = self._colorCardViewModel!
                
                return colorCardViewModel
            }
        }
        
        var labelViewModel : LabelViewModel
        {
            get
            {
                if (self._labelViewModel == nil)
                {
                    self._labelViewModel = LabelViewModel(text: "Set your scheduled Appointment:",
                                                          textColor: self.colorCardViewModel,
                                                          numberOfLines: 1,
                                                          borderColor: self.colorCardViewModel,
                                                          borderWidth: 0,
                                                          size: CGSize.zero,
                                                          style: .truncate,
                                                          textAlignment: .center)
                }
                
                let labelViewModel = self._labelViewModel!
                
                return labelViewModel
            }
        }
        
        var datePickerInputViewModel : DatePickerInputViewModel
        {
            get
            {
                if (self._datePickerInputViewModel == nil)
                {
                    self._datePickerInputViewModel = DatePickerInputViewModel(mode: .dateAndTime,
                                                                              timeInterval: Date().timeIntervalSince1970)
                }
                
                let datePickerInputViewModel = self._datePickerInputViewModel!
                
                return datePickerInputViewModel
            }
        }
    }
}
