//
//  AddReviewViewController.swift
//  BearBurp
//
//  Created by Haoran Song on 11/2/22.
//

import UIKit

class AddReviewViewController: UIViewController {

    var name: String = "namePlaceHolder"
    var movieId: Int?
    let submitBtn = UIButton()
    
    @IBOutlet weak var restaurantName: UILabel!
    @IBOutlet weak var writeReviewView: UITextView!
    @IBOutlet weak var submitBtnLabel: UIButton!
    @IBAction func submitBtnClicked(_ sender: Any) {
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white
        
        restaurantName.text = name
        restaurantName.font = UIFont.boldSystemFont(ofSize: 25)
        restaurantName.numberOfLines = 0
        restaurantName.textAlignment = .left
        restaurantName.lineBreakMode = NSLineBreakMode.byWordWrapping
        let textViewSize = restaurantName.sizeThatFits(CGSize(width: 358, height: CGFloat(MAXFLOAT)))
        let titleFrame = CGRect(x: 16, y: 100, width: 358, height: textViewSize.height)
        restaurantName.frame = titleFrame
        
        writeReviewView.layer.borderWidth = 1
        writeReviewView.layer.borderColor = UIColor(red: 0.00, green: 0.42, blue: 0.46, alpha: 1.00).cgColor
        writeReviewView.layer.cornerRadius = 4
        writeReviewView.font = UIFont.systemFont(ofSize: 15)
        let writeReviewFrame = CGRect(x: 16, y: 175, width: 358, height: 200)
        writeReviewView.frame = writeReviewFrame
        
        submitBtnLabel.setTitle("Submit", for: .normal)
        submitBtnLabel.backgroundColor = UIColor(red: 0.00, green: 0.42, blue: 0.46, alpha: 1.00)
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
