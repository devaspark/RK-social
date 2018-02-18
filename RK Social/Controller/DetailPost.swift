//
//  DetailPost.swift
//  RK Social
//
//  Created by Rex Kung on 2/9/18.
//  Copyright © 2018 Rex Kung. All rights reserved.
//

import UIKit
import Firebase

class DetailPost: UIViewController, PostDelegate, UICollectionViewDelegate, UICollectionViewDataSource {

    @IBOutlet weak var profileImg: UIImageView!
    @IBOutlet weak var usernameLbl: UILabel!
    @IBOutlet weak var postImg: UIImageView!
    @IBOutlet weak var caption: UITextView!
    @IBOutlet weak var collectionView: UICollectionView!

    var threadReference: DatabaseReference!
    var tempPost: Post!
    var posts = [Post]()
    
//    override func loadView() {
//        threadReference.observe(.value) { (snapshot) in
//            if let snapshot = snapshot.children.allObjects as? [DataSnapshot] {
//                for snap in snapshot {
//                    let key = snap.key
//                    DataService.ds.REF_COMMENTS.observeSingleEvent(of: .value, with: { (singleSnapshotPost) in
//                        if let postDict = singleSnapshotPost.value as? Dictionary<String, Any> {
//                            let post = Post(postKey: key, caption: postDict[key] as! String)
//                            self.posts.append(post)
//                        }
//                    })
//                    
//                }
//                
//            }
//        }
//    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        print("This is viewdidload thread ref: \(threadReference)")
        threadReference.observe(.value) { (snapshot) in
            self.posts = []     //clear the posts
            if let snapshot = snapshot.children.allObjects as? [DataSnapshot] {
                for snap in snapshot {
                    let key = snap.key
                    print(snap)
                    DataService.ds.REF_COMMENTS.observeSingleEvent(of: .value, with: { (singleSnapshotPost) in

                        if let postDict = singleSnapshotPost.value as? Dictionary<String, Any> {
                            print("This is what i get: \(postDict)")
                            print("this is the key: \(key)")
                            print("This is what i want: \(String(describing: postDict[key]))")
                            let post = Post(postKey: key, caption: postDict[key] as! String)
                            self.posts.append(post)
                            print("number of postssssssssss: \(self.posts.count)")
                            self.collectionView.reloadData()
                        }
                    })
                    
                }
                
            }
            
        }
        threadReference.observeSingleEvent(of: .value) { (firstSnapshot) in
            self.posts = []     //clear the posts
            if let snapshot = firstSnapshot.children.allObjects as? [DataSnapshot] {
                for snap in snapshot {
                    let key = snap.key
                    DataService.ds.REF_COMMENTS.observeSingleEvent(of: .value, with: { (singleSnapshotPost) in
                        
                        if let postDict = singleSnapshotPost.value as? Dictionary<String, Any> {
                            let post = Post(postKey: key, caption: postDict[key] as! String)
                            self.posts.append(post)
                            self.collectionView.reloadData()
                        }
                    })
                    
                }
                
            }
        }

        print("number of posts: \(self.posts.count)")
//        ref?.observe(.childAdded, with: { (snapshot) in
//
//            //Convert the info of the data into a string variable
//            if let getData = snapshot.value as? [String:Any] {
//
//                print(getData)
//
//                let wins = getData["wins"] as? String
//
//                print("\(wins)")
//                
//            }
//
//        })        // Do any additional setup after loading the view.
    }

    func SendingPostData(tempPost: Post) {
        self.tempPost = tempPost
        threadReference = DataService.ds.REF_THREADS.child(tempPost.postKey)
        print("This is sendingpostdata thread ref: \(threadReference)")
    }

    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if self.posts.count > 0 {
            return self.posts.count
        } else {
            return 1

        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        //Grab number of comments under a particular post
        
        
        guard let post = posts[indexPath.row] as Post? else {
            return UICollectionViewCell()
        }
        
        //dequeue cell
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PostCollect", for: indexPath) as? PostCollectionCell {
            cell.configureCell(post: post)
            return cell
        } else {
            return UICollectionViewCell()
        }
    }
    
    /*override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let nav = segue.destination as? UINavigationController, let previousVC = nav.topViewController as? FeedVC {
            previousVC.postDelegate = self
        }
        
    }*/
    

}
