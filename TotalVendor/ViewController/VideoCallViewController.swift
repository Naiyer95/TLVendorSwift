//
//  VideoCallViewController.swift
//  TotalVendor
//
//  Created by Darrin Brooks on 12/08/21.
//


import UIKit

import TwilioVideo
import CallKit
import AVFoundation
import UserNotifications
import Alamofire
import MagicTimer

class VideoCallViewController: UIViewController, UIPopoverPresentationControllerDelegate, UIViewControllerTransitioningDelegate, RoomDelegate, CameraSourceDelegate {
    var room: Room?
    var apiVriCallDisconnetResponseModel : ApiVriCallDisconnetResponseModel?
    var lid=0
    // In Case of 3 participants 1  ` Vendor and 2 customers
    @IBOutlet weak var videoViewCollectionView: UICollectionView!
    var isClientVideoPaused = false
    @IBOutlet weak var firstTopPreviewView:VideoView?
    @IBOutlet weak var bottomRemoteView1:VideoView?
    @IBOutlet weak var bottomRemoteView2:VideoView?
    // In Case of 4 participants 1 Vendor and 3 customers
    @IBOutlet weak var secondFirstTop:VideoView?
    @IBOutlet weak var secondSecondTopView:VideoView?
    @IBOutlet weak var singleVideoViewOutlet: UIView!
    var senderid = 0
    var second:Double = 0.0;
    var touserid = 0
    var sourceLid = 0
    var customerImage = ""
    var customerName = ""
    var testingVideoTrack = [RemoteVideoTrackPublication]()
    var languageTest1 = ""
    var languageTest2 = ""
    var patientname = "NA"
    var patientno = 0
    var roomSid = ""
    var apiConferenceParticipantResponseModel : ApiConferenceParticipantResponseModel?
    var acceptMemberResponseModel : AcceptMemberResponseModel?
    @IBOutlet weak var micIconView: UIImageView!
    @IBOutlet weak var muteIconLbl: UILabel!
    @IBOutlet weak var stopVideoIcon: UIImageView!
    @IBOutlet weak var stopVideoLbl: UILabel!
    @IBOutlet weak var timerCountUpView: MagicTimerView!
    @IBOutlet weak var singleVideoView: UIView!
    @IBOutlet weak var connectTwoVideoPlayerView: UIView!
    @IBOutlet weak var singleVideoOneView: UIView!
    @IBOutlet weak var twoVideoView: UIView!
    @IBOutlet weak var threeVideoView: UIView!
    @IBOutlet weak var fourVideoView: UIView!
    /**
     * We will create an audio device and manage it's lifecycle in response to CallKit events.
     */
    @IBOutlet weak var timeIntervalLbl: UILabel!
    var audioDevice: DefaultAudioDevice = DefaultAudioDevice()
    var camera: CameraSource?
    var localVideoTrack: LocalVideoTrack?
    var localAudioTrack: LocalAudioTrack?
    var remoteParticipant: RemoteParticipant?
    var remoteView: VideoView?
    @IBOutlet weak var firstVideoView: UIView!
    @IBOutlet weak var secondVideoView: UIView!
    @IBOutlet weak var thirdVideoView: UIView!
    @IBOutlet weak var fourthVideoView: UIView!
    var remoteParticipantList = [RemoteParticipant]()
    // CallKit components
    @IBOutlet weak var previewView: VideoView!
    var callKitProvider:CXProvider?
    var callKitCallController=CXCallController()
    var callKitCompletionHandler: ((Bool)->Swift.Void?)? = nil
    var userInitiatedDisconnect: Bool = false
    var roomID = 0
    var twilioToken = ""
    var timer = Timer()
    var callID = 0
    var apiTwilioTokenResponseModel : ApiTwilioTokenResponseModel?
    @IBOutlet weak var moreButtonView: UIStackView!
    deinit {
        // We are done with camera
        if let camera = self.camera {
            camera.stopCapture()
            self.camera = nil
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        UIApplication.shared.isIdleTimerDisabled = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        UIApplication.shared.isIdleTimerDisabled = false
    }
    
    func startTimer() {
        timer = Timer.scheduledTimer(timeInterval: 0.01, target: self, selector: (#selector(VideoCallViewController.updateTimer)), userInfo: nil, repeats: true)
    }
    
    @objc func updateTimer() {
        second += 0.01;
        let secondInt = Int(second)
        let hours = getStringFrom(seconds: (secondInt / 3600))
        let minutes = getStringFrom(seconds: ((secondInt % 3600) / 60))
        let seconds = getStringFrom(seconds: ((secondInt % 3600) % 60))
        timeIntervalLbl.text="\(hours) : \(minutes) : \(seconds)"
    }
    
    
    func getStringFrom(seconds: Int) -> String {
        return seconds < 10 ? "0\(seconds)" : "\(seconds)"
    }
     
    @IBAction func micBtnTapped(_ sender: Any) {
        print("LOCAL VIDEO TRACK STATUS IS \(self.localAudioTrack?.isEnabled)")
        self.localAudioTrack?.isEnabled = !(self.localAudioTrack?.isEnabled ?? false)
        if self.localAudioTrack?.isEnabled ?? false {
            self.muteIconLbl.text = "Mute"
            self.muteIconLbl.text = "Unmute"
            self.micIconView.image = UIImage(named: "micIcon")
            self.micIconView.tintColor = .white
        }
        else
        {
            self.muteIconLbl.text = "Unmute"
            self.micIconView.image = UIImage(systemName: "mic.slash")
            self.micIconView.tintColor = .white
        }
    }
    
    @IBAction func chatTapped(_ sender: Any) {
        
    }
    
    @IBAction func chatViewTapped(_ sender: Any) {
        print("CHAT VIEW TAPPED....")
        
    }
    
    @IBAction func pinVideoTapped(_ sender: Any) {
        print("PIN VIDEO VIEW TAPPED....")
    }
    
    
    @IBAction func endCallTapped(_ sender: Any) {
        print("END CALL VIEW TAPPED....")
        hitroomDidDisconnectApi()
    }
    
    
    @IBAction func videoBtnTapped(_ sender: Any) {
        print("LOCAL VIDEO TRACK STATUS IS \(self.localVideoTrack?.isEnabled)")
        self.localVideoTrack?.isEnabled = !(self.localVideoTrack?.isEnabled ?? false)
        
        if self.localVideoTrack?.isEnabled ?? false {
            self.stopVideoLbl.text = "Stop Video"
            self.stopVideoIcon.image = UIImage(named: "videoIcon")
            self.stopVideoIcon.tintColor = .white
        }
        else
        {
            self.stopVideoLbl.text = "Start Video"
            self.stopVideoIcon.image = UIImage(systemName: "video.slash")
            self.stopVideoIcon.tintColor = .white
        }
    }
    
    @IBAction func participantsBtnAction(_ sender: Any) {
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let pvc = storyboard.instantiateViewController(withIdentifier: "ParticipantsViewController") as! ParticipantsViewController
        pvc.modalPresentationStyle = .custom
            pvc.transitioningDelegate = self
        present(pvc, animated: true)
        
    }
    
    @IBAction func moreBtnAction(_ sender: Any) {
        
        let storyboard : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let popupVC = storyboard.instantiateViewController(withIdentifier: "VideoCallViewController1") as! VideoCallViewController1
        popupVC.modalPresentationStyle = .popover
        popupVC.preferredContentSize = CGSize(width: 250, height: 250)
        let pVC = popupVC.popoverPresentationController
        pVC?.permittedArrowDirections = .any
        pVC?.delegate = self
        pVC?.sourceView = sender as! UIView
        // pVC?.sourceRect = CGRect(x: 100, y: 100, width: 1, height: 1)
        present(popupVC, animated: true, completion: nil)
    }
    
    @IBAction func EndCallBtnAction(_ sender: Any) {
        
        let popupview = storyboard?.instantiateViewController(withIdentifier: "RatingViewController")
        popupview!.view.frame = CGRect(x: 25, y: 100, width: view.frame.width - 50, height: view.frame.height - 200)
        self.addChild(popupview!)
        self.view.addSubview(popupview!.view)
        popupview!.didMove(toParent: popupview)
        //        RatingViewController
        //        let customAlert = self.storyboard?.instantiateViewController(withIdentifier: "RatingViewController") as! RatingViewController
        //        customAlert.view.frame = CGRect(x: 30, y: 50, width: view.frame.width - 50, height: view.frame.height - 100)
        //                customAlert.providesPresentationContextTransitionStyle = true
        //                customAlert.definesPresentationContext = true
        //                customAlert.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
        //                customAlert.modalTransitionStyle = UIModalTransitionStyle.crossDissolve
        //        self.addChild(customAlert)
        //        self.view.addSubview(customAlert.view)
        //                self.present(customAlert, animated: true, completion: nil)
    }
    
    
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
      
        return UIModalPresentationStyle.none
        
    }
    
    func popoverPresentationControllerShouldDismissPopover(_ popoverPresentationController: UIPopoverPresentationController) -> Bool {
        
        return true
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let abc = String(self.roomID)
        print("ROOM ID IS \(abc)")
        self.previewView.contentMode = .scaleAspectFill
        if PlatformUtils.isSimulator {
            self.previewView.removeFromSuperview()
        } else {
            // preview our local camera track in the local video preview view.
            self.startPreview()
        }
        //        CreateVRICallVendor()
        self.GetVRICallStatus()
        self.videoViewCollectionView.delegate=self
        self.videoViewCollectionView.dataSource=self
        // Do any additional setup after loading the view.
    }
    
    func GetVRICallStatus(){
        
        var URLReqObj = URLRequest(url: URL(string:APIs.getVRICallStatus)!)
        URLReqObj.httpMethod = "POST"
        let parameters: [String: Any] = ["strSearchString": "<Info><CC_ID>\(callID)</CC_ID></Info>"]
        //        URLReqObj.setValue("application/json", forHTTPHeaderFieLoginld: "Content-Type")
        //        URLReqObj.setValue("application/json", forHTTPHeaderField: "Accept")
        print("URL REQUEST IS \(URLReqObj)")
        print("PARAMETERS ARE \(parameters)")
        URLReqObj.httpBody = parameters.percentEncoded()
        var  dataTask = URLSession.shared.dataTask(with: URLReqObj, completionHandler: { (receiveData, connDetails, error) in
            //        do{
            //                   var JsonData = try JSONSerialization.jsonObject(with: receiveData!, options: JSONSerialization.ReadingOptions.allowFragments) as! NSArray
            //            print(JsonData)
            //            let callAvailablility = JsonData.first?["ErrorId"] as? Int ?? 00
            //            print("Call Availability is \(callAvailablility)")
            //
            //        }catch{
            //            print("Something went wrong")
            //        }
            let jsonDecoder = JSONDecoder()
            do {
                let parsedJSON = try jsonDecoder.decode([ApiCallStatusResponseModel].self, from: receiveData!)
                print("PARSED JSON DATA IS \(parsedJSON)")
                let errorID = parsedJSON.first?.errorId ?? "1"
                if errorID == "0" {
                    print("No Call is Available Now")
                }else {
                    print("Call is Available Now")
                    self.hitAcceptMemberApi()
                    self.createTwilioTokenApi()
                }
            }
            catch
            {
                print(error)
            }
        })
        dataTask.resume()
    }
    
    
    func CreateVRICallVendor(){
        var URLReqObj = URLRequest(url: URL(string:APIs.CreateVRICallVendor)!)
        URLReqObj.httpMethod = "POST"
        let parameters: [String: Any] = ["strSearchString": "<VRIVENDOR><ACTION>A</ACTION><ID>0</ID><CCID>\(callID)</CCID><VENDORID>217712</VENDORID><CALLRINGSTATUS>1</CALLRINGSTATUS></VRIVENDOR>"]
        //        URLReqObj.setValue("application/json", forHTTPHeaderFieLoginld: "Content-Type")
        //        URLReqObj.setValue("application/json", forHTTPHeaderField: "Accept")
        print("URL REQUEST IS \(URLReqObj)")
        print("PARAMETERS ARE \(parameters)")
        URLReqObj.httpBody = parameters.percentEncoded()
        var  dataTask = URLSession.shared.dataTask(with: URLReqObj, completionHandler: { (receiveData, connDetails, error) in
            //        do{
            //                   var JsonData = try JSONSerialization.jsonObject(with: receiveData!, options: JSONSerialization.ReadingOptions.allowFragments) as! NSArray
            //            print(JsonData)
            //            let callAvailablility = JsonData.first?["ErrorId"] as? Int ?? 00
            //            print("Call Availability is \(callAvailablility)")
            //
            //        }catch{
            //            print("Something went wrong")
            //        }
            
            let jsonDecoder = JSONDecoder()
            do {
                let parsedJSON = try jsonDecoder.decode([ApiCallStatusResponseModel].self, from: receiveData!)
                print("PARSED JSON IS \(parsedJSON)")
                let errorID = parsedJSON.first?.errorId ?? "0"
                if errorID == "0"
                {
                    print("No Call is Available Now")
                }
                else
                {
                    print("Call is Available Now")
                    self.createTwilioTokenApi()
                }
            } catch
            {
                print(error)
            }
        })
        dataTask.resume()
    }
    
    func hitAcceptMemberApi(){
        var URLReqObj = URLRequest(url: URL(string:APIs.AcceptMember)!)
        URLReqObj.httpMethod = "POST"
        let parameters: [String: Any] = [ "lid": self.lid, "Roomno": self.roomID, "senderid": self.senderid, "touserid": self.touserid, "statustype": 1, "Accepttype": "A", "calltype": "V", "callfrom": "app", "sourceLid": self.sourceLid, "patientname": self.patientname, "patientno": self.patientno, "CallGetInType": "app" ]
        //        URLReqObj.setValue("application/json", forHTTPHeaderFieLoginld: "Content-Type")
        //        URLReqObj.setValue("application/json", forHTTPHeaderField: "Accept")
        print("URL REQUEST IS \(URLReqObj)")
        print("PARAMETERS ARE \(parameters)")
        URLReqObj.httpBody = parameters.percentEncoded()
        var  dataTask = URLSession.shared.dataTask(with: URLReqObj, completionHandler: { (receiveData, connDetails, error) in
            //        do{
            //                   var JsonData = try JSONSerialization.jsonObject(with: receiveData!, options: JSONSerialization.ReadingOptions.allowFragments) as! NSArray
            //            print(JsonData)
            //            let callAvailablility = JsonData.first?["ErrorId"] as? Int ?? 00
            //            print("Call Availability is \(callAvailablility)")
            //
            //        }catch{
            //            print("Something went wrong")
            //        }
            let jsonDecoder = JSONDecoder()
            do {
                let parsedJSON = try jsonDecoder.decode(AcceptMemberResponseModel.self, from: receiveData!)
                //            let errorID = parsedJSON.first?.errorId ?? "0"
                print("ACCEPT MEMBER DATA IS \(parsedJSON)")
            } catch
            {
                print(error)
            }
        })
        dataTask.resume()
    }
    
    
    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        return HalfSizePresentationController(presentedViewController: presented, presenting: presentingViewController)
    }
    /*
     // MARK: - NavigationRat
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
}
class HalfSizePresentationController: UIPresentationController {
    
    override var frameOfPresentedViewInContainerView: CGRect {
        guard let bounds = containerView?.bounds else { return .zero }
        return CGRect(x: 0, y: bounds.height / 2, width: bounds.width, height: bounds.height / 2)
    }
    
}


extension VideoCallViewController{
    
    func createTwilioTokenApi() {
        print("TWILIO SID IS \(self.room?.sid)")
        let headers: HTTPHeaders = [
            "cache-control": "no-cache"
        ]
        print("hitApiGetLatLongFromPostalCode--" ,headers)
        AF.request(APIs.getTwilioToken,
                   method: .get,
                   parameters: nil,
                   encoding: JSONEncoding.default,
                   headers: nil)
            .responseData {
                response in
                switch response.result {
                case .success(_):
                    guard let data = response.data else { return }
                    print("Success hitApiGetBusinessProfile Api ",data)
                    do {
                        let decoder = JSONDecoder()
                        self.apiTwilioTokenResponseModel = try decoder.decode(ApiTwilioTokenResponseModel.self, from: data)
                        let name = self.apiTwilioTokenResponseModel?.sname
                        let identity = self.apiTwilioTokenResponseModel?.identity
                        self.twilioToken = self.apiTwilioTokenResponseModel?.token ?? ""
                        self.connectToARoom()
                        
                    } catch let error {
                        self.view.makeToast("Please try after sometime.", duration: 3.0, position: .center)
                        print(error)
                    }
                case .failure(let error):
                    print(error)
                    self.view.makeToast("Please try after sometime.", duration: 3.0, position: .center)
                }
            }
    }
   
}

extension VideoCallViewController : UITextFieldDelegate,VideoViewDelegate,RemoteParticipantDelegate,MagicTimerViewDelegate {
    
    func timerElapsedTimeDidChange(timer: MagicTimerView, elapsedTime: TimeInterval) {
        print("Elapsed time is \(elapsedTime)")
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        //        self.connect(sender: textField)
        return true
    }
    func cameraSourceDidFail(source: CameraSource, error: Error) {
        logMessage(messageText: "Camera source failed with error: \(error.localizedDescription)")
    }
    func videoViewDimensionsDidChange(view: VideoView, dimensions: CMVideoDimensions) {
        self.view.setNeedsLayout()
    }
    
    func remoteParticipantDidPublishVideoTrack(participant: RemoteParticipant, publication: RemoteVideoTrackPublication) {
        // Remote Participant has offered to share the video Track.
        
        logMessage(messageText: "Participant \(participant.identity) published \(publication.trackName) video track")
        self.testingVideoTrack.append(publication)
        //        self.videoViewCollectionView.reloadData()
    }
    
    func remoteParticipantDidUnpublishVideoTrack(participant: RemoteParticipant, publication: RemoteVideoTrackPublication) {
        // Remote Participant has stopped sharing the video Track.
        logMessage(messageText: "Participant \(participant.identity) unpublished \(publication.trackName) video track")
    }
    func remoteParticipantDidPublishAudioTrack(participant: RemoteParticipant, publication: RemoteAudioTrackPublication) {
        // Remote Participant has offered to share the audio Track.
        
        logMessage(messageText: "Participant \(participant.identity) published \(publication.trackName) audio track")
    }
    
    func remoteParticipantDidUnpublishAudioTrack(participant: RemoteParticipant, publication: RemoteAudioTrackPublication) {
        // Remote Participant has stopped sharing the audio Track.
        logMessage(messageText: "Participant \(participant.identity) unpublished \(publication.trackName) audio track")
    }
    
    func didSubscribeToVideoTrack(videoTrack: RemoteVideoTrack, publication: RemoteVideoTrackPublication, participant: RemoteParticipant) {
        // The LocalParticipant is subscribed to the RemoteParticipant's video Track. Frames will begin to arrive now.
        
        logMessage(messageText: "Subscribed to \(publication.trackName) video track for Participant \(participant.identity)")
        //        self.videoViewCollectionView.reloadData()
        if (self.remoteParticipant == nil) {
            _ = renderRemoteParticipant(participant: participant)
        }
    }
    
    func didUnsubscribeFromVideoTrack(videoTrack: RemoteVideoTrack, publication: RemoteVideoTrackPublication, participant: RemoteParticipant) {
        // We are unsubscribed from the remote Participant's video Track. We will no longer receive the
        // remote Participant's video.
        logMessage(messageText: "Unsubscribed from \(publication.trackName) video track for Participant \(participant.identity)")
        if self.remoteParticipant == participant {
            cleanupRemoteParticipant()
            // Find another Participant video to render, if possible.
            if var remainingParticipants = room?.remoteParticipants,
               let index = remainingParticipants.firstIndex(of: participant) {
                remainingParticipants.remove(at: index)
                renderRemoteParticipants(participants: remainingParticipants)
            }
        }
    }
    
    func didSubscribeToAudioTrack(audioTrack: RemoteAudioTrack, publication: RemoteAudioTrackPublication, participant: RemoteParticipant) {
        // We are subscribed to the remote Participant's audio Track. We will start receiving the
        // remote Participant's audio now.
        logMessage(messageText: "Subscribed to \(publication.trackName) audio track for Participant \(participant.identity)")
    }
    
    func didUnsubscribeFromAudioTrack(audioTrack: RemoteAudioTrack, publication: RemoteAudioTrackPublication, participant: RemoteParticipant) {
        // We are unsubscribed from the remote Participant's audio Track. We will no longer receive the
        // remote Participant's audio.
        logMessage(messageText: "Unsubscribed from \(publication.trackName) audio track for Participant \(participant.identity)")
    }
    
    func remoteParticipantDidEnableVideoTrack(participant: RemoteParticipant, publication: RemoteVideoTrackPublication) {
        logMessage(messageText: "Participant \(participant.identity) enabled \(publication.trackName) video track")
    }
    
    func remoteParticipantDidDisableVideoTrack(participant: RemoteParticipant, publication: RemoteVideoTrackPublication) {
        logMessage(messageText: "Participant \(participant.identity) disabled \(publication.trackName) video track")
    }
    
    
    
    
    func remoteParticipantDidEnableAudioTrack(participant: RemoteParticipant, publication: RemoteAudioTrackPublication) {
        logMessage(messageText: "Participant \(participant.identity) enabled \(publication.trackName) audio track")
    }
    
    func remoteParticipantDidDisableAudioTrack(participant: RemoteParticipant, publication: RemoteAudioTrackPublication) {
        logMessage(messageText: "Participant \(participant.identity) disabled \(publication.trackName) audio track")
    }
    
    func didFailToSubscribeToAudioTrack(publication: RemoteAudioTrackPublication, error: Error, participant: RemoteParticipant) {
        logMessage(messageText: "FailedToSubscribe \(publication.trackName) audio track, error = \(String(describing: error))")
    }
    
    func didFailToSubscribeToVideoTrack(publication: RemoteVideoTrackPublication, error: Error, participant: RemoteParticipant) {
        logMessage(messageText: "FailedToSubscribe \(publication.trackName) video track, error = \(String(describing: error))")
    }
    func roomDidConnect(room: Room) {
        logMessage(messageText: "Connected to room \(room.name) as \(room.localParticipant?.identity ?? "")")
        print("TWILIO SID for ROOM IS IS \(room.sid)")
        self.roomSid = room.sid
        //        timerCountUpView.startCounting()
        self.startTimer()
        // This example only renders 1 RemoteVideoTrack at a time. Listen for all events to decide which track to render.
        for remoteParticipant in room.remoteParticipants {
            remoteParticipant.delegate = self
        }
        
    }
    
    func roomDidDisconnect(room: Room, error: Error?) {
        logMessage(messageText: "Disconnected from room \(room.name), error = \(String(describing: error))")
        
        print("REMOTE PARTICIPANT DID DISCOUNT \(remoteParticipant)")
        //        self.cleanupRemoteParticipant()
        //        self.room = nil
        self.showRoomUI(inRoom: false)
    }
    
    func roomDidFailToConnect(room: Room, error: Error) {
        logMessage(messageText: "Failed to connect to room with error = \(String(describing: error))")
        self.room = nil
        self.showRoomUI(inRoom: false)
    }
    
    func roomIsReconnecting(room: Room, error: Error) {
        logMessage(messageText: "Reconnecting to room \(room.name), error = \(String(describing: error))")
    }
    
    func roomDidReconnect(room: Room) {
        logMessage(messageText: "Reconnected to room \(room.name)")
    }
    
    func participantDidConnect(room: Room, participant: RemoteParticipant) {
        // Listen for events from all Participants to decide which RemoteVideoTrack to render.
        
        print("CONNECTED REMOTE PARTICPANT IS \(participant)")
        self.remoteParticipantList.append(participant)
        participant.delegate = self
//        DispatchQueue.main.async {
//            self.videoViewCollectionView.reloadData()
//        }
        logMessage(messageText: "Participant \(participant.identity) connected with \(participant.remoteAudioTracks.count) audio and \(participant.remoteVideoTracks.count) video tracks")
        print("NEWWW PARTICIPANT CONNECTED \(participant)")
        
    }
    
    func participantDidDisconnect(room: Room, participant: RemoteParticipant) {
        logMessage(messageText: "Room \(room.name), Participant \(participant.identity) disconnected")
        print("ROOM \(room.name) Particpant \(participant.identity) disconnected")
        // Nothing to do in this example. Subscription events are used to add/remove renderers.
        print("Call ended")
        //        timerCountUpView.stopCounting()
        timer.invalidate()
        //        self.previewView.isHidden=true
        let vc = self.storyboard?.instantiateViewController(identifier: "RatingViewController") as! RatingViewController
        vc.roomNo = String(self.roomID)
        vc.type = "Video"
        vc.vendorID = self.touserid
        vc.customerName = self.customerName
        vc.customerImage = self.customerImage
        vc.translateLanguage1 = self.languageTest1
        vc.translateLanguage2 = self.languageTest2
        vc.vendorID = self.senderid
        vc.callDuration = self.timeIntervalLbl.text ?? ""
        vc.modalPresentationStyle = .overCurrentContext
        self.present(vc, animated: true, completion: nil)
    }
    
    
    func startPreview() {
        if PlatformUtils.isSimulator {
            return
        }
        
        let frontCamera = CameraSource.captureDevice(position: .front)
        let backCamera = CameraSource.captureDevice(position: .back)
        
        if (frontCamera != nil || backCamera != nil) {
            
            let options = CameraSourceOptions { (builder) in
                if #available(iOS 13.0, *) {
                    // Track UIWindowScene events for the key window's scene.
                    // The example app disables multi-window support in the .plist (see UIApplicationSceneManifestKey).
                    builder.orientationTracker = UserInterfaceTracker(scene: UIApplication.shared.keyWindow!.windowScene!)
                }
            }
            
            // Preview our local camera track in the local video preview view.
            camera = CameraSource(options: options, delegate: self)
            localVideoTrack = LocalVideoTrack(source: camera!, enabled: true, name: "Camera")
            // Add renderer to video track for local preview
            localVideoTrack!.addRenderer(self.previewView)
            logMessage(messageText: "Video track created")
            if (frontCamera != nil && backCamera != nil) {
                // We will flip camera on tap.
                //                let tap = UITapGestureRecognizer(target: self, action: #selector(VideoCallViewController.flipCamera))
                //                self.previewView.addGestureRecognizer(tap)
            }
            
            camera!.startCapture(device: frontCamera != nil ? frontCamera! : backCamera!) { (captureDevice, videoFormat, error) in
                if let error = error {
                    self.logMessage(messageText: "Capture failed with error.\ncode = \((error as NSError).code) error = \(error.localizedDescription)")
                } else {
                    self.previewView.shouldMirror = (captureDevice.position == .front)
                }
            }
        }
        else {
            self.logMessage(messageText:"No front or back capture device found!")
        }
    }
    
    //    @objc func flipCamera()
    
    
    @IBAction func disableCameraView(){
        
    }
    
    
    
    @IBAction func clipCameraView(){
        var newDevice: AVCaptureDevice?
        
        if let camera = self.camera, let captureDevice = camera.device {
            if captureDevice.position == .front {
                newDevice = CameraSource.captureDevice(position: .back)
            } else {
                newDevice = CameraSource.captureDevice(position: .front)
            }
            
            if let newDevice = newDevice {
                camera.selectCaptureDevice(newDevice) { (captureDevice, videoFormat, error) in
                    if let error = error {
                        self.logMessage(messageText: "Error selecting capture device.\ncode = \((error as NSError).code) error = \(error.localizedDescription)")
                    } else {
                        self.previewView.shouldMirror = (captureDevice.position == .front)
                    }
                }
            }
        }
    }
    
    
    func prepareLocalMedia() {
        
        // We will share local audio and video when we connect to the Room.
        
        // Create an audio track.
        if (localAudioTrack == nil) {
            localAudioTrack = LocalAudioTrack(options: nil, enabled: true, name: "Microphone")
            
            if (localAudioTrack == nil) {
                logMessage(messageText: "Failed to create audio track")
            }
        }
        
        // Create a video track which captures from the camera.
        if (localVideoTrack == nil) {
            self.startPreview()
        }
    }
    
    // Update our UI based upon if we are in a Room or not
    
    func showRoomUI(inRoom: Bool) {
        //        self.connectButton.isHidden = inRoom
        //        self.roomTextField.isHidden = inRoom
        //        self.roomLine.isHidden = inRoom
        //        self.roomLabel.isHidden = inRoom
        //        self.micButton.isHidden = !inRoom
        //        self.disconnectButton.isHidden = !inRoom
        //        self.navigationController?.setNavigationBarHidden(inRoom, animated: true)
        //        UIApplication.shared.isIdleTimerDisabled = inRoom
        // Show / hide the automatic home indicator on modern iPhones.
        self.setNeedsUpdateOfHomeIndicatorAutoHidden()
    }
    
    
    @objc func dismissKeyboard() {
        //        if (self.roomTextField.isFirstResponder) {
        ////            self.roomTextField.resignFirstResponder()
        //        }
    }
    
    func logMessage(messageText: String) {
        NSLog(messageText)
        print("Message is \(messageText)")
    }
    
    func renderRemoteParticipant(participant : RemoteParticipant) -> Bool {
        // This example renders the first subscribed RemoteVideoTrack from the RemoteParticipant.
        
        let videoPublications = participant.remoteVideoTracks
        
        for publication in videoPublications {
            
            if let subscribedVideoTrack = publication.remoteTrack,
               publication.isTrackSubscribed {
//                                testingVideoTrack.append(publication)
                                         setupRemoteVideoView()
                                         subscribedVideoTrack.addRenderer(self.remoteView!)
                self.remoteParticipant = participant
                //                    self.videoViewCollectionView.reloadData()
                return true
            }
        }
        
        return false
    }
    
    func renderRemoteParticipants(participants : Array<RemoteParticipant>) {
        print("PARTICIPANT COUNT IS \(participants.count) abd participants are \(participants)")
        for participant in participants {
            // Find the first renderable track.
            if participant.remoteVideoTracks.count > 0,
               renderRemoteParticipant(participant: participant) {
                break
            }
        }
    }
    
    func dominantSpeakerDidChange(room: Room, participant: RemoteParticipant?) {
        print("DOMINANT SPEAKER IS \(participant.debugDescription)")
        print("DOMINANT SPEAKER IS \(participant)")
    }
    
    func cleanupRemoteParticipant() {
        if self.remoteParticipant != nil {
            self.remoteView?.removeFromSuperview()
            self.remoteView = nil
            self.remoteParticipant = nil
        }
    }
    
    func setupRemoteVideoView() {
        // Creating `VideoView` programmatically
        self.remoteView = VideoView(frame: CGRect.zero, delegate: self)
        self.view.insertSubview(self.remoteView!, at: 0)
        self.remoteView!.contentMode = .scaleAspectFill;
        let centerX = NSLayoutConstraint(item: self.remoteView!,
                                         attribute: NSLayoutConstraint.Attribute.centerX,
                                         relatedBy: NSLayoutConstraint.Relation.equal,
                                         toItem: self.view,
                                         attribute: NSLayoutConstraint.Attribute.centerX,
                                         multiplier: 1,
                                         constant: 0);
        self.view.addConstraint(centerX )
        let centerY = NSLayoutConstraint(item: self.remoteView!,
                                         attribute: NSLayoutConstraint.Attribute.centerY,
                                         relatedBy: NSLayoutConstraint.Relation.equal,
                                         toItem: self.view,
                                         attribute: NSLayoutConstraint.Attribute.centerY,
                                         multiplier: 1,
                                         constant: 0);
        self.view.addConstraint(centerY)
        let width = NSLayoutConstraint(item: self.remoteView!,
                                       attribute: NSLayoutConstraint.Attribute.width,
                                       relatedBy: NSLayoutConstraint.Relation.equal,
                                       toItem: self.view,
                                       attribute: NSLayoutConstraint.Attribute.width,
                                       multiplier: 1,
                                       constant: 0);
        self.view.addConstraint(width)
        let height = NSLayoutConstraint(item: self.remoteView!,
                                        attribute: NSLayoutConstraint.Attribute.height,
                                        relatedBy: NSLayoutConstraint.Relation.equal,
                                        toItem: self.view,
                                        attribute: NSLayoutConstraint.Attribute.height,
                                        multiplier: 1,
                                        constant: 0);
        self.view.addConstraint(height)
    }
    
    func connectToARoom() {
        //        self.connectButton.isEnabled = true;
        // Prepare local media which we will share with Room Participants.
        self.prepareLocalMedia()
        // Preparing the connect options with the access token that we fetched (or hardcoded).
        let connectOptions = ConnectOptions(token: twilioToken) { (builder) in
            // Use the local media that we prepared earlier.
            builder.audioTracks = self.localAudioTrack != nil ? [self.localAudioTrack!] : [LocalAudioTrack]()
            builder.videoTracks = self.localVideoTrack != nil ? [self.localVideoTrack!] : [LocalVideoTrack]()
            
            // Use the preferred audio codec
            if let preferredAudioCodec = Settings.shared.audioCodec {
                builder.preferredAudioCodecs = [preferredAudioCodec]
            }
            // Use the preferred video codec
            if let preferredVideoCodec = Settings.shared.videoCodec {
                builder.preferredVideoCodecs = [preferredVideoCodec]
            }
            
            // Use the preferred encoding parameters
            if let encodingParameters = Settings.shared.getEncodingParameters() {
                builder.encodingParameters = encodingParameters
            }
            
            // Use the preferred signaling region
            if let signalingRegion = Settings.shared.signalingRegion {
                builder.region = signalingRegion
            }
            // The name of the Room where the Client will attempt to connect to. Please note that if you pass an empty
            // Room `name`, the Client will create one for you. You can get the name or sid from any connected Room.
            builder.roomName = "\(self.roomID)"
        }
        
        // Connect to the Room using the options we provided.
        room = TwilioVideoSDK.connect(options: connectOptions, delegate: self)
        
        logMessage(messageText: "Attempting to connect to room \(String(describing: self.roomID))")
        
        self.showRoomUI(inRoom: true)
        self.dismissKeyboard()
    }
    
}

extension VideoCallViewController:UICollectionViewDelegate,UICollectionViewDataSource{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        print("REMOTE PARTICIPANT COUNT IS \(self.remoteParticipantList.count)")
        return self.remoteParticipantList.count + 1
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let callCell = videoViewCollectionView.dequeueReusableCell(withReuseIdentifier: "VideoCell", for: indexPath) as! VideoCell
        if(indexPath.row == 0){
            localVideoTrack?.removeRenderer(callCell.ContainerView)
            callCell.audioCallImg.isHidden = true
            callCell.privacyView.isHidden = true
            if((self.localVideoTrack?.isEnabled ?? false)){
                localVideoTrack!.addRenderer(callCell.ContainerView)
            }
            else{
                //                callCell.privacyView.isHidden = true
            }
            
            //                       if(self.isLowNetwork){
            //                           callCell.privacyView.hidden = NO;
            //                       }
            //                       else{
            //                           callCell.privacyView.hidden = YES;
            //                       }
            callCell.speakerImg.image = UIImage(named: "")
            //            self.localVideoTrack =  [[self.localParticipantsDictionary valueForKey:@"0"] valueForKey:@"videoTrak"];
            //
            //                           if(videoT != nil){
            //                               [videoT addRenderer:remoteView];
            //                           }
            
            //                if(indexPath.row == 0){
            //                callCell.contentView.layer.borderColor = UIColor.clear.cgColor
            //                callCell.contentView.layer.borderWidth = 0;
            //                callCell.talkingView.isHidden = true
            //                callCell.pinBtn.isHidden = true
            //                             }
            return  callCell;
        } else{
            
            //            self.remoteParticipantList[indexPath.row - 1].remoteVideoTracks.first?.videoTrack?.removeRenderer(callCell.ContainerView!)
            self.remoteParticipantList[indexPath.row - 1].remoteVideoTracks.forEach { RemoteVideoTrackPublication in
                RemoteVideoTrackPublication.remoteTrack?.removeRenderer(callCell.ContainerView)
            }
            
            
            print("INDEX PATH IS \(indexPath.row)")
            print("REMOTE VIDEO TRACK IS \(self.remoteParticipantList[indexPath.row - 1].remoteVideoTracks)")
            print("REMOTE VIDEO TRACKS IS \(self.remoteParticipantList[indexPath.row - 1].remoteVideoTracks.first?.videoTrack)")
            //            callCell.ContainerView.invalidateRenderer()
            //            self.remoteParticipantList[indexPath.row - 1].remoteVideoTracks.first?.videoTrack?.addRenderer(callCell.ContainerView)
            self.remoteParticipantList[indexPath.row - 1].remoteVideoTracks.forEach { RemoteVideoTrackPublication in
                RemoteVideoTrackPublication.remoteTrack?.addRenderer(callCell.ContainerView)
            }
            //            self.remoteParticipantList[indexPath.row - 1].remoteVideoTracks[indexPath.row - 1].videoTrack?.addRenderer(callCell.ContainerView)
        }
        return callCell
    }
}



extension VideoCallViewController{
    
    func hitroomDidDisconnectApi(){
        //        var URLReqObj = URLRequest(url: URL(string:"https://sai2.smsionline.com/roomdisconnect")!)
        var URLReqObj = URLRequest(url: URL(string:"https://vriservices.totallanguage.com/roomdisconnect")!)
        URLReqObj.httpMethod = "POST"
        let parameters: [String: Any] = [ "status": "completed", "roomSid": self.roomSid]
        //        URLReqObj.setValue("application/json", forHTTPHeaderFieLoginld: "Content-Type")
        //        URLReqObj.setValue("application/json", forHTTPHeaderField: "Accept")
        print("URL REQUEST IS \(URLReqObj)")
        print("PARAMETERS ARE \(parameters)")
        URLReqObj.httpBody = parameters.percentEncoded()
        let  dataTask = URLSession.shared.dataTask(with: URLReqObj, completionHandler: { (receiveData, connDetails, error) in
            let jsonDecoder = JSONDecoder()
            do {
                let parsedJSON = try jsonDecoder.decode(ApiVriCallDisconnetResponseModel.self, from: receiveData!)
                //let errorID = parsedJSON.first?.errorId ?? "0"
                print("ACCEPT MEMBER DATA IS \(parsedJSON)")
                self.timer.invalidate()
                DispatchQueue.main.async {
                    let vc = self.storyboard?.instantiateViewController(identifier: "RatingViewController") as! RatingViewController
                    vc.roomNo = String(self.roomID)
                    vc.type = "Video"
                    vc.vendorID = self.touserid
                    vc.customerName = self.customerName
                    vc.customerImage = self.customerImage
                    vc.translateLanguage1 = self.languageTest1
                    vc.translateLanguage2 = self.languageTest2
                    vc.vendorID = self.senderid
                    vc.callDuration = self.timeIntervalLbl.text ?? ""
                    vc.modalPresentationStyle = .overCurrentContext
                    self.present(vc, animated: true, completion: nil)
                }
            } catch
            {
                print(error)
            }
        })
        dataTask.resume()
    }
    
    func hitConferenceParticipantApi(){
        var URLReqObj = URLRequest(url: URL(string:"https://lspservices.smsionline.com/roomdisconnect")!)
        URLReqObj.httpMethod = "POST"
        let parameters: [String: Any] = ["strSearchString": "<Info><ACTION>D</ACTION><ACTUALROOM>\(self.roomID)</ACTUALROOM><CALL>0</CALL></Info>"]
        //        URLReqObj.setValue("application/json", forHTTPHeaderFieLoginld: "Content-Type")
        //        URLReqObj.setValue("application/json", forHTTPHeaderField: "Accept")
        print("URL REQUEST IS \(URLReqObj)")
        print("PARAMETERS ARE \(parameters)")
        URLReqObj.httpBody = parameters.percentEncoded()
        var  dataTask = URLSession.shared.dataTask(with: URLReqObj, completionHandler: { (receiveData, connDetails, error) in
            //        do{
            //                   var JsonData = try JSONSerialization.jsonObject(with: receiveData!, options: JSONSerialization.ReadingOptions.allowFragments) as! NSArray
            //            print(JsonData)
            //            let callAvailablility = JsonData.first?["ErrorId"] as? Int ?? 00
            //            print("Call Availability is \(callAvailablility)")
            //
            //        }catch{
            //            print("Something went wrong")
            //        }
            
            let jsonDecoder = JSONDecoder()
            do {
                let parsedJSON = try jsonDecoder.decode(ApiVriCallDisconnetResponseModel.self, from: receiveData!)
                //            let errorID = parsedJSON.first?.errorId ?? "0"
                let status = self.apiVriCallDisconnetResponseModel?.status
                print("ACCEPT MEMBER DATA IS \(parsedJSON)")
                if (status != nil) == true {
                    print("apiVriCallDisconnectResonseModel",self.apiVriCallDisconnetResponseModel)
                }
            } catch
            {
                print(error)
            }
        })
        dataTask.resume()
    }
    func hitUpdateVRIRoomData(){
        var URLReqObj = URLRequest(url: URL(string:"https://lsp.smsionline.com/Appointment/updateVriRoomData")!)
        URLReqObj.httpMethod = "POST"
        let parameters: [String: Any] = ["RoomSid": self.roomSid]
        //        URLReqObj.setValue("application/json", forHTTPHeaderFieLoginld: "Content-Type")
        //        URLReqObj.setValue("application/json", forHTTPHeaderField: "Accept")
        print("URL REQUEST IS \(URLReqObj)")
        print("PARAMETERS ARE \(parameters)")
        URLReqObj.httpBody = parameters.percentEncoded()
        var  dataTask = URLSession.shared.dataTask(with: URLReqObj, completionHandler: { (receiveData, connDetails, error) in
            //        do{
            //                   var JsonData = try JSONSerialization.jsonObject(with: receiveData!, options: JSONSerialization.ReadingOptions.allowFragments) as! NSArray
            //            print(JsonData)
            //            let callAvailablility = JsonData.first?["ErrorId"] as? Int ?? 00
            //            print("Call Availability is \(callAvailablility)")
            //
            //        }catch{
            //            print("Something went wrong")
            //        }
            let jsonDecoder = JSONDecoder()
            do {
                let parsedJSON = try jsonDecoder.decode(ApiVriCallDisconnetResponseModel.self, from: receiveData!)
                //            let errorID = parsedJSON.first?.errorId ?? "0"
                print("ACCEPT MEMBER DATA IS \(parsedJSON)")
            } catch
            {
                print(error)
            }
        })
        dataTask.resume()
    }
}
struct ApiVriCallDisconnetResponseModel : Codable {
    let status : Int?
    enum CodingKeys: String, CodingKey {
        case status = "status"
    }
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        status = try values.decodeIfPresent(Int.self, forKey: .status)
    }
    
}

struct ApiConferenceParticipantResponseModel : Codable {
    let id : String?
    let errorId : String?
    enum CodingKeys: String, CodingKey {
        case id = "Id"
        case errorId = "ErrorId"
    }
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decodeIfPresent(String.self, forKey: .id)
        errorId = try values.decodeIfPresent(String.self, forKey: .errorId)
    }
    
}



class VideoCell : UICollectionViewCell{
    
    @IBOutlet weak var ContainerView : VideoView!
    @IBOutlet weak var talkingView : UIView!
    @IBOutlet weak var privacyView : UIView!
    @IBOutlet weak var pinBtn : UIButton!
    @IBOutlet weak var speakerImg : UIImageView!
    @IBOutlet weak var audioCallImg : UIView!
    
    
}


protocol VideoTrack: AnyObject {
    var isSwitchedOff: Bool { get }
    var isEnabled: Bool { get }
    var priority: Track.Priority? { get set }
    var renderers: [VideoRenderer] { get }
    func addRenderer(_ renderer: VideoRenderer)
    func removeRenderer(_ renderer: VideoRenderer)
}
