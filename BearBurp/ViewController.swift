//
//  ViewController.swift
//  JiarongLiang-Lab4
//
//  Created by 梁家榕 on 10/28/22.
//

import UIKit

class ViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UISearchBarDelegate{
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var collectionView: UICollectionView!
    
    var fetchResult:[APIResults] = []
    var imageCache:[UIImage] = []
    var movies:[Movie] = []
    var lang:String = "en"
    var adult:Bool = false
    var spinner : UIActivityIndicatorView = UIActivityIndicatorView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchBar.delegate = self
        setupView()
    }
    
    func setupView(){
        collectionView.delegate = self
        collectionView.dataSource = self
        let cellSize = UIScreen.main.bounds.width / 3 - 10
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: cellSize, height: cellSize * 3/2)
        collectionView.collectionViewLayout = layout
        
        // set spinner
        spinner.color = .blue
        spinner.hidesWhenStopped = true
        spinner.center = view.center
        spinner.style = UIActivityIndicatorView.Style.large
        collectionView.addSubview(spinner)
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        let keyword = searchBar.text!
        spinner.startAnimating()
        
        DispatchQueue.global().async {
            
            self.movies = []
            self.fetchResult = []
            self.imageCache = []
            
            self.fetchData(keyword: keyword)
            self.cacheImages()
            
            DispatchQueue.main.async {
                self.collectionView.reloadData()
                self.spinner.stopAnimating()
            }
        }
        
    }
    
    // Creative Portion 2: Users can sort the movies (by "Release date" or by "Rating")
    @IBAction func sortButton(_ sender: UIButton) {
        sender.showsMenuAsPrimaryAction = true
        sender.menu = UIMenu(children: [
                    UIAction(title: "Release date", handler: { action in
                        if(!self.movies.isEmpty){
                            self.movies.sort(by: {$0.release_date! > $1.release_date!})
                        }
                        self.imageCache = []
                        self.cacheImages()
                        self.collectionView.reloadData()
                    }),
                    UIAction(title: "Rating", handler: { action in
                        if(!self.movies.isEmpty){
                            self.movies.sort(by: {$0.vote_average > $1.vote_average})
                        }
                        self.imageCache = []
                        self.cacheImages()
                        self.collectionView.reloadData()
                    })
                ])
    }
    
    func fetchData(keyword:String){
        
        let movieName = keyword
        let urlString = "https://api.themoviedb.org/3/search/movie?api_key=b098ff88609fe28342ee137c2b6048f5&query=\(movieName)&language=\(lang)&include_adult=\(adult)"
        let url = URL(string: urlString)
        let data = try!Data(contentsOf: url!)
        if(url != nil){
            fetchResult = [try! JSONDecoder().decode(APIResults.self, from: data)]
            movies = fetchResult[0].results
        }
        
        
    }
    func cacheImages(){
        for i in movies {
            if(i.poster_path != nil){
                let url = URL(string:"https://image.tmdb.org/t/p/w200/\(i.poster_path!)" )
                let data = try! Data(contentsOf: url!)
                let image = UIImage(data:data)
                imageCache.append(image!)
            }
        }
    }
    
    //    how many cell will return
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return movies.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! movieCollectionViewCell
        cell.movieImageView.image = imageCache[indexPath.row]
        cell.movieTitle.text = movies[indexPath.row].title
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let detailedCV = detailedViewController()
        detailedCV.image = imageCache[indexPath.row]
        detailedCV.movie = movies[indexPath.row]
        navigationController?.pushViewController(detailedCV, animated: true)
    }
    
    // Extra Credit: Implement a Context Menu
    func collectionView(_ collectionView: UICollectionView,contextMenuConfigurationForItemAt indexPath: IndexPath,point: CGPoint) -> UIContextMenuConfiguration? {
            return UIContextMenuConfiguration(identifier: nil, previewProvider: nil) { _ -> UIMenu? in
            return self.makeContextMenu(for:self.movies[indexPath.row])
        }
    }
    
    func makeContextMenu(for movie:Movie) -> UIMenu {

        // Create a UIAction for favoriting
        let favorite = UIAction(title: "Favorite", image: UIImage(systemName: "star")) { action in
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

        // Create and return a UIMenu with the favorite action
        return UIMenu(title: "", children: [favorite])
    }
    

}

