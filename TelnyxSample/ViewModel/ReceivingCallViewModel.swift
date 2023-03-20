//
//  ReceivingCallViewModel.swift
//  TelnyxSample
//
//  Created by Mostafa Elbaz on 19/03/2023.
//

import Foundation

protocol ReceivingCallViewModelDelegate: AnyObject {
    func onAnswerCall()
    func onRejectCall()
}

class ReceivingCallViewModel {
    weak var delegate: ReceivingCallViewModelDelegate?

    var callerName: String
    
    init(delegate: ReceivingCallViewModelDelegate? = nil, callerName: String) {
        self.delegate = delegate
        self.callerName = callerName
    }
    
    func answerCall() {
        delegate?.onAnswerCall()
    }

    func rejectCall() {
        delegate?.onRejectCall()
    }
}
