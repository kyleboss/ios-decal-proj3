//
//  PhotoViewController.swift
//  Photos
//
//  Created by Kyle Boss on 11/15/15.
//  Copyright © 2015 iOS DeCal. All rights reserved.
//

import Foundation
import UIKit

class PhotoViewController: UIViewController {
    
    @IBOutlet weak var uploader: UILabel!
    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var numLikes: UILabel!
    @IBOutlet weak var likeImg: UIImageView!
    var photo:Photo?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        uploader.text   = photo!.username
        numLikes.text   = String(photo!.likes)
        let url         = NSURL(string: photo!.url)
        if let data     = NSData(contentsOfURL: url!) {
            image.image = UIImage(data: data)
        }
        if (photo!.isLiked) {
            likeImg.image = UIImage(named: "heartRed.png")
        } else {
            likeImg.image = UIImage(named: "heartGrey.png")
        }
        
        let singleTap                   = UITapGestureRecognizer(target: self, action:Selector("tapDetected"))
        likeImg.userInteractionEnabled  = true
        likeImg.addGestureRecognizer(singleTap)
    }
    
    func tapDetected() {
        print(photo!.isLiked)
        if (photo!.isLiked) {
            likeImg.image = UIImage(named: "heartGrey.png")
            numLikes.text = String(photo!.likes)
            photo!.isLiked = false
        } else {
            likeImg.image = UIImage(named: "heartRed.png")
            numLikes.text = String(photo!.likes+1)
            photo!.isLiked = true
        }
    }
}