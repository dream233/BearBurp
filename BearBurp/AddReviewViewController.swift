//
//  AddReviewViewController.swift
//  BearBurp
//
//  Created by Haoran Song on 11/2/22.
//

import UIKit
import SwiftUI

class AddReviewViewController: UIViewController {

    var restaurant: Restaurant?
    let submitBtn = UIButton()
    var theData:Message?
    
    @IBOutlet weak var restaurantName: UILabel!
    @IBOutlet weak var writeReviewView: UITextView!
    @IBOutlet weak var submitBtnLabel: UIButton!
    @IBAction func submitBtnClicked(_ sender: Any) {
        let userName = UserDefaults.standard.string(forKey: "username")
        if(userName==nil){
            alert(title: "Login Needed", message: "Please login before adding reviews!")
        }else{
            if(writeReviewView.text==""){
                alert(title: "Review Empty", message: "Please add reviews before you submit!")
            }else{
                let myUserName = userName
                let restaurantId = restaurant?.id
                let review = writeReviewView.text
                let userAvar = UserDefaults.standard.string(forKey: ((userName ?? "") + "/" + "imagedata")) ?? ""
                
                var url:URL?
                url = URL(string: "http://3.86.178.119/~Charles/CSE438-final/addReview.php?username=\(myUserName!)&restaurantId=\(restaurantId!)&rid=\(review!)&userAvar=\(userAvar)")
                let data = try! Data(contentsOf: url!)
                theData = try! JSONDecoder().decode(Message.self,from:data)
                
                if let regIndicator = theData?.success, let regMSG = theData?.message {
                    if (!regIndicator){
                        alert(title: "Error", message: regMSG)
                    }else{
                        navigationController?.popViewController(animated: true)
                    }
                }

//                let myReview = Review(userName: userName!, userAvar: userAvar, movieId: movieId!, movieName: movieName, review: review!)
//
//                let addToDatabase = DatabaseCommand.insertRow(myReview)
//
//                if addToDatabase == true {
//                    navigationController?.popViewController(animated: true)
//                }
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white
        
        restaurantName.text = restaurant?.name
        restaurantName.font = UIFont.boldSystemFont(ofSize: 25)
        restaurantName.numberOfLines = 0
        restaurantName.textAlignment = .left
        restaurantName.lineBreakMode = NSLineBreakMode.byWordWrapping
        let textViewSize = restaurantName.sizeThatFits(CGSize(width: 358, height: CGFloat(MAXFLOAT)))
        let titleFrame = CGRect(x: 16, y: 100, width: 358, height: textViewSize.height)
        restaurantName.frame = titleFrame
        
        writeReviewView.layer.borderWidth = 1
        writeReviewView.layer.borderColor = UIColor(named: "black")?.cgColor
        writeReviewView.layer.cornerRadius = 4
        writeReviewView.font = UIFont.systemFont(ofSize: 15)
        let writeReviewFrame = CGRect(x: 16, y: 175, width: 358, height: 200)
        writeReviewView.frame = writeReviewFrame
        
        submitBtnLabel.setTitle("Submit", for: .normal)
        submitBtnLabel.backgroundColor = UIColor(red: 1.00, green: 0.13, blue: 0.09, alpha: 1.00)
        submitBtnLabel.tintColor = UIColor.white
        let submitBtnFrame = CGRect(x: 277, y: 425, width: 93, height: 31)
        submitBtnLabel.layer.cornerRadius = 10
        submitBtnLabel.layer.masksToBounds = true
        submitBtnLabel.frame = submitBtnFrame
        
    }

    func alert(title:String, message:String){
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(action)
        self.present(alert, animated: true, completion: nil)
    }

}
