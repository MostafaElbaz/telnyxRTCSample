import Foundation
import TelnyxRTC

protocol LoginViewModelDelegate: AnyObject {
    func loginSuccess()
    func loginFailed(error: Error)
}

class LoginViewModel {

    weak var delegate: LoginViewModelDelegate?
    private var username: String?
    private var password: String?

    var appDelegate: AppDelegate {
        return UIApplication.shared.delegate as! AppDelegate
    }
    
    func login(username: String?, password: String?) {
        self.username = username
        self.password = password
        
        let txConfig = TxConfig(sipUser: "MostafaElbaz1", password: "17HdvZVm", logLevel: .all)
        
        do {
//            telnyxClient.delegate = self
            try appDelegate.telnyxClient!.connect(txConfig: txConfig)
        } catch let error {
            delegate?.loginFailed(error: error)
        }
    }


}
