//
//  ColorModel.swift
//  Cataract
//
//  Created by Roseanne Choi on 7/2/18.
//  Copyright © 2018 Roseanne Choi. All rights reserved.
//

import UIKit

final class ColorModel : DynamicModel, Decodable
{
    private var _redValue : Double!
    private var _greenValue : Double!
    private var _blueValue : Double!
    private var _alphaValue = 1.0
    
    init(from decoder: Decoder) throws
    {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        self._redValue = try values.decode(Double.self, forKey: ColorModel.CodingKeys.redValue)
        self._greenValue = try values.decode(Double.self, forKey: ColorModel.CodingKeys.greenValue)
        self._blueValue = try values.decode(Double.self, forKey: ColorModel.CodingKeys.blueValue)
        self._alphaValue = try values.decode(Double.self, forKey: ColorModel.CodingKeys.alphaValue)
        
        super.init()
    }
    
    var redValue : Double
    {
        get
        {
            let redValue = self._redValue!
            
            return redValue
        }
    }
    
    var greenValue : Double
    {
        get
        {
            let greenValue = self._greenValue!
            
            return greenValue
        }
    }
    
    var blueValue : Double
    {
        get
        {
            let blueValue = self._blueValue!
            
            return blueValue
        }
    }

    var alphaValue : Double
    {
        get
        {
            let alphaValue = self._alphaValue

            return alphaValue
        }
    }
    
    var uiColor : UIColor
    {
        get
        {
            let uiColor = UIColor(red: CGFloat(self.redValue / 255),
                                  green: CGFloat(self.greenValue / 255),
                                  blue: CGFloat(self.blueValue / 255),
                                  alpha: CGFloat(self.alphaValue))
            
            return uiColor
        }
    }
    
    enum CodingKeys: String, CodingKey
    {
        case redValue
        case greenValue
        case blueValue
        case alphaValue
    }
}
