//
//  PhotosViewController.swift
//  iPadUsers
//
//  Created by Ahmed Onawale on 3/21/16.
//  Copyright © 2016 Ahmed Onawale. All rights reserved.
//

import UIKit
import CoreData

class PhotosViewController: UITableViewController {
    
    // MARK: - Properties
    
    var album: Album!
    var managedObjectContext: NSManagedObjectContext!
    var fetchedResultsControllerDataSource: FetchedResultsControllerDataSource!
    
    lazy var fetchedResultsController: NSFetchedResultsController = {
        NSFetchedResultsController.deleteCacheWithName("PhotoCache")
        let fetchRequest = NSFetchRequest(entityName: "Photo")
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "id", ascending: true)]
        fetchRequest.predicate = NSPredicate(format: "album == %@", self.album)
        let fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest,
            managedObjectContext: self.managedObjectContext,
            sectionNameKeyPath: nil,
            cacheName: "PhotoCache")
        return fetchedResultsController
    }()
    
    // MARK: - View controller life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = album.title
        tableView.tableFooterView = UIView()
        
        // initialize fetchedResultsControllerDataSource
        fetchedResultsControllerDataSource = FetchedResultsControllerDataSource(tableView: tableView, reuseIdentifier: "Photo Cell", fetchedResultsController: fetchedResultsController)
        fetchedResultsControllerDataSource.delegate = self
        
        // fetch photos from the server if the album doesn't have any photos
        if album.photos.isEmpty {
            let activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: .Gray)
            activityIndicator.startAnimating()
            navigationItem.rightBarButtonItem = UIBarButtonItem(customView: activityIndicator)
            
            APIClient.sharedInstance.fetchPhotosForAlbumId(album.id.integerValue) { [unowned self] result, error in
                self.navigationItem.rightBarButtonItem = nil
                guard error == nil,
                    let photos = result as? [[String: AnyObject]] else {
                    Alert.showWithTitle(error?.localizedDescription ?? "Unknown Error", message: nil, controller: self)
                    return
                }
                photos.forEach {
                    let photo = Photo(dictionary: $0, insertIntoManagedObjectContext: self.managedObjectContext)
                    photo.album = self.album
                }
                self.managedObjectContext.saveContext()
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
}

extension PhotosViewController: FetchedResultsControllerDataSourceDelegate {
    
    // MARK: - FetchedResultsControllerDataSourceDelegate
    
    func configureCell(cell: UITableViewCell, withObject object: NSManagedObject) {
        guard let cell = cell as? PhotoTableViewCell else { return }
        guard let photo = object as? Photo else { return }
        cell.title.text = photo.title
        var placeHolderImage = UIImage(named: "placeholder")
        if photo.thumbnailurl.isEmpty {
            placeHolderImage = UIImage(named: "noImage")
        } else if photo.image != nil {
            placeHolderImage = photo.image
        } else {
            cell.taskToCancelifCellIsReused = APIClient.sharedInstance.fetchImageWithURL(photo.thumbnailurl) { data, error in
                guard error == nil, let data = data else { return }
                let image = UIImage(data: data)
                photo.image = image
                dispatch_async(dispatch_get_main_queue()) {
                    cell.thumbnail.image = image
                }
            }
        }
        cell.thumbnail.image = placeHolderImage
    }
}
