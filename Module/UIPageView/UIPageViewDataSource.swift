//
//  UIPageViewDataSource.swift
//  Pacific
//
//  Created by Minh Nguyen on 11/25/15.
//  Copyright © 2015 Minh Nguyen. All rights reserved.
//

import UIKit

@objc
protocol UIPageViewDataSource
{
    func pageView(_ pageView: UIPageView, cellForItemAt indexPath: IndexPath) -> UIPageViewCell
    @objc optional func numberOfPageSections(in pageView: UIPageView) -> Int
    func pageView(_ pageView: UIPageView, numberOfItemsInSection section: Int) -> Int
    @objc optional func pageView(_ pageView: UIPageView, titleForHeaderInSection section: Int) -> String?
    @objc optional func pageView(_ pageView: UIPageView, titleForFooterInSection section: Int) -> String?
    @objc optional func pageView(_ pageView: UIPageView, indexPathBefore indexPath: IndexPath) -> IndexPath?
    @objc optional func pageView(_ pageView: UIPageView, indexPathAfter indexPath: IndexPath) -> IndexPath?
    @objc optional func pageView(_ pageView: UIPageView, initializeAt indexPath: IndexPath) -> IndexPath
    @objc optional func pageViewShouldReloadAtLeadingBuffer(_ pageView: UIPageView) -> Bool
    @objc optional func pageViewShouldReloadAtTrailingBuffer(_ pageView: UIPageView) -> Bool
}
