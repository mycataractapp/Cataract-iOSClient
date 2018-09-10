//
//  ColorCardController.swift
//  Cataract
//
//  Created by Roseanne Choi on 9/9/18.
//  Copyright © 2018 Roseanne Choi. All rights reserved.
//

import UIKit

class ColorCardController : DynamicController, DynamicViewModelDelegate
{
    private var _buttonView : UIImageView!
    @objc dynamic var viewModel : ColorCardViewModel!
    
    var buttonView : UIImageView
    {
        get
        {
            if (self._buttonView == nil)
            {
                self._buttonView = UIImageView()
            }
            
            let buttonView = self._buttonView!
            
            return buttonView
        }
    }
    
    override func viewDidLoad()
    {
        self.view.addSubview(self.buttonView)
    }
    
    override func render(canvas: DynamicCanvas) -> DynamicCanvas
    {
        let canvas = DynamicCanvas()
        self.view.frame.size = canvas.size
        
        self.buttonView.frame.size.width = self.view.frame.size.width - canvas.draw(tiles: 1)
        self.buttonView.frame.size.height = self.buttonView.frame.size.width
        self.buttonView.frame.origin.x = (canvas.size.width - self.buttonView.frame.size.width) / 2
        self.buttonView.frame.origin.y = (canvas.size.height - self.buttonView.frame.size.height) / 2
        self.buttonView.layer.cornerRadius = self.buttonView.frame.width / 2
        
        return canvas
    }
    
    override func observeController(for controllerEvent: DynamicController.Event, kvoEvent: DynamicKVO.Event)
    {
        if (kvoEvent.keyPath == DynamicKVO.keyPath(\ColorCardController.viewModel))
        {
            if (controllerEvent.operation == DynamicController.Event.Operation.bind)
            {
                self.viewModel.delegate = self
            }
            else
            {
                self.viewModel.delegate = nil
            }
        }
    }
    
    func viewModel(_ viewModel: DynamicViewModel, transitWith event: DynamicViewModel.Event)
    {
        if (event.newState == ColorCardViewModel.State.on)
        {
            self.buttonView.backgroundColor = self.viewModel.uicolor
            self.buttonView.layer.borderWidth = 0
        }
        else
        {
            self.buttonView.backgroundColor = UIColor.white
            self.buttonView.layer.borderColor = self.viewModel.uicolor.cgColor
            self.buttonView.layer.borderWidth = 2
        }
    }
}
