//
//  CallerViewModel.swift
//  TelnyxSample
//
//  Created by Mostafa Elbaz on 19/03/2023.
//

import Foundation
import UIKit

protocol CallerViewModelDelegate: AnyObject {
    func callSuccessful()
    func callFailed(error: Error)
    func didReceiveCall(callerName: String)
}


class CallerViewModel {
    weak var delegate: CallerViewModelDelegate?
    let callManager: CallerManager
    
    init(delegate: CallerViewModelDelegate? = nil, callManager: CallerManager) {
        self.delegate = delegate
        self.callManager = callManager
        self.callManager.delegate = self
    }
    

    func makeCall(destinationNumber: String) {
        
        callManager.executeStartCallAction(uuid: UUID(), handle: "Test")
        delegate?.callSuccessful()
        // make a call with the destination number
        // using the telnyx client
    }
    
    func hangout() {
        
        callManager.executeEndCallAction(uuid: UUID())
//        delegate?.
        // make a call with the destination number
        // using the telnyx client
    }
    
    func answer() {
        
        callManager.executeAnswerCallAction(uuid: UUID())
//        delegate?.
        // make a call with the destination number
        // using the telnyx client
    }
}

extension CallerViewModel: CallerManagerDelegate {
    func didReceiveCall(callerName: String) {
        self.delegate?.didReceiveCall(callerName: callerName)
    }
    
    
}
