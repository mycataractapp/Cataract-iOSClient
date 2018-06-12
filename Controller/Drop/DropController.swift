//
//  DropController.swift
//  Cataract
//
//  Created by Rose Choi on 6/6/18.
//  Copyright © 2018 Rose Choi. All rights reserved.
//

import UIKit

class DropController : DynamicController<DropViewModel>
{
    private var _dropImageView : UIImageView!
    private var _neutralImageView : UIImageView!
    private var _happyImageView : UIImageView!
    private var _scaleView : UIView!
    private var _timeLabel : UILabel!
    
    var dropImageView : UIImageView
    {
        get
        {
            if (self._dropImageView == nil)
            {
                self._dropImageView = UIImageView()
                self._dropImageView.image = UIImage(contentsOfFile: Bundle.main.path(forResource: "Drop", ofType: "png")!)
            }
            
            let dropImageView = self._dropImageView!
            
            return dropImageView
        }
    }
    
    var neutralImageView : UIImageView
    {
        get
        {
            if (self._neutralImageView == nil)
            {
                self._neutralImageView = UIImageView()
                self._neutralImageView.image = UIImage(contentsOfFile: Bundle.main.path(forResource: "Neutral", ofType: "png")!)
            }
            
            let neutralImageView = self._neutralImageView!
            
            return neutralImageView
        }
    }
    
    var happyImageView : UIImageView
    {
        get
        {
            if (self._happyImageView == nil)
            {
                self._happyImageView = UIImageView()
                self._happyImageView.image = UIImage(contentsOfFile: Bundle.main.path(forResource: "Smiling", ofType: "png")!)
            }
            
            let happyImageView = self._happyImageView!
            
            return happyImageView
        }
    }
    
    var scaleView : UIView
    {
        get
        {
            if (self._scaleView == nil)
            {
                self._scaleView = UIView()
                self._scaleView.isHidden = true
            }
            
            let scaleView = self._scaleView!
            
            return scaleView
        }
    }
    
    var timeLabel : UILabel
    {
        get
        {
            if (self._timeLabel == nil)
            {
                self._timeLabel = UILabel()
                self._timeLabel.textAlignment = NSTextAlignment.center
                self._timeLabel.textColor = UIColor.white
            }
            
            let timeLabel = self._timeLabel!
            
            return timeLabel
        }
    }
    
    override func viewDidLoad()
    {
        self.view.backgroundColor = UIColor(red: 0/255, green: 0/255, blue: 144/255, alpha: 1)
        
        self.view.addSubview(self.dropImageView)
        self.view.addSubview(self.neutralImageView)
        self.view.addSubview(self.happyImageView)
        self.view.addSubview(self.scaleView)
        self.view.addSubview(self.timeLabel)
    }
    
    override func render(size: CGSize)
    {
        super.render(size: size)
        
        self.timeLabel.font = UIFont.systemFont(ofSize: 48)
        
        self.neutralImageView.frame.size.width = self.canvas.draw(tiles: 3)
        self.neutralImageView.frame.size.height = self.neutralImageView.frame.size.width
        
        self.happyImageView.frame.size.width = self.canvas.draw(tiles: 3)
        self.happyImageView.frame.size.height = self.happyImageView.frame.size.width
        
        self.scaleView.frame.size.width = self.canvas.gridSize.width - self.neutralImageView.frame.size.width -  self.happyImageView.frame.size.width - self.canvas.draw(tiles: 1.5)
         self.scaleView.frame.size.height = 1
        
        self.dropImageView.frame.size.width = self.canvas.draw(tiles: 2)
        self.dropImageView.frame.size.height = self.dropImageView.frame.size.width
        
        self.timeLabel.frame.size.width = self.canvas.gridSize.width - self.canvas.draw(tiles: 1)
        self.timeLabel.frame.size.height = self.canvas.draw(tiles: 3)
        
        self.neutralImageView.frame.origin.x = self.canvas.draw(tiles: 0.5)
        self.neutralImageView.frame.origin.y = (self.canvas.gridSize.height - self.neutralImageView.frame.size.height - self.timeLabel.frame.size.height - self.canvas.draw(tiles: 2)) / 2
        
        self.happyImageView.frame.origin.x = self.canvas.gridSize.width - self.canvas.draw(tiles: 3.5)
        self.happyImageView.frame.origin.y = self.neutralImageView.frame.origin.y
        
        self.scaleView.frame.origin.x = self.neutralImageView.frame.origin.x + self.neutralImageView.frame.size.width + self.canvas.draw(tiles: 0.25)
        self.scaleView.center.y = self.neutralImageView.center.y
        
        self.dropImageView.frame.origin.x = self.scaleView.frame.origin.x
        self.dropImageView.center.y = self.scaleView.center.y
        
        self.timeLabel.frame.origin.x = self.neutralImageView.frame.origin.x
        self.timeLabel.frame.origin.y = self.neutralImageView.frame.origin.y + self.neutralImageView.frame.size.height + self.canvas.draw(tiles: 2)
    }
    
    override func bind(viewModel: DropViewModel)
    {
        super.bind(viewModel: viewModel)

        viewModel.addObserver(self,
                              forKeyPath: "time",
                              options: NSKeyValueObservingOptions([NSKeyValueObservingOptions.new,
                                                                   NSKeyValueObservingOptions.initial]),
                              context: nil)
    }
    
    override func unbind()
    {
        self.viewModel.removeObserver(self, forKeyPath: "time")
        
        super.unbind()
    }
    
    override func shouldSetKeyPath(_ keyPath: String?, ofObject object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?)
    {
        if (keyPath == "time")
        {
            let newValue = change![NSKeyValueChangeKey.newKey] as! String
            self.set(time: newValue)
        }
    }
    
    func set(time: String)
    {
        self.timeLabel.text = "Drop @ " + time
    }
}
