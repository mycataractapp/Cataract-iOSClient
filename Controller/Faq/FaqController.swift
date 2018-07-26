//
//  FaqController.swift
//  Cataract
//
//  Created by Rose Choi on 7/4/18.
//  Copyright © 2018 Rose Choi. All rights reserved.
//

import UIKit

class FaqController : DynamicController<FaqViewModel>
{
    private var _imageView : UIImageView!
    private var _headingLabel : UILabel!
    private var _infoLabel : UILabel!
    private var _lineView : UIView!
    
    var imageView : UIImageView
    {
        get
        {
            if (self._imageView == nil)
            {
                self._imageView = UIImageView()
                self._imageView.image = UIImage(contentsOfFile: Bundle.main.path(forResource: "Info", ofType: "png")!)
            }
            
            let imageView = self._imageView!
            
            return imageView
        }
    }
    
    var headingLabel : UILabel
    {
        get
        {
            if (self._headingLabel == nil)
            {
                self._headingLabel = UILabel()
                self._headingLabel.numberOfLines = 0
                self._headingLabel.textColor = UIColor(red: 51/255, green: 127/255, blue: 159/255, alpha: 1)
            }
            
            let headingLabel = self._headingLabel!
            
            return headingLabel
        }
    }
    
    var infoLabel : UILabel
    {
        get
        {
            if (self._infoLabel == nil)
            {
                self._infoLabel = UILabel()
                self._infoLabel.numberOfLines = 0
            }
            
            let infoLabel = self._infoLabel!
            
            return infoLabel
        }
    }
    
    var lineView : UIView
    {
        get
        {
            if (self._lineView == nil)
            {
                self._lineView = UIView()
                self._lineView.backgroundColor = UIColor(red: 234/255, green: 234/255, blue: 234/255, alpha: 1)
            }
            
            let lineView = self._lineView!
            
            return lineView
        }
    }
    
    override func viewDidLoad()
    {
        self.view.addSubview(self.imageView)
        self.view.addSubview(self.headingLabel)
        self.view.addSubview(self.infoLabel)
        self.view.addSubview(self.lineView)
    }
    
    override func render(size: CGSize)
    {
        super.render(size: size)
        
        self.headingLabel.font = UIFont.boldSystemFont(ofSize: 20)
        self.infoLabel.font = UIFont.systemFont(ofSize: 20)
        
        self.imageView.frame.size.width = self.canvas.draw(tiles: 1)
        self.imageView.frame.size.height = self.imageView.frame.size.width
        
        self.headingLabel.frame.size.width = self.view.frame.size.width - self.imageView.frame.size.width - self.canvas.draw(tiles: 1.15)
        self.headingLabel.sizeToFit()
        
        self.infoLabel.frame.size.width = self.view.frame.size.width - self.imageView.frame.size.width - self.canvas.draw(tiles: 1.15)
        self.infoLabel.sizeToFit()
        
        self.lineView.frame.size.width = self.view.frame.size.width - self.canvas.draw(tiles: 1)
        self.lineView.frame.size.height = 1

        self.view.frame.size.height = self.headingLabel.frame.size.height + self.infoLabel.frame.size.height + self.lineView.frame.size.height + self.canvas.draw(tiles: 0.75)
        
        self.imageView.frame.origin.x = self.canvas.draw(tiles: 0.15)
        self.imageView.frame.origin.y = self.canvas.draw(tiles: 0.25)

        self.headingLabel.frame.origin.x = self.imageView.frame.origin.x + self.imageView.frame.size.width + self.canvas.draw(tiles: 0.25)
        self.headingLabel.frame.origin.y = self.imageView.frame.origin.y

        self.infoLabel.frame.origin.x = self.headingLabel.frame.origin.x
        self.infoLabel.frame.origin.y = self.headingLabel.frame.origin.y + self.headingLabel.frame.size.height + self.canvas.draw(tiles: 0.25)

        self.lineView.frame.origin.x = self.headingLabel.frame.origin.x
        self.lineView.frame.origin.y = self.view.frame.size.height - self.lineView.frame.size.height
    }
    
    override func bind(viewModel: FaqViewModel)
    {
        super.bind(viewModel: viewModel)
        
        self.viewModel.addObserver(self,
                                   forKeyPath: "heading",
                                   options: NSKeyValueObservingOptions([NSKeyValueObservingOptions.new,
                                                                        NSKeyValueObservingOptions.initial]),
                                   context: nil)
        self.viewModel.addObserver(self,
                                   forKeyPath: "info",
                                   options: NSKeyValueObservingOptions([NSKeyValueObservingOptions.new,
                                                                        NSKeyValueObservingOptions.initial]),
                                   context: nil)
    }
    
    override func unbind()
    {
        self.viewModel.removeObserver(self, forKeyPath: "heading")
        self.viewModel.removeObserver(self, forKeyPath: "info")
        
        super.unbind()
    }
    
    override func shouldSetKeyPath(_ keyPath: String?, ofObject object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?)
    {
        if (keyPath == "heading")
        {
            let newValue = change![NSKeyValueChangeKey.newKey] as! String
            self.set(heading: newValue)
        }
        else if (keyPath == "info")
        {
            let newValue = change![NSKeyValueChangeKey.newKey] as! String
            self.set(info: newValue)
        }
    }
    
    func set(heading: String)
    {
        self.headingLabel.text = heading
        self.render(size: self.view.frame.size)
    }
    
    func set(info: String)
    {
        self.infoLabel.text = info
        self.render(size: self.view.frame.size)
    }
}
