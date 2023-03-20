//
//  CallerViewController.swift
//  TelnyxSample
//
//  Created by Mostafa Elbaz on 19/03/2023.
//

import UIKit

class CallerViewController: UIViewController {

    private var viewModel: CallerViewModel!
    var onCallViewController: OnCallViewController?
    var receivingCallViewController: ReceivingCallViewController?
    
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

    func receiveCall(callerName: String) {
        receivingCallViewController = ReceivingCallViewController()
        receivingCallViewController?.modalPresentationStyle = .overFullScreen
        receivingCallViewController?.modalTransitionStyle = .crossDissolve
        receivingCallViewController?.delegate = self
        receivingCallViewController?.viewModel = ReceivingCallViewModel(callerName: callerName)
        self.present(receivingCallViewController!, animated: true, completion: nil)

    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

    func showOnCallView(callerName: String) {
        self.onCallViewController = OnCallViewController()
        self.onCallViewController?.modalPresentationStyle = .overFullScreen
        self.onCallViewController?.modalTransitionStyle = .crossDissolve
        self.onCallViewController?.delegate = self
        let onCallViewModel = OnCallViewModel(callerName: callerName)

        self.onCallViewController?.viewModel = OnCallViewModel(callerName: callerName)
        self.present(self.onCallViewController!, animated: true, completion: nil)
    }
    
}

extension CallerViewController: CallerViewModelDelegate {
    fileprivate func resetView() {
        onCallViewController = nil
        receivingCallViewController = nil
    }
    
    func didEndCall() {
        onCallViewController?.dismiss(animated: true)
        receivingCallViewController?.dismiss(animated: true)
        
        resetView()
    }
    
    func didReceiveCall(callerName: String) {
        receiveCall(callerName: callerName)
    }
    
    func callSuccessful(callerName: String) {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else {return}
            self.receivingCallViewController?.dismiss(animated: true)
            self.showOnCallView(callerName: callerName)
        }
    }
    
    func callFailed(error: Error) {
        resetView()
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
    }
    
    func receivingCallDidReject() {
        viewModel.hangout()
    }
    
}
