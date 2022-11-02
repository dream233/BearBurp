//
//  detailedViewController.swift
//  JiarongLiang-Lab4
//
//  Created by 梁家榕 on 10/30/22.
//

import UIKit

class detailedViewController: UIViewController{

    var movie : Movie!
    var image : UIImage!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        let theImageFrame = CGRect(x: view.frame.midX - image.size.width/2, y: 120, width: image.size.width, height: image.size.height)
        let imageView = UIImageView(frame:theImageFrame)
        imageView.image = image
        view.addSubview(imageView)
        
        let theTitleFrame = CGRect(x: 0, y: image.size.height + 120, width: view.frame.width, height: 30)
        var textView = UILabel(frame: theTitleFrame)
        textView.text = "Title: " + movie.title
        textView.textAlignment = .center
        view.addSubview(textView)
        
        let theReleasedFrame = CGRect(x: 0, y: image.size.height + 150, width: view.frame.width, height: 30)
        textView = UILabel(frame: theReleasedFrame)
        textView.text = "Release: " + movie.release_date!
        textView.textAlignment = .center
        view.addSubview(textView)
        
        let theScoreFrame = CGRect(x: 0, y: image.size.height + 180, width: view.frame.width, height: 30)
        textView = UILabel(frame: theScoreFrame)
        textView.text = "Rate: " + String(movie.vote_average)
        textView.textAlignment = .center
        view.addSubview(textView)
        
        let theOverviewFrame = CGRect(x: 0, y: image.size.height + 210, width: view.frame.width, height: 160)
        textView = UILabel(frame: theOverviewFrame)
        textView.numberOfLines = 0
        textView.text = "Overview: " + movie.overview
        textView.textAlignment = .center
        view.addSubview(textView)
        
        let theButtonFrame = CGRect(x: view.frame.midX - view.frame.width/6, y: image.size.height + 360, width: view.frame.width/3, height: 30)
        let button = UIButton(frame: theButtonFrame)
        button.setTitleColor(.black, for: .normal)
        button.layer.cornerRadius = 5
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.black.cgColor
        button.setTitle("Add to Favorite", for: .normal)
        button.addTarget(self, action: #selector(buttonAction), for: .touchUpInside)
        view.addSubview(button)
        
        let theWebButtonFrame = CGRect(x: view.frame.midX - view.frame.width/6, y: image.size.height + 400, width: view.frame.width/3, height: 30)
        let webButton = UIButton(frame: theWebButtonFrame)
        webButton.setTitleColor(.black, for: .normal)
        webButton.layer.cornerRadius = 5
        webButton.layer.borderWidth = 1
        webButton.layer.borderColor = UIColor.black.cgColor
        webButton.setTitle("View Youtube", for: .normal)
        webButton.addTarget(self, action: #selector(launchWebView), for: .touchUpInside)
        view.addSubview(webButton)
        
    }
    
    // Creative Portion 1: Saving all the information about a favorited movie locally by sqllite3
    @objc func buttonAction(sender: UIButton!) {
        let thePath = Bundle.main.path(forResource: "favorites", ofType: "db")
        let contactDB = FMDatabase(path: thePath)
        
        if contactDB.open() {
            defer { contactDB.close() }
            do {
                try contactDB.executeUpdate("INSERT INTO Movies (id, title, release_date, vote_average, overview, poster_path) values (?,?,?,?,?,?)", values: [movie.id!, movie.title, movie.release_date!, movie.vote_average, movie.overview, movie.poster_path!])
                print("Insert data to DB")
            } catch {
                print(error)
            }
        } else {
            print("Error: \(contactDB.lastErrorMessage())")
        }
    }
    
    // Creative Portion 3: Users can watch related video by click button "View Youtube" on detailedView
    @objc func launchWebView(sender: UIButton!){
            let webVC = webViewController()
            let baseURL:String = "https://m.youtube.com/results?q="
            let search = movie.title.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
            let url = URL(string: baseURL + search!)!
            webVC.url = URLRequest(url: url)
            navigationController?.pushViewController(webVC, animated: true)
        }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
