//
//  IconOverviewController.swift
//  Cataract
//
//  Created by Rose Choi on 6/15/18.
//  Copyright © 2018 Rose Choi. All rights reserved.
//

import UIKit

class IconOverviewController : DynamicController<IconOverviewViewModel>, UIListViewDelegate, UIListViewDataSource
{
    private var _listView : UIListView!
    private var _iconQueue : DynamicQueue<IconController>!

    var listView : UIListView
    {
        get
        {
            if (self._listView == nil)
            {
                self._listView = UIListView()
                self._listView.delegate = self
                self._listView.dataSource = self
                self._listView.isScrollEnabled = false
            }

            let listView = self._listView!

            return listView
        }
    }

    var iconQueue : DynamicQueue<IconController>
    {
        get
        {
            if (self._iconQueue == nil)
            {
                self._iconQueue = DynamicQueue()
            }

            let iconQueue = self._iconQueue!

            return iconQueue
        }
    }

    var iconControllerSize : CGSize
    {
        get
        {
            var iconControllerSize = CGSize.zero
            iconControllerSize.width = self.view.frame.size.width / 4
            iconControllerSize.height = self.view.frame.size.height / 2

            return iconControllerSize
        }
    }

    override func viewDidLoad()
    {
        self.view.addSubview(self.listView)
    }

    override func render(size: CGSize)
    {
        super.render(size: size)

        self.listView.frame.size = self.view.frame.size
    }

    override func unbind()
    {
        self.iconQueue.purge
        { (identifier, iconController) in

            iconController.unbind()
        }

        super.unbind()
    }

    func listView(_ listView: UIListView, numberOfItemsInSection section: Int) -> Int
    {
        return self.viewModel.iconViewModels.count
    }

    func listView(_ listView: UIListView, sizeForItemAt indexPath: IndexPath) -> CGSize
    {
        var itemSize = CGSize(width: UIListViewAutomaticDimension, height: UIListViewAutomaticDimension)
        let iconController = self.iconQueue.retrieveElement(withIdentifier: String(indexPath.item))

        if (iconController != nil)
        {
            itemSize.width = iconController!.view.frame.size.width
            itemSize.height = iconController!.view.frame.size.height
        }
        
        return itemSize
    }

    func listView(_ listView: UIListView, cellForItemAt indexPath: IndexPath) -> UIListViewCell
    {
        let cell = UIListViewCell()

        let iconController = self.iconQueue.dequeueElement(withIdentifier: String(indexPath.item))
        { () -> IconController in

            let iconController = IconController()

            return iconController
        }

        let iconViewModel = self.viewModel.iconViewModels[indexPath.item]
        iconController.bind(viewModel: iconViewModel)
        iconController.render(size: self.iconControllerSize)
        cell.addSubview(iconController.view)

        return cell
    }

    func listView(_ listView: UIListView, didEndDisplaying cell: UIListViewCell, forItemAt indexPath: IndexPath)
    {
        self.iconQueue.enqueueElement(withIdentifier: String(indexPath.item))
        { (iconController) in

            if (iconController != nil)
            {
                iconController!.unbind()
            }
        }
    }

    func listView(_ listView: UIListView, willSelectItemAt indexPath: IndexPath) -> IndexPath?
    {
        self.viewModel.toggle(at: indexPath.item)
        
        return indexPath
    }
}
