//
//  PhotoDetailViewController.swift
//  MVVMDemo
//
//  Created by 李昀 on 2018/9/28.
//  Copyright © 2018 李昀. All rights reserved.
//

import UIKit
import SDWebImage

class PhotoDetailViewController: UIViewController {
  
  @IBOutlet weak var imageView: UIImageView!
  var imageUrl: String?
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    if let imageUrl = imageUrl {
      imageView.sd_setImage(with: URL(string: imageUrl), completed: nil)
    }

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
