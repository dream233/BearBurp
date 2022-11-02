//
//  DetailViewController.swift
//  HaoranSong-Lab4
//
//  Created by Haoran Song on 10/22/22.
//

import UIKit

class DetailViewController: UIViewController {
    
    var name = "namePlaceholder"
    @IBOutlet weak var restaurantName: UILabel!
    @IBOutlet weak var restaurantImages: UIImageView!
    @IBAction func reviewClicked(_ sender: Any) {
        let reviewVC = self.storyboard?.instantiateViewController(withIdentifier: "review") as! ReviewViewController
        reviewVC.name = name
        navigationController?.pushViewController(reviewVC, animated: true)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        restaurantImages.image = UIImage(named: "test")
        restaurantImages.contentMode = .scaleToFill
        restaurantName.text = name
    }
    
    
}



