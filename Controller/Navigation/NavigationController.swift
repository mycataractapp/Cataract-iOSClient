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
    private var _label : UILabel!
    
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
    
    var label : UILabel
    {
        get
        {
            if (self._label == nil)
            {
                self._label = UILabel()
                self._label.textAlignment = NSTextAlignment.center
            }
            
            let label = self._label!
            
            return label
        }
    }
    
    override func viewDidLoad()
    {
        self.view.backgroundColor = UIColor.white
        self.view.addSubview(self.imageView)
        self.view.addSubview(self.label)
    }
    
    override func render(size: CGSize)
    {
        super.render(size: size)
        
        self.label.font = UIFont.systemFont(ofSize: 12)
        
        self.imageView.frame.size.width = self.canvas.draw(tiles: 2)
        self.imageView.frame.size.height = self.imageView.frame.size.width
        
        self.label.sizeToFit()
        
        self.imageView.frame.origin.x = (self.canvas.gridSize.width - self.imageView.frame.size.width) / 2
        self.imageView.frame.origin.y = (self.canvas.gridSize.height - self.imageView.frame.size.height - self.label.frame.size.height) / 2
        
        self.label.center.x = self.imageView.center.x
        self.label.frame.origin.y = self.imageView.frame.origin.y + self.imageView.frame.size.height + self.canvas.draw(tiles: 0.5)
    }
    
    override func bind(viewModel: NavigationViewModel)
    {
        super.bind(viewModel: viewModel)
        
        viewModel.addObserver(self,
                              forKeyPath: "title",
                              options: NSKeyValueObservingOptions([NSKeyValueObservingOptions.new,
                                                                   NSKeyValueObservingOptions.initial]),
                              context: nil)
        
        viewModel.delegate = self
    }
    
    override func unbind()
    {
        self.viewModel.removeObserver(self, forKeyPath: "title")
        
        super.unbind()
    }
    
    override func shouldSetKeyPath(_ keyPath: String?, ofObject object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?)
    {
        if (keyPath == "title")
        {
            let newValue = change![NSKeyValueChangeKey.newKey] as! String
            self.set(title: newValue)
        }
    }
    
    func set(title: String)
    {
        self.label.text = title
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
        
        if (newState == "On")
        {
            self.label.textColor = UIColor(red: 51/255, green: 127/255, blue: 159/255, alpha: 1)
        }
        
        if (newState == "Off")
        {
            self.label.textColor = UIColor.lightGray
        }
    }
}
