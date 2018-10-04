//
//  ColorCardViewModel.swift
//  Cataract
//
//  Created by Roseanne Choi on 9/9/18.
//  Copyright © 2018 Roseanne Choi. All rights reserved.
//

import UIKit

class ColorCardViewModel : CardViewModel
{
    private var _redValue : Double!
    private var _greenValue : Double!
    private var _blueValue : Double!
    private var _alphaValue = 1.0
    
    init(redValue: Double, greenValue: Double, blueValue: Double, alphaValue: Double, isSelected: Bool, id: String, size: CGSize)
    {
        self._redValue = redValue
        self._greenValue = greenValue
        self._blueValue = blueValue
        self._alphaValue = alphaValue
        
        if (isSelected)
        {
            super.init(id: id, state: ColorCardViewModel.State.on)
        }
        else
        {
            super.init(id: id, state: ColorCardViewModel.State.off)
        }        
    }
    
    init(redValue: Double, greenValue: Double, blueValue: Double, alphaValue: Double)
    {
        self._redValue = redValue
        self._greenValue = greenValue
        self._blueValue = blueValue
        self._alphaValue = alphaValue
        
        super.init(id: UUID().uuidString)
    }
    
    var uicolor : UIColor
    {
        get
        {
            let uiColor = UIColor(red: CGFloat(self._redValue / 255),
                                  green: CGFloat(self._greenValue / 255),
                                  blue: CGFloat(self._blueValue / 255),
                                  alpha: CGFloat(self._alphaValue))
            
            return uiColor
        }
    }
    
    @objc func select()
    {
        self.transit(transition: ColorCardViewModel.Transition.select, to: ColorCardViewModel.State.on)
    }
    
    @objc func deselect()
    {
        self.transit(transition: ColorCardViewModel.Transition.deselect, to: ColorCardViewModel.State.off)
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
    
    class CollectionViewModel : DynamicViewModel
    {
        var itemSize = CGSize.zero
        private var _colorCardViewModels : [ColorCardViewModel]
        
        init(colorCardViewModels: [ColorCardViewModel])
        {
            self._colorCardViewModels = colorCardViewModels
            
            super.init()
        }
        
        var colorCardsViewModels : [ColorCardViewModel]
        {
            get
            {
                let colorCardsViewModels = self._colorCardViewModels
                
                return colorCardsViewModels
            }
        }
    }
}
