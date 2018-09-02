//
//  AppDetailController.swift
//  Cataract
//
//  Created by Roseanne Choi on 6/9/18.
//  Copyright © 2018 Roseanne Choi. All rights reserved.
//

import UIKit
import CareKit
import UserNotifications

class AppDetailController : DynamicController<AppDetailViewModel>, UIPageViewDelegate, UIPageViewDataSource, DynamicViewModelDelegate, UNUserNotificationCenterDelegate
{
    private var _menuOverviewController : MenuOverviewController!
    private var _overLayView : UIView!
    private var _dropButton : UIButton!
    private var _appointmentButton : UIButton!
    private var _contactsButton : UIButton!
    private var _pageView : UIPageView!
    private var _dropOverviewController : DropOverviewController!
    private var _appointmentTimeOverviewController : AppointmentTimeOverviewController!
    private var _navigationOverviewController : NavigationOverviewController!
    private var _faqOverviewController : FaqOverviewController!
    private var _contactsOverviewController : ContactsOverviewController!
    var appointmentFormDetailController : AppointmentFormDetailController!
    var dropFormDetailController : DropFormDetailController?
    var contactsFormDetailController : ContactsFormDetailController!
    private var _appointmentStore : AppointmentStore!
    private var _colorStore : ColorStore!
    private var _faqStore : FaqStore!
    private var _contactStore : ContactStore!

    var menuOverviewController : MenuOverviewController
    {
        get
        {
            if (self._menuOverviewController == nil)
            {
                self._menuOverviewController = MenuOverviewController()
                self._menuOverviewController.listView.isScrollEnabled = false
            }

            let menuOverviewController = self._menuOverviewController!

            return menuOverviewController
        }
    }
    
    var overLayView : UIView
    {
        get
        {
            if (self._overLayView == nil)
            {
                self._overLayView = UIView()
                self._overLayView.autoresizesSubviews = false
                self._overLayView.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.5)
            }
            
            let overLayView = self._overLayView!
            
            return overLayView
        }
    }
    
    var dropButton : UIButton
    {
        get
        {
            if (self._dropButton == nil)
            {
                self._dropButton = UIButton()
                self._dropButton.setImage(UIImage(contentsOfFile: Bundle.main.path(forResource: "Add", ofType: "png")!),
                                      for: UIControlState.normal)
            }
            
            let dropButton = self._dropButton!
            
            return dropButton
        }
    }
    
    var appointmentButton : UIButton
    {
        get
        {
            if (self._appointmentButton == nil)
            {
                self._appointmentButton = UIButton()
                self._appointmentButton.setImage(UIImage(contentsOfFile: Bundle.main.path(forResource: "Add", ofType: "png")!),
                                                 for: UIControlState.normal)
            }
            
            let appointmentButton = self._appointmentButton!
            
            return appointmentButton
        }
    }
    
    var contactsButton : UIButton
    {
        get
        {
            if (self._contactsButton == nil)
            {
                self._contactsButton = UIButton()
                self._contactsButton.setImage(UIImage(contentsOfFile: Bundle.main.path(forResource: "Add", ofType: "png")!),
                                              for: UIControlState.normal)
            }
            
            let contactsButton = self._contactsButton!
            
            return contactsButton
        }
    }
    
    var pageView : UIPageView
    {
        get
        {
            if (self._pageView == nil)
            {
                self._pageView = UIPageView(mode: UIPageViewMode.autoScrolling)
                self._pageView.delegate = self
                self._pageView.dataSource = self
                self._pageView.isScrollEnabled = true
                self._pageView.backgroundColor = UIColor.white
            }
            
            let pageView = self._pageView!
            
            return pageView
        }
    }

    var dropOverviewController : DropOverviewController
    {
        get
        {
            if (self._dropOverviewController == nil)
            {
                self._dropOverviewController = DropOverviewController()
                self._dropOverviewController.view.addSubview(self.dropButton)
            }

            let dropOverviewController = self._dropOverviewController!

            return dropOverviewController
        }
    }
    
    var appointmentTimeOverviewController : AppointmentTimeOverviewController
    {
        get
        {
            if (self._appointmentTimeOverviewController == nil)
            {
                self._appointmentTimeOverviewController = AppointmentTimeOverviewController()
                self._appointmentTimeOverviewController.view.addSubview(self.appointmentButton)
            }
            
            let appointmentTimeOverviewController = self._appointmentTimeOverviewController!
            
            return appointmentTimeOverviewController
        }
    }
    
    var navigationOverviewController : NavigationOverviewController
    {
        get
        {
            if (self._navigationOverviewController == nil)
            {
                self._navigationOverviewController = NavigationOverviewController()
            }
            
            let navigationOverviewController = self._navigationOverviewController!
            
            return navigationOverviewController
        }
    }

    var faqOverviewController : FaqOverviewController
    {
        get
        {
            if (self._faqOverviewController == nil)
            {
                self._faqOverviewController = FaqOverviewController()
            }
            
            let faqOverviewController = self._faqOverviewController!
            
            return faqOverviewController
        }
    }
    
    var contactsOverviewController : ContactsOverviewController
    {
        get
        {
            if (self._contactsOverviewController == nil)
            {
                self._contactsOverviewController = ContactsOverviewController()
                self.contactsOverviewController.view.addSubview(self.contactsButton)
            }
            
            let contactsOverviewController = self._contactsOverviewController!
            
            return contactsOverviewController
        }
    }

    var appointmentStore : AppointmentStore
    {
        get
        {
            if (self._appointmentStore == nil)
            {
                self._appointmentStore = AppointmentStore()
            }
            
            let appointmentStore = self._appointmentStore!
            
            return appointmentStore
        }
    }
    
    var faqStore : FaqStore
    {
        get
        {
            if (self._faqStore == nil)
            {
                self._faqStore = FaqStore()
            }
            
            let faqStore = self._faqStore!
            
            return faqStore
        }
    }
    
    var contactStore : ContactStore
    {
        get
        {
            if (self._contactStore == nil)
            {
                self._contactStore = ContactStore()
            }
            
            let contactStore = self._contactStore!
            
            return contactStore
        }
    }
    
    var dropOverviewControllerSize : CGSize
    {
        get
        {
            var dropOverviewControllerSize = CGSize.zero
            dropOverviewControllerSize.width = self.pageView.frame.size.width
            dropOverviewControllerSize.height = self.pageView.frame.height

            return dropOverviewControllerSize
        }
    }
    
    var appointmentTimeOverviewControllerSize : CGSize
    {
        get
        {
            var appointmentTimeOverviewControllerSize = CGSize.zero
            appointmentTimeOverviewControllerSize.width = self.pageView.frame.size.width
            appointmentTimeOverviewControllerSize.height = self.pageView.frame.size.height
            
            return appointmentTimeOverviewControllerSize
        }
    }
    
    var navigationOverviewControllerSize : CGSize
    {
        get
        {
            var navigationOverviewControllerSize = CGSize.zero
            navigationOverviewControllerSize.width = self.view.frame.size.width
            navigationOverviewControllerSize.height = self.canvas.draw(tiles: 4)
            
            return navigationOverviewControllerSize
        }
    }
    
    var faqOverviewControllerSize : CGSize
    {
        get
        {
            var faqOverviewControllerSize = CGSize.zero
            faqOverviewControllerSize.width = self.pageView.frame.size.width
            faqOverviewControllerSize.height = self.pageView.frame.size.height

            return faqOverviewControllerSize
        }
    }
    
    var contactsOverviewControllerSize : CGSize
    {
        get
        {
            var contactsOverviewControllerSize = CGSize.zero
            contactsOverviewControllerSize.width = self.pageView.frame.size.width
            contactsOverviewControllerSize.height = self.pageView.frame.size.height
            
            return contactsOverviewControllerSize
        }
    }
    
    var menuOverviewSize : CGSize
    {
        get
        {
            var menuOverviewSize = CGSize.zero
            menuOverviewSize.width = self.view.frame.size.width
            menuOverviewSize.height = self.canvas.draw(tiles: 9)
            
            return menuOverviewSize
        }
    }

    override func viewDidLoad()
    {
        self.view.backgroundColor = UIColor.white
        self.view.addSubview(self.pageView)
        self.view.addSubview(self.navigationOverviewController.view)
        self.view.addSubview(self.overLayView)
        self.view.addSubview(self.menuOverviewController.view)
        
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge])
        {
            (granted, error) in
        }
        
        self.dropOverviewController.dropStore.load(count: 20, info: nil, isNetworkEnabled: false)
    }
    
    override func render(size: CGSize)
    {
        super.render(size: size)
        
        self.overLayView.frame.size = self.view.frame.size
        
        self.dropButton.frame.size.width = self.canvas.draw(tiles: 3)
        self.dropButton.frame.size.height = self.dropButton.frame.size.width
        
        self.appointmentButton.frame.size.width = self.canvas.draw(tiles: 3)
        self.appointmentButton.frame.size.height = self.appointmentButton.frame.size.width
        
        self.contactsButton.frame.size.width = self.canvas.draw(tiles: 3)
        self.contactsButton.frame.size.height = self.contactsButton.frame.size.width
        
        self.navigationOverviewController.render(size: self.navigationOverviewControllerSize)
        self.navigationOverviewController.view.frame.origin.y = self.canvas.gridSize.height - self.navigationOverviewController.view.frame.size.height
        
        self.pageView.frame.size.width = self.view.frame.width
        self.pageView.frame.size.height = self.view.frame.height - self.navigationOverviewController.view.frame.height
        self.pageView.scrollThreshold = self.pageView.frame.width / 2
        
        self.dropOverviewController.render(size: self.dropOverviewControllerSize)
        self.appointmentTimeOverviewController.render(size: self.appointmentTimeOverviewControllerSize)
        self.faqOverviewController.render(size: self.faqOverviewControllerSize)
        self.contactsOverviewController.render(size: self.contactsOverviewControllerSize)
        self.menuOverviewController.render(size: self.menuOverviewSize)
        
        self.dropButton.frame.origin.x = self.dropOverviewController.view.frame.size.width - self.canvas.draw(tiles: 4.5)
        self.dropButton.frame.origin.y = self.dropOverviewController.view.frame.size.height - self.navigationOverviewController.view.frame.size.height - self.dropButton.frame.size.height
        
        self.appointmentButton.frame.origin.x = self.appointmentTimeOverviewController.view.frame.size.width - self.canvas.draw(tiles: 4.5)
        self.appointmentButton.frame.origin.y = self.appointmentTimeOverviewController.view.frame.size.height - self.navigationOverviewController.view.frame.size.height - self.appointmentButton.frame.size.height
        
        self.contactsButton.frame.origin.x = self.contactsOverviewController.view.frame.size.width - self.canvas.draw(tiles: 4.5)
        self.contactsButton.frame.origin.y = self.contactsOverviewController.view.frame.size.height - self.navigationOverviewController.view.frame.size.height - self.contactsButton.frame.size.height
        
        self.menuOverviewController.view.frame.origin.y = UIScreen.main.bounds.height
        
        self.overLayView.frame.origin.y = UIScreen.main.bounds.height
    }
    
    override func bind(viewModel: AppDetailViewModel)
    {
        super.bind(viewModel: viewModel)
        
        UNUserNotificationCenter.current().delegate = self

        self.viewModel.delegate = self
        
        self.menuOverviewController.bind(viewModel: self.viewModel.menuOverviewViewModel)
        self.dropOverviewController.bind(viewModel: viewModel.dropOverviewViewModel)
        self.appointmentTimeOverviewController.bind(viewModel: self.viewModel.appointmentTimeOverviewViewModel)
        self.navigationOverviewController.bind(viewModel: viewModel.navigationOverviewViewModel)
        self.faqOverviewController.bind(viewModel: viewModel.faqOverviewViewModel)
        

        self.appointmentStore.addObserver(self,
                                          forKeyPath: "models",
                                          options: NSKeyValueObservingOptions([NSKeyValueObservingOptions.new,
                                                                               NSKeyValueObservingOptions.initial]),
                                          context: nil)        
        self.faqStore.addObserver(self,
                                  forKeyPath: "models",
                                  options: NSKeyValueObservingOptions([NSKeyValueObservingOptions.new,
                                                                       NSKeyValueObservingOptions.initial]),
                                  context: nil)
        self.contactStore.addObserver(self,
                                      forKeyPath: "models",
                                      options: NSKeyValueObservingOptions([NSKeyValueObservingOptions.new,
                                                                           NSKeyValueObservingOptions.initial]),
                                      context: nil)
        self.navigationOverviewController.viewModel.addObserver(self,
                                                                forKeyPath: "event",
                                                                options: NSKeyValueObservingOptions([NSKeyValueObservingOptions.new,
                                                                                                       NSKeyValueObservingOptions.initial]),
                                                                context: nil)
        self.appointmentTimeOverviewController.viewModel.addObserver(self,
                                                                     forKeyPath: "event",
                                                                     options: NSKeyValueObservingOptions([NSKeyValueObservingOptions.new,
                                                                                                         NSKeyValueObservingOptions.initial]),
                                                                     context: nil)
        self.dropOverviewController.viewModel.addObserver(self,
                                                          forKeyPath: "event",
                                                          options: NSKeyValueObservingOptions([NSKeyValueObservingOptions.new,
                                                                                               NSKeyValueObservingOptions.initial]),
                                                          context: nil)
        self.menuOverviewController.viewModel.addObserver(self,
                                                          forKeyPath: "event",
                                                          options: NSKeyValueObservingOptions([NSKeyValueObservingOptions.new,
                                                                                               NSKeyValueObservingOptions.initial]),
                                                          context: nil)
        
        self.dropButton.addTarget(self.viewModel,
                                  action: #selector(self.viewModel.addDropForm),
                                  for: UIControlEvents.touchDown)
        self.appointmentButton.addTarget(self.viewModel,
                                         action: #selector(self.viewModel.addAppointmentForm),
                                         for: UIControlEvents.touchDown)
        self.contactsButton.addTarget(self.viewModel,
                                      action: #selector(self.viewModel.addContactsForm),
                                      for: UIControlEvents.touchDown)
    }
    
    override func unbind()
    {
        UNUserNotificationCenter.current().delegate = nil
        self.viewModel.delegate = nil
        
        self.dropOverviewController.unbind()
        self.appointmentTimeOverviewController.unbind()
        self.navigationOverviewController.unbind()
        self.faqOverviewController.unbind()
        self.menuOverviewController.unbind()

        self.navigationOverviewController.viewModel.removeObserver(self, forKeyPath: "event")
        self.dropOverviewController.viewModel.removeObserver(self, forKeyPath: "event")
        self.menuOverviewController.viewModel.removeObserver(self, forKeyPath: "event")
        
        self.dropButton.removeTarget(self.viewModel,
                                     action: #selector(self.viewModel.addDropForm),
                                     for: UIControlEvents.touchDown)
        
        self.appointmentButton.removeTarget(self.viewModel,
                                            action: #selector(self.viewModel.addAppointmentForm),
                                            for: UIControlEvents.touchDown)
        
        super.unbind()
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void)
    {
        completionHandler([.alert, .badge, .sound])
    }

    func viewModel(_ viewModel: DynamicViewModel, transition: String, from oldState: String, to newState: String)
    {
        if (transition == "AddDropForm")
        {
            self.enterDropForm()
        }
        else if (transition == "AddAppointmentForm")
        {
            self.enterAppointmentForm()
        }
        else if (transition == "AddContactsForm")
        {
            self.enterContactsForm()
        }
        else if (newState == "Menu")
        {
            self.overLayView.frame.origin.y = 0

            UIView.animate(withDuration: 0.25)
            {
                self.menuOverviewController.view.frame.origin.y = (UIScreen.main.bounds.height - self.menuOverviewController.view.frame.size.height) - self.view.frame.origin.y - self.view.superview!.frame.origin.y
            }
        }
    }
    
    override func shouldInsertKeyPath(_ keyPath: String?, ofObject object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?)
    {
        if (keyPath == "models")
        {
            let indexSet = change![NSKeyValueChangeKey.indexesKey] as! IndexSet
            
            if (self.appointmentStore === object as! NSObject)
            {
                for index in indexSet
                {
                    let appointmentModel = self.appointmentStore.retrieve(at: index)
                    let appointmentTimeViewModel = AppointmentTimeViewModel(title: appointmentModel.title,
                                                                            date: appointmentModel.date,
                                                                            time: appointmentModel.time)
                    self.appointmentTimeOverviewController.viewModel.appointmentTimeViewModels.insert(appointmentTimeViewModel, at: index)
                }
                self.appointmentTimeOverviewController.listView.reloadData()
            }
            else if (self.faqStore === object as! NSObject)
            {
                for index in indexSet
                {
                    let faqModel = self.faqStore.retrieve(at: index)
                    let faqViewModel = FaqViewModel(heading: faqModel.heading,
                                                             info: faqModel.info)
                    self.faqOverviewController.viewModel.faqViewModels.append(faqViewModel)
                }
                
                self.faqOverviewController.listView.reloadData()
            }
            else if (self.contactStore === object as! NSObject)
            {
                for index in indexSet
                {
                    var contacts = [OCKContact]()
                    let contactModel = self.contactStore.retrieve(at: index)
                    
                    for contactModel in self.contactStore
                    {
                        contacts.append(contactModel.contact)
                    }
                    
                    self.contactsOverviewController.connectViewController.contacts = contacts
                }
            }
        }
    }
    
    override func shouldSetKeyPath(_ keyPath: String?, ofObject object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?)
    {
        if (keyPath == "models")
        {
            if (self.appointmentStore === object as! NSObject)
            {
                self.appointmentTimeOverviewController.viewModel.appointmentTimeViewModels = [AppointmentTimeViewModel]()
                
                for appointmentModel in self.appointmentStore
                {
                    let appointmentTimeViewModel = AppointmentTimeViewModel(title: appointmentModel.title,
                                                                            date: appointmentModel.date,
                                                                            time: appointmentModel.time)
                    self.appointmentTimeOverviewController.viewModel.appointmentTimeViewModels.append(appointmentTimeViewModel)
                }
                
                self.appointmentTimeOverviewController.listView.reloadData()
            }
            else if (self.faqStore === object as! NSObject)
            {
                self.faqOverviewController.viewModel.faqViewModels = [FaqViewModel]()
                
                for faqModel in self.faqStore
                {
                    let faqViewModel = FaqViewModel(heading: faqModel.heading,
                                                    info: faqModel.info)
                    self.faqOverviewController.viewModel.faqViewModels.append(faqViewModel)
                }
                
                self.faqOverviewController.listView.reloadData()
            }
        }
        else if (keyPath == "event")
        {
            let newValue = change![NSKeyValueChangeKey.newKey] as! String
            
            if (self.viewModel.dropOverviewViewModel === object as! NSObject)
            {
                if (newValue == "DidEnterMenu")
                {
                    self.viewModel.editDrops()
                }
            }
            
            else if (self.viewModel.menuOverviewViewModel === object as! NSObject)
            {
                if (newValue == "DidToggle")
                {
                    UIView.animate(withDuration: 0.25, animations:
                    {
                        self.menuOverviewController.view.frame.origin.y = UIScreen.main.bounds.height
                    })
                    { (isCompleted) in

                        self.overLayView.frame.origin.y = UIScreen.main.bounds.height
                        
                        for menuViewModel in self.menuOverviewController.viewModel.menuViewModels
                        {
                            menuViewModel.deselect()
                        }
                    }
                }
            }

            else if (self.viewModel.navigationOverviewViewModel === object as! NSObject)
            {
                if (newValue == "EnterDrop")
                {
                    self.pageView.scrollToItem(at: IndexPath(item: 0, section: 0), at: UIPageViewScrollPosition.left, animated: true)
                }
                else if (newValue == "EnterAppointment")
                {
                    self.pageView.scrollToItem(at: IndexPath(item: 1, section: 0), at: UIPageViewScrollPosition.right, animated: true)
                }
                else if (newValue == "EnterFaq")
                {
                    self.pageView.scrollToItem(at: IndexPath(item: 2, section: 0), at: UIPageViewScrollPosition.right, animated: true)
                }
                else if (newValue == "EnterContacts")
                {
                    self.pageView.scrollToItem(at: IndexPath(item: 3, section: 0), at: UIPageViewScrollPosition.right, animated: true)
                }
            }
            else if (self.dropFormDetailController != nil && self.dropFormDetailController!.viewModel === object as! NSObject)
            {
                if (newValue == "DidCreateDrop" || newValue == "DidExitDrop")
                {
                    self.exitDropForm()
                }
            }
            else if (self.appointmentFormDetailController != nil && self.appointmentFormDetailController!.viewModel === object as! NSObject)
            {
                if (newValue == "DidCreateAppointment" || newValue == "DidExitAppointment")
                {
                    self.exitAppointmentForm()
                }
            }
            else if (self.contactsFormDetailController != nil && self.contactsFormDetailController!.viewModel === object as! NSObject)
            {
                if (newValue == "DidCreateContacts" || newValue == "DidExitContacts")
                {
                    self.exitContactsForm()
                }
            }
        }
    }
    
    func enterDropForm()
    {
        self.dropFormDetailController = DropFormDetailController()
        self.dropFormDetailController!.dropStore = self.dropOverviewController.dropStore
        let dropFormDetailViewModel = DropFormDetailViewModel()
        self.dropFormDetailController!.bind(viewModel: dropFormDetailViewModel)
        self.dropFormDetailController!.render(size: self.view.frame.size)
        self.dropFormDetailController!.viewModel.addObserver(self,
                                                             forKeyPath: "event",
                                                             options: NSKeyValueObservingOptions([NSKeyValueObservingOptions.new,
                                                                                                  NSKeyValueObservingOptions.initial]),
                                                             context: nil)
        self.dropFormDetailController!.dropFormInputController.colorStore.load(count: 7, info: nil, isNetworkEnabled: false)
        self.view.addSubview(self.dropFormDetailController!.view)
    }
    
    func exitDropForm()
    {
        self.dropFormDetailController!.viewModel.removeObserver(self, forKeyPath: "event")
        self.dropFormDetailController!.unbind()
        self.dropFormDetailController!.view.removeFromSuperview()
        self.dropFormDetailController = nil
    }

    func enterAppointmentForm()
    {
        self.appointmentFormDetailController = AppointmentFormDetailController()
        self.appointmentFormDetailController.appointmentStore = self.appointmentStore
        let appointmentFormDetailViewModel = AppointmentFormDetailViewModel()
        self.appointmentFormDetailController!.bind(viewModel: appointmentFormDetailViewModel)
        self.appointmentFormDetailController!.render(size: self.view.frame.size)
        self.appointmentFormDetailController!.viewModel.addObserver(self,
                                                                    forKeyPath: "event",
                                                                    options: NSKeyValueObservingOptions([NSKeyValueObservingOptions.new,
                                                                                                         NSKeyValueObservingOptions.initial]),
                                                                    context: nil)
        self.view.addSubview(self.appointmentFormDetailController!.view)
    }
    
    func exitAppointmentForm()
    {
        self.appointmentFormDetailController!.viewModel.removeObserver(self, forKeyPath: "event")
        self.appointmentFormDetailController!.unbind()
        self.appointmentFormDetailController.view.removeFromSuperview()
        self.appointmentFormDetailController = nil
    }
    
    func enterContactsForm()
    {
        self.contactsFormDetailController = ContactsFormDetailController()
        self.contactsFormDetailController.contactStore = self.contactStore
        let contactsFormDetailViewModel = ContactsFormDetailViewModel()
        self.contactsFormDetailController!.bind(viewModel: contactsFormDetailViewModel)
        self.contactsFormDetailController!.render(size: self.view.frame.size)
        self.contactsFormDetailController!.viewModel.addObserver(self,
                                                                 forKeyPath: "event",
                                                                 options: NSKeyValueObservingOptions([NSKeyValueObservingOptions.new,
                                                                                                      NSKeyValueObservingOptions.initial]),
                                                                 context: nil)
        self.view.addSubview(self.contactsFormDetailController.view)
    }
    
    func exitContactsForm()
    {
        self.contactsFormDetailController!.viewModel.removeObserver(self, forKeyPath: "event")
        self.contactsFormDetailController!.unbind()
        self.contactsFormDetailController.view.removeFromSuperview()
        self.contactsFormDetailController = nil
    }
    
    func pageView(_ pageView: UIPageView, numberOfItemsInSection section: Int) -> Int
    {
        return self.viewModel.navigationOverviewViewModel.navigationViewModels.count
    }
    
    func pageView(_ pageView: UIPageView, sizeForItemAt indexPath: IndexPath) -> CGSize
    {
        var itemSize = CGSize(width: UIListViewAutomaticDimension, height: UIListViewAutomaticDimension)

        if (indexPath.item == 0)
        {
            itemSize.width = self.dropOverviewController.view.frame.width
        }
        else if (indexPath.item == 1)
        {
            itemSize.width = self.appointmentTimeOverviewController.view.frame.width
        }
        else if (indexPath.item == 2)
        {
            itemSize.width = self.faqOverviewController.view.frame.width
        }
        else if (indexPath.item == 3)
        {
            itemSize.width = self.contactsOverviewController.view.frame.width
        }
        
        return itemSize
    }
    
    func pageView(_ pageView: UIPageView, cellForItemAt indexPath: IndexPath) -> UIPageViewCell
    {
        let cell = UIPageViewCell()

        if (indexPath.item == 0)
        {
            cell.addSubview(self.dropOverviewController.view)
        }
        else if (indexPath.item == 1)
        {
            cell.addSubview(self.appointmentTimeOverviewController.view)
        }
        else if (indexPath.item == 2)
        {
            cell.addSubview(self.faqOverviewController.view)
        }
        else if (indexPath.item == 3)
        {
            cell.addSubview(self.contactsOverviewController.view)
        }

        return cell
    }
    
    func pageView(_ pageView: UIPageView, didEndDisplaying cell: UIPageViewCell, forItemAt indexPath: IndexPath)
    {
        
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle
    {
        get
        {
            return UIStatusBarStyle.lightContent
        }
    }
}
