//
//  ViewController.swift
//  HaoranSong-Lab4
//
//  Created by Haoran Song on 10/20/22.
//

import UIKit

class ViewController: UIViewController{
    
//    var theRestaurant : [Restaurant] = []
//    var theAPIData : APIData?
    
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true

        return imageView
    }()
//
    var theData : APIData?
    var theImageCache : [UIImage] = []
//    var theGenre : GenreBackData?
//    var genreDict: [Int: String] = [:]
//    let apiKey = "d766a2eea4ccdbb5593aea0eafa7fb55"
//    let defaults = UserDefaults.standard
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var searchBar: UISearchBar!
    // Creative Portion 2: Users can sort the movies (by "Release date" or by "Rating")
    @IBAction func sortButton(_ sender: UIButton) {
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Movies"
        searchBar.delegate = self
        setupCollectionView()
        addLoadingView()
        DispatchQueue.global(qos: .userInitiated).async {
//            self.createDatabase()
            self.getDataFromTMDB(query: "")
//            self.getGenre()
            self.cacheImages()
            
            DispatchQueue.main.async {
                self.removeLoadingView()
                self.collectionView.reloadData()
            }
        }
    }
    
    func addLoadingView(){
        let loadingView: LoadingView = LoadingView(frame: CGRect(x: view.frame.size.width/2-50, y: view.frame.size.height/2-50, width: 100, height: 100))

        loadingView.backgroundColor = UIColor(displayP3Red: 230/255.0, green: 230/255.0, blue: 230/255.0, alpha: 0.3)
        UIView.transition(with: view, duration: 0.25, options: [.transitionCrossDissolve], animations: {
            self.view.addSubview(loadingView)
        }, completion: nil)
    }
    
    func removeLoadingView(){
        for item in view.subviews {
            if item.isKind(of: LoadingView.self) {
                UIView.transition(with: view, duration: 1, options: [.transitionCrossDissolve], animations: {
                  item.removeFromSuperview()
                }, completion: nil)
            }
        }
    }
    
    func setupCollectionView(){
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "mycell")
    }
    
    // Jiarong 11-06 update
    func getDataFromTMDB(query: String){
        var url:URL?
        
        var myQuery = query.removeSpecialCharacters().condensedWhitespace
        myQuery = myQuery.unicodeScalars
            .filter { !$0.properties.isEmojiPresentation }
            .reduce("") { $0 + String($1) }
        
        // fetch data from mysql
        url = URL(string: "http://3.83.69.24/~Charles/CSE438-final/fetchdata.php?&query=\(myQuery)")
        let data = try! Data(contentsOf: url!)
        theData = try! JSONDecoder().decode(APIData.self,from:data)
        
    }
    
    // Jiarong 11-06 update
    func cacheImages(){
        theImageCache = []
        for item in theData?.message ?? [] {
            if(item.image_url==""){
                theImageCache.append(UIImage(named: "empty")!)
            }else{
                let url = URL(string: item.image_url)
                do{
                    let data = try Data(contentsOf: url!)
                    let image = UIImage(data: data)
                    theImageCache.append(image!)
                }catch{
                    theImageCache = []
                }

            }
        }
    }

}

extension ViewController: UISearchBarDelegate{
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        let query = searchBar.text
        addLoadingView()
        DispatchQueue.global(qos: .userInitiated).async {
            self.getDataFromTMDB(query: query ?? "")
            self.cacheImages()
            
            DispatchQueue.main.async {
                self.removeLoadingView()
                self.collectionView.reloadData()
            }
        }
    }
}

extension ViewController: UICollectionViewDataSource, UICollectionViewDelegate,UICollectionViewDelegateFlowLayout{
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return theImageCache.count
    }
    
    // Jiarong 11-06 update
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "mycell", for: indexPath)
//        cell.backgroundColor = .black
        
        let imageview:UIImageView=UIImageView(frame: CGRect(x: 0, y: 0, width: view.frame.size.width-3, height: 120));
        imageview.image = theImageCache[indexPath.item]
        
        let title = UILabel(frame: CGRect(x: 0, y: 120, width: view.frame.size.width/2 - 3, height: 30))
        title.text = theData?.message[indexPath.item].name
        title.font = UIFont(name: "Futura", size: CGFloat(14))
        imageview.addSubview(title)
        
        let rate = UILabel(frame: CGRect(x: 280, y: 120, width: view.frame.size.width/2 - 3, height: 30))
        let vote = theData?.message[indexPath.item].rating ?? 0.0
        let rateString = "Vote Average: \(vote)"
        let mString = NSMutableAttributedString(string: rateString)
        if(vote>=7.5){
            mString.setAttributes(
                [NSAttributedString.Key.foregroundColor : UIColor(red: 1.00, green: 0.73, blue: 0.20, alpha: 1.00)],
                range: NSRange(location: 14, length: mString.string.count - 14)
            )
        }else if(vote<6){
            mString.setAttributes(
                [NSAttributedString.Key.foregroundColor : UIColor(red: 1.00, green: 0.20, blue: 0.20, alpha: 1.00)],
                range: NSRange(location: 14, length: mString.string.count - 14)
            )
        }else{
            mString.setAttributes(
                [NSAttributedString.Key.foregroundColor : UIColor(red: 0.36, green: 0.84, blue: 0.36, alpha: 1.00)],
                range: NSRange(location: 14, length: mString.string.count - 14)
            )
        }
        rate.attributedText = mString
        rate.font = UIFont(name: "Futura", size: CGFloat(12))
        imageview.addSubview(rate)
        cell.contentView.subviews.forEach {$0.removeFromSuperview()}
        UIView.transition(with: cell.contentView, duration: 0.25, options: [.transitionCrossDissolve], animations: {
            cell.contentView.addSubview(imageview)
        }, completion: nil)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(
            width: view.frame.size.width-3,
            height: view.frame.size.width/3
        )
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
    
    // spacing between rows
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 30
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 1, left: 1, bottom: 1, right: 1)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {

        let detailedCV = self.storyboard?.instantiateViewController(withIdentifier: "detail") as! DetailViewController
        detailedCV.image = theImageCache[indexPath.row]
        detailedCV.restaurant = theData?.message[indexPath.row]
        navigationController?.pushViewController(detailedCV, animated: true)
    }
    
}
// Reference:  https://stackoverflow.com/questions/56984247/swift-how-to-remove-special-character-without-remove-emoji-from-string
extension String {
    var condensedWhitespace: String {
        let components = self.components(separatedBy: NSCharacterSet.whitespacesAndNewlines)
        return components.filter { !$0.isEmpty }.joined(separator: " ")
    }

    func removeSpecialCharacters() -> String {
        let okayChars = CharacterSet(charactersIn: "abcdefghijklmnopqrstuvwxyz ABCDEFGHIJKLKMNOPQRSTUVWXYZ1234567890 ")
        return String(self.unicodeScalars.filter { okayChars.contains($0) || $0.properties.isEmoji })
    }
}

