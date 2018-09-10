//
//  IconController.swift
//  Cataract
//
//  Created by Roseanne Choi on 6/15/18.
//  Copyright © 2018 Roseanne Choi. All rights reserved.
//

import UIKit

class IconController : DynamicController, DynamicViewModelDelegate
{
    private var _buttonView : UIImageView!
    
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
        super.render(canvas: canvas)
        self.view.frame.size = canvas.size
        
        self.buttonView.frame.size.width = self.view.frame.size.width - canvas.draw(tiles: 1)
        self.buttonView.frame.size.height = self.buttonView.frame.size.width
        self.buttonView.frame.origin.x = (canvas.size.width - self.buttonView.frame.size.width) / 2
        self.buttonView.frame.origin.y = (canvas.size.height - self.buttonView.frame.size.height) / 2
        
        return canvas
    }
    
    override func bind()
    {
        super.bind()
        
        self.viewModel.delegate = self
    }
    
    override func unbind()
    {
        super.unbind()
        
        self.viewModel.delegate = nil
    }

    func viewModel(_ viewModel: DynamicViewModel, transition: String, from oldState: String, to newState: String)
    {
        if (newState == "On" || newState == "Off")
        {
            let imagePath = self.viewModel.colorPathByState[newState]

            UIImage.load(contentsOfFile: Bundle.main.path(forResource: imagePath!, ofType: "png")!)
            { (image) in

                self.buttonView.image = image
            }
        }
    }
}
