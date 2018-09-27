//
//  PhotoListViewController.swift
//  MVCDemo
//
//  Created by 李昀 on 2018/9/27.
//  Copyright © 2018 李昀. All rights reserved.
//

import UIKit
import SDWebImage

class PhotoListViewController: UIViewController {

  @IBOutlet weak var tableView: UITableView!
  @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
  
  var photos: [Photo] = [Photo]()
  
  var selectedIndexPath: IndexPath?
  
  lazy var apiService: ApiService = {
    return ApiService()
  }()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    // init view
    initView()
    
    // fetch data
    initData()
  }
  
  func initView(){
    self.navigationItem.title = "Popular"
    
    tableView.estimatedRowHeight = 150.0
    tableView.rowHeight = UITableView.automaticDimension
  }
  
  func initData(){
    apiService.fetchPopularPhoto { [weak self] (success, photos, error) in
      DispatchQueue.main.async {
        self?.photos = photos
        
        self?.activityIndicator.stopAnimating()
        UIView.animate(withDuration: 0.2, animations: {
          self?.tableView.alpha = 1.0
        })
        
        self?.tableView.reloadData()
      }
    }
  }
 
}

extension PhotoListViewController: UITableViewDelegate, UITableViewDataSource{
  func numberOfSections(in tableView: UITableView) -> Int {
    return 1
  }
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return photos.count
  }
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    guard let cell = tableView.dequeueReusableCell(withIdentifier: "photoCellIdentifier", for: indexPath) as? PhotoListTableViewCell else {
      fatalError("Cell not exist")
    }
    
    let photo = self.photos[indexPath.row]
    
    // text
    cell.nameLabel.text = photo.name
    
    // description (wrap)
    var descText: [String] = [String]()
    if let camera = photo.camera {
      descText.append(camera)
    }
    if let description = photo.description {
      descText.append(description)
    }
    cell.descriptionLabel.text = descText.joined(separator: " - ")
    
    // date (wrap)
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yyyy-MM-dd"
    cell.dateLabel.text = dateFormatter.string(from: photo.created_at)
    
    // image
    cell.mainImageView.sd_setImage(with: URL(string: photo.image_url), completed: nil)
    
    return cell
  }
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return 150.0
  }
  func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
    let photo = self.photos[indexPath.row]
    if photo.for_sale {
      self.selectedIndexPath = indexPath
      return indexPath
    } else {
      let alert = UIAlertController(title: "Not for sale", message: "This item is not for sale", preferredStyle: .alert)
      alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
      self.present(alert, animated: true, completion: nil)
      
      return nil
    }
  }
}

extension PhotoListViewController {
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if let vc = segue.destination as? PhotoDetailViewController,
       let indexPath = self.selectedIndexPath {
      let photo = self.photos[indexPath.row]
      vc.imageUrl = photo.image_url
    }
  }
}


class PhotoListTableViewCell: UITableViewCell {
  @IBOutlet weak var mainImageView: UIImageView!
  @IBOutlet weak var dateLabel: UILabel!
  @IBOutlet weak var descriptionLabel: UILabel!
  @IBOutlet weak var nameLabel: UILabel!
  @IBOutlet weak var descContainerHeightConstraint: NSLayoutConstraint!

}
