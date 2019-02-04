//
//  MainDashboardController.swift
//  Cataract
//
//  Created by Roseanne Choi on 9/9/18.
//  Copyright © 2018 Roseanne Choi. All rights reserved.
//

import UIKit
import UserNotifications
import CareKit

class MainDashboardController : DynamicController, UNUserNotificationCenterDelegate
{
    private var _tabBarController : UITabBarController!
    private var _dropCardCollectionController : DropCardController!
    private var _appointmentCardCollectionController : AppointmentCardController.CollectionController!
    private var _contactCardController : ContactCardController!
    private var _faqCardCollectionController : FAQCardController.TableController!
    var dropFormController : DropFormController!
    var appointmentFormController : AppointmentFormController!
    var contactFormController : ContactFormController!
    private var _faqStore : DynamicStore.Collection<FAQModel>!
    private var _dropAddButtonController : UserController.AddButtonController!
    private var _appointmentAddButtonController : UserController.AddButtonController!
    private var _contactsAddButtonController : UserController.AddButtonController!
    var appointmentFormCardViewModels = [AppointmentCardViewModel]()
    var dropModels = [DropModel]()
    var contacts = [OCKContact]()
    var contactModels = [ContactModel]()
    private var _dropsUrl : URL!
    private var _appointmentsUrl : URL!
    private var _contactsUrl : URL!
    @objc dynamic var viewModel : MainDashboardViewModel!
    
    var dropsUrl : URL
    {
        get
        {
            if (self._dropsUrl == nil)
            {
                let fileManager : String = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0].appendingPathComponent("Drops").path
                
                self._dropsUrl = URL(fileURLWithPath: fileManager)
            }
            
            let dropsUrl = self._dropsUrl!
            
            return dropsUrl
        }
    }

    var appointmentsUrl : URL
    {
        get
        {
            if (self._appointmentsUrl == nil)
            {
                let fileManager : String = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0].appendingPathComponent("Appointments").path

                self._appointmentsUrl = URL(fileURLWithPath: fileManager)
            }
            
            let appointmentsUrl = self._appointmentsUrl!
            
            return appointmentsUrl
        }
    }
    
    var contactsUrl : URL
    {
        get
        {
            if (self._contactsUrl == nil)
            {
                let fileManager : String = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0].appendingPathComponent("Contacts").path
                
                self._contactsUrl = URL(fileURLWithPath: fileManager)
            }
            
            let contactsUrl = self._contactsUrl!
            
            return contactsUrl
        }
    }
    
    override var tabBarController : UITabBarController
    {
        get
        {
            if (self._tabBarController == nil)
            {
                self._tabBarController = UITabBarController()
                self._tabBarController.tabBar.tintColor = UIColor(red: 51/255, green: 127/255, blue: 159/255, alpha: 1)
                self._tabBarController.viewControllers = [self.dropCardCollectionController, self.appointmentCardCollectionController, self.faqCardCollectionController]
            }
            
            let tabBarController = self._tabBarController!
            
            return tabBarController
        }
    }
 
    var dropCardCollectionController : DropCardController
    {
        get
        {
            if (self._dropCardCollectionController == nil)
            {
                self._dropCardCollectionController = DropCardController()
                self._dropCardCollectionController.tabBarItem = UITabBarItem(title: "Drops",
                                                                             image: UIImage(contentsOfFile: Bundle.main.path(forResource: "Dose", ofType: "png")!),
                                                                             tag: 0)
            }
            
            let dropCardCollectionController = self._dropCardCollectionController!
            
            return dropCardCollectionController
        }
    }
    
    var appointmentCardCollectionController : AppointmentCardController.CollectionController
    {
        get
        {
            if (self._appointmentCardCollectionController == nil)
            {
               self._appointmentCardCollectionController = AppointmentCardController.CollectionController()
               self._appointmentCardCollectionController.tabBarItem = UITabBarItem(title: "Appointments",
                                                                                   image: UIImage(contentsOfFile: Bundle.main.path(forResource: "Calendar", ofType: "png")!),
                                                                                   tag: 0)
               self._appointmentCardCollectionController.tableViewController.tableView.contentInset = UIEdgeInsets(top: 0,
                                                                                               left: 0,
                                                                                               bottom: self.tabBarController.tabBar.frame.height,
                                                                                               right: 0)
            }
            
            let appointmentCardCollectionController = self._appointmentCardCollectionController!
            
            return appointmentCardCollectionController
        }
    }
    
//    var contactCardController : ContactCardController
//    {
//        get
//        {
//            if (self._contactCardController == nil)
//            {
//                self._contactCardController = ContactCardController()
//                self._contactCardController.tabBarItem = UITabBarItem(title: "Contacts",
//                                                                      image: UIImage(contentsOfFile: Bundle.main.path(forResource: "Contact", ofType: "png")!),
//                                                                      tag: 0)
//            }
//
//            let contactCardController = self._contactCardController!
//
//            return contactCardController
//        }
//    }

    var faqCardCollectionController : FAQCardController.TableController
    {
        get
        {
            if (self._faqCardCollectionController == nil)
            {
                self._faqCardCollectionController = FAQCardController.TableController()
                self._faqCardCollectionController.tabBarItem = UITabBarItem(title: "FAQ",
                                                                            image: UIImage(contentsOfFile: Bundle.main.path(forResource: "Information", ofType: "png")!),
                                                                            tag: 0)
                self._faqCardCollectionController.tableViewController.tableView.contentInset = UIEdgeInsets(top: 0,
                                                                                        left: 0,
                                                                                        bottom: self.tabBarController.tabBar.frame.height,
                                                                                        right: 0)
            }
            
            let faqCardCollectionController = self._faqCardCollectionController!
            
            return faqCardCollectionController
        }
    }

    var faqStore : DynamicStore.Collection<FAQModel>
    {
        get
        {
            if (self._faqStore == nil)
            {
                self._faqStore = DynamicStore.Collection<FAQModel>()
            }
            
            let faqStore = self._faqStore!
            
            return faqStore
        }
    }

    @objc var faqStoreRepresentable : DynamicStore
    {
        get
        {
            let faqStoreRepresentable = self.faqStore
            
            return faqStoreRepresentable
        }
    }
    
    var dropAddButtonController : UserController.AddButtonController
    {
        get
        {
            if (self._dropAddButtonController == nil)
            {
                self._dropAddButtonController = UserController.AddButtonController()
            }
            
            let dropAddButtonController = self._dropAddButtonController!
            
            return dropAddButtonController
        }
    }
    
    var appointmentAddButtonController : UserController.AddButtonController
    {
        get
        {
            if (self._appointmentAddButtonController == nil)
            {
                self._appointmentAddButtonController = UserController.AddButtonController()
            }
            
            let appointmentAddButtonController = self._appointmentAddButtonController!
            
            return appointmentAddButtonController
        }
    }
    
    var contactsAddButtonController : UserController.AddButtonController
    {
        get
        {
            if (self._contactsAddButtonController == nil)
            {
                self._contactsAddButtonController = UserController.AddButtonController()
            }
            
            let contactsAddButtonController = self._contactsAddButtonController!
            
            return contactsAddButtonController
        }
    }

    override func viewDidLoad()
    {
        UNUserNotificationCenter.current().requestAuthorization(options: UNAuthorizationOptions([.badge, .alert, .sound]))
        { (completed, error) in
        }
        
        UNUserNotificationCenter.current().delegate = self
        
        self.view.addSubview(self.tabBarController.view)
        self.dropCardCollectionController.view.addSubview(self.dropAddButtonController.view)
        self.appointmentCardCollectionController.view.addSubview(self.appointmentAddButtonController.view)
//        self.contactCardController.view.addSubview(self.contactsAddButtonController.view)
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void)
    {
        completionHandler([.badge, .alert, .sound])
    }
    
    override func bind()
    {
        super.bind()
        
        self.dropCardCollectionController.bind()
        self.appointmentCardCollectionController.bind()
        self.faqCardCollectionController.bind()
        self.dropAddButtonController.bind()
        self.appointmentAddButtonController.bind()
        self.contactsAddButtonController.bind()
        
        self.addObserver(self,
                         forKeyPath: "viewModel.dropAddButtonViewModel.event",
                         options: NSKeyValueObservingOptions([NSKeyValueObservingOptions.new,
                                                              NSKeyValueObservingOptions.initial]),
                         context: nil)
        self.addObserver(self,
                         forKeyPath: "viewModel.appointmentAddButtonViewModel.event",
                         options: NSKeyValueObservingOptions([NSKeyValueObservingOptions.new,
                                                              NSKeyValueObservingOptions.initial]),
                         context: nil)
        self.addObserver(self,
                         forKeyPath: "viewModel.contactAddButtonViewModel.event",
                         options: NSKeyValueObservingOptions([NSKeyValueObservingOptions.new,
                                                              NSKeyValueObservingOptions.initial]),
                         context: nil)
        self.addObserver(self,
                         forKeyPath: "viewModel.appointmentCardCollectionViewModel",
                         options: NSKeyValueObservingOptions([NSKeyValueObservingOptions.new,
                                                              NSKeyValueObservingOptions.initial]),
                         context: nil)
        self.addObserver(self,
                         forKeyPath: "viewModel.appointmentCardCollectionViewModel.event",
                         options: ([NSKeyValueObservingOptions.new,
                                    NSKeyValueObservingOptions.initial]),
                         context: nil)
        self.addObserver(self,
                         forKeyPath: "viewModel.faqCardCollectionViewModel",
                         options: NSKeyValueObservingOptions([NSKeyValueObservingOptions.new,
                                                              NSKeyValueObservingOptions.initial]),
                         context: nil)
        self.addObserver(self,
                         forKeyPath: "faqStoreRepresentable.event",
                         options: NSKeyValueObservingOptions([NSKeyValueObservingOptions.new,
                                                              NSKeyValueObservingOptions.initial]),
                         context: nil)
        self.addObserver(self,
                         forKeyPath: "viewModel.dropCardViewModel.event",
                         options: NSKeyValueObservingOptions([NSKeyValueObservingOptions.new,
                                                              NSKeyValueObservingOptions.initial]),
                         context: nil)
        self.addObserver(self,
                         forKeyPath: "viewModel.dropCardViewModel.dropsMenuOverlayViewModel.event",
                         options: NSKeyValueObservingOptions([NSKeyValueObservingOptions.new,
                                                              NSKeyValueObservingOptions.initial]),
                         context: nil)
    }
    
    override func unbind()
    {
        super.unbind()
        
        self.dropCardCollectionController.unbind()
        self.appointmentCardCollectionController.unbind()
        self.faqCardCollectionController.unbind()
        self.dropAddButtonController.unbind()
        self.appointmentAddButtonController.unbind()
        self.contactsAddButtonController.unbind()
        
        self.removeObserver(self, forKeyPath: "viewModel.dropAddButtonViewModel.event")
        self.removeObserver(self, forKeyPath: "viewModel.appointmentAddButtonViewModel.event")
        self.removeObserver(self, forKeyPath: "viewModel.contactAddButtonViewModel.event")
        self.removeObserver(self, forKeyPath: "viewModel.appointmentCardCollectionViewModel")
        self.removeObserver(self, forKeyPath: "viewModel.appointmentCardCollectionViewModel.event")
        self.removeObserver(self, forKeyPath: "viewModel.faqCardCollectionViewModel")
        self.removeObserver(self, forKeyPath: "faqStoreRepresentable.event")
        self.removeObserver(self, forKeyPath: "viewModel.dropCardViewModel")
        self.removeObserver(self, forKeyPath: "viewModel.dropCardViewModel.dropsMenuOverlayViewModel.event")
    }
    
    func writeDrops()
    {
        let jsonEncoder : JSONEncoder = JSONEncoder()
        let jsonData : Data = try! jsonEncoder.encode(self.dropModels)
        
        do
        {
            try jsonData.write(to: self.dropsUrl)
        }
        catch
        {
            print(error)
        }
    }
    
    func readDrops()
    {
        if FileManager.default.fileExists(atPath: self.dropsUrl.path)
        {
            let data : Data = try! Data(contentsOf: self.dropsUrl)
            let jsonDecoder : [DropModel] = try! JSONDecoder().decode([DropModel].self, from: data)
            
            self.dropModels.append(contentsOf: jsonDecoder)
        }
    }
    
    func writeAppointments()
    {
        let jsonEncoder : JSONEncoder = JSONEncoder()
        let jsonData : Data = try! jsonEncoder.encode(self.appointmentFormCardViewModels)

        do
        {
            try jsonData.write(to: self.appointmentsUrl)
        }
        catch
        {
            print(error)
        }
    }

    func readAppointments()
    {
        if FileManager.default.fileExists(atPath: self.appointmentsUrl.path)
        {
            let data : Data = try! Data(contentsOf: self.appointmentsUrl)
            let jsonDecoder : [AppointmentCardViewModel] = try! JSONDecoder().decode([AppointmentCardViewModel].self, from: data)
            self.appointmentFormCardViewModels.append(contentsOf: jsonDecoder)

            let appointmentCardCollectionViewModel = AppointmentCardViewModel.CollectionViewModel(appointmentCardViewModels: self.appointmentFormCardViewModels)
            appointmentCardCollectionViewModel.itemSize = self.viewModel.appointmentCardCollectionViewModel.itemSize
            self.viewModel.appointmentCardCollectionViewModel = appointmentCardCollectionViewModel
        }
    }
    
    func writeContacts()
    {
        let jsonEncoder = JSONEncoder()
        let jsonData = try! jsonEncoder.encode(self.contactModels)
        
        do
        {
            try jsonData.write(to: self.contactsUrl)
        }
        catch
        {
            print(error)
        }
    }
    
//    func readContacts()
//    {
//        if FileManager.default.fileExists(atPath: self.contactsUrl.path)
//        {
//            let data : Data = try! Data(contentsOf: self.contactsUrl)
//            let jsonDecoder : [ContactModel] = try! JSONDecoder().decode([ContactModel].self, from: data)
//
//            for contactModel in jsonDecoder
//            {
//                self.contacts.append(contactModel.ockContact)
//            }
//
//            self.contactCardController.connectViewController.contacts = self.contacts
//        }
//    }
    
    override func observeKeyValue(for kvoEvent: DynamicKVO.Event)
    {
        if (kvoEvent.keyPath == "viewModel.dropCardViewModel.dropsMenuOverlayViewModel.event")
        {
            if (self.viewModel.dropCardViewModel.dropsMenuOverlayViewModel.state == UserViewModel.DropsMenuOverlayViewModel.State.end || self.viewModel.dropCardViewModel.dropsMenuOverlayViewModel.state == UserViewModel.DropsMenuOverlayViewModel.State.idle)
            {
                if (self.viewModel.dropCardViewModel.dropsMenuOverlayViewModel.state == UserViewModel.DropsMenuOverlayViewModel.State.end)
                {
                    let activity = self.dropCardCollectionController.interventionActivity
                    
                    for dropModel in self.dropModels
                    {
                        var identifiers = [String]()
                        
                        if (dropModel.title == activity!.title)
                        {
                            for timeModel in dropModel.frequencyTimeModels
                            {
                                identifiers.append(timeModel.identifier)
                            }
                        }
                        
                        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: identifiers)
                    }
                }
                
                self.dropCardCollectionController.view.addSubview(self.dropAddButtonController.view)
            }
        }
        
        else if (kvoEvent.keyPath == "viewModel.dropCardViewModel.event")
        {
            if (self.viewModel.dropCardViewModel.state == DropCardViewModel.State.options)
            {
                self.dropAddButtonController.view.removeFromSuperview()
            }
        }
        
        else if (kvoEvent.keyPath == "viewModel.appointmentAddButtonViewModel.event")
        {
            if (self.viewModel.appointmentAddButtonViewModel.state == UserViewModel.AddButtonViewModel.State.computation)
            {
                let footerPanelViewModel = FooterPanelViewModel(id: "")
                let firstPageViewModel = AppointmentFormViewModel.FirstPageViewModel()
                let secondPageViewModel = AppointmentFormViewModel.SecondPageViewModel()
                let appointmentInputViewModel = UserViewModel.AppointmentInputViewModel(id: "")

                let appointmentFormViewModel = AppointmentFormViewModel(footerPanelViewModel: footerPanelViewModel,
                                                                        firstPageViewModel: firstPageViewModel,
                                                                        secondPageViewModel: secondPageViewModel,
                                                                        appointmentInputViewModel: appointmentInputViewModel)
                self.appointmentFormController = AppointmentFormController()
                self.appointmentFormController.bind()
                appointmentFormViewModel.size = self.view.frame.size
                self.appointmentFormController.viewModel = appointmentFormViewModel

                self.appointmentFormController.viewModel.addObserver(self,
                                                                     forKeyPath: "event",
                                                                     options: NSKeyValueObservingOptions([NSKeyValueObservingOptions.new,
                                                                                                          NSKeyValueObservingOptions.initial]),
                                                                     context: nil)
                
                self.view.addSubview(self.appointmentFormController.view)
            }
        }
        else if (kvoEvent.keyPath == "viewModel.appointmentCardCollectionViewModel.event")
        {
            if (self.viewModel.appointmentCardCollectionViewModel.state == AppointmentCardViewModel.CollectionViewModel.State.removed)
            {
                var identifiers = [String]()
                
                for mainAppointmentFormCardViewModel in self.appointmentFormCardViewModels
                {
                    for viewModelAppointmentFormCardViewModel in self.viewModel.appointmentCardCollectionViewModel.appointmentCardViewModels
                    {
                        if (mainAppointmentFormCardViewModel.title != viewModelAppointmentFormCardViewModel.title)
                        {
                            identifiers.append(mainAppointmentFormCardViewModel.id)
                        }
                    }
                }
                
                UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: identifiers)
                
                self.appointmentFormCardViewModels = self.viewModel.appointmentCardCollectionViewModel.appointmentCardViewModels
                
                self.writeAppointments()
            }
        }
        else if (kvoEvent.keyPath == "viewModel.dropAddButtonViewModel.event")
        {
            if (self.viewModel.dropAddButtonViewModel.state == UserViewModel.AddButtonViewModel.State.computation)
            {
                let firstPageViewModel = DropFormViewModel.FirstPageViewModel()
                let secondPageViewModel = DropFormViewModel.SecondPageViewModel()
                let thirdPageViewModel = DropFormViewModel.ThirdPageViewModel()
                let footerPanelViewModel = FooterPanelViewModel(id: "")
                let overLayCardViewModel = UserViewModel.OverLayCardViewModel(id: "")

                let dropFormViewModel = DropFormViewModel(firstPageViewModel: firstPageViewModel,
                                                          secondPageViewModel: secondPageViewModel,
                                                          thirdPageViewModel: thirdPageViewModel,
                                                          footerPanelViewModel: footerPanelViewModel,
                                                          overLayCardViewModel: overLayCardViewModel)

                self.dropFormController = DropFormController()
                self.dropFormController.carePlanStore = self.dropCardCollectionController.carePlanStore
                self.dropFormController.bind()
                dropFormViewModel.size = self.view.frame.size
                self.dropFormController.viewModel = dropFormViewModel
                self.dropFormController.viewModel.addObserver(self,
                                                              forKeyPath: "event",
                                                              options: NSKeyValueObservingOptions([NSKeyValueObservingOptions.new,
                                                                                                   NSKeyValueObservingOptions.initial]),
                                                              context: nil)

                self.view.addSubview(self.dropFormController.view)
            }
        }
        else if (kvoEvent.keyPath == "viewModel.contactAddButtonViewModel.event")
        {
            if (self.viewModel.contactAddButtonViewModel.state == UserViewModel.AddButtonViewModel.State.computation)
            {
                let footerPanelViewModel = FooterPanelViewModel(id: "")
                let contactFormViewModel = ContactFormViewModel(footerPanelViewModel: footerPanelViewModel)
                
                self.contactFormController = ContactFormController()
                self.contactFormController.bind()
                contactFormViewModel.size = self.view.frame.size
                self.contactFormController.viewModel = contactFormViewModel
                self.contactFormController.viewModel.addObserver(self,
                                                                 forKeyPath: "event",
                                                                 options: NSKeyValueObservingOptions([NSKeyValueObservingOptions.new,
                                                                                                      NSKeyValueObservingOptions.initial]),
                                                                 context: nil)
                
                self.view.addSubview(self.contactFormController.view)
            }
        }
        else if (kvoEvent.keyPath == "event")
        {
            if (self.dropFormController != nil && self.dropFormController.viewModel != nil)
            {
                if (self.dropFormController.viewModel.state == DropFormViewModel.State.completion || self.dropFormController.viewModel.state == DropFormViewModel.State.cancellation)
                {
                    if (self.dropFormController.viewModel.state == DropFormViewModel.State.completion)
                    {
                        let dropModels = self.dropFormController.dropModels

                        self.dropModels.append(contentsOf: dropModels)
                        
                        self.writeDrops()
                    }
                    
                    self.dropFormController.viewModel.removeObserver(self, forKeyPath: "event")
                    self.dropFormController.unbind()
                    self.dropFormController.view.removeFromSuperview()
                    self.dropFormController.viewModel = nil
                }
            }
            else if (self.appointmentFormController != nil && self.appointmentFormController.viewModel != nil)
            {                
                if (self.appointmentFormController.viewModel.state == AppointmentFormViewModel.State.completion || self.appointmentFormController.viewModel.state == AppointmentFormViewModel.State.cancellation)
                {
                    if (self.appointmentFormController.viewModel.state == AppointmentFormViewModel.State.completion)
                    {
                        self.appointmentFormCardViewModels.append(contentsOf: self.appointmentFormController.appointmentCardViewModels)
                        
                        self.writeAppointments()
                        
                        let appointmentCardCollectionViewModel = AppointmentCardViewModel.CollectionViewModel(appointmentCardViewModels: self.appointmentFormCardViewModels)
                        appointmentCardCollectionViewModel.itemSize = self.viewModel.appointmentCardCollectionViewModel.itemSize
                        self.viewModel.appointmentCardCollectionViewModel = appointmentCardCollectionViewModel
                    }
                    
                    self.appointmentFormController.viewModel.removeObserver(self, forKeyPath: "event")
                    self.appointmentFormController.unbind()
                    self.appointmentFormController.view.removeFromSuperview()
                    self.appointmentFormController.viewModel = nil
                }
            }
//            else if (self.contactFormController != nil && self.contactFormController.viewModel != nil)
//            {
//                if (self.contactFormController.viewModel.state == ContactFormViewModel.State.completion || self.contactFormController.viewModel.state == ContactFormViewModel.State.cancellation)
//                {
//                    if (self.contactFormController.viewModel.state == ContactFormViewModel.State.completion)
//                    {
//                        for contactModel in self.contactFormController.contactModels
//                        {
//                            self.contacts.append(contactModel.ockContact)
//                        }
//
//                        self.contactCardController.connectViewController.contacts = self.contacts
//
//                        self.contactModels.append(contentsOf: self.contactFormController.contactModels)
//
//                        self.writeContacts()
//                    }
//
//                    self.contactFormController.viewModel.removeObserver(self, forKeyPath: "event")
//                    self.contactFormController.unbind()
//                    self.contactFormController.view.removeFromSuperview()
//                    self.contactFormController.viewModel = nil
//                }
//            }
        }
        else if (kvoEvent.keyPath == "viewModel.appointmentCardCollectionViewModel")
        {
            self.appointmentCardCollectionController.viewModel = self.viewModel.appointmentCardCollectionViewModel
        }
    }
    
    override func render()
    {
        super.render()
        
        self.view.frame.size = self.viewModel.size
        
        self.viewModel.dropAddButtonViewModel.size.width = 80
        self.viewModel.dropAddButtonViewModel.size.height = self.viewModel.dropAddButtonViewModel.size.width
        self.dropAddButtonController.view.frame.origin.x = self.view.frame.size.width - 110
        self.dropAddButtonController.view.frame.origin.y = self.view.frame.size.height - 230
        
        self.viewModel.appointmentAddButtonViewModel.size.width = 80
        self.viewModel.appointmentAddButtonViewModel.size.height = self.viewModel.appointmentAddButtonViewModel.size.width
        self.appointmentAddButtonController.view.frame.origin.x = self.view.frame.size.width - 110
        self.appointmentAddButtonController.view.frame.origin.y = self.view.frame.size.height - 230
        
        self.viewModel.contactAddButtonViewModel.size.width = 80
        self.viewModel.contactAddButtonViewModel.size.height = self.viewModel.contactAddButtonViewModel.size.width
        self.contactsAddButtonController.view.frame.origin.x = self.view.frame.size.width - 110
        self.contactsAddButtonController.view.frame.origin.y = self.view.frame.size.height - 230
        
        self.viewModel.dropCardViewModel.size = self.view.frame.size
                    
        self.viewModel.appointmentCardCollectionViewModel.itemSize = CGSize(width: self.view.frame.width,
                                                                            height: 200)

        self.viewModel.faqCardCollectionViewModel.itemSize = CGSize(width: self.view.frame.width,
                                                                    height: 300)
        
        self.dropCardCollectionController.viewModel = self.viewModel.dropCardViewModel
        self.dropAddButtonController.viewModel = self.viewModel.dropAddButtonViewModel
        self.appointmentAddButtonController.viewModel = self.viewModel.appointmentAddButtonViewModel
        self.contactsAddButtonController.viewModel = self.viewModel.contactAddButtonViewModel
    }
    
    override var controllerEventKeyPaths: Set<String>
    {
        get
        {
            var controllerEventKeyPaths = Set<String>([DynamicKVO.keyPath(\MainDashboardController.viewModel.faqCardCollectionViewModel)])
            controllerEventKeyPaths = controllerEventKeyPaths.union(super.controllerEventKeyPaths)

            return controllerEventKeyPaths
        }
    }
    
    override var storeEventKeyPaths: Set<String>
    {
        get
        {
            let storeEventKeyPaths = super.storeEventKeyPaths.union([DynamicKVO.keyPath(\MainDashboardController.faqStoreRepresentable.event)])
            return storeEventKeyPaths
        }
    }
    
    override func observeController(for controllerEvent: DynamicController.Event, kvoEvent: DynamicKVO.Event)
    {
        if (kvoEvent.keyPath == DynamicKVO.keyPath(\MainDashboardController.viewModel.faqCardCollectionViewModel))
        {
            self.faqCardCollectionController.viewModel = self.viewModel.faqCardCollectionViewModel
        }
    }
    
    override func observeStore(for storeEvent: DynamicStore.Event, kvoEvent: DynamicKVO.Event)
    {
        if (kvoEvent.keyPath == DynamicKVO.keyPath(\MainDashboardController.faqStoreRepresentable.event))
        {
            if (storeEvent.operation == DynamicStore.Event.Operation.load)
            {
                let faqModels = storeEvent.models as! [FAQModel]
                var faqCardViewModels = [FAQCardViewModel]()

                for faqModel in faqModels
                {
                    let faqCardViewModel = FAQCardViewModel(id: faqModel.id,
                                                            question: faqModel.question,
                                                            answer: faqModel.answer)
                    faqCardViewModels.append(faqCardViewModel)
                }

                let faqCardCollectionViewModel = FAQCardViewModel.CollectionViewModel(faqCardViewModels: faqCardViewModels)

                if (self.viewModel != nil)
                {
                    faqCardCollectionViewModel.itemSize = self.viewModel.faqCardCollectionViewModel.itemSize
                }

                self.viewModel.faqCardCollectionViewModel = faqCardCollectionViewModel
            }
        }
    }
    
    func loadAllStores()
    {
        self.faqStore.load(FAQOperation.GetFAQModelsQuery())
    }
}
