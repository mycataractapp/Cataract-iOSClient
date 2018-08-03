//
//  IconOverviewViewModel.swift
//  Cataract
//
//  Created by Roseanne Choi on 6/15/18.
//  Copyright © 2018 Roseanne Choi. All rights reserved.
//
//
import UIKit

class IconOverviewViewModel : DynamicViewModel
{
    private var _iconViewModels : [IconViewModel]!

    var iconViewModels : [IconViewModel]
    {
        get
        {
            if (self._iconViewModels == nil)
            {
                self._iconViewModels = [IconViewModel]()
            }

            let iconViewModels = self._iconViewModels!

            return iconViewModels
        }

        set(newValue)
        {
            self._iconViewModels = newValue
        }
    }

    func toggle(at index: Int)
    {
        var color : String! = nil

        for (counter, iconViewModel) in self.iconViewModels.enumerated()
        {
            if (counter != index)
            {
                iconViewModel.deselect()
            }
            else
            {
                iconViewModel.select()
                color = iconViewModel.title
            }
        }

        self.transit(transition: "Toggle", to: color)
    }
}
