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
    private var _runningImageView : UIImageView!
    private var _emptyDropImageView : UIImageView!
    private var _filledDropImageView : UIImageView!
    private var _scaleView : UIView!
    private var _timeLabel : UILabel!
    
    var runningImageView : UIImageView
    {
        get
        {
            if (self._runningImageView == nil)
            {
                self._runningImageView = UIImageView()
                self._runningImageView.image = UIImage(contentsOfFile: Bundle.main.path(forResource: "Running", ofType: "png")!)
            }
            
            let runningImageView = self._runningImageView!
            
            return runningImageView
        }
    }
    
    var emptyDropImageView : UIImageView
    {
        get
        {
            if (self._emptyDropImageView == nil)
            {
                self._emptyDropImageView = UIImageView()
                self._emptyDropImageView.image = UIImage(contentsOfFile: Bundle.main.path(forResource: "EmptyDrop", ofType: "png")!)
            }
            
            let emptyDropImageView = self._emptyDropImageView!
            
            return emptyDropImageView
        }
    }
    
    var filledDropImageView : UIImageView
    {
        get
        {
            if (self._filledDropImageView == nil)
            {
                self._filledDropImageView = UIImageView()
                self._filledDropImageView.image = UIImage(contentsOfFile: Bundle.main.path(forResource: "FilledDrop", ofType: "png")!)
            }
            
            let filledDropImageView = self._filledDropImageView!
            
            return filledDropImageView
        }
    }
    
    var scaleView : UIView
    {
        get
        {
            if (self._scaleView == nil)
            {
                self._scaleView = UIView()
                self._scaleView.backgroundColor = UIColor.white
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
    
        self.view.addSubview(self.runningImageView)
        self.view.addSubview(self.emptyDropImageView)
        self.view.addSubview(self.filledDropImageView)
        self.view.addSubview(self.scaleView)
        self.view.addSubview(self.timeLabel)
    }
    
    override func render(size: CGSize)
    {
        super.render(size: size)
        
        self.timeLabel.font = UIFont.systemFont(ofSize: 48)
        
        self.emptyDropImageView.frame.size.width = self.canvas.draw(tiles: 3)
        self.emptyDropImageView.frame.size.height = self.emptyDropImageView.frame.size.width
        
        self.filledDropImageView.frame.size.width = self.canvas.draw(tiles: 3)
        self.filledDropImageView.frame.size.height = self.filledDropImageView.frame.size.width
        
        self.scaleView.frame.size.width = self.canvas.gridSize.width - self.emptyDropImageView.frame.size.width -  self.filledDropImageView.frame.size.width - self.canvas.draw(tiles: 1.5)
         self.scaleView.frame.size.height = 1
        
        self.runningImageView.frame.size.width = self.canvas.draw(tiles: 2)
        self.runningImageView.frame.size.height = self.runningImageView.frame.size.width
        
        self.timeLabel.frame.size.width = self.canvas.gridSize.width - self.canvas.draw(tiles: 1)
        self.timeLabel.frame.size.height = self.canvas.draw(tiles: 3)
        
        self.emptyDropImageView.frame.origin.x = self.canvas.draw(tiles: 0.5)
        self.emptyDropImageView.frame.origin.y = (self.canvas.gridSize.height - self.emptyDropImageView.frame.size.height - self.timeLabel.frame.size.height - self.canvas.draw(tiles: 2)) / 2
        
        self.filledDropImageView.frame.origin.x = self.canvas.gridSize.width - self.canvas.draw(tiles: 3.5)
        self.filledDropImageView.frame.origin.y = self.emptyDropImageView.frame.origin.y
        
        self.scaleView.frame.origin.x = self.emptyDropImageView.frame.origin.x + self.emptyDropImageView.frame.size.width + self.canvas.draw(tiles: 0.25)
        self.scaleView.center.y = self.emptyDropImageView.center.y
        
        self.runningImageView.frame.origin.x = self.scaleView.frame.origin.x
        self.runningImageView.center.y = self.scaleView.center.y
        
        self.timeLabel.frame.origin.x = self.emptyDropImageView.frame.origin.x
        self.timeLabel.frame.origin.y = self.emptyDropImageView.frame.origin.y + self.emptyDropImageView.frame.size.height + self.canvas.draw(tiles: 2)
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
