//
//  LoginViewController.swift
//  BearBurp
//
//  Created by W Q on 11/7/22.
//

import UIKit

class LoginViewController: UIViewController {
    
    @IBOutlet weak var usernameInput: UITextField!
    @IBOutlet weak var pwInput: UITextField!
    
    var username:String?
    var password:String?
    var theData:Message?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    @IBAction func click_login(_ sender: Any) {
        var url:URL?
        username = usernameInput.text
        password = pwInput.text
        url = URL(string: "http://3.86.178.119/~Charles/CSE438-final/login.php?username=\(username!)&password=\(password!)")
        let data = try! Data(contentsOf: url!)
        theData = try! JSONDecoder().decode(Message.self,from:data)
        
        // 成功会返回username，失败会返回错误信息，下同
        print(theData?.message)
        
        // 失败展示alert
        if let loginIndicator = theData?.success, let loginMSG = theData?.message {
            if (!loginIndicator){
                showAlert(alertText: "Login Error", alertMessage: loginMSG)
            }else{
                // hide login UI and show logged in UI
            }
        }
    }
    @IBAction func click_register(_ sender: Any) {
        var url:URL?
        username = usernameInput.text
        password = pwInput.text
        url = URL(string: "http://3.86.178.119/~Charles/CSE438-final/signup.php?username=\(username!)&password=\(password!)")
        let data = try! Data(contentsOf: url!)
        theData = try! JSONDecoder().decode(Message.self,from:data)
        print(theData?.message)
        
        if let regIndicator = theData?.success, let regMSG = theData?.message {
            if (!regIndicator){
                showAlert(alertText: "Register Error", alertMessage: regMSG)
            }else{
                showAlert(alertText: "Success", alertMessage: "You have registered a account, please login.")
            }
        }
    }
}

extension UIViewController {
//Show a basic alert
    func showAlert(alertText : String, alertMessage : String) {
        let alert = UIAlertController(title: alertText, message: alertMessage, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))
        //Add more actions as you see fit
        self.present(alert, animated: true, completion: nil)
    }
}
