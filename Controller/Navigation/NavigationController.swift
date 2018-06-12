//
//  NavigationController.swift
//  Cataract
//
//  Created by Rose Choi on 6/9/18.
//  Copyright © 2018 Rose Choi. All rights reserved.
//

import UIKit

class NavigationController : DynamicController<NavigationViewModel>
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
        self.view.backgroundColor = UIColor(red: 0/255, green: 0/255, blue: 144/255, alpha: 1)
        self.view.addSubview(self.imageView)
    }
    
    override func render(size: CGSize)
    {
        super.render(size: size)
        
        self.view.layer.borderWidth = 0.5
        
        self.imageView.frame.size.width = self.canvas.draw(tiles: 2)
        self.imageView.frame.size.height = self.imageView.frame.size.width
        self.imageView.frame.origin.x = (self.canvas.gridSize.width - self.imageView.frame.size.width) / 2
        self.imageView.frame.origin.y = (self.canvas.gridSize.height - self.imageView.frame.size.height) / 2
    }
    
    override func bind(viewModel: NavigationViewModel)
    {
        super.bind(viewModel: viewModel)
        viewModel.addObserver(self,
                              forKeyPath: "imagePath",
                              options: NSKeyValueObservingOptions([NSKeyValueObservingOptions.new,
                                                                   NSKeyValueObservingOptions.initial]),
                              context: nil)
    }
    
    override func unbind()
    {
        self.viewModel.removeObserver(self, forKeyPath: "imagePath")
        
        super.unbind()
    }
    
    override func shouldSetKeyPath(_ keyPath: String?, ofObject object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?)
    {
        if (keyPath == "imagePath")
        {
            let newValue = change![NSKeyValueChangeKey.newKey] as! String
            self.set(imagePath: newValue)
        }
    }
    
    func set(imagePath: String)
    {
        UIImage.load(contentsOfFile: imagePath)
        { (image) in
            
            self.imageView.image = image
        }
    }
}
