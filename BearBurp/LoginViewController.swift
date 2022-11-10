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
    }
    @IBAction func click_register(_ sender: Any) {
        var url:URL?
        username = usernameInput.text
        password = pwInput.text
        url = URL(string: "http://3.86.178.119/~Charles/CSE438-final/signup.php?username=\(username!)&password=\(password!)")
        let data = try! Data(contentsOf: url!)
        theData = try! JSONDecoder().decode(Message.self,from:data)
        print(theData?.message)
    }
}
