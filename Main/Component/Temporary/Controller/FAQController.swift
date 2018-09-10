//
//  FAQController.swift
//  Cataract
//
//  Created by Roseanne Choi on 7/4/18.
//  Copyright © 2018 Roseanne Choi. All rights reserved.
//

import UIKit

class FAQController : DynamicController
{
    private var _imageView : UIImageView!
    private var _headingLabel : UILabel!
    private var _contentLabel : UILabel!
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
    
    var contentLabel : UILabel
    {
        get
        {
            if (self._contentLabel == nil)
            {
                self._contentLabel = UILabel()
                self._contentLabel.numberOfLines = 0
            }
            
            let contentLabel = self._contentLabel!
            
            return contentLabel
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
        self.view.addSubview(self.contentLabel)
        self.view.addSubview(self.lineView)
    }
    
    override func render(canvas: DynamicCanvas) -> DynamicCanvas
    {
        super.render(canvas: canvas)
        self.view.frame.size = canvas.size
        
        self.headingLabel.font = UIFont.boldSystemFont(ofSize: 20)
        self.contentLabel.font = UIFont.systemFont(ofSize: 20)
        
        self.imageView.frame.size.width = canvas.draw(tiles: 1)
        self.imageView.frame.size.height = self.imageView.frame.size.width
        
        self.headingLabel.frame.size.width = self.view.frame.size.width - self.imageView.frame.size.width - canvas.draw(tiles: 1.15)
        self.headingLabel.sizeToFit()
        
        self.contentLabel.frame.size.width = self.view.frame.size.width - self.imageView.frame.size.width - canvas.draw(tiles: 1.15)
        self.contentLabel.sizeToFit()
        
        self.lineView.frame.size.width = self.view.frame.size.width - canvas.draw(tiles: 1)
        self.lineView.frame.size.height = 1

        self.view.frame.size.height = self.headingLabel.frame.size.height + self.contentLabel.frame.size.height + self.lineView.frame.size.height + canvas.draw(tiles: 0.75)
        
        self.imageView.frame.origin.x = canvas.draw(tiles: 0.15)
        self.imageView.frame.origin.y = canvas.draw(tiles: 0.25)

        self.headingLabel.frame.origin.x = self.imageView.frame.origin.x + self.imageView.frame.size.width + canvas.draw(tiles: 0.25)
        self.headingLabel.frame.origin.y = self.imageView.frame.origin.y

        self.contentLabel.frame.origin.x = self.headingLabel.frame.origin.x
        self.contentLabel.frame.origin.y = self.headingLabel.frame.origin.y + self.headingLabel.frame.size.height + canvas.draw(tiles: 0.25)

        self.lineView.frame.origin.x = self.headingLabel.frame.origin.x
        self.lineView.frame.origin.y = self.view.frame.size.height - self.lineView.frame.size.height
        
        return canvas
    }
    
    override func bind()
    {
        super.bind()
        
        self.viewModel.addObserver(self,
                                   forKeyPath: "heading",
                                   options: NSKeyValueObservingOptions([NSKeyValueObservingOptions.new,
                                                                        NSKeyValueObservingOptions.initial]),
                                   context: nil)
        self.viewModel.addObserver(self,
                                   forKeyPath: "content",
                                   options: NSKeyValueObservingOptions([NSKeyValueObservingOptions.new,
                                                                        NSKeyValueObservingOptions.initial]),
                                   context: nil)
    }
    
    override func unbind()
    {
        super.unbind()
        
        self.viewModel.removeObserver(self, forKeyPath: "heading")
        self.viewModel.removeObserver(self, forKeyPath: "content")
    }
    
    override func shouldSetKeyPath(_ keyPath: String?, ofObject object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?)
    {
        if (keyPath == "heading")
        {
            let newValue = change![NSKeyValueChangeKey.newKey] as! String
            self.set(heading: newValue)
        }
        else if (keyPath == "content")
        {
            let newValue = change![NSKeyValueChangeKey.newKey] as! String
            self.set(content: newValue)
        }
    }
    
    func set(heading: String)
    {
        self.headingLabel.text = heading
    }
    
    func set(content: String)
    {
        self.contentLabel.text = content
    }
}
