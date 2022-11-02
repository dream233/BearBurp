//
//  ReviewViewController.swift
//  BearBurp
//
//  Created by Haoran Song on 11/2/22.
//

import UIKit

class ReviewViewController: UIViewController {

    var name: String = "namePlaceHolder"
//    var movieId: Int?
    var reviewArray: [Review] = []
    @IBOutlet weak var writeReviewBtn: UIButton!
    @IBAction func writeReviewBtnClicked(_ sender: Any) {
        let addReviewCV = self.storyboard?.instantiateViewController(withIdentifier: "addReview") as! AddReviewViewController
        addReviewCV.name = name
        navigationController?.pushViewController(addReviewCV, animated: true)
    }
    @IBOutlet weak var restaurantName: UILabel!
    @IBOutlet weak var restaurantTableView: UITableView!
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
        
        writeReviewBtn.setImage(UIImage(systemName: "highlighter"), for: .normal)
        writeReviewBtn.tintColor = UIColor(red: 0.50, green: 0.50, blue: 0.50, alpha: 1.00)
        writeReviewBtn.backgroundColor = .clear
        let addReviewButtonFrame = CGRect(x: 295, y: 100, width: 93, height: 31)
        writeReviewBtn.frame = addReviewButtonFrame
        
        
        
        
        let reviewFrame = CGRect(x: 16, y: 142, width: 358, height: 608)
        restaurantTableView.frame = reviewFrame
        restaurantTableView.backgroundColor = .black
        setupTableView()
        
        DispatchQueue.global(qos: .userInitiated).async {
            self.getReviewData()
            
            DispatchQueue.main.async {
                self.restaurantTableView.reloadData()
            }
        }
        
    }
    
    func setupTableView() {
        restaurantTableView.dataSource = self
        restaurantTableView.delegate = self
        restaurantTableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
    }
    
    func getReviewData(){
    }
}

extension ReviewViewController: UITableViewDelegate,UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return reviewArray.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "cell")
        cell.layer.cornerRadius = 4
        cell.clipsToBounds = true
        cell.textLabel!.text = reviewArray[indexPath.item].userName
        cell.textLabel!.font = UIFont.systemFont(ofSize: 10)
        cell.textLabel?.textColor = UIColor.gray
        cell.detailTextLabel?.numberOfLines = 0
        cell.detailTextLabel?.text = reviewArray[indexPath.item].review
        cell.detailTextLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        cell.detailTextLabel?.textColor = UIColor.black
        let newImageData = Data(base64Encoded: reviewArray[indexPath.item].userAvar)
        
        var newImage = UIImage(data: newImageData!)
        if(newImageData?.count==0){
            newImage = UIImage(named: "black")
        }

        cell.imageView?.image = newImage
        cell.isUserInteractionEnabled = false
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 5
    }

}
