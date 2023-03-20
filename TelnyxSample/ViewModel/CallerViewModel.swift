//
//  CallerViewModel.swift
//  TelnyxSample
//
//  Created by Mostafa Elbaz on 19/03/2023.
//

import Foundation
import UIKit

protocol CallerViewModelDelegate: AnyObject {
    func callSuccessful(callerName: String)
    func callFailed(error: Error)
    func didReceiveCall(callerName: String)
    func didEndCall()
}


class CallerViewModel {
    weak var delegate: CallerViewModelDelegate?
    var callManager: CallerManagerProtocol
    
    init(delegate: CallerViewModelDelegate? = nil, callManager: CallerManagerProtocol) {
        self.delegate = delegate
        self.callManager = callManager
        self.callManager.delegate = self
    }
    

    func makeCall(destinationNumber: String) {
        callManager.executeStartCallAction(destinationNumber: destinationNumber, uuid: UUID(), handle: "TelnyxSample")
        
    }
    
    func hangout() {
        callManager.executeEndCallAction(uuid: UUID())
    }
    
    func answer() {
        callManager.executeAnswerCallAction(uuid: UUID())
    }
}

extension CallerViewModel: CallerManagerDelegate {
    func didEndCall() {
        delegate?.didEndCall()
    }
    
    func didStartCall(callerName: String) {
        delegate?.callSuccessful(callerName: callerName)
    }
    
    func didReceiveCall(callerName: String) {
        self.delegate?.didReceiveCall(callerName: callerName)
    }
    
    
}
