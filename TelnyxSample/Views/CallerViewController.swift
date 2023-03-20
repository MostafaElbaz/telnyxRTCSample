//
//  CallerViewController.swift
//  TelnyxSample
//
//  Created by Mostafa Elbaz on 19/03/2023.
//

import UIKit

class CallerViewController: UIViewController {

    private var viewModel: CallerViewModel!
    
    @IBOutlet weak var destinationTextField: UITextField!
    
    
    init(viewModel: CallerViewModel) {
           self.viewModel = viewModel
           super.init(nibName: nil, bundle: nil)
        self.viewModel.delegate = self
       }

       required init?(coder: NSCoder) {
           fatalError("init(coder:) has not been implemented")
       }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func makeCallButtonPressed(_ sender: Any) {
        guard let destinationNumber = destinationTextField.text else {
            return
        }
        viewModel.makeCall(destinationNumber: destinationNumber)
    }

    func receiveCall() {
        let receivingCallViewController = ReceivingCallViewController()
        receivingCallViewController.modalPresentationStyle = .overFullScreen
        receivingCallViewController.modalTransitionStyle = .crossDissolve
        receivingCallViewController.delegate = self
        self.present(receivingCallViewController, animated: true, completion: nil)

    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension CallerViewController: CallerViewModelDelegate {
    func didReceiveCall(callerName: String) {
        receiveCall()
    }
    
    func callSuccessful() {
        let onCallViewController = OnCallViewController()
        onCallViewController.modalPresentationStyle = .overFullScreen
        onCallViewController.modalTransitionStyle = .crossDissolve
        onCallViewController.delegate = self
        onCallViewController.viewModel = OnCallViewModel(callerName: "NAME")
        self.present(onCallViewController, animated: true, completion: nil)
    }
    
    func callFailed(error: Error) {
        // Handle the call failure
    }
}

extension CallerViewController: OnCallViewControllerDelegate {
    func onHangUpButtonTapped() {
        // call ended
        viewModel.hangout()
        
    }
    
}


extension CallerViewController: ReceivingCallDelegate {
    func receivingCallDidAnswer() {
        viewModel.answer()
        callSuccessful()

    }
    
    func receivingCallDidReject() {
        viewModel.hangout()
    }
    
}
