//
//  PhotoListViewController.swift
//  MVVMDemo
//
//  Created by 李昀 on 2018/9/28.
//  Copyright © 2018 李昀. All rights reserved.
//

import UIKit
import SDWebImage

class PhotoListViewController: UIViewController {
  
  @IBOutlet weak var tableView: UITableView!
  @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
  
  
  lazy var viewModel: PhotoListViewModel = {
    return PhotoListViewModel()
  }()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    // init view
    initView()

    // init view model
    initVM()
  }
  
  func initView(){
    self.navigationItem.title = "Popular"
    
    tableView.estimatedRowHeight = 150.0
    tableView.rowHeight = UITableView.automaticDimension
  }
  
  func initVM(){
    
    viewModel.showAlertClosure = { [weak self] () in
      DispatchQueue.main.async {
        if let message = self?.viewModel.alertMessage {
          self?.showAlert(message)
        }
      }
    }
    
    viewModel.updateLoadingStatus = { [weak self] () in
      DispatchQueue.main.async {
        let isLoading = self?.viewModel.isLoading ?? false
        if isLoading {
          self?.activityIndicator.startAnimating()
          UIView.animate(withDuration: 0.2, animations: {
            self?.tableView.alpha = 0.0
          })
        } else {
          self?.activityIndicator.stopAnimating()
          UIView.animate(withDuration: 0.2, animations: {
            self?.tableView.alpha = 1.0
          })
        }
      }
    }
    
    viewModel.reloadTableViewClosure = { [weak self] () in
      DispatchQueue.main.async {
        self?.tableView.reloadData()
      }
    }
    
    viewModel.initFetch()
    
  }
  
  func showAlert(_ message: String){
    let alert = UIAlertController(title: "Not for sale", message: message, preferredStyle: .alert)
    alert.addAction( UIAlertAction(title: "Ok", style: .cancel, handler: nil))
    self.present(alert, animated: true, completion: nil)

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

extension PhotoListViewController: UITableViewDelegate, UITableViewDataSource{
  func numberOfSections(in tableView: UITableView) -> Int {
    return 1
  }
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return viewModel.numberOfCells
  }
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    guard let cell = tableView.dequeueReusableCell(withIdentifier: "photoCellIdentifier", for: indexPath) as? PhotoListTableViewCell else {
      fatalError("Cell not exist")
    }
    
    let cellVM = viewModel.getCellViewModel(at: indexPath)
    
    cell.nameLabel.text = cellVM.titleText
    cell.descriptionLabel.text = cellVM.descText
    cell.mainImageView.sd_setImage(with: URL(string: cellVM.imageUrl), completed: nil)
    cell.dateLabel.text = cellVM.dateText
    
    return cell
  }
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return 150.0
  }
  func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
    viewModel.userPressed(at: indexPath)
    if viewModel.isAllowSegue {
      return indexPath
    } else {
      return nil
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
