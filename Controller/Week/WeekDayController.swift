//
//  WeekDayController.swift
//  Cataract
//
//  Created by Rose Choi on 6/19/18.
//  Copyright © 2018 Rose Choi. All rights reserved.
//

import UIKit

class WeekDayController : DynamicController<WeekDayViewModel>, DynamicViewModelDelegate
{
    private var _label : UILabel!
    private var _checkBoxView : UIImageView!
    
    var label : UILabel
    {
        get
        {
            if (self._label == nil)
            {
                self._label = UILabel()
            }
            
            let label = self._label!
            
            return label
        }
    }
    
    var checkBoxView : UIImageView
    {
        get
        {
            if (self._checkBoxView == nil)
            {
                self._checkBoxView = UIImageView()
            }
            
            let checkBoxView = self._checkBoxView!
            
            return checkBoxView
        }
    }
    
    override func viewDidLoad()
    {
        self.view.addSubview(self.label)
        self.view.addSubview(self.checkBoxView)
    }
    
    override func render(size: CGSize)
    {
        super.render(size: size)

        self.label.font = UIFont.systemFont(ofSize: 24)
        
        self.label.sizeToFit()
        
        self.checkBoxView.frame.size.width =  self.canvas.draw(tiles: 2)
        self.checkBoxView.frame.size.height = self.checkBoxView.frame.size.width
        
        self.label.frame.origin.x = self.canvas.draw(tiles: 0.5)
        self.label.frame.origin.y = (self.canvas.gridSize.height - self.label.frame.size.height) / 2
        
        self.checkBoxView.frame.origin.x = self.canvas.gridSize.width - self.canvas.draw(tiles: 2.5)
        self.checkBoxView.center.y = self.label.center.y
    }
    
    override func bind(viewModel: WeekDayViewModel)
    {
        super.bind(viewModel: viewModel)
        
        self.viewModel.delegate = self
        
        self.viewModel.addObserver(self,
                              forKeyPath: "weekDay",
                              options: NSKeyValueObservingOptions([NSKeyValueObservingOptions.new,
                                                                   NSKeyValueObservingOptions.initial]),
                              context: nil)
    }
    
    override func unbind()
    {
        self.viewModel.delegate = nil
        
        self.viewModel.removeObserver(self, forKeyPath: "weekDay")
        
        super.unbind()
    }
    
    override func shouldSetKeyPath(_ keyPath: String?, ofObject object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?)
    {
        if (keyPath == "weekDay")
        {
            let newValue = change![NSKeyValueChangeKey.newKey] as! String
            self.set(weekDay: newValue)
        }
    }
    
    func set(weekDay: String)
    {
        self.label.text = weekDay
    }
    
    func viewModel(_ viewModel: DynamicViewModel, transition: String, from oldState: String, to newState: String)
    {
        if (newState == "On")
        {
//            let imagePath = self.viewModel.checkPathByState[newState]
            
            UIImage.load(contentsOfFile: Bundle.main.path(forResource: "Checked", ofType: "png")!)
            { (image) in
                
                self.checkBoxView.image = image
            }
        }
        else
        {
            UIImage.load(contentsOfFile: Bundle.main.path(forResource: "Unchecked", ofType: "png")!)
            { (image) in
                
                self.checkBoxView.image = image
            }
        }
    }
}
