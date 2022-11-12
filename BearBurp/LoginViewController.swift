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
    var logoutBtn = UIButton(frame: CGRect(x: 0, y: 0 , width: 100, height: 30 ))
    var loggedView = UIView()
    
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
                if let username = username{
                    showLoggedUI(username: username)
                }
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
    
    func showLoggedUI(username:String){
        let screenWidth = view.frame.width;
        let screenHeight = UIScreen.main.bounds.height;
        loggedView = UIView(frame: CGRect(x: 0, y: 0, width: screenWidth, height: screenHeight))
        loggedView.backgroundColor = .lightGray
        
        // username label
        let usernameLabel = UILabel()
        usernameLabel.text = "You are logged in as \(username)"
        usernameLabel.frame = CGRect(x: 0,y: screenHeight * 0.3,width: 0, height: 0 )
        usernameLabel.sizeToFit()
        usernameLabel.center.x = loggedView.center.x
        loggedView.addSubview(usernameLabel)
        
        // log out button
        logoutBtn.setTitle("Log Out", for: .normal)
        logoutBtn.frame = CGRect(x: 0,y: screenHeight * 0.5,width: 0, height: 0)
        logoutBtn.setTitleColor(.tintColor, for: .normal)
        logoutBtn.layer.cornerRadius = 10
        logoutBtn.backgroundColor = #colorLiteral(red: 0.8104380965, green: 0.9008539915, blue: 0.9891548753, alpha: 1)
        logoutBtn.sizeToFit()
        logoutBtn.frame.size.width += 35
        logoutBtn.center.x = loggedView.center.x
        logoutBtn.addTarget(self, action: #selector(pressLogout), for: .touchUpInside)
        loggedView.addSubview(logoutBtn)
        
        view.addSubview(loggedView)
    }
    
    @objc func pressLogout(){
        loggedView.removeFromSuperview()
        showAlert(alertText: "Sucess", alertMessage: "You've logged out!")
        // any addtional process for logging out
        
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
