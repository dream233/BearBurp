//
//  favoriteViewController.swift
//  JiarongLiang-Lab4
//
//  Created by 梁家榕 on 10/30/22.
//

import UIKit

class favoriteViewController:UIViewController, UITableViewDataSource, UITableViewDelegate{
    
    @IBOutlet weak var tableView: UITableView!
    var favoriteMovies:[Movie] = []
    var imageCache:[UIImage] = []
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return favoriteMovies.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: "cell")
        cell.textLabel!.text = favoriteMovies[indexPath.row].title 
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let detailedCV = detailedViewController()
        detailedCV.image = imageCache[indexPath.row]
        detailedCV.movie = favoriteMovies[indexPath.row]
        navigationController?.pushViewController(detailedCV, animated: true)
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if(editingStyle == .delete){
            let id = favoriteMovies[indexPath.row].id
            deleteDataFromDB(id: id!)
            favoriteMovies.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .automatic)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        getDataFromDB()
        cacheImages()
        tableView.reloadData()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getDataFromDB()
        cacheImages()
        tableView.reloadData()
    }
    
    // Creative Portion 1: Saving all the information about a favorited movie locally by sqllite3
    func getDataFromDB(){
        let thePath = Bundle.main.path(forResource: "favorites", ofType: "db")
        let contactDB = FMDatabase(path: thePath)
        
        if contactDB.open() {
            defer { contactDB.close() }
            do {
                let results = try contactDB.executeQuery("SELECT * FROM Movies", values: nil)
//                try contactDB.executeUpdate("INSERT INTO Movies (id, title, release_date, vote_average, overview, poster_path) values (?,?,?,?,?,?)", values: [movie.id!, movie.title, movie.release_date!, movie.vote_average, movie.overview, movie.poster_path!])
                while(results.next()){
                    let movie = Movie(id: Int(results.int(forColumn: "id")),poster_path: results.string(forColumn: "poster_path")!, title: results.string(forColumn: "title")!,release_date: results.string(forColumn: "release_date")!,vote_average:results.double(forColumn: "vote_average"),overview: results.string(forColumn: "overview")!,vote_count: 0)
                    if(!favoriteMovies.contains{$0.id == movie.id}){
                        favoriteMovies.append(movie)
                    }
                    print("Load data from DB")
                }
            } catch {
                print(error)
            }
        } else {
            print("Error: \(contactDB.lastErrorMessage())")
        }
    }
    
    func deleteDataFromDB(id:Int){
        let thePath = Bundle.main.path(forResource: "favorites", ofType: "db")
        let contactDB = FMDatabase(path: thePath)
        
        if contactDB.open() {
            defer { contactDB.close() }
            do {
                try contactDB.executeUpdate("DELETE FROM Movies WHERE id = (?)", values: [id])
                print("delete data from DB")
            } catch {
                print(error)
            }
        } else {
            print("Error: \(contactDB.lastErrorMessage())")
        }
        
    }
    func cacheImages(){
        for i in favoriteMovies {
            if(i.poster_path != nil){
                let url = URL(string:"https://image.tmdb.org/t/p/w200/\(i.poster_path!)" )
                let data = try! Data(contentsOf: url!)
                let image = UIImage(data:data)
                imageCache.append(image!)
            }
        }
    }
    
}
