//
//  DropTrackerController.swift
//  Cataract
//
//  Created by Roseanne Choi on 6/6/18.
//  Copyright © 2018 Roseanne Choi. All rights reserved.
//

import UIKit

class DropTrackerController : DynamicController<DropTrackerViewModel>
{
    private var _runningImageView : UIImageView!
    private var _emptyDropTrackerImageView : UIImageView!
    private var _filledDropTrackerImageView : UIImageView!
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
    
    var emptyDropTrackerImageView : UIImageView
    {
        get
        {
            if (self._emptyDropTrackerImageView == nil)
            {
                self._emptyDropTrackerImageView = UIImageView()
                self._emptyDropTrackerImageView.image = UIImage(contentsOfFile: Bundle.main.path(forResource: "EmptyDrop", ofType: "png")!)
            }
            
            let emptyDropTrackerImageView = self._emptyDropTrackerImageView!
            
            return emptyDropTrackerImageView
        }
    }
    
    var filledDropTrackerImageView : UIImageView
    {
        get
        {
            if (self._filledDropTrackerImageView == nil)
            {
                self._filledDropTrackerImageView = UIImageView()
                self._filledDropTrackerImageView.image = UIImage(contentsOfFile: Bundle.main.path(forResource: "FilledDrop", ofType: "png")!)
            }
            
            let filledDropTrackerImageView = self._filledDropTrackerImageView!
            
            return filledDropTrackerImageView
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
                self._scaleView.addSubview(self.runningImageView)
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
    
        self.view.addSubview(self.emptyDropTrackerImageView)
        self.view.addSubview(self.filledDropTrackerImageView)
        self.view.addSubview(self.scaleView)
        self.view.addSubview(self.timeLabel)
    }
    
    override func render(size: CGSize)
    {
        super.render(size: size)
        
        self.timeLabel.font = UIFont.systemFont(ofSize: 48)
        
        self.emptyDropTrackerImageView.frame.size.width = self.canvas.draw(tiles: 3)
        self.emptyDropTrackerImageView.frame.size.height = self.emptyDropTrackerImageView.frame.size.width
        
        self.filledDropTrackerImageView.frame.size.width = self.canvas.draw(tiles: 3)
        self.filledDropTrackerImageView.frame.size.height = self.filledDropTrackerImageView.frame.size.width
        
        self.scaleView.frame.size.width = self.canvas.gridSize.width - self.emptyDropTrackerImageView.frame.size.width -  self.filledDropTrackerImageView.frame.size.width - self.canvas.draw(tiles: 1.5)
         self.scaleView.frame.size.height = 1
        
        self.runningImageView.frame.size.width = self.canvas.draw(tiles: 2)
        self.runningImageView.frame.size.height = self.runningImageView.frame.size.width
        
        self.timeLabel.frame.size.width = self.canvas.gridSize.width - self.canvas.draw(tiles: 1)
        self.timeLabel.frame.size.height = self.canvas.draw(tiles: 3)
        
        self.emptyDropTrackerImageView.frame.origin.x = self.canvas.draw(tiles: 0.5)
        self.emptyDropTrackerImageView.frame.origin.y = (self.canvas.gridSize.height - self.emptyDropTrackerImageView.frame.size.height - self.timeLabel.frame.size.height - self.canvas.draw(tiles: 2)) / 2
        
        self.filledDropTrackerImageView.frame.origin.x = self.canvas.gridSize.width - self.canvas.draw(tiles: 3.5)
        self.filledDropTrackerImageView.frame.origin.y = self.emptyDropTrackerImageView.frame.origin.y
        
        self.scaleView.frame.origin.x = self.emptyDropTrackerImageView.frame.origin.x + self.emptyDropTrackerImageView.frame.size.width + self.canvas.draw(tiles: 0.25)
        self.scaleView.center.y = self.emptyDropTrackerImageView.center.y
        
        self.runningImageView.center.y = self.scaleView.frame.height / 2
        
        self.timeLabel.frame.origin.x = self.emptyDropTrackerImageView.frame.origin.x
        self.timeLabel.frame.origin.y = self.emptyDropTrackerImageView.frame.origin.y + self.emptyDropTrackerImageView.frame.size.height + self.canvas.draw(tiles: 2)
    }
    
    override func bind(viewModel: DropTrackerViewModel)
    {
        super.bind(viewModel: viewModel)

        viewModel.addObserver(self,
                              forKeyPath: "time",
                              options: NSKeyValueObservingOptions([NSKeyValueObservingOptions.new,
                                                                   NSKeyValueObservingOptions.initial]),
                              context: nil)
        viewModel.addObserver(self,
                              forKeyPath: "completionRate",
                              options: NSKeyValueObservingOptions([NSKeyValueObservingOptions.new,
                                                                   NSKeyValueObservingOptions.initial]),
                              context: nil)
    }
    
    override func unbind()
    {
        self.viewModel.removeObserver(self, forKeyPath: "time")
        self.viewModel.removeObserver(self, forKeyPath: "completionRate")
        
        super.unbind()
    }
    
    override func shouldSetKeyPath(_ keyPath: String?, ofObject object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?)
    {
        if (keyPath == "time")
        {
            let newValue = change![NSKeyValueChangeKey.newKey] as! String
            self.set(time: newValue)
        }
        else if (keyPath == "completionRate")
        {
            let newValue = change![NSKeyValueChangeKey.newKey] as! Double
            self.set(completionRate: newValue)
        }
    }
    
    func set(time: String)
    {
//        self.timeLabel.text = "Next Drop: " + time
    }
    
    func set(completionRate: Double)
    {
        UIView.animate(withDuration: 0.5)
        {
            self.runningImageView.center.x = self.scaleView.frame.size.width * CGFloat(completionRate)
        }
        
    }
}
