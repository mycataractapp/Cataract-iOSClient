//
//  NavigationController.swift
//  Cataract
//
//  Created by Roseanne Choi on 6/9/18.
//  Copyright © 2018 Roseanne Choi. All rights reserved.
//

import UIKit

class NavigationController : DynamicController<NavigationViewModel>, DynamicViewModelDelegate
{
    private var _imageView : UIImageView!
    
    var imageView : UIImageView
    {
        get
        {
            if (self._imageView == nil)
            {
                self._imageView = UIImageView()
            }
            
            let imageView = self._imageView!
            
            return imageView
        }
    }
    
    override func viewDidLoad()
    {
        self.view.backgroundColor = UIColor.white
        self.view.addSubview(self.imageView)
    }
    
    override func render(size: CGSize)
    {
        super.render(size: size)
        
        self.imageView.frame.size.width = self.canvas.draw(tiles: 2)
        self.imageView.frame.size.height = self.imageView.frame.size.width
        self.imageView.frame.origin.x = (self.canvas.gridSize.width - self.imageView.frame.size.width) / 2
        self.imageView.frame.origin.y = (self.canvas.gridSize.height - self.imageView.frame.size.height) / 2
    }
    
    override func bind(viewModel: NavigationViewModel)
    {
        super.bind(viewModel: viewModel)
        
        viewModel.delegate = self
    }
    
    override func unbind()
    {
        self.viewModel.removeObserver(self, forKeyPath: "title")
        
        super.unbind()
    }
    
    func viewModel(_ viewModel: DynamicViewModel, transition: String, from oldState: String, to newState: String)
    {
        if (newState == "On" || newState == "Off")
        {
            let imagePath = self.viewModel.imagePathByState[newState]
            
            UIImage.load(contentsOfFile: imagePath!)
            { (image) in

                self.imageView.image = image
            }
        }
    }
}
