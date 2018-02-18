//
//  PostCollectionCell.swift
//  RK Social
//
//  Created by Rex Kung on 2/13/18.
//  Copyright © 2018 Rex Kung. All rights reserved.
//

import UIKit
import Firebase

class PostCollectionCell: UICollectionViewCell {
    @IBOutlet weak var profileImg: UIImageView!
    @IBOutlet weak var caption: UITextView!
    var post: Post!
   
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
   
    }
    
    func configureCell(post: Post) {
        self.post = post
        self.caption.text = post.caption
    }
    
//    func configureCell(post: Post, img: UIImage? = nil) {
//        self.post = post
//        self.caption.text = post.caption
//
//
//        if img != nil {
//            self.postImg.image = img
//        } else {
//            let ref = Storage.storage().reference(forURL: post.imageUrl)
//            ref.getData(maxSize: 2 * 1024 * 1024, completion: { (data, error) in
//                if error != nil {
//                    // there is an error
//                    print("Rex: Unable to download image from Firebase Storage")
//                } else {
//                    print("Rex: Image downloaded from Firebase storage")
//                    if let imgData = data {
//                        if let img = UIImage(data: imgData) {
//                            self.postImg.image = img
//                            FeedVC.imageCache.setObject(img, forKey: post.imageUrl as NSString)
//                        }
//                    }
//                }
//            })
//
//        }
//    }
}
