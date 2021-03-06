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
import SwiftMoment

class MainDashboardController : DynamicController, UNUserNotificationCenterDelegate
{
    private var _noAppointmentsLabel : LabelController!
    private var _onboardingContentViewController : OnboardingContentViewController.CollectionViewController!
    private var _tabBarController : UITabBarController!
    private var _dropCardCollectionController : DropCardController!
    private var _appointmentCardCollectionController : AppointmentCardController.CollectionController!
    private var _contactCardController : ContactCardController!
    private var _faqCardCollectionController : FAQCardController.TableController!
    @objc var dropFormController : DropFormController!
    @objc var appointmentFormController : AppointmentFormController!
    var contactFormController : ContactFormController!
    private var _faqStore : DynamicStore.Collection<FAQModel>!
    private var _dropAddButtonController : UserController.AddButtonController!
    private var _appointmentAddButtonController : UserController.AddButtonController!
    private var _contactsAddButtonController : UserController.AddButtonController!
    private var _appointmentsOverlayView : UIView!
    private var _appointmentsMenuOverlayController : UserController.MenuOverlayController!
    var appointmentFormCardViewModels = [AppointmentCardViewModel]()
    var dropModels = [DropModel]()
    var contacts = [OCKContact]()
    var contactModels = [ContactModel]()
    private var _dropsUrl : URL!
    private var _appointmentsUrl : URL!
    private var _contactsUrl : URL!
    var activity : OCKCarePlanActivity!
    var storedDropModel : DropModel!
    var storedAppointmentCardViewModel : AppointmentCardViewModel!
    var dropModelIndex : Int!
    @objc dynamic var viewModel : MainDashboardViewModel!
    
    var noAppointmentsLabel : LabelController
    {
        get
        {
            if (self._noAppointmentsLabel == nil)
            {
                self._noAppointmentsLabel = LabelController()
            }
            
            let noAppointmentsLabel = self._noAppointmentsLabel!
            
            return noAppointmentsLabel
        }
    }
    
    var onboardingContentViewController : OnboardingContentViewController.CollectionViewController
    {
        get
        {
            if (self._onboardingContentViewController == nil)
            {
                self._onboardingContentViewController = OnboardingContentViewController.CollectionViewController()
            }
            
            let onboardingContentViewController = self._onboardingContentViewController!
            
            return onboardingContentViewController
        }
    }
    
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
    
    var appointmentsOverlayView : UIView
    {
        get
        {
            if (self._appointmentsOverlayView == nil)
            {
                self._appointmentsOverlayView = UIView()
                self._appointmentsOverlayView.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.5)
            }
            
            let appointmentsOverlayView = self._appointmentsOverlayView!
            
            return appointmentsOverlayView
        }
    }
    
    var appointmentsMenuOverlayController : UserController.MenuOverlayController
    {
        get
        {
            if (self._appointmentsMenuOverlayController == nil)
            {
                self._appointmentsMenuOverlayController = UserController.MenuOverlayController()
            }
            
            let appointmentsMenuOverlayController = self._appointmentsMenuOverlayController!
            
            return appointmentsMenuOverlayController
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
        self.appointmentCardCollectionController.view.addSubview(self.noAppointmentsLabel.view)
        self.appointmentCardCollectionController.view.addSubview(self.appointmentAddButtonController.view)
        self.appointmentCardCollectionController.view.addSubview(self.appointmentsOverlayView)
        self.appointmentCardCollectionController.view.addSubview(self.appointmentsMenuOverlayController.view)
        
//        self.contactCardController.view.addSubview(self.contactsAddButtonController.view)
    }
    
    override func viewDidAppear(_ animated: Bool)
    {        
        if UserDefaults.standard.bool(forKey: "onboardingComplete")
        {
        }
        else
        {
            self.present(self.onboardingContentViewController, animated: true, completion: nil)
        }
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void)
    {
        completionHandler([.badge, .alert, .sound])
    }
    
    override func render()
    {
        super.render()

        self.view.frame.size = self.viewModel.size
        
        self.appointmentsOverlayView.frame.size = self.view.frame.size
        self.appointmentsOverlayView.frame.origin.y = self.view.frame.size.height
        
        self.viewModel.dropAddButtonViewModel.size.width = 80
        self.viewModel.dropAddButtonViewModel.size.height = self.viewModel.dropAddButtonViewModel.size.width
        self.dropAddButtonController.view.frame.origin.x = self.view.frame.size.width - 110
        self.dropAddButtonController.view.frame.origin.y = self.view.frame.size.height - 230
        
        self.viewModel.noAppointmentsLabelViewModel.size.width = self.view.frame.size.width - 10
        self.viewModel.noAppointmentsLabelViewModel.size.height = 90
        self.noAppointmentsLabel.view.frame.origin.x = (self.view.frame.size.width - self.viewModel.noAppointmentsLabelViewModel.size.width) / 2
        self.noAppointmentsLabel.view.frame.origin.y = (self.view.frame.size.height - self.viewModel.noAppointmentsLabelViewModel.size.height) / 2
        
        self.viewModel.appointmentAddButtonViewModel.size.width = 80
        self.viewModel.appointmentAddButtonViewModel.size.height = self.viewModel.appointmentAddButtonViewModel.size.width
        self.appointmentAddButtonController.view.frame.origin.x = self.view.frame.size.width - 110
        self.appointmentAddButtonController.view.frame.origin.y = self.view.frame.size.height - 230
        
        self.viewModel.contactAddButtonViewModel.size.width = 80
        self.viewModel.contactAddButtonViewModel.size.height = self.viewModel.contactAddButtonViewModel.size.width
        self.contactsAddButtonController.view.frame.origin.x = self.view.frame.size.width - 110
        self.contactsAddButtonController.view.frame.origin.y = self.view.frame.size.height - 230
        
        self.viewModel.appointmentsMenuOverlayViewModel.size.width = self.view.frame.size.width
        self.viewModel.appointmentsMenuOverlayViewModel.size.height = 380
        self.appointmentsMenuOverlayController.view.frame.origin.y = self.view.frame.size.height
        
        self.viewModel.dropCardViewModel.size = self.view.frame.size
        self.viewModel.appointmentCardCollectionViewModel.itemSize = self.view.frame.size
        self.viewModel.faqCardCollectionViewModel.itemSize = CGSize(width: self.view.frame.width, height: 300)
        self.viewModel.onboardingContentViewModel.itemSize = self.view.frame.size
        
        self.dropCardCollectionController.viewModel = self.viewModel.dropCardViewModel
        self.noAppointmentsLabel.viewModel = self.viewModel.noAppointmentsLabelViewModel
        self.dropAddButtonController.viewModel = self.viewModel.dropAddButtonViewModel
        self.appointmentAddButtonController.viewModel = self.viewModel.appointmentAddButtonViewModel
        self.contactsAddButtonController.viewModel = self.viewModel.contactAddButtonViewModel
        self.appointmentsMenuOverlayController.viewModel = self.viewModel.appointmentsMenuOverlayViewModel
        self.onboardingContentViewController.viewModel = self.viewModel.onboardingContentViewModel
    }
    
    override func bind()
    {
        super.bind()
        
        self.onboardingContentViewController.bind()
        self.dropCardCollectionController.bind()
        self.appointmentCardCollectionController.bind()
        self.faqCardCollectionController.bind()
        self.dropAddButtonController.bind()
        self.noAppointmentsLabel.bind()
        self.appointmentAddButtonController.bind()
        self.contactsAddButtonController.bind()
        self.appointmentsMenuOverlayController.bind()
        
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
        self.addObserver(self, forKeyPath: "viewModel.appointmentsMenuOverlayViewModel.event",
                         options: NSKeyValueObservingOptions([NSKeyValueObservingOptions.new,
                                                              NSKeyValueObservingOptions.initial]),
                         context: nil)
        self.addObserver(self,
                         forKeyPath: "viewModel.onboardingContentViewModel.event",
                         options: ([NSKeyValueObservingOptions.new,
                                    NSKeyValueObservingOptions.initial]),
                         context: nil)
    }
    
    override func unbind()
    {
        super.unbind()
        
        self.onboardingContentViewController.unbind()
        self.dropCardCollectionController.unbind()
        self.appointmentCardCollectionController.unbind()
        self.faqCardCollectionController.unbind()
        self.dropAddButtonController.unbind()
        self.noAppointmentsLabel.unbind()
        self.appointmentAddButtonController.unbind()
        self.contactsAddButtonController.unbind()
        self.appointmentsMenuOverlayController.unbind()
        
        self.removeObserver(self, forKeyPath: "viewModel.dropAddButtonViewModel.event")
        self.removeObserver(self, forKeyPath: "viewModel.appointmentAddButtonViewModel.event")
        self.removeObserver(self, forKeyPath: "viewModel.contactAddButtonViewModel.event")
        self.removeObserver(self, forKeyPath: "viewModel.appointmentCardCollectionViewModel")
        self.removeObserver(self, forKeyPath: "viewModel.appointmentCardCollectionViewModel.event")
        self.removeObserver(self, forKeyPath: "viewModel.faqCardCollectionViewModel")
        self.removeObserver(self, forKeyPath: "faqStoreRepresentable.event")
        self.removeObserver(self, forKeyPath: "viewModel.dropCardViewModel")
        self.removeObserver(self, forKeyPath: "viewModel.dropCardViewModel.dropsMenuOverlayViewModel.event")
        self.removeObserver(self, forKeyPath: "viewModel.appointmentsMenuOverlayViewModel.event")
        self.removeObserver(self, forKeyPath: "viewModel.onboardingContentViewModel.event")
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
            
            for appointmentFormCardViewModel in self.appointmentFormCardViewModels
            {
                appointmentFormCardViewModel.size.width = self.view.frame.size.width
                appointmentFormCardViewModel.size.height = 210
            }

            let appointmentCardCollectionViewModel = AppointmentCardViewModel.CollectionViewModel(appointmentCardViewModels: self.appointmentFormCardViewModels)
            appointmentCardCollectionViewModel.itemSize = self.viewModel.appointmentCardCollectionViewModel.itemSize
            self.viewModel.appointmentCardCollectionViewModel = appointmentCardCollectionViewModel
            
            if (appointmentCardCollectionViewModel.appointmentCardViewModels.count <= 0)
            {
                self.appointmentCardCollectionController.view.addSubview(self.noAppointmentsLabel.view)
            }
            else
            {
                self.noAppointmentsLabel.view.removeFromSuperview()
            }
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
            if (self.viewModel.dropCardViewModel.dropsMenuOverlayViewModel.state == UserViewModel.MenuOverlayViewModel.State.end || self.viewModel.dropCardViewModel.dropsMenuOverlayViewModel.state == UserViewModel.MenuOverlayViewModel.State.revision || self.viewModel.dropCardViewModel.dropsMenuOverlayViewModel.state == UserViewModel.MenuOverlayViewModel.State.idle)
            {
                self.activity = self.dropCardCollectionController.interventionActivity!
                var identifiers = [String]()

                for dropModel in self.dropModels
                {
                    if (dropModel.title == activity.title)
                    {
                        self.storedDropModel = dropModel
                        
                        self.dropModelIndex = self.dropModels.firstIndex(of: dropModel)
                        
                        for timeModel in dropModel.frequencyTimeModels
                        {
                            identifiers.append(timeModel.identifier)
                        }
                    }
                }
                
                if (self.viewModel.dropCardViewModel.dropsMenuOverlayViewModel.state == UserViewModel.MenuOverlayViewModel.State.end)
                {
                    self.dropModels.remove(at: self.dropModelIndex)
                    UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: identifiers)
                }
                else if (self.viewModel.dropCardViewModel.dropsMenuOverlayViewModel.state == UserViewModel.MenuOverlayViewModel.State.revision)
                {
                   self.displayDropData(storedDropModel: storedDropModel, identifiers: identifiers)
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
            if (self.viewModel.appointmentCardCollectionViewModel.state == AppointmentCardViewModel.CollectionViewModel.State.options)
            {
                UIView.animate(withDuration: 0.25, animations:
                {
                    self.appointmentsOverlayView.frame.origin.y = 0
                    
                })
                { (isCompleted) in
                    
                    self.appointmentsMenuOverlayController.view.frame.origin.y = self.view.frame.size.height - self.appointmentsMenuOverlayController.view.frame.size.height - self.tabBarController.tabBar.frame.size.height - 20
                }
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
                if (self.dropFormController.viewModel.state == DropFormViewModel.State.completion)
                {
                    let dropModels = self.dropFormController.dropModels

                    self.dropModels.append(contentsOf: dropModels)
                    
                    self.writeDrops()
                    
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
                        
                        for appointmentCardViewModel in self.viewModel.appointmentCardCollectionViewModel.appointmentCardViewModels
                        {
                            appointmentCardViewModel.size.width = self.view.frame.size.width
                            appointmentCardViewModel.size.height = 210
                        }
                        
                        self.noAppointmentsLabel.view.removeFromSuperview()
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
        else if (kvoEvent.keyPath == "viewModel.appointmentsMenuOverlayViewModel.event")
        {
            if (self.viewModel.appointmentsMenuOverlayViewModel.state == UserViewModel.MenuOverlayViewModel.State.end || self.viewModel.appointmentsMenuOverlayViewModel.state == UserViewModel.MenuOverlayViewModel.State.revision || self.viewModel.appointmentsMenuOverlayViewModel.state == UserViewModel.MenuOverlayViewModel.State.idle)
            {
                if (self.viewModel.appointmentsMenuOverlayViewModel.state == UserViewModel.MenuOverlayViewModel.State.end)
                {
                    let int = self.viewModel.appointmentCardCollectionViewModel.buttonInt!
                    let viewModel = self.viewModel.appointmentCardCollectionViewModel.appointmentCardViewModels[int]
                    self.viewModel.appointmentCardCollectionViewModel.appointmentCardViewModels.remove(at: int)
                    
                    let numberOfViewModels = self.viewModel.appointmentCardCollectionViewModel.appointmentCardViewModels.count
                    
                    if (numberOfViewModels <= 0)
                    {
                        self.appointmentCardCollectionController.view.addSubview(self.noAppointmentsLabel.view)
                    }
                    
                    self.appointmentCardCollectionController.tableViewController.tableView.reloadData()
                    
                    var identifiers = [String]()
                    identifiers.append(viewModel.id)
                    
                    UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: identifiers)
                    
                    self.appointmentFormCardViewModels = self.viewModel.appointmentCardCollectionViewModel.appointmentCardViewModels
                    
                    self.writeAppointments()
                }
                else if (self.viewModel.appointmentsMenuOverlayViewModel.state == UserViewModel.MenuOverlayViewModel.State.revision)
                {
                    self.displayAppointmentFormData()
                }
                
                UIView.animate(withDuration: 0.25, animations:
                {
                    self.appointmentsMenuOverlayController.view.frame.origin.y = self.view.frame.size.height
                })
                { (isCompleted) in
                    
                    self.appointmentsOverlayView.frame.origin.y = self.view.frame.size.height
                }
            }
        }
        else if (kvoEvent.keyPath == "dropFormController.viewModel.event")
        {
            if (self.dropFormController.viewModel.state == DropFormViewModel.State.completion)
            {
                self.dropModels.remove(at: self.dropModelIndex)
                
                self.dropCardCollectionController.carePlanStore.ockCarePlanStore.remove(self.activity)
                { (isCompleted, error) in
                }
                
                var identifiers = [String]()
                
                for timeModel in self.storedDropModel.frequencyTimeModels
                {
                    identifiers.append(timeModel.identifier)
                }
                
                UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: identifiers)
                
                let dropModels = self.dropFormController.dropModels
                
                self.dropModels.append(contentsOf: dropModels)
                
                self.writeDrops()
                
                self.dropFormController.unbind()
                self.removeObserver(self, forKeyPath: "dropFormController.viewModel.event")
                self.dropFormController.viewModel = nil
                self.dropFormController.view.removeFromSuperview()
            }
        }
        else if (kvoEvent.keyPath == "appointmentFormController.viewModel.event")
        {
            if (self.appointmentFormController.viewModel != nil)
            {
                if (self.appointmentFormController.viewModel.state == AppointmentFormViewModel.State.completion)
                {
                    var identifiers = [String]()
                    
                    self.appointmentFormCardViewModels.remove(at: self.viewModel.appointmentCardCollectionViewModel.buttonInt)
                    identifiers.append(self.storedAppointmentCardViewModel.id)
                    
                    UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: identifiers)
                    
                    let appointmentCardViewModel = self.appointmentFormController!.appointmentCardViewModels[0]
                    appointmentCardViewModel.size.width = self.view.frame.size.width
                    appointmentCardViewModel.size.height = 210
                    
                    self.appointmentFormCardViewModels.insert(appointmentCardViewModel,
                                                              at: self.viewModel.appointmentCardCollectionViewModel.buttonInt)
                    
                    self.writeAppointments()
                    
                    let appointmentCardCollectionViewModel = AppointmentCardViewModel.CollectionViewModel(appointmentCardViewModels: self.appointmentFormCardViewModels)
                    appointmentCardCollectionViewModel.itemSize = self.viewModel.appointmentCardCollectionViewModel.itemSize
                    
                    self.viewModel.appointmentCardCollectionViewModel = appointmentCardCollectionViewModel
                    
                    self.removeObserver(self, forKeyPath: "appointmentFormController.viewModel.event")
                    self.appointmentFormController.unbind()
                    self.appointmentFormController.viewModel = nil
                    self.appointmentFormController.view.removeFromSuperview()
                }
            }
        }
        else if (kvoEvent.keyPath == "viewModel.onboardingContentViewModel.event")
        {
            if (self.viewModel.onboardingContentViewModel.state == OnboardingContentViewModel.CollectionViewModel.State.mainApp)
            {
                self.onboardingContentViewController.dismiss(animated: true, completion: nil)
            }
        }
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
    
    func displayDropData(storedDropModel: DropModel, identifiers: [String])
    {
        var colorCardViewModelIndex : Int!
        
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
        self.addObserver(self,
                         forKeyPath: "dropFormController.viewModel.event",
                         options: NSKeyValueObservingOptions([NSKeyValueObservingOptions.new,
                                                              NSKeyValueObservingOptions.initial]),
                         context: nil)
        
        self.view.addSubview(self.dropFormController.view)
        
        for colorCardViewModel in dropFormViewModel.firstPageViewModel.colorCardViewModels
        {
            if (storedDropModel.colorModel.uiColor == colorCardViewModel.uicolor)
            {
                colorCardViewModelIndex = dropFormViewModel.firstPageViewModel.colorCardViewModels.firstIndex(of: colorCardViewModel)
            }
        }
        
        let firstTimeModel = storedDropModel.frequencyTimeModels[0]
        let secondTimeModel = storedDropModel.frequencyTimeModels[1]
        let interval = secondTimeModel.interval - firstTimeModel.interval
        
        let hour = Int(interval) / 3600
        let minute = (Int(interval) % 3600) / 60
        var display = ""
        
        if (hour > 0)
        {
            display = String(hour) + " hour " + String(minute) + " min"
        }
        else
        {
            display = String(hour) + " hours " + String(minute) + " min"
        }
        
        let startTimeMoment = moment(firstTimeModel.interval).format("hh:mm a")
        let intervalMoment = display
        let perDay = String(storedDropModel.frequencyTimeModels.count)
        
        dropFormViewModel.firstPageViewModel.textFieldInputViewModel.value = storedDropModel.title
        dropFormViewModel.firstPageViewModel.toggle(at: colorCardViewModelIndex)
        dropFormViewModel.secondPageViewModel.startDatePickerInputViewModel.timeInterval = storedDropModel.startTimeModel.interval
        dropFormViewModel.secondPageViewModel.endDatePickerInputViewModel.timeInterval = storedDropModel.endTimeModel.interval
        
        dropFormViewModel.overLayCardViewModel.timeDatePickerInputViewModel.timeInterval = firstTimeModel.interval
        dropFormViewModel.overLayCardViewModel.intervalDatePickerViewModel.timeInterval = interval
        dropFormViewModel.overLayCardViewModel.textFieldTimesPerdayViewModel.value = String(storedDropModel.frequencyTimeModels.count)
        
        dropFormViewModel.thirdPageViewModel.controlCardStartTime.display = startTimeMoment
        dropFormViewModel.thirdPageViewModel.controlCardInterval.display = intervalMoment
        dropFormViewModel.thirdPageViewModel.controlCardTimesPerDay.display = perDay
    }
    
    func displayAppointmentFormData()
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
        self.addObserver(self,
                         forKeyPath: "appointmentFormController.viewModel.event",
                         options: NSKeyValueObservingOptions([NSKeyValueObservingOptions.new,
                                                              NSKeyValueObservingOptions.initial]),
                         context: nil)
        appointmentFormViewModel.size = self.view.frame.size
        self.appointmentFormController.viewModel = appointmentFormViewModel
        
        self.view.addSubview(self.appointmentFormController.view)
        
        self.storedAppointmentCardViewModel = self.appointmentFormCardViewModels[self.viewModel.appointmentCardCollectionViewModel.buttonInt]
        
        var appointmentFormLabelIndex : Int!
        
        for appointmentLabelViewModel in appointmentFormViewModel.firstPageViewModel.appointmentFormLabelViewModels
        {
            let appointmentLabel : UserViewModel.AppointmentFormLabelViewModel!
            
            if (appointmentLabelViewModel.labelViewModel.text == storedAppointmentCardViewModel.title)
            {
                appointmentLabel = appointmentLabelViewModel
                
                appointmentFormLabelIndex = appointmentFormViewModel.firstPageViewModel.appointmentFormLabelViewModels.firstIndex(of: appointmentLabel)
                
                appointmentFormViewModel.firstPageViewModel.toggle(at: appointmentFormLabelIndex)
                
                break
            }
        }
        
        if (appointmentFormLabelIndex == nil)
        {
            appointmentFormViewModel.appointmentInputViewModel.textFieldInputViewModel.value = storedAppointmentCardViewModel.title
        }
        
        appointmentFormViewModel.secondPageViewModel.datePickerInputViewModel.timeInterval = storedAppointmentCardViewModel.timeModel.interval
    }
    
    func loadAllStores()
    {
        self.faqStore.load(FAQOperation.GetFAQModelsQuery())
    }
}
