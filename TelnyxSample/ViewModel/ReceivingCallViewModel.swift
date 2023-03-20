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
//    private let call: Call
    weak var delegate: ReceivingCallViewModelDelegate?

//    init(call: Call) {
//        self.call = call
//    }

    var callerName: String {
        return "call.remoteNumber"
    }

//    var callState: CallState {
//        return call.state
//    }

    func answerCall() {
//        call.answer()
        delegate?.onAnswerCall()
    }

    func rejectCall() {
//        call.reject()
        delegate?.onRejectCall()
    }
}
