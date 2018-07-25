//
//  FaqOverviewController.swift
//  Cataract
//
//  Created by Rose Choi on 7/4/18.
//  Copyright © 2018 Rose Choi. All rights reserved.
//

import UIKit

class FaqOverviewController : DynamicController<FaqOverviewViewModel>, UIListViewDelegate, UIListViewDataSource
{
    private var _listView : UIListView!
    private var _faqQueue : DynamicQueue<FaqController>!
    
    var listView : UIListView!
    {
        get
        {
            if (self._listView == nil)
            {
                self._listView = UIListView()
                self._listView.delegate = self
                self._listView.dataSource = self
            }
            
            let listView = self._listView!
            
            return listView
        }
    }
    
    var faqQueue : DynamicQueue<FaqController>
    {
        get
        {
            if (self._faqQueue == nil)
            {
                self._faqQueue = DynamicQueue()
            }
            
            let faqQueue = self._faqQueue!
            
            return faqQueue
        }
    }
    
    var faqControllerSize : CGSize
    {
        get
        {
            var faqControllerSize = CGSize.zero
            faqControllerSize.width = self.listView.frame.size.width
            faqControllerSize.height = self.canvas.draw(tiles: 5)
            
            return faqControllerSize
        }
    }
    
    override func viewDidLoad()
    {
        self.listView.backgroundColor = UIColor.white
        
        self.view.addSubview(self.listView)
    }
    
    override func render(size: CGSize)
    {
        super.render(size: size)
        
        self.listView.frame.size = self.view.frame.size
    }
    
    override func unbind()
    {
        self.faqQueue.purge
        { (indentifier, faqController) in
            
            faqController.unbind()
        }
        
        super.unbind()
    }
    
    func listView(_ listView: UIListView, numberOfItemsInSection section: Int) -> Int
    {
        return self.viewModel.faqViewModels.count
    }
    
    func listView(_ listView: UIListView, sizeForItemAt indexPath: IndexPath) -> CGSize
    {
        var itemSize = CGSize(width: UIListViewAutomaticDimension, height: UIListViewAutomaticDimension)
        let faqController = self.faqQueue.retrieveElement(withIdentifier: String(indexPath.item))
        
        if (faqController != nil)
        {
            itemSize.width = faqController!.view.frame.size.width
            itemSize.height = faqController!.view.frame.size.height
        }
        
        return itemSize
    }
    
    func listView(_ listView: UIListView, cellForItemAt indexPath: IndexPath) -> UIListViewCell
    {
        let cell = UIListViewCell()
        
        let faqController = self.faqQueue.dequeueElement(withIdentifier: String(indexPath.item))
        { () -> FaqController in
            
            let faqController = FaqController()
            
            return faqController
        }
        
        let faqViewModel = self.viewModel.faqViewModels[indexPath.item]
        faqController.bind(viewModel: faqViewModel)
        faqController.render(size: self.faqControllerSize)
        cell.addSubview(faqController.view)
        
        return cell
    }
    
    func listView(_ listView: UIListView, didEndDisplaying cell: UIListViewCell, forItemAt indexPath: IndexPath)
    {
        self.faqQueue.enqueueElement(withIdentifier: String(indexPath.item))
        { (faqController) in
            
            if (faqController != nil)
            {
                faqController!.unbind()
            }
        }
    }
}
