//
//  ReceivingCallViewController.swift
//  TelnyxSample
//
//  Created by Mostafa Elbaz on 19/03/2023.
//

import UIKit

protocol ReceivingCallDelegate: AnyObject {
    func receivingCallDidAnswer()
    func receivingCallDidReject()
}

class ReceivingCallViewController: UIViewController {
    @IBOutlet weak var callerNameLabel: UILabel!
    weak var delegate: ReceivingCallDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()

        callerNameLabel.text = "viewModel.callerName"

    }
    
    @IBAction func answerButtonPressed(_ sender: Any) {

        self.dismiss(animated: true) { [weak self] in
            self?.delegate?.receivingCallDidAnswer()

        }

    }
    

    @IBAction func rejectButtonPressed(_ sender: Any) {

        self.dismiss(animated: true) { [weak self] in
            self?.delegate?.receivingCallDidReject()

        }

    }

}

