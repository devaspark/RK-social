//
//  FeedVC.swift
//  RK Social
//
//  Created by Rex Kung on 1/10/18.
//  Copyright © 2018 Rex Kung. All rights reserved.
//

import UIKit
import Firebase
import SwiftKeychainWrapper

protocol PostDelegate {
    func SendingPostData(tempPost: Post)
}



class FeedVC: UIViewController, UITableViewDelegate, UITableViewDataSource, UIImagePickerControllerDelegate, UINavigationControllerDelegate, CommentDelegate {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var imageAdd: CircleView!
    @IBOutlet weak var captionField: CustomText!
    
    var posts = [Post]()
    var imagePicker: UIImagePickerController!
    static var imageCache: NSCache<NSString, UIImage> = NSCache()
    var imageSelected = false
    var postDelegate: PostDelegate?
    weak var tempPost: Post?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = self
        
        imagePicker = UIImagePickerController()
        imagePicker.allowsEditing = true
        imagePicker.delegate = self
        imagePicker.navigationController?.delegate = self
        
        DataService.ds.REF_POSTS.observe(.value, with: { (snapshot) in
            self.posts = []
            if let snapshot = snapshot.children.allObjects as? [DataSnapshot] {
                for snap in snapshot {

                    if let postDict = snap.value as? Dictionary<String, Any> {
                        let key = snap.key
                        let post = Post(postKey: key, postData: postDict)
                        self.posts.append(post)
                        
                        
                    }
                }
            }
            self.tableView.reloadData()
        })
    }

    @IBAction func signOutTapped(_ sender: Any) {
        KeychainWrapper.standard.removeObject(forKey: KEY_UID)
        let firebaseAuth = Auth.auth()
        do {
            try firebaseAuth.signOut()
        } catch let signOutError as NSError {
            print ("Error signing out: %@", signOutError)
        }
        performSegue(withIdentifier: "goToSignIn", sender: nil)
        
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //add number of rows
        return self.posts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let post = posts[indexPath.row]
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: "PostCell") as? PostCell {
            cell.delegate = self
            if let img = FeedVC.imageCache.object(forKey: post.imageUrl as NSString) {
                cell.configureCell(post: post, img: img)
            } else {
                cell.configureCell(post: post)
            }
            return cell
            
        } else {
            return PostCell()
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let image = info[UIImagePickerControllerEditedImage] as? UIImage {
            imageAdd.image = image
            imageSelected = true
        } else {
            print("Rex: Image wasn't selected")
        }
        imagePicker.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func addImageTapped(_ sender: Any) {
        present(imagePicker, animated: true, completion: nil)
    }
    
    @IBAction func postBtnTapped(_ sender: Any) {
        guard let caption = captionField.text, caption != "" else {
            print("Rex: Caption must be entered")
            return
        }
        
        guard let img = imageAdd.image, imageSelected == true else {
            print("Rex: An image must be selected")
            return
        }
        
        if let imgData = UIImageJPEGRepresentation(img, 0.2) {
            
            let imgUid = NSUUID().uuidString
            let metadata = StorageMetadata()
            metadata.contentType = "image/jpeg"
            
            DataService.ds.REF_POST_IMAGES.child(imgUid).putData(imgData, metadata: metadata) {(metadata, error) in
                if error != nil {
                    print("Rex: unable to upload image to Firebase Storage")
                } else {
                    print("Rex: successfully uploaded image to Firebase Storage")
                    let downloadURL = metadata?.downloadURL()?.absoluteString
                    if let url = downloadURL {
                        self.postToFirebase(imgUrl: url)
                    }
                    

                }
                
            }
            
 
        }
    }
    
    func postToFirebase(imgUrl: String) {
        let post: Dictionary<String, Any> = [
            "caption": captionField.text!,
            "imageUrl": imgUrl,
            "likes": 0
            ]
        
        let firebasePost = DataService.ds.REF_POSTS.childByAutoId()
        firebasePost.setValue(post)
        
        //let threadPost = DataService.ds.REF_THREADS.child(firebasePost.key)
        //threadPost.setValue(firebasePost.key)
        
        captionField.text = ""
        imageSelected = false
        imageAdd.image = UIImage(named: "add-image")
        
        self.posts = []
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toDetailPost" {
            print("did it get here?")
            let vc = segue.destination as! DetailPost
            self.postDelegate = vc
            print("This is postcell \(String(describing: self.tempPost?.caption))")
            postDelegate?.SendingPostData(tempPost: self.tempPost!)
            
        }
    }

    
    
    
    
    func CommentData(cell: PostCell) {
        let indexPath = self.tableView.indexPath(for: cell)
        let postCell = self.tableView.cellForRow(at: indexPath!) as! PostCell
        tempPost = postCell.post
        performSegue(withIdentifier: "toDetailPost", sender: nil)
        
        

        print(indexPath!.row)
        
    }

}
