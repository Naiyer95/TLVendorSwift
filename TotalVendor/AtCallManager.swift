//
//  AtCallManager.swift
//  TotalVendor
//
//  Created by Darrin Brooks on 24/09/21.
//
import CallKit
import Foundation
import UIKit

class ATCallManager: NSObject {
    
    static let shared: ATCallManager = ATCallManager()
    
    private var provider: CXProvider?
    
    private override init() {
        super.init()
        self.configureProvider()
    }
    
    private func configureProvider() {
        let config = CXProviderConfiguration(localizedName: "AT Call")
        config.supportsVideo = true
        config.supportedHandleTypes = [.emailAddress]
        
        provider = CXProvider(configuration: config)
        provider?.setDelegate(self, queue: DispatchQueue.main)
    }
    
    public func incommingCall(from: String, delay: TimeInterval) {
        let update = CXCallUpdate()
        update.remoteHandle = CXHandle(type: .emailAddress, value: from)
        
        let bgTaskID = UIApplication.shared.beginBackgroundTask(expirationHandler: nil)
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + delay) {
            self.provider?.reportNewIncomingCall(with: UUID(), update: update, completion: { (_) in })
            UIApplication.shared.endBackgroundTask(bgTaskID)
        }
    }
    
    public func outgoingCall(from: String, connectAfter: TimeInterval) {
        let controller = CXCallController()
        let fromHandle = CXHandle(type: .emailAddress, value: from)
        let startCallAction = CXStartCallAction(call: UUID(), handle: fromHandle)
        startCallAction.isVideo = true
        let startCallTransaction = CXTransaction(action: startCallAction)
        controller.request(startCallTransaction) { (error) in }
        
        self.provider?.reportOutgoingCall(with: startCallAction.callUUID, startedConnectingAt: nil)
        
        let bgTaskID = UIApplication.shared.beginBackgroundTask(expirationHandler: nil)
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + connectAfter) {
            self.provider?.reportOutgoingCall(with: startCallAction.callUUID, connectedAt: nil)
            UIApplication.shared.endBackgroundTask(bgTaskID)
        }
    }
}

extension ATCallManager: CXProviderDelegate {
    func providerDidReset(_ provider: CXProvider) {
        print("provider did reset")
    }
    
    func provider(_ provider: CXProvider, perform action: CXAnswerCallAction) {
        print("call answered")
        action.fulfill()
    }
    
    func provider(_ provider: CXProvider, perform action: CXEndCallAction) {
        print("call ended")
        action.fulfill()
    }
    
    func provider(_ provider: CXProvider, perform action: CXStartCallAction) {
        print("call started")
        action.fulfill()
    }
}
