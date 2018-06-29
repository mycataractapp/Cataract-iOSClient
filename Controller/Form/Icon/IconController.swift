//
//  IconController.swift
//  Cataract
//
//  Created by Rose Choi on 6/15/18.
//  Copyright © 2018 Rose Choi. All rights reserved.
//

import UIKit

class IconController : DynamicController<IconViewModel>, DynamicViewModelDelegate
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
    
    override func render(size: CGSize)
    {
        super.render(size: size)
        
        self.buttonView.frame.size.width = self.view.frame.size.width - self.canvas.draw(tiles: 1)
        self.buttonView.frame.size.height = self.buttonView.frame.size.width
        self.buttonView.frame.origin.x = (self.canvas.gridSize.width - self.buttonView.frame.size.width) / 2
        self.buttonView.frame.origin.y = (self.canvas.gridSize.height - self.buttonView.frame.size.height) / 2
    }
    
    override func bind(viewModel: IconViewModel)
    {
        super.bind(viewModel: viewModel)
        
        self.viewModel.delegate = self
    }
    
    override func unbind()
    {
        self.viewModel.delegate = nil
        
        super.unbind()
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
