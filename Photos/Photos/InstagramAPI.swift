//
//  InstagramAPI.Swift
//  Photos
//
//  Created by Gene Yoo on 11/3/15.
//  Copyright © 2015 iOS DeCal. All rights reserved.
//

import Foundation

class InstagramAPI {
    
    func makeNewPhotoFromInstaJSON(photoJson:NSDictionary) -> Photo {
        let likes:NSDictionary          = photoJson.valueForKey("likes") as! NSDictionary
        let numLikes:Int                = (likes.valueForKey("count"))! as! Int
        let allResOfPhoto:NSDictionary  = photoJson.valueForKey("images") as! NSDictionary
        let lowResPhoto:NSDictionary    = allResOfPhoto.valueForKey("low_resolution") as! NSDictionary
        let photoUrl:String             = (lowResPhoto.valueForKey("url"))! as! String
        let user:NSDictionary           = photoJson.valueForKey("user") as! NSDictionary
        let username:String             = (user.valueForKey("username"))! as! String
        let photoParams:NSDictionary    = ["likes": numLikes, "url": photoUrl, "username": username]
        let newPhoto                    = Photo(data: photoParams)
        return newPhoto
    }
    
    /* Connects with the Instagram API and pulls resources from the server. */
    func loadPhotos(completion: (([Photo]) -> Void)!) {
        /*
         * 1. Get the endpoint URL to the popular photos 
         *    HINT: Look in Utils
         * 2. Create a Session
         * 3. Create a Data Task with a URL and completionHandler
         *    If no error:
         *       a. Get NSDictionary from the JSON object, from key the "photos"
         *       b. Create Array of NSDictionaries (one NSDictionary for each photo)
         *       c. For each NSDictionary, create a Photo object, and add to Photos array
         *       d. Wait for completion of Photos array
         */
        // FILL ME IN
        var url: NSURL
        url = Utils.getPopularURL()
        let task = NSURLSession.sharedSession().dataTaskWithURL(url) {
            (data: NSData?, response: NSURLResponse?, error: NSError?) -> Void in
            if error == nil {
                //FIX ME
                var photos: [Photo]!
                do {
                    let feedDictionary = try NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.MutableContainers) as! NSDictionary
                    // FILL ME IN, REMEMBER TO USE FORCED DOWNCASTING
                    photos = []
                    let photosFromJson = feedDictionary.valueForKey("data") as! NSArray
                    for (var i = 0; i < photosFromJson.count; i++) {
                        let currentPhoto:NSDictionary   = photosFromJson.objectAtIndex(i) as! NSDictionary
                        let newPhoto:Photo              = self.makeNewPhotoFromInstaJSON(currentPhoto)
                        photos.append(newPhoto)
                    }
                    
                    
                    // DO NOT CHANGE BELOW
                    let priority = DISPATCH_QUEUE_PRIORITY_DEFAULT
                    dispatch_async(dispatch_get_global_queue(priority, 0)) {
                        dispatch_async(dispatch_get_main_queue()) {
                            completion(photos)
                        }
                    }
                } catch let error as NSError {
                    print("ERROR: \(error.localizedDescription)")
                }
            }
        }
        task.resume()
    }
}