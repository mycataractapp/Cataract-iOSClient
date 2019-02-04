//
//  LabelViewModel.swift
//  Cataract
//
//  Created by Roseanne Choi on 9/10/18.
//  Copyright © 2018 Rose Choi. All rights reserved.
//

import UIKit

class LabelViewModel : DynamicViewModel
{
    var size : CGSize
    var style : LabelViewModel.Style
    @objc dynamic var textAlignment : LabelViewModel.TextAlignment
    @objc dynamic var text : String!
    @objc dynamic var textColor : ColorCardViewModel!
    @objc dynamic var numberOfLines : Int
    @objc var borderColor : ColorCardViewModel!
    @objc dynamic var borderWidth : Int
    
    init(text: String, textColor: ColorCardViewModel, numberOfLines: Int, borderColor: ColorCardViewModel, borderWidth: Int, size: CGSize, style: LabelViewModel.Style, textAlignment: LabelViewModel.TextAlignment)
    {
        self.text = text
        self.textColor = textColor
        self.numberOfLines = numberOfLines
        self.borderColor = borderColor
        self.borderWidth = borderWidth
        self.size = size
        self.style = style
        self.textAlignment = textAlignment
 
        super.init()
    }

    enum Style : Int
    {
        case truncate
        case fit
    }
    
    @objc enum TextAlignment : Int
    {
        case left
        case right
        case center
        case justified
        case natural
    }
}
