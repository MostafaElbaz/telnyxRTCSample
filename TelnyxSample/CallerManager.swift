//
//  CallerManager.swift
//  TelnyxSample
//
//  Created by Mostafa Elbaz on 19/03/2023.
//

import Foundation
import TelnyxRTC
import CallKit
import AVFoundation

protocol CallerManagerDelegate: AnyObject {
    func didReceiveCall(callerName: String)
    func didStartCall(callerName: String)
    func didEndCall()

}

protocol CallerManagerProtocol {
    func login(username: String, password: String, completion: @escaping (Bool) -> Void)
    var delegate: CallerManagerDelegate? { get set }
    func executeEndCallAction(uuid: UUID)
    func executeAnswerCallAction(uuid: UUID)
    func executeStartCallAction(destinationNumber: String, uuid: UUID, handle: String)
}

class CallerManager: NSObject, CallerManagerProtocol {
    
    private let telnyxClient: TxClient
    var currentCall: Call?
    var callKitUUID: UUID?
    var callKitProvider: CXProvider?
    let callKitCallController = CXCallController()
    weak var delegate: CallerManagerDelegate?
    
    var currentUserName: String?
    
    var didLoginSuccessfully:((Bool) -> Void)?
    
    override init() {
        // Initialize the Telnyx client
//        super.init()
        telnyxClient = TxClient()
        super.init()
        telnyxClient.delegate = self
        self.initCallKit()
    }
    
    func initCallKit() {
        let configuration = CXProviderConfiguration(localizedName: "TelnyxRTC")
        configuration.maximumCallGroups = 1
        configuration.maximumCallsPerCallGroup = 1
        callKitProvider = CXProvider(configuration: configuration)
        if let provider = callKitProvider {
            provider.setDelegate(self, queue: nil)
        }
    }
    
    func login(username: String, password: String, completion: @escaping (Bool) -> Void) {
        // Use the Telnyx client to login
        didLoginSuccessfully = completion
        let txConfig = TxConfig(sipUser: username, password: password, logLevel: .all)
        
        do {
//            telnyxClient.delegate = self
            try self.telnyxClient.connect(txConfig: txConfig)
            currentUserName = username
        } catch let error {
            
        }

    }
    
    func makeCall(destinationNumber: String) {
//        print("AppDelegate:: START call action: callKitUUID [\(String(describing: self.callKitUUID))] action [\(action.callUUID)]")
//        self.callKitUUID = action.callUUID
        do {
            let call = try telnyxClient.newCall(callerName: currentUserName!,
                                                 callerNumber: currentUserName!,
                                                 destinationNumber: destinationNumber,
                                                 callId: UUID())
        } catch {
            print("AppDelegate:: START call action FAILED ")
        }
    }
    
    func answerCall(call: Call) {
        // Use the Telnyx client to answer a call
    }
    
    func endCall(call: Call) {
        // Use the Telnyx client to end a call
    }
    
    
    
}

extension CallerManager: TxClientDelegate {
    
    func onSocketConnected() {
        print("AppDelegate:: TxClientDelegate onSocketConnected()")
        didLoginSuccessfully?(true)
//        self.voipDelegate?.onSocketConnected()
    }
    
    func onSocketDisconnected() {
        print("AppDelegate:: TxClientDelegate onSocketDisconnected()")
        didLoginSuccessfully?(true)
//        self.voipDelegate?.onSocketDisconnected()
    }
    
    func onClientError(error: Error) {
        print("AppDelegate:: TxClientDelegate onClientError() error: \(error)")
//        self.voipDelegate?.onClientError(error: error)
    }
    
    func onClientReady() {
        print("AppDelegate:: TxClientDelegate onClientReady()")
//        self.voipDelegate?.onClientReady()
    }
    
    func onSessionUpdated(sessionId: String) {
        print("AppDelegate:: TxClientDelegate onSessionUpdated() sessionId: \(sessionId)")
//        self.voipDelegate?.onSessionUpdated(sessionId: sessionId)
    }
    
    func onIncomingCall(call: Call) {
        guard let callId = call.callInfo?.callId else {
            print("AppDelegate:: TxClientDelegate onIncomingCall() Error unknown call UUID")
            return
        }
        print("AppDelegate:: TxClientDelegate onIncomingCall() callKitUUID [\(String(describing: self.callKitUUID))] callId [\(callId)]")

        if let currentCallUUID = self.currentCall?.callInfo?.callId {
            print("AppDelegate:: TxClientDelegate onIncomingCall() end previous call [\(currentCallUUID)]")
            executeEndCallAction(uuid: currentCallUUID) //Hangup the previous call if there's one active
        }
        self.callKitUUID = call.callInfo?.callId
        self.currentCall = call //Update the current call with the incoming call
        self.newIncomingCall(from: call.callInfo?.callerName ?? "Unknown", uuid: callId)
//        self.voipDelegate?.onIncomingCall(call: call)
    }
    
    func onPushCall(call: Call) {
        print("AppDelegate:: TxClientDelegate onPushCall() \(call)")
        self.currentCall = call //Update the current call with the incoming call
    }
    
    func onRemoteCallEnded(callId: UUID) {
        print("AppDelegate:: TxClientDelegate onRemoteCallEnded() callKitUUID [\(String(describing: self.callKitUUID))] callId [\(callId)]")
//        self.voipDelegate?.onRemoteCallEnded(callId: callId)
        let reason = CXCallEndedReason.remoteEnded
        if let provider = self.callKitProvider,
           let callKitUUID = self.callKitUUID {
            provider.reportCall(with: callKitUUID, endedAt: Date(), reason: reason)
        }
    }
    
    func onCallStateUpdated(callState: CallState, callId: UUID) {
        print("AppDelegate:: TxClientDelegate onCallStateUpdated() callKitUUID [\(String(describing: self.callKitUUID))] callId [\(callId)]")
//        self.voipDelegate?.onCallStateUpdated(callState: callState, callId: callId)
        
        if callState == .DONE {
//            if let currentCallId = self.currentCall?.callInfo?.callId,
//               currentCallId == callId {
                self.currentCall = nil // clear current call
                delegate?.didEndCall()
//            }
        }
    }
}


// MARK: - CXProviderDelegate
extension CallerManager: CXProviderDelegate {

    /// Call this function to tell the CX provider to request the OS to create a new call.
    /// - Parameters:
    ///   - uuid: The UUID of the outbound call
    ///   - handle: A handle for this call
    func executeStartCallAction(destinationNumber: String, uuid: UUID, handle: String) {
        guard let provider = callKitProvider else {
            print("CallKit provider not available")
            return
        }

        let callHandle = CXHandle(type: .generic, value: handle)
        let startCallAction = CXStartCallAction(call: uuid, handle: callHandle)
        let transaction = CXTransaction(action: startCallAction)

        callKitCallController.request(transaction) { [weak self] error in
            if let error = error {
                print("StartCallAction transaction request failed: \(error.localizedDescription)")
                return
            }

            print("StartCallAction transaction request successful")

            let callUpdate = CXCallUpdate()

            callUpdate.remoteHandle = callHandle
            callUpdate.supportsDTMF = true
            callUpdate.supportsHolding = true
            callUpdate.supportsGrouping = false
            callUpdate.supportsUngrouping = false
            callUpdate.hasVideo = false
            provider.reportCall(with: uuid, updated: callUpdate)
            self?.callKitUUID = uuid

            self?.makeCall(destinationNumber: destinationNumber)
            self?.delegate?.didStartCall(callerName: destinationNumber)
        }
    }

    /// Report a new incoming call. This will generate the Native Incoming call notification
    /// - Parameters:
    ///   - from: Caller name
    ///   - uuid: uuid of the incoming call
    func newIncomingCall(from: String, uuid: UUID) {
        print("AppDelegate:: report NEW incoming call from [\(from)] uuid [\(uuid)]")
#if targetEnvironment(simulator)
        //Do not execute this function when debugging on the simulator.
        //By reporting a call through CallKit from the simulator, it automatically cancels the call.
        return
#endif
        
        guard let provider = callKitProvider else {
            print("AppDelegate:: CallKit provider not available")
            return
        }
        
        let callHandle = CXHandle(type: .generic, value: from)
        let callUpdate = CXCallUpdate()
        callUpdate.remoteHandle = callHandle
        callUpdate.hasVideo = false
        
        provider.reportNewIncomingCall(with: uuid, update: callUpdate) { [weak self] error in
            if let error = error {
                print("AppDelegate:: Failed to report incoming call: \(error.localizedDescription).")
            } else {
                print("AppDelegate:: Incoming call successfully reported.")
                
                self?.callKitUUID = uuid
                self?.delegate?.didReceiveCall(callerName: from)
            }
        }
        
        
//        DispatchQueue.main.asyncAfter(deadline: .now() + 10) { [weak self] in
//            guard let callID = self?.currentCall?.callInfo?.callId else { return }
//            self?.executeAnswerCallAction(uuid: callID)
//        }
    }
    
    /// To answer a call using CallKit
    /// - Parameter uuid: the UUID of the CallKit call.
    func executeAnswerCallAction(uuid: UUID) {
        print("AppDelegate:: execute ANSWER call action: callKitUUID [\(String(describing: self.callKitUUID))] uuid [\(uuid)]")
        var endUUID = uuid
        if let callkitUUID = self.callKitUUID {
            endUUID = callkitUUID
        }
        let answerCallAction = CXAnswerCallAction(call: endUUID)
        let transaction = CXTransaction(action: answerCallAction)
        callKitCallController.request(transaction) { error in
            if let error = error {
                print("AppDelegate:: AnswerCallAction transaction request failed: \(error.localizedDescription).")
            } else {
                print("AppDelegate:: AnswerCallAction transaction request successful")
            }
        }
    }

    /// End the current call
    /// - Parameter uuid: The uuid of the call
    func executeEndCallAction(uuid: UUID) {
        print("AppDelegate:: execute END call action: callKitUUID [\(String(describing: self.callKitUUID))] uuid [\(uuid)]")

        var endUUID = uuid
        if let callkitUUID = self.callKitUUID {
            endUUID = callkitUUID
        }

        let endCallAction = CXEndCallAction(call: endUUID)
        let transaction = CXTransaction(action: endCallAction)

        callKitCallController.request(transaction) { error in
            if let error = error {
                #if targetEnvironment(simulator)
                //The simulator does not support to register an incoming call through CallKit.
                //For that reason when an incoming call is received on the simulator,
                //we are updating the UI and not registering the callID to callkit.
                //When the user whats to hangup the call and the incoming call was not registered in callkit,
                //the CXEndCallAction fails. That's why we are manually ending the call in this case.
                self.telnyxClient?.calls[uuid]?.hangup() // end the active call
                #endif
                print("AppDelegate:: EndCallAction transaction request failed: \(error.localizedDescription).")
            } else {
                print("AppDelegate:: EndCallAction transaction request successful")
            }
            self.callKitUUID = nil
        }
    }
    // MARK: - CXProviderDelegate -
    func provider(_ provider: CXProvider, perform action: CXStartCallAction) {
//        print("AppDelegate:: START call action: callKitUUID [\(String(describing: self.callKitUUID))] action [\(action.callUUID)]")
//        self.callKitUUID = action.callUUID
//        do {
//            let call = try telnyxClient.newCall(callerName: "MostafaElbaz1",
//                                                 callerNumber: "callerNumber",
//                                                 destinationNumber: "MostafaElbaz2",
//                                                 callId: UUID())
//        } catch {
//            print("AppDelegate:: START call action FAILED ")
//        }
        //        self.voipDelegate?.executeCall(callUUID: action.callUUID) { call in
//            self.currentCall = call
//            if call != nil {
//                print("AppDelegate:: performVoiceCall() successful")
//                provider.reportOutgoingCall(with: action.callUUID, connectedAt: Date())
//            } else {
//                print("AppDelegate:: performVoiceCall() failed")
//            }
//        }
        action.fulfill()
    }

    func provider(_ provider: CXProvider, perform action: CXAnswerCallAction) {
        print("AppDelegate:: ANSWER call action: callKitUUID [\(String(describing: self.callKitUUID))] action [\(action.callUUID)]")
        self.currentCall?.answer()
        delegate?.didStartCall(callerName: self.currentCall?.callInfo?.callerName ?? "unknowm")
        action.fulfill()
    }

    func provider(_ provider: CXProvider, perform action: CXEndCallAction) {
        print("AppDelegate:: END call action: callKitUUID [\(String(describing: self.callKitUUID))] action [\(action.callUUID)]")
        self.currentCall?.hangup()
        action.fulfill()
    }

    func providerDidReset(_ provider: CXProvider) {
        print("providerDidReset:")
    }
    
    func providerDidBegin(_ provider: CXProvider) {
        print("providerDidBegin")
    }
    
    func provider(_ provider: CXProvider, didActivate audioSession: AVAudioSession) {
        print("provider:didActivateAudioSession:")
        self.telnyxClient.isAudioDeviceEnabled = true
    }
    
    func provider(_ provider: CXProvider, didDeactivate audioSession: AVAudioSession) {
        print("provider:didDeactivateAudioSession:")
        self.telnyxClient.isAudioDeviceEnabled = false
    }
    
    func provider(_ provider: CXProvider, timedOutPerforming action: CXAction) {
        print("provider:timedOutPerformingAction:")
    }
    
    func provider(_ provider: CXProvider, perform action: CXSetHeldCallAction) {
        print("provider:performSetHeldAction:")
    }
    
    func provider(_ provider: CXProvider, perform action: CXSetMutedCallAction) {
        print("provider:performSetMutedAction:")
    }
    
//    func processVoIPNotification(callUUID: UUID) {
//        print("AppDelegate:: processVoIPNotification \(callUUID)")
//        self.callKitUUID = callUUID
//        var serverConfig: TxServerConfiguration
//        let userDefaults = UserDefaults.init()
////        if userDefaults.getEnvironment() == .development {
//            serverConfig = TxServerConfiguration(environment: .development)
////        } else {
////            serverConfig = TxServerConfiguration()
////        }
////
////        let sipUser = userDefaults.getSipUser()
////        let password = userDefaults.getSipUserPassword()
////        let deviceToken = userDefaults.getPushToken()
//        //Sets the login credentials and the ringtone/ringback configurations if required.
//        //Ringtone / ringback tone files are not mandatory.
//        let txConfig = TxConfig(sipUser: "sipUser",
//                                password: "password",
//                                pushDeviceToken: "deviceToken",
//                                ringtone: "incoming_call.mp3",
//                                ringBackTone: "ringback_tone.mp3",
//                                //You can choose the appropriate verbosity level of the SDK.
//                                logLevel: .all)
//
//        do {
//            try telnyxClient?.processVoIPNotification(txConfig: txConfig, serverConfiguration: serverConfig)
//        } catch let error {
//            print("ViewController:: processVoIPNotification Error \(error)")
//        }
//    }
}
