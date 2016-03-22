//
//  APIClient.swift
//  iPadUsers
//
//  Created by Ahmed Onawale on 3/21/16.
//  Copyright © 2016 Ahmed Onawale. All rights reserved.
//

import Foundation

class APIClient {
    
    // MARK: - Constants
    private struct Sherpany {
        static let BASE_URL = "http://jsonplaceholder.typicode.com"
        struct Path {
            static let USERS = "/users"
            static let ALBUMS = "/albums"
            static let PHOTOS = "/photos"
        }
    }
    
    // MARK: - Properties
    static let sharedInstance = APIClient()
    private init() {}
    
    private lazy var URLWithPath: (path: String) -> NSURL = {
        let URLComponents = NSURLComponents(string: Sherpany.BASE_URL)!
        URLComponents.path = $0
        return URLComponents.URL!
    }
    
    typealias CompletionHandler = (result: AnyObject?, error: NSError?) -> Void
    
    private var session = NSURLSession.sharedSession()
    
    // MARK: - Request
    
    /// Fetch a photo with from the server
    /// - Returns: NSURLSessionDataTask
    /// - Parameters:
    ///   - url: the url of the photo to fetch
    ///   - completionHandler: the completionHandler to call when the image is returend from the server
    func fetchImageWithURL(url: String, completionHandler: (imageData: NSData?, error: NSError?) -> Void) -> NSURLSessionDataTask {
        let url = NSURL(string: url)!
        let task = session.dataTaskWithURL(url) { data, response, error in
            guard error == nil, let data = data else {
                completionHandler(imageData: nil, error: error!)
                return
            }
            completionHandler(imageData: data, error: nil)
        }
        task.resume()
        return task
    }
    
    /// Fetch all photos with the provided album id
    /// from the server
    /// - Returns: NSURLSessionDataTask
    /// - Parameters:
    ///   - albumId: the id of the album
    ///   - completionHandler: the completionHandler to call when the request is returend from the server
    func fetchPhotosForAlbumId(albumId: Int, completionHandler: CompletionHandler) -> NSURLSessionDataTask {
        let url = URLWithPath(path: Sherpany.Path.ALBUMS + "/\(albumId)" + Sherpany.Path.PHOTOS)
        return requestWithURL(url, completionHandler: completionHandler)
    }
    
    /// Fetch all album with the provided user id
    /// from the server
    /// - Returns: NSURLSessionDataTask
    /// - Parameters:
    ///   - userId: the id of the user
    ///   - completionHandler: the completionHandler to call when the request is returend from the server
    func fetchAlbumsForUserId(userId: Int, completionHandler: CompletionHandler) -> NSURLSessionDataTask {
        let url = URLWithPath(path: Sherpany.Path.USERS + "/\(userId)" + Sherpany.Path.ALBUMS)
        return requestWithURL(url, completionHandler: completionHandler)
    }
    
    /// Fetch all users
    /// from the server
    /// - Returns: NSURLSessionDataTask
    /// - Parameters:
    ///   - completionHandler: the completionHandler to call when the request is returend from the server
    func fetchAllUsers(completionHandler: CompletionHandler) -> NSURLSessionDataTask {
        let url = URLWithPath(path: Sherpany.Path.USERS)
        return requestWithURL(url, completionHandler: completionHandler)
    }
    
    private func requestWithURL(url: NSURL, completionHandler: CompletionHandler) -> NSURLSessionDataTask {
        let task = session.dataTaskWithURL(url) { data, response, error in
            dispatch_async(dispatch_get_main_queue()) {
                guard error == nil, let data = data else {
                    completionHandler(result: nil, error: error)
                    return
                }
                APIClient.parseJSONWithCompletionHandler(data, completionHandler: completionHandler)
            }
        }
        task.resume()
        return task
    }
    
    // Parsing the JSON
    
    class func parseJSONWithCompletionHandler(data: NSData, completionHandler: CompletionHandler) {
        let parsedResult: AnyObject?
        do {
            parsedResult = try NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.AllowFragments)
            completionHandler(result: parsedResult, error: nil)
        } catch let error as NSError {
            completionHandler(result: nil, error: error)
        }
    }
    
}