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
    var firstPageViewModel : AppointmentFormViewModel.FirstPageViewModel!
    
    init(firstPageViewModel: AppointmentFormViewModel.FirstPageViewModel)
    {
        self.firstPageViewModel = AppointmentFormViewModel.FirstPageViewModel()
        
        super.init()
    }
    
    class FirstPageViewModel : DynamicViewModel
    {
        private var _labelTextColorViewModel : ColorCardViewModel!
        private var _appointmentTextColorViewModel : ColorCardViewModel!
        private var _labelViewModel : LabelViewModel!
        private var _instructionLabelViewModel : LabelViewModel!
        private var _labelViewModels : [LabelViewModel]!
        
//        var labelViewModels : [LabelViewModel]
//        {
//            get
//            {
//                if (self._labelViewModels == nil)
//                {
//
//                }
//            }
//        }
        
        var labelTextColorViewModel : ColorCardViewModel
        {
            get
            {
                if (self._labelTextColorViewModel == nil)
                {
                    self._labelTextColorViewModel = ColorCardViewModel(redValue: 51,
                                                                       greenValue: 127,
                                                                       blueValue: 159,
                                                                       alphaValue: 1)
                }
                
                let labelTextColorViewModel = self._labelTextColorViewModel!
                
                return labelTextColorViewModel
            }
        }
        
        var appointmentTextColorViewModel : ColorCardViewModel
        {
            get
            {
                if (self._appointmentTextColorViewModel == nil)
                {
                    self._appointmentTextColorViewModel = ColorCardViewModel(redValue: 0,
                                                                             greenValue: 0,
                                                                             blueValue: 0,
                                                                             alphaValue: 1)
                }
                
                let appointmentTextColorViewModel = self._appointmentTextColorViewModel!
                
                return appointmentTextColorViewModel
            }
        }
        
        var labelViewModel : LabelViewModel
        {
            get
            {
                if (self._labelViewModel == nil)
                {
                    self._labelViewModel = LabelViewModel(text: "Select your appointment",
                                                          textColor: self.labelTextColorViewModel,
                                                          numberOfLines: 1,
                                                          borderColor: self.labelTextColorViewModel,
                                                          borderWidth: 0,
                                                          size: CGSize.zero,
                                                          style: .truncate,
                                                          textAlignment: .center)
                }
                
                let labelViewModel = self._labelViewModel!
                
                return labelViewModel
            }
        }
        
        var instructionLabelViewModel : LabelViewModel
        {
            get
            {
                if (self._instructionLabelViewModel == nil)
                {
                    self._instructionLabelViewModel = LabelViewModel(text: "Press the add button to create your own appointment",
                                                                     textColor: self.labelTextColorViewModel,
                                                                     numberOfLines: 1,
                                                                     borderColor: self.labelTextColorViewModel,
                                                                     borderWidth: 1,
                                                                     size: CGSize.zero,
                                                                     style: .truncate,
                                                                     textAlignment: .center)
                }
                
                let instructionLabelViewModel = self._instructionLabelViewModel!
                
                return instructionLabelViewModel
            }
        }
    }
}
