//
//  AppDelegate.swift
//  TotalVendor
//
//  Created by Darrin Brooks on 12/08/21.
//

import UIKit
import CoreData
import IQKeyboardManager
import PushKit
import Firebase
import Intents
import CallKit
import TwilioVideo

@main


class AppDelegate: UIResponder, UIApplicationDelegate, UNUserNotificationCenterDelegate, MessagingDelegate, CXProviderDelegate {
    
    var backgroundSessionCompletionHandler: (() -> Void)?
    let start = Date()
    
    var customerName = ""
    var customerImage = ""
    var lid = 0
    var senderid = 0
    var languageTest1 = ""
    var languageTest2 = ""
    var touserid = 0
    var sourceLid = 0
    var patientname = ""
    var patientno = 0
    var screenTime = 0
    var screenTimeCount = 0
    var roomName = 0
    var callID = 0
    
    func providerDidReset(_ provider: CXProvider) {
            print("providerDidReset:")

            // AudioDevice is enabled by default
//            self.audioDevice.isEnabled = false
            
//            room?.disconnect()
        }
    
    var timerForApp : Timer?
    var voipRegistry: PKPushRegistry?
    var window: UIWindow?
    var callKitProvider: CXProvider?
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        IQKeyboardManager.shared().isEnabled = true
        IQKeyboardManager.shared().isEnableAutoToolbar = true
        IQKeyboardManager.shared().shouldShowToolbarPlaceholder = true
        IQKeyboardManager.shared().shouldResignOnTouchOutside = true
        Messaging.messaging().isAutoInitEnabled = true
        let date = Date()

        // Create Date Formatter
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy h:mm a"
        // Convert Date to String
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        let abc = dateFormatter.string(from: date)
        
        print("CURRENT DATE TIME IS \(abc)")

        self.voipRegistration()
        
        FirebaseApp.configure()
        Messaging.messaging().delegate = self
        
        let center = UNUserNotificationCenter.current()
            center.requestAuthorization(options:[.badge, .alert, .sound]) { (granted, error) in
                // Enable or disable features based on Screen Time authorization.
            }
            application.registerForRemoteNotifications()
        
        if #available(iOS 10.0, *) {
          // For iOS 10 display notification (sent via APNS)
          UNUserNotificationCenter.current().delegate = self

          let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
          UNUserNotificationCenter.current().requestAuthorization(
            options: authOptions,
            completionHandler: { _, _ in }
          )
        } else {
          let settings: UIUserNotificationSettings =
            UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
          application.registerUserNotificationSettings(settings)
        }
        if #available(iOS 13.0, *) {
                    window?.overrideUserInterfaceStyle = .light
                    UIView.appearance(whenContainedInInstancesOf: [UIAlertController.self]).overrideUserInterfaceStyle = .light
                }
        
        if #available(iOS 13.0, *) {
                 window?.overrideUserInterfaceStyle = .light
                 UIView.appearance(whenContainedInInstancesOf: [UIAlertController.self]).overrideUserInterfaceStyle = .light
             }
      print("LOGG IN DEFAULT VALUE IS \(UserDefaults.standard.value(forKey: "isLoggedIn") as? Bool ?? false)")
        
        if UserDefaults.standard.value(forKey: "isLoggedIn") as? Bool ?? false == true{
            
                let storyboard : UIStoryboard = UIStoryboard(name:"Main", bundle: nil)
                               let navigationController : UINavigationController = storyboard.instantiateInitialViewController() as! UINavigationController
                               let rootViewController:UIViewController = storyboard.instantiateViewController(withIdentifier: "CalendarViewController") as! CalendarViewController
            
                               navigationController.viewControllers = [rootViewController]
                               //self.window = UIWindow(frame: UIScreen.main.bounds)
                               self.window?.rootViewController = navigationController
                               self.window?.makeKeyAndVisible()
           
        }else {
            let appDelegate: AppDelegate = UIApplication.shared.delegate as! AppDelegate
                                     let storyboard:UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                                     let navigationController:UINavigationController = storyboard.instantiateInitialViewController() as! UINavigationController
                                     let rootViewController:UIViewController = storyboard.instantiateViewController(withIdentifier:"InitialViewController") as! InitialViewController
                                     navigationController.viewControllers = [rootViewController]
                                     appDelegate.window!.rootViewController = navigationController
                                     appDelegate.window!.makeKeyAndVisible()
        }
       
      
        
        

        let notificationSettings = UIUserNotificationSettings(types: [.badge, .sound, .alert], categories: nil)
         
                //register the notification settings
                application.registerUserNotificationSettings(notificationSettings)
         
                //output what state the app is in. This will be used to see when the app is started in the background
                NSLog("app launched with state \(application.applicationState)")
         
        
//        timerForApp = Timer.scheduledTimer(timeInterval: 01.0, target: self, selector: #selector(AppTime), userInfo: nil, repeats: true)


        Messaging.messaging().token { token, error in
          if let error = error {
            print("Error fetching FCM registration token: \(error)")
          } else if let token = token {
            print("FCM registration token: \(token)")
            UserDefaults.standard.setValue(token, forKey: "FCMToken")
            let fcmRegTokenMessage  = "Remote FCM registration token: \(token)"
          }
        }
                
        
        var DeviceToken =  UIDevice.current.identifierForVendor!.uuidString
        UserDefaults.standard.setValue(DeviceToken, forKey: "deviceToken")
      
        // Override point for customization after application launch.
        return true
    
    }
    
    @objc func AppTime(){
            if screenTime >= 0 {
                print("Elapsed time: \(start.timeIntervalSinceNow) seconds")
                screenTime = screenTime + 1
                screenTimeCount = screenTime
//                   print("SCREEN TIME COUNT IS \()")
                print("Screen time is ", screenTimeCount)
                NotificationCenter.default.post(name: Notification.Name("changeScreenTime"), object: nil, userInfo: nil)
             	   //resendCodeLabel.text = "Resend code in 00:\(totalSecond)"
            }
        }
    
//    func registerForVOIPNotifications()
//       {
//           guard voipRegistry == nil else {return}
//
//           voipRegistry = PKPushRegistry(queue: nil)
//           voipRegistry.desiredPushTypes = Set([PKPushType.voIP])
//           voipRegistry.delegate = self
//           useVoipToken(voipRegistry!.pushToken(for: .voIP)) // use latest token cached
//       }

//       func pushRegistry(_ registry: PKPushRegistry, didUpdate pushCredentials: PKPushCredentials, for type: PKPushType)
//       {
//            useVoipToken(pushCredentials.token) // update token if needed
//       }
       
       private func useVoipToken(_ tokenData: Data?) {
           // Do whatever with the token

       }

    
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                  willPresent notification: UNNotification,
                                  withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
          let userInfo = notification.request.content.userInfo
          print(userInfo) // the payload that is attached to the push notification
          // you can customize the notification presentation options. Below code will show notification banner as well as play a sound. If you want to add a badge too, add .badge in the array.
          completionHandler([.alert,.sound])
      }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                   didReceive response: UNNotificationResponse,
                                   withCompletionHandler completionHandler: @escaping () -> Void) {
           let userInfo = response.notification.request.content.userInfo
           // Print full message.
           print("tap on on forground app",userInfo)
        let type =  userInfo[AnyHashable("type")] as? String
            print("TYPE IS \(type)")
           completionHandler()
       }
    
 
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
            
            print("userInfo-------------------->",userInfo.values, "Info:", userInfo )
            handleNotification(userInfo: userInfo)
        }


    func handleNotification(userInfo:[AnyHashable:Any]){
            let type =  userInfo[AnyHashable("type")] as? String
            let payload = userInfo[AnyHashable("payload")] as? String
            
            if type != nil {
               // let dict = convertToDictionary(text: payload!)
         
                if type == "tokenupdate" {
//                    if isLogoutPressed {
//                        isLogoutPressed = false
//                    }else {
                        self.window?.makeToast("This customer already logged-in on another device")
                        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
//                            DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) { // Change
                                SwiftLoader.hide()
                                UserDefaults.standard.setValue(false, forKey: "isLoggedIn")
                                let appDelegate: AppDelegate = UIApplication.shared.delegate as! AppDelegate
                                                         let storyboard:UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                                                         let navigationController:UINavigationController = storyboard.instantiateInitialViewController() as! UINavigationController
                                                         let rootViewController:UIViewController = storyboard.instantiateViewController(withIdentifier:"InitialViewController") as! InitialViewController
                                                         navigationController.viewControllers = [rootViewController]
                                                         appDelegate.window!.rootViewController = navigationController
                                                         appDelegate.window!.makeKeyAndVisible()
                               // Code you want to be delayed
//                            }
                        }
//                    }
                    
                }
                
             
            }
        }
    
 
    
    
    
    
    
    
    
    
    
    
    
    
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
      print("Firebase registration token: \(String(describing: fcmToken))")

      let dataDict: [String: String] = ["token": fcmToken ?? ""]
      NotificationCenter.default.post(
        name: Notification.Name("FCMToken"),
        object: nil,
        userInfo: dataDict
      )
        
      // TODO: If necessary send token to application server.
      // Note: This callback is fired at each app startup and whenever a new token is generated.
    }
    
    func application(_ application: UIApplication,
                     didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
      Messaging.messaging().apnsToken = deviceToken
    }
    
    /*
    func application(_ application: UIApplication, didRegister notificationSettings: UIUserNotificationSettings) {
        //register for voip notifications
    }
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {

        let deviceTokenString = deviceToken.reduce("", {$0 + String(format: "%02X", $1)})
        print(deviceTokenString)
    }
     
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
            print("i am not available in simulator \(error)")
    }
    
    func pushRegistry(_ registry: PKPushRegistry, didUpdate pushCredentials: PKPushCredentials, for type: PKPushType) {
            NSLog("VoIP Token: \(pushCredentials)")
            let deviceTokenString = pushCredentials.token.reduce("") { $0 + String(format: "%02X", $1) }
        print("OLD SUBSTRITUTION")
        print("voip token: \(pushCredentials.token)")
            print("VOIP TOKEN ",deviceTokenString)
    }
    
    func voipRegistration() {
            // Create a push registry object
            let mainQueue = DispatchQueue.main
            let voipRegistry: PKPushRegistry = PKPushRegistry(queue: mainQueue)
            voipRegistry.delegate = self
        voipRegistry.desiredPushTypes = [.voIP]
        }
    
    
    func pushRegistry(_ registry: PKPushRegistry, didReceiveIncomingPushWith payload: PKPushPayload, for type: PKPushType, completion: @escaping () -> Void) {
         print("VOIP NOTIFICATION",payload.dictionaryPayload)
        let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "VideoViewController") as? VideoViewController
        vc?.reportIncomingCall(uuid: UUID(), roomName: payload.dictionaryPayload[""] as? String ?? "")
        ///Call Function
    }
    
    func application(_ application: UIApplication, continue userActivity: NSUserActivity, restorationHandler: @escaping ([UIUserActivityRestoring]?) -> Void) -> Bool {
        // the place on viewcontroller set your controller
        //This using for access the method form view controller
            guard let interaction = userActivity.interaction else {
                return false
            }
        let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "VideoViewController") as? VideoViewController

            var personHandle: INPersonHandle?

            if let startVideoCallIntent = interaction.intent as? INStartVideoCallIntent {
                personHandle = startVideoCallIntent.contacts?[0].personHandle
            } else if let startAudioCallIntent = interaction.intent as? INStartAudioCallIntent {
                personHandle = startAudioCallIntent.contacts?[0].personHandle
            }

            if let personHandle = personHandle {
                vc?.performStartCallAction(uuid: UUID(), roomName: personHandle.value)
            }

            return true
        }
    // MARK: UISceneSession Lifecycle
    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }

    // MARK: - Core Data stack
    lazy var persistentContainer: NSPersistentCloudKitContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
        */
        let container = NSPersistentCloudKitContainer(name: "TotalVendor")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                 
                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    // MARK: - Core Data Saving support

    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }

}
/*
extension AppDelegate : PKPushRegistryDelegate {
    
    // Handle updated push credentials
//    func pushRegistry(_ registry: PKPushRegistry, didUpdate credentials: PKPushCredentials, for type: PKPushType) {
//        print(credentials.token)
//        let deviceToken = credentials.token.map { String(format: "%02x", $0) }.joined()
//        print("pushRegistry -> deviceToken :\(deviceToken)")
//        UserDefaults.standard.setValue(deviceToken, forKey: "deviceID")
//    }
        
    func pushRegistry(_ registry: PKPushRegistry, didInvalidatePushTokenFor type: PKPushType) {
        print("pushRegistry:didInvalidatePushTokenForType:")
    }
}
*/
/*

extension AppDelegate {

    func pushRegistry(registry: PKPushRegistry!, didUpdatePushCredentials credentials: PKPushCredentials!, forType type: String!) {

        //print out the VoIP token. We will use this to test the notification.
        NSLog("voip token: \(credentials.token)")
    }

    func pushRegistry(registry: PKPushRegistry!, didReceiveIncomingPushWithPayload payload: PKPushPayload!, forType type: String!) {

        let payloadDict = payload.dictionaryPayload["aps"] as? Dictionary<String, String>
        let message = payloadDict?["alert"]

        //present a local notifcation to visually see when we are recieving a VoIP Notification
        if UIApplication.shared.applicationState == UIApplication.State.background {

            let localNotification = UILocalNotification();
            localNotification.alertBody = message
            localNotification.applicationIconBadgeNumber = 1;
            localNotification.soundName = UILocalNotificationDefaultSoundName;

            UIApplication.shared.presentLocalNotificationNow(localNotification);
        }

        else {

            DispatchQueue.main.async(execute: { () -> Void in

                let alert = UIAlertView(title: "VoIP Notification", message: message, delegate: nil, cancelButtonTitle: "Ok");
                alert.show()
            })
        }

        NSLog("incoming voip notfication: \(payload.dictionaryPayload)")
    }

    func pushRegistry(registry: PKPushRegistry!, didInvalidatePushTokenForType type: String!) {

        NSLog("token invalidated")
    }
}
*/


extension AppDelegate: PKPushRegistryDelegate {
    
    func pushRegistry(registry: PKPushRegistry!, didUpdatePushCredentials credentials: PKPushCredentials!, forType type: String!) {
        
        //print out the VoIP token. We will use this to test the notification.
        print("NEWWW SUBSTRITUTION")
        NSLog("voip token: \(credentials.token)")
    }
    
    private func pushRegistry(registry: PKPushRegistry!, didReceiveIncomingPushWithPayload payload: PKPushPayload!, forType type: String!) {
        
        let payloadDict = payload.dictionaryPayload["aps"] as? Dictionary<String, String>
        let message = payloadDict?["alert"]
        
        //present a local notifcation to visually see when we are recieving a VoIP Notification
        if UIApplication.shared.applicationState == UIApplication.State.background {
            
            let localNotification = UILocalNotification();
            localNotification.alertBody = message
            localNotification.applicationIconBadgeNumber = 1;
            localNotification.soundName = UILocalNotificationDefaultSoundName;
            
            UIApplication.shared.presentLocalNotificationNow(localNotification);
        }
            
        else {
            
            DispatchQueue.main.async { () -> Void in
                
                let alert = UIAlertView(title: "VoIP Notification", message: message, delegate: nil, cancelButtonTitle: "Ok");
                alert.show()
            }
        }
        
        NSLog("incoming voip notfication: \(payload.dictionaryPayload)")
    }
    
    func pushRegistry(registry: PKPushRegistry!, didInvalidatePushTokenForType type: String!) {
        
        NSLog("token invalidated")
    }
}

*/

}




extension AppDelegate: PKPushRegistryDelegate {
    
    func voipRegistration() {
        self.voipRegistry = PKPushRegistry(queue: DispatchQueue.main)
        self.voipRegistry?.delegate = self
        self.voipRegistry?.desiredPushTypes = [.voIP]
    }
    
    // MARK: - SendBirdCalls - Registering push token.
    func pushRegistry(_ registry: PKPushRegistry, didUpdate pushCredentials: PKPushCredentials, for type: PKPushType) {
//        UserDefaults.standard.voipPushToken =
        let newVoipToken = pushCredentials.token.description.replacingOccurrences(of: "<", with: "")
        let abc = newVoipToken.replacingOccurrences(of: ">", with: "")
        let test = abc.replacingOccurrences(of: " ", with: "")
        
        let deviceTokennn = pushCredentials.token.map { String(format: "%02x", $0) }.joined()
        print("New decoded token is \(deviceTokennn)")
        print("Push token is \(pushCredentials.token.toHexString())")
        let voipNew = pushCredentials.token.toHexString()
        print("New Voip Token is \(voipNew)")
        UserDefaults.standard.setValue(voipNew, forKey: "voipToken")
//        SendBirdCall.registerVoIPPush(token: pushCredentials.token, unique: true) { error in
//            guard error == nil else { return }
//        }
    }
    
    // MARK: - SendBirdCalls - Receive incoming push event
//    func pushRegistry(_ registry: PKPushRegistry, didReceiveIncomingPushWith payload: PKPushPayload, for type: PKPushType) {
//        print("payload received is \(payload)")
//        DispatchQueue.main.async {
//            let alert = UIAlertController(title: "Test", message:"Message", preferredStyle: UIAlertController.Style.alert)
//                    
//            // add an action (button)
//            alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
//                   
//            // show the alert
//            self.window?.rootViewController?.present(alert, animated: true,completion: nil)
//        
//        
//        }
//     
//        //        SendBirdCall.pushRegistry(registry, didReceiveIncomingPushWith: payload, for: type, completionHandler: nil)
//    }
    
    // MARK: - SendBirdCalls - Handling incoming call
    // Please refer to `AppDelegate+SendBirdCallsDelegates.swift` file.
    func pushRegistry(_ registry: PKPushRegistry, didReceiveIncomingPushWith payload: PKPushPayload, for type: PKPushType, completion: @escaping () -> Void) {
        print("payload received is \(payload.dictionaryPayload)")
        let userInfo:[AnyHashable:Any]=payload.dictionaryPayload["notification"] as! [AnyHashable : Any]
                  print("USER INFO ISSS \(userInfo)")
                  let callfrom =  userInfo[AnyHashable("callfrom")] as? String
                  let type2 =  userInfo[AnyHashable("type")] as? String
        print("USER INFO IS \(userInfo)")
      print("BTYPEE IS \(callfrom)")
        let lid = userInfo[AnyHashable("Lid")] as? String ?? "0"
        let senderid = userInfo[AnyHashable("FromUserID")] as? String ?? "0"
        let touserid = userInfo[AnyHashable("ToUserID")] as? String ?? "0"
        let sourceLid = userInfo[AnyHashable("sourcelid")] as? String ?? "0"
        let patientname = userInfo[AnyHashable("patientname")] as? String ?? "NA"
        let patientno = userInfo[AnyHashable("patientno")] as? String ?? "0"
        let callid = userInfo[AnyHashable("callid")] as? String ?? "0"
        let customerName = userInfo[AnyHashable("patientname")] as? String ?? "0"
        let customerImage = userInfo[AnyHashable("CustomerImage")] as? String ?? "0"
        print("CALLID DATA IS \(callid)")
        self.lid = Int(lid) ?? 0
        self.customerName = customerName
        self.customerImage = customerImage
        self.senderid = Int(senderid) ?? 0
        self.touserid = Int(touserid) ?? 0
        self.sourceLid = Int(sourceLid) ?? 0
        self.patientname = patientname
        self.patientno = Int(patientno) ?? 0
        self.callID = Int(callid) ?? 0
        print("NEW CALL ID DATA IS \(self.callID)")
        let firstLanguage = userInfo[AnyHashable("slname")] as? String
       let secondLanguage = userInfo[AnyHashable("tlname")] as? String
        let roomNamee = userInfo[AnyHashable("room")] as? Int
        let roomNameeString = userInfo[AnyHashable("room")] as? String
//        let callIDD = userInfo[AnyHashable("callid")] as?  Int
        self.roomName = Int(roomNameeString ?? "0") ?? 0
//        self.callID = callIDD ?? 0
        print("ROOM FROM NOTIFICATION IS \(roomName)")
        let callType = userInfo[AnyHashable("CallType")] as? String ?? ""
        print("STRING ROOM IS \(roomNameeString ?? "")")
        
        let cFirstLanguage = firstLanguage?.capitalized ?? ""
        let csecondLanguage = secondLanguage?.capitalized ?? ""
        
        self.languageTest1 = cFirstLanguage
        self.languageTest2 = cFirstLanguage
        
        configureProvider(firstLanguage: cFirstLanguage, secondLangugae: csecondLanguage, callType: callType)
        

        //        SendBirdCall.pushRegistry(registry, didReceiveIncomingPushWith: payload, for: type) { uuid in
//            guard uuid != nil else {
//                let update = CXCallUpdate()
//                update.remoteHandle = CXHandle(type: .generic, value: "invalid")
//                let randomUUID = UUID()
//                
//                CXCallManager.shared.reportIncomingCall(with: randomUUID, update: update) { _ in
//                    CXCallManager.shared.endCall(for: randomUUID, endedAt: Date(), reason: .acceptFailed)
//                }
//                completion()
//                return
//            }
//            
//            completion()
//        }
    }
    
    
    private func configureProvider(firstLanguage : String , secondLangugae : String, callType:String) {
        let configuration = CXProviderConfiguration(localizedName: "AT Call")
        configuration.maximumCallGroups = 1
        configuration.maximumCallsPerCallGroup = 1
        configuration.supportsVideo = true
        configuration.supportedHandleTypes = [.generic]
        configuration.iconTemplateImageData = UIImage(named: "callkit-icon")?.pngData()
       let provider = CXProvider(configuration: configuration)
        // set delegate to your CXProviderDelegate implementation
        provider.setDelegate(self, queue: nil)
        
        var stringToShow = "\(firstLanguage)>\(secondLangugae)"
        if callType == "VRI"{
            stringToShow = "\(firstLanguage)>\(secondLangugae)"
        }else {
            stringToShow = "OPI Call"
        }
        
        
        let handle = CXHandle(type: .generic, value: stringToShow)
        let update = CXCallUpdate()
        update.remoteHandle = handle
        update.supportsHolding = true
        if callType == "VRI"{
            update.hasVideo = true
        }else {
            update.hasVideo = false
        }
        
        
        let uuid = UUID()
        provider.reportNewIncomingCall(with: uuid, update: update, completion: { error in
            if let error = error {
                print("Error reporting new incoming call: \(error.localizedDescription)")
            } else {
                print("Reported new incoming call successfully")
                
            }
        })
    }
    
}



extension AppDelegate{
    func provider(_ provider: CXProvider, perform action: CXAnswerCallAction) {
        print("ANSWER CALL TAPPED")
        let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "VideoCallViewController") as? VideoCallViewController
//        vc?.reportIncomingCall(uuid: UUID(), roomName: roomName)
        vc?.lid = self.lid
        vc?.callID = self.callID
        vc?.senderid = self.senderid
        vc?.touserid = self.touserid
        vc?.sourceLid = self.sourceLid
        vc?.patientname = self.patientname
        vc?.patientno = self.patientno
        vc?.roomID = self.roomName
        vc?.languageTest1 = self.languageTest1
        vc?.languageTest2 = self.languageTest2
        vc?.customerName = self.customerName
        vc?.customerImage = self.customerImage
        print("NEXT CALL DATA IS \(self.callID)")
        guard let window = UIWindow.key else { return }
        vc?.modalPresentationStyle = .fullScreen
                     //  isfromAppdelegate = true
                     if let rootViewController = window.rootViewController {
                         var currentController = rootViewController
                         while let presentedController = currentController.presentedViewController {
                             currentController = presentedController
                         }
                         currentController.present(vc!, animated: true, completion: nil)
                     }
        
    }
    
    func provider(_ provider: CXProvider, perform action: CXEndCallAction) {
//        print("END CALL TAPPED")
    }
    
    func provider(_ provider: CXProvider, perform action: CXStartCallAction) {
        print("START CALL TAPPED")
    }
    
}



extension Data {
    func toHexString() -> String {
        return self.map { String(format: "%02x", $0) }.joined()
    }
}

extension UIWindow {
    static var key: UIWindow? {
        if #available(iOS 13, *) {
            return UIApplication.shared.windows.first { $0.isKeyWindow }
        } else {
            return UIApplication.shared.keyWindow
        }
    }
}

public func secElapsed(completion: () -> Void) {
    let startDate: NSDate = NSDate()
    completion()
    let endDate: NSDate = NSDate()
    let timeInterval: Double = endDate.timeIntervalSince(startDate as Date)
    print("seconds: \(timeInterval)")
}
