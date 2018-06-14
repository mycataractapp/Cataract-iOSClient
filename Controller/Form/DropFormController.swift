//
//  DropFormController.swift
//  Cataract
//
//  Created by Rose Choi on 6/13/18.
//  Copyright © 2018 Rose Choi. All rights reserved.
//

import UIKit

class DropFormController : DynamicController<DropFormViewModel>
{
    private var _label : UILabel!
    private var _tanButton : UIButton!
    private var _pinkButton : UIButton!
    private var _grayButton : UIButton!
    private var _yellowButton : UIButton!
    private var _purpleButton : UIButton!
    private var _navyButton : UIButton!
    private var _orangeButton: UIButton!
    
    var label : UILabel
    {
        get
        {
            if (self._label == nil)
            {
                self._label = UILabel()
            }
            
            let label = self._label!
            
            return label
        }
    }
    
    var tanButton : UIButton
    {
        get
        {
            if (self._tanButton == nil)
            {
                self._tanButton = UIButton()
            }
            
            let tanButton = self._tanButton!
            
            return tanButton
        }
    }
    
    var pinkButton : UIButton
    {
        get
        {
            if (self._pinkButton == nil)
            {
                self._pinkButton = UIButton()
            }
            
            let pinkButton = self._pinkButton!
            
            return pinkButton
        }
    }
    
    var grayButton : UIButton
    {
        get
        {
            if (self._grayButton == nil)
            {
                self._grayButton = UIButton()
            }
            
            let grayButton = self._grayButton!
            
            return grayButton
        }
    }
    
    var yellowButton : UIButton
    {
        get
        {
            if (self._yellowButton == nil)
            {
                self._yellowButton = UIButton()
            }
            
            let yellowButton = self._yellowButton!
            
            return yellowButton
        }
    }
    
    var purpleButton : UIButton
    {
        get
        {
            if (self._purpleButton == nil)
            {
                self._purpleButton = UIButton()
            }
            
            let purpleButton = self._purpleButton!
            
            return purpleButton
        }
    }
    
    var navyButton : UIButton
    {
        get
        {
            if (self._navyButton == nil)
            {
                self._navyButton = UIButton()
            }
            
            let navyButton = self._navyButton!
            
            return navyButton
        }
    }
    
    var orangeButton : UIButton
    {
        get
        {
            if (self._orangeButton == nil)
            {
                self._orangeButton = UIButton()
            }
            
            let orangeButton = self._orangeButton!
            
            return orangeButton
        }
    }
    
    override func viewDidLoad()
    {
        self.view.addSubview(self.label)
        self.view.addSubview(self.tanButton)
        self.view.addSubview(self.pinkButton)
        self.view.addSubview(self.grayButton)
        self.view.addSubview(self.yellowButton)
        self.view.addSubview(self.purpleButton)
        self.view.addSubview(self.navyButton)
        self.view.addSubview(self.orangeButton)
    }
    
    override func render(size: CGSize)
    {
        self.label.frame.size.width = self.canvas.gridSize.width - self.canvas.draw(tiles: 1)
        self.label.frame.size.height = self.canvas.draw(tiles: 2)
        self.label.frame.origin.x = self.canvas.draw(tiles: 0.5)
        self.label.frame.origin.y = (self.canvas.gridSize.height - self.label.frame.size.height) / 2
        
        self.tanButton.frame.size.width = self.canvas.draw(tiles: 1)
        self.tanButton.frame.size.height = self.tanButton.frame.size.width
        self.tanButton.frame.origin.x = self.label.frame.origin.x
        self.tanButton.frame.origin.y = self.label.frame.size.height + self.canvas.draw(tiles: 1)
        
        self.pinkButton.frame.size.width = self.tanButton.frame.size.width
        self.pinkButton.frame.size.height = self.pinkButton.frame.size.width
        self.pinkButton.frame.origin.x = self.tanButton.frame.origin.x + self.tanButton.frame.size.width + self.canvas.draw(tiles: 0.5)
        self.pinkButton.frame.origin.y = self.tanButton.frame.origin.y
        
        self.grayButton.frame.size.width = self.tanButton.frame.size.width
        self.grayButton.frame.size.height = self.grayButton.frame.size.width
        self.grayButton.frame.origin.x = self.pinkButton.frame.origin.x + self.pinkButton.frame.size.width + self.canvas.draw(tiles: 0.5)
        self.grayButton.frame.origin.y = self.tanButton.frame.origin.y
        
        self.yellowButton.frame.size.width = self.tanButton.frame.size.width
        self.yellowButton.frame.size.height = self.yellowButton.frame.size.width
        self.yellowButton.frame.origin.x = self.tanButton.frame.origin.x
        self.yellowButton.frame.origin.y = self.tanButton.frame.origin.y + self.tanButton.frame.size.height + self.canvas.draw(tiles: 1)
        
        self.purpleButton.frame.size.width = self.tanButton.frame.size.width
        self.purpleButton.frame.size.height = self.purpleButton.frame.size.width
        
    }
}

