//
//  VendorCallHistoryViewController.swift
//  TotalVendor
//
//  Created by Darrin Brooks on 12/08/21.
//

import UIKit
import ARKit
import CallKit
import TwilioVideo
import TwilioVoice
import SceneKit

class VendorCallHistoryViewController: UIViewController , UISceneDelegate{
    
    
//    var room: Room?
//    var consumer:TVIVideoCaptureConsumer?
//    var frame: VideoFrame?
//    var displayLink: CADisplayLink?
//
//
//    var supportedFormats = [VideoFormat]()
//    var videoTrack: LocalVideoTrack?
//    var audioTrack: LocalAudioTrack?
//    var sceneView = SceneView()
//
        override func viewDidLoad() {
        super.viewDidLoad()
//
//        // Set the view's delegate
//                sceneView.delegate = self
//
//                // Show statistics such as fps and timing information
//                sceneView.showsStatistics = true
//                self.sceneView.preferredFramesPerSecond = 30
//                self.sceneView.contentScaleFactor = 1
//
//                // Create a new scene
//                let scene = SCNScene(named: "art.scnassets/ship.scn")!
//
//                // Set the scene to the view
//                self.sceneView.scene = scene
//        self.supportedFormats = [VideoFormat()]
//                sceneView.debugOptions =
//                      [ARSCNDebugOptions.showFeaturePoints, ARSCNDebugOptions.showWorldOrigin] //show feature points
//                self.videoTrack = TVILocalVideoTrack.init(capturer: self)
//        self.audioTrack = LocalAudioTrack.init()
//                let token = TWILIO-ACCESS-TOKEN
//                let options = TVIConnectOptions.init(token: token, block: {(builder: TVIConnectOptionsBuilder) -> Void in
//                    builder.videoTracks = [self.videoTrack!]
//                    builder.roomName = "Arkit"
//                })
//        self.room = TwilioVideo.connect(options, self as? TVIRoomDelegate, <#socklen_t#>)
//
//        // Do any additional setup after loading the view.
    }
    
//    func startCapture(format: VideoFormat, consumer: TVIVideoCaptureConsumer) {
//            self.consumer = consumer
//            self.displayLink = CADisplayLink(target: self, selector: #selector(self.displayLinkDidFire))
//            self.displayLink?.preferredFramesPerSecond = self.sceneView.preferredFramesPerSecond
//        displayLink?.add(to: RunLoop.main, forMode: RunLoopMode.RunLoop.Mode.common)
//            consumer.captureDidStart(true)
//        }
//
//
//
//    @objc func displayLinkDidFire() {
//            let myImage = self.sceneView.snapshot
//            let imageRef = myImage().cgImage!
//            let pixelBuffer = self.pixelBufferFromCGImage(fromCGImage: imageRef)
//            self.frame = TVIVideoFrame(timestamp: Int64((displayLink?.timestamp)! * 1000000), buffer: pixelBuffer, orientation: TVIVideoOrientation.up)
//            self.consumer?.consumeCapturedFrame(self.frame!)
//        }
//
//    func pixelBufferFromCGImage(fromCGImage image: CGImage) -> CVPixelBuffer {
//            let frameSize = CGSize(width: image.width, height: image.height)
//            let options: [AnyHashable: Any]? = [kCVPixelBufferCGImageCompatibilityKey: false, kCVPixelBufferCGBitmapContextCompatibilityKey: false]
//            var pixelBuffer: CVPixelBuffer? = nil
//            let status: CVReturn? = CVPixelBufferCreate(kCFAllocatorDefault, Int(frameSize.width), Int(frameSize.height), kCVPixelFormatType_32ARGB, (options! as CFDictionary), &pixelBuffer)
//            if status != kCVReturnSuccess {
//                return NSNull.self as! CVPixelBuffer
//            }
//            CVPixelBufferLockBaseAddress(pixelBuffer!, CVPixelBufferLockFlags(rawValue: 0))
//            let data = CVPixelBufferGetBaseAddress(pixelBuffer!)
//            let rgbColorSpace: CGColorSpace? = CGColorSpaceCreateDeviceRGB()
//            let context = CGContext(data: data, width: Int(frameSize.width), height: Int(frameSize.height), bitsPerComponent: 8, bytesPerRow: CVPixelBufferGetBytesPerRow(pixelBuffer!), space: rgbColorSpace!, bitmapInfo: (CGImageAlphaInfo.noneSkipLast.rawValue))
//            context?.draw(image, in: CGRect(x:0, y:0, width: image.width, height: image.height))
//            CVPixelBufferUnlockBaseAddress(pixelBuffer!, CVPixelBufferLockFlags(rawValue: 0))
//            return pixelBuffer!
//        }
//    override func viewWillAppear(_ _animated: Bool) {
//        super.viewWillAppear(animated)
//
//            let configuration = ARWorldTrackingConfiguration()
//            sceneView.session.run(configuration)
//    }
//    override func viewWillDisappear(_ _animated: Bool) {
//        super.viewWillDisappear(animated)
//        sceneView.session.pause()
//    }
//    /*
//    // MARK: - Navigation
//
//    // In a storyboard-based application, you will often want to do a little preparation before navigation
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        // Get the new view controller using segue.destination.
//        // Pass the selected object to the new view controller.
//    }
//    */

}
