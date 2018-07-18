//
//  UIListViewDataSource.swift
//  Pacific
//
//  Created by Minh Nguyen on 11/25/15.
//  Copyright © 2015 Minh Nguyen. All rights reserved.
//

import UIKit

@objc
protocol UIListViewDataSource 
{
    func listView(_ listView: UIListView, cellForItemAt indexPath: IndexPath) -> UIListViewCell
    @objc optional func numberOfListSections(in listView: UIListView) -> Int
    func listView(_ listView: UIListView, numberOfItemsInSection section: Int) -> Int
    @objc optional func listView(_ listView: UIListView, titleForHeaderInSection section: Int) -> String?
    @objc optional func listView(_ listView: UIListView, titleForFooterInSection section: Int) -> String?
    @objc optional func listView(_ listView: UIListView, indexPathBefore indexPath: IndexPath) -> IndexPath?
    @objc optional func listView(_ listView: UIListView, indexPathAfter indexPath: IndexPath) -> IndexPath?
    @objc optional func listView(_ listView: UIListView, initializeAt indexPath: IndexPath) -> IndexPath
    @objc optional func listViewShouldReloadAtLeadingBuffer(_ listView: UIListView) -> Bool
    @objc optional func listViewShouldReloadAtTrailingBuffer(_ listView: UIListView) -> Bool
}
