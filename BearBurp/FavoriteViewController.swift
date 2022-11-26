//
//  MyViewController.swift
//  HaoranSong-Lab4
//
//  Created by Haoran Song on 10/23/22.
//

import UIKit
import PhotosUI
import Photos
import SwiftUI

class FavoriteViewController: UIViewController {
    
    var likedList: [Restaurant] = []
    let defaults = UserDefaults.standard
    var myAvatar: UIImage?
    var theUrl:String = ""
//    var myUserName = "Guest"
//    var myAvatar: UIImage?
    
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var userAvatar: UIImageView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var userBack: UIView!
    @IBOutlet weak var uploadButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUserAvatar()
        setupTableView()
        userBack.backgroundColor = UIColor(red: 0.92, green: 0.92, blue: 0.88, alpha: 1.00)
    }
    override func viewWillAppear(_ animated: Bool) {
        var tempList: [Restaurant] = []
        for i in defaults.dictionaryRepresentation().keys{
            if i.contains("Favorite_") {
                if let temp = defaults.object(forKey: i) as? Data {
                    let decoder = JSONDecoder()
                    if let loadedTemp = try? decoder.decode(Restaurant.self, from: temp) {
                        tempList.append(loadedTemp)
                    }
                }
            }
        }
        likedList = tempList.sorted { (lhs, rhs) in
            return lhs.id > rhs.id
        }
        tableView.reloadData()
        setupUserAvatar()
//        if(UserDefaults.standard.string(forKey: "myName")==nil){
//        }else{
//            connectBtn.setTitle("Update Profile", for: .normal)
//        }
            
    }
    
    func setupTableView() {
        tableView.dataSource = self
        tableView.delegate = self
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
    }
    func setupUserAvatar(){
        let avatarInDefaults = UserDefaults.standard.string(forKey: "myAvatar")
        if(avatarInDefaults==nil){
            userAvatar.image = myAvatar
        }else{
            let newImageData = Data(base64Encoded: avatarInDefaults!)
            let newImage = UIImage(data: newImageData!)
            userAvatar.image = newImage
        }
        userAvatar.layer.cornerRadius = (userAvatar.frame.size.width)/2
        userAvatar.layer.masksToBounds = true
        userAvatar.layer.borderWidth = 2;
        userAvatar.layer.borderColor = UIColor.white.cgColor
        userName.text = UserDefaults.standard.string(forKey: "username")
    }
 

    @IBAction func pressUploadImg(_ sender: Any) {
        let vc = UIImagePickerController()
        vc.sourceType = .photoLibrary
        vc.delegate = self
        vc.allowsEditing = true
        present(vc, animated: true)
        //        var config = PHPickerConfiguration(photoLibrary:  .shared())
//        config.selectionLimit = 2
//        config.filter = .images
//        let vc = PHPickerViewController(configuration: config)
//        vc.delegate = self
//        present(vc, animated: true)
    }

}



extension FavoriteViewController: UITableViewDelegate,UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return likedList.count+1
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "cell")
        if(indexPath.item==0){
            cell.textLabel!.text = "@BearBurp All Rights Reserved"
            cell.textLabel!.font =  UIFont.italicSystemFont(ofSize: 12)
            cell.isUserInteractionEnabled = false
        }else{
            cell.textLabel!.text = likedList[indexPath.item-1].name
            cell.textLabel!.font = UIFont.boldSystemFont(ofSize: 18.0)

            let tempString = likedList[indexPath.item-1].location
            cell.detailTextLabel?.text = tempString

            let image_url = likedList[indexPath.item-1].image_url
            let url = URL(string: image_url)
            let data = try! Data(contentsOf: url!)
            let image = UIImage(data: data)
            cell.imageView?.image = image
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let detailedCV = self.storyboard?.instantiateViewController(withIdentifier: "detail") as! DetailViewController
        let image_url = likedList[indexPath.item-1].image_url
        let url = URL(string: image_url)
        let data = try! Data(contentsOf: url!)
        let image = UIImage(data: data)
        detailedCV.image = image
        detailedCV.restaurant = likedList[indexPath.item-1]
        navigationController?.pushViewController(detailedCV, animated: true)
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        if(indexPath.item==0){
            return UITableViewCell.EditingStyle.none
        }else{
            return UITableViewCell.EditingStyle.delete
        }
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete{
            if tableView.numberOfRows(inSection: indexPath.section) == 1{}else{
                if(indexPath.item==0){}else{
                    let key = "Favorite_\(likedList[indexPath.item-1].id)"
                    likedList.remove(at: indexPath.item-1)
                    tableView.deleteRows(at: [indexPath], with: .fade)
                    defaults.removeObject(forKey: key)
                }
            }
        }
    }

}

extension FavoriteViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        userAvatar.image = UIImage(systemName: "circle")
        if let image = info[UIImagePickerController.InfoKey(rawValue: "UIImagePickerControllerEditedImage")] as? UIImage{
            self.userAvatar.image = image
        }
        picker.dismiss(animated: true, completion: nil)
    }
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
}
//// MARK: - PHPicker Configurations (PHPickerViewControllerDelegate)
//extension FavoriteViewController: PHPickerViewControllerDelegate {
//    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
//         picker.dismiss(animated: true, completion: .none)
//        let group = DispatchGroup()
//
//        self.userAvatar.image = UIImage(systemName: "circle")
//         results.forEach { result in
//             group.enter()
//               result.itemProvider.loadObject(ofClass: UIImage.self) { reading, error in
//                   defer{
//                       group.leave()
//                   }
//               guard let image = reading as? UIImage, error == nil else {
//                   print("!!!!!!!!!!!! PHPicker failed")
//                   print(error)
//
//                   return }
//                   print (image)
//          }
//       }
//        group.notify(queue: .main){
//            print("sSSSSssssSS")
//        }
//  }
//}
//
