//
//  InputOverviewController.swift
//  Rose
//
//  Created by Rose Choi on 5/12/18.
//  Copyright © 2018 Rose Choi. All rights reserved.
//

import UIKit

class InputOverviewController : DynamicController<InputOverviewViewModel>, UIPageViewDataSource, UIPageViewDelegate
{
    private var _pageView : UIPageView!
    private var _inputQueue : DynamicQueue<InputController>!
    
    var pageView : UIPageView!
    {
        get
        {
            if (self._pageView == nil)
            {
                self._pageView = UIPageView()
                self._pageView.dataSource = self
                self._pageView.delegate = self
            }
            
            let pageView = self._pageView
            
            return pageView
        }
    }
    
    var inputQueue : DynamicQueue<InputController>!
    {
        get
        {
            if (self._inputQueue == nil)
            {
                self._inputQueue = DynamicQueue()
            }
            
            let inputQueue = self._inputQueue
            
            return inputQueue
        }
    }
    
    override func viewDidLoad()
    {
        self.view.backgroundColor = UIColor.white
        
        self.view.addSubview(self.pageView)
    }

    var inputControllerSize : CGSize
    {
        get
        {
            var inputControllerSize = CGSize.zero
            inputControllerSize.height = self.canvas.draw(tiles: 3)
            inputControllerSize.width = self.canvas.gridSize.width
            
            return inputControllerSize
        }
    }
    
    override func render(size: CGSize)
    {
        self.pageView.frame.size = self.view.frame.size
    }
    
    override func unbind()
    {
        self.inputQueue.purge
        { (identifier, inputController) in
                
                inputController.unbind()
        }
        
        super.unbind()
    }
    
    func pageView(_ pageView: UIPageView, numberOfItemsInSection section: Int) -> Int
    {
        return self.viewModel.inputViewModels.count
    }
    
    func pageView(_ pageView: UIPageView, cellForItemAt indexPath: IndexPath) -> UIPageViewCell
    {
        let cell = UIPageViewCell()
        
        let inputController = self.inputQueue.dequeueElement(withIdentifier: String(indexPath.item))
        { () -> InputController in
            
            let inputController = InputController()
            
            return inputController
        }
        
        let inputViewModel = self.viewModel.inputViewModels[indexPath.item]
        inputController.bind(viewModel: inputViewModel)
        inputController.render(size: self.inputControllerSize)
        cell.addSubview(inputController.view)
        
        return cell
    }
    
    func pageView(_ pageView: UIPageView, sizeForItemAt indexPath: IndexPath) -> CGSize
    {
        var itemSize = CGSize(width: UIListViewAutomaticDimension, height: UIListViewAutomaticDimension)
        let inputController = self.inputQueue.retrieveElement(withIdentifier: String(indexPath.item))
        
        if (inputController != nil)
        {
            itemSize.width = inputController!.view.frame.width
        }
        
        return itemSize
    }
    
    func pageView(_ pageView: UIPageView, didEndDisplaying cell: UIPageViewCell, forItemAt indexPath: IndexPath)
    {
        self.inputQueue.enqueueElement(withIdentifier: String(indexPath.item))
        { (inputController) in
            
            if (inputController != nil)
            {
                inputController!.unbind()
            }
        }
    }
}
