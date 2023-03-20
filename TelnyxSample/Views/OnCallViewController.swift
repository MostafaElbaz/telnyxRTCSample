//
//  OnCallViewController.swift
//  TelnyxSample
//
//  Created by Mostafa Elbaz on 19/03/2023.
//

import UIKit

protocol OnCallViewControllerDelegate: AnyObject {
    func onHangUpButtonTapped()
}

class OnCallViewController: UIViewController {
    @IBOutlet private weak var callerNameLabel: UILabel!
    @IBOutlet private weak var callDurationLabel: UILabel!
    @IBOutlet private weak var hangUpButton: UIButton!

    // MARK: - Properties
    var viewModel: OnCallViewModel?
    weak var delegate: OnCallViewControllerDelegate?


    // MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }
    
    // MARK: - Private Methods
    private func configureUI() {
        guard let viewModel = viewModel else { return }
        callerNameLabel.text = viewModel.callerName
    }
    
    // MARK: - IBActions
    @IBAction private func hangUpButtonTapped(_ sender: Any) {
        delegate?.onHangUpButtonTapped()
        self.dismiss(animated: true)
    }

}
