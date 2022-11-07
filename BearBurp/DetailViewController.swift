//
//  DetailViewController.swift
//  HaoranSong-Lab4
//
//  Created by Haoran Song on 10/22/22.
//

import UIKit

class DetailViewController: UIViewController, UITableViewDataSource, UITableViewDelegate{
    
    var restaurant : Restaurant!
    var image : UIImage!
    var foods : foodAPIData?
    
    @IBOutlet weak var restaurantTableView: UITableView!
    @IBOutlet weak var restaurantRate: UILabel!
    @IBOutlet weak var restaurantName: UILabel!
    @IBOutlet weak var restaurantImages: UIImageView!
    @IBAction func reviewClicked(_ sender: Any) {
        let reviewVC = self.storyboard?.instantiateViewController(withIdentifier: "review") as! ReviewViewController
        reviewVC.name = restaurant.name
        navigationController?.pushViewController(reviewVC, animated: true)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        restaurantTableView.dataSource = self
        restaurantTableView.delegate = self
        view.backgroundColor = .white
        restaurantImages.image = image
        restaurantImages.contentMode = .scaleToFill
        restaurantName.text = restaurant.name
        restaurantRate.text = String(restaurant.rating)
        
        fetchFood()
    }
    
    func fetchFood(){
        var url:URL?
        url = URL(string: "http://3.83.69.24/~Charles/CSE438-final/fetchfood.php?&rid=\(restaurant.id)")
        let data = try! Data(contentsOf: url!)
        foods = try! JSONDecoder().decode(foodAPIData.self,from:data)
//        print(foods?.message)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return foods!.message.count//菜单长度
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: "cell")
        cell.textLabel!.text = foods?.message[indexPath.row].name
        return cell
    }
    
    
}





