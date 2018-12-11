//
//  ContactFormViewModel.swift
//  Cataract
//
//  Created by Roseanne Choi on 9/9/18.
//  Copyright © 2018 Roseanne Choi. All rights reserved.
//

import UIKit

class ContactFormViewModel : DynamicViewModel
{
    var size = CGSize.zero
    private var _colorCardHeaderLabel : ColorCardViewModel!
    private var _colorCardLabel : ColorCardViewModel!
    private var _headerLabelViewModel : LabelViewModel!
    private var _nameLabelViewModel : LabelViewModel!
    private var _numberLabelViewModel : LabelViewModel!
    private var _emailLabelViewModel : LabelViewModel!
    private var _nameInputViewModel : TextFieldInputViewModel!
    private var _numberInputViewModel : TextFieldInputViewModel!
    private var _emailInputViewModel : TextFieldInputViewModel!
    @objc dynamic var footerPanelViewModel : FooterPanelViewModel!
    
    init(footerPanelViewModel: FooterPanelViewModel)
    {
        self.footerPanelViewModel = FooterPanelViewModel(id: "")
        
        super.init()
    }
    
    var colorCardHeaderLabel : ColorCardViewModel
    {
        get
        {
            if (self._colorCardHeaderLabel == nil)
            {
                self._colorCardHeaderLabel = ColorCardViewModel(redValue: 255,
                                                                greenValue: 255,
                                                                blueValue: 255,
                                                                alphaValue: 1)
            }
            
            let colorCardHeaderLabel = self._colorCardHeaderLabel!
            
            return colorCardHeaderLabel
        }
    }
    
    var colorCardLabel : ColorCardViewModel
    {
        get
        {
            if (self._colorCardLabel == nil)
            {
               self._colorCardLabel = ColorCardViewModel(redValue: 0,
                                                         greenValue: 0,
                                                         blueValue: 0,
                                                         alphaValue: 1)
            }
            
            let colorCardLabel = self._colorCardLabel!
            
            return colorCardLabel
        }
    }
    
    var headerLabelViewModel : LabelViewModel
    {
        get
        {
            if (self._headerLabelViewModel == nil)
            {
                self._headerLabelViewModel = LabelViewModel(text: "Add Emergency Contact",
                                                            textColor: self.colorCardHeaderLabel,
                                                            numberOfLines: 1,
                                                            borderColor: self.colorCardHeaderLabel,
                                                            borderWidth: 0,
                                                            size: CGSize.zero,
                                                            style: .truncate,
                                                            textAlignment: .center)
            }
            
            let headerLabelViewModel = self._headerLabelViewModel!
            
            return headerLabelViewModel
        }
    }
    
    var nameLabelViewModel : LabelViewModel
    {
        get
        {
            if (self._nameLabelViewModel == nil)
            {
                self._nameLabelViewModel = LabelViewModel(text: "Name",
                                                          textColor: self.colorCardLabel,
                                                          numberOfLines: 1,
                                                          borderColor: self.colorCardLabel,
                                                          borderWidth: 0,
                                                          size: CGSize.zero,
                                                          style: .truncate,
                                                          textAlignment: .center)
            }
            
            let nameLabelViewModel = self._nameLabelViewModel!
            
            return nameLabelViewModel
        }
    }
    
    var numberLabelViewModel : LabelViewModel
    {
        get
        {
            if (self._numberLabelViewModel == nil)
            {
                self._numberLabelViewModel = LabelViewModel(text: "Number",
                                                            textColor: self.colorCardLabel,
                                                            numberOfLines: 1,
                                                            borderColor: self.colorCardLabel,
                                                            borderWidth: 0,
                                                            size: CGSize.zero,
                                                            style: .truncate,
                                                            textAlignment: .center)
            }
            
            let numberLabelViewModel = self._numberLabelViewModel!
            
            return numberLabelViewModel
        }
    }
    
    var emailLabelViewModel : LabelViewModel
    {
        get
        {
            if (self._emailLabelViewModel == nil)
            {
                self._emailLabelViewModel = LabelViewModel(text: "e-mail",
                                                                 textColor: self.colorCardLabel,
                                                                 numberOfLines: 1,
                                                                 borderColor: self.colorCardLabel,
                                                                 borderWidth: 0,
                                                                 size: CGSize.zero,
                                                                 style: .truncate,
                                                                 textAlignment: .center)
            }
            
            let emailLabelViewModel = self._emailLabelViewModel!
            
            return emailLabelViewModel
        }
    }
    
    @objc var nameInputViewModel : TextFieldInputViewModel
    {
        get
        {
            if (self._nameInputViewModel == nil)
            {
                self._nameInputViewModel = TextFieldInputViewModel(placeHolder: "",
                                                                   value: "",
                                                                   id: "")
            }
            
            let nameInputViewModel = self._nameInputViewModel!
            
            return nameInputViewModel
        }
    }
    
    @objc var numberInputViewModel : TextFieldInputViewModel
    {
        get
        {
            if (self._numberInputViewModel == nil)
            {
                self._numberInputViewModel = TextFieldInputViewModel(placeHolder: "",
                                                                     value: "",
                                                                     id: "")
            }
            
            let numberInputViewModel = self._numberInputViewModel!
            
            return numberInputViewModel
        }
    }
    
    @objc var emailInputViewModel : TextFieldInputViewModel
    {
        get
        {
            if (self._emailInputViewModel == nil)
            {
                self._emailInputViewModel = TextFieldInputViewModel(placeHolder: "",
                                                                    value: "",
                                                                    id: "")
            }
            
            let emailInputViewModel = self._emailInputViewModel!
            
            return emailInputViewModel
        }
    }
    
    @objc func exit()
    {
        self.transit(transition: ContactFormViewModel.Transition.exit,
                     to: ContactFormViewModel.State.cancellation)
    }
    
    @objc func create()
    {
        self.transit(transition: ContactFormViewModel.Transition.create,
                     to: ContactFormViewModel.State.completion)
    }
    
    struct Transition
    {
        static let exit = DynamicViewModel.Transition(rawValue: "Exit")
        static let create = DynamicViewModel.Transition(rawValue: "Create")
    }
    
    struct State
    {
        static let cancellation = DynamicViewModel.State(rawValue: "Cancellation")
        static let completion = DynamicViewModel.State(rawValue: "Completion")
    }
}
