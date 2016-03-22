//
//  AlbumsViewController.swift
//  iPadUsers
//
//  Created by Ahmed Onawale on 3/21/16.
//  Copyright © 2016 Ahmed Onawale. All rights reserved.
//

import UIKit
import CoreData

class AlbumsViewController: UITableViewController {
    
    // MARK: - Properties
    
    var user: User!
    var managedObjectContext: NSManagedObjectContext!
    var fetchedResultsControllerDataSource: FetchedResultsControllerDataSource!
    
    lazy var fetchedResultsController: NSFetchedResultsController = {
        NSFetchedResultsController.deleteCacheWithName("AlbumCache")
        let fetchRequest = NSFetchRequest(entityName: "Album")
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "id", ascending: true)]
        fetchRequest.predicate = NSPredicate(format: "user == %@", self.user)
        let fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest,
            managedObjectContext: self.managedObjectContext,
            sectionNameKeyPath: nil,
            cacheName: "AlbumCache")
        return fetchedResultsController
    }()

    // MARK: - View controller life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // if the user property is not set, we return to avoid crash
        guard user != nil else { return }
        
        title = user.name
        
        // initialize fetchedResultsControllerDataSource
        fetchedResultsControllerDataSource = FetchedResultsControllerDataSource(tableView: tableView, reuseIdentifier: "Album Cell", fetchedResultsController: fetchedResultsController)
        fetchedResultsControllerDataSource.delegate = self
        
        // fetch albums from the server if the user doesn't have any album
        if user.albums.isEmpty {
            let activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: .Gray)
            activityIndicator.startAnimating()
            navigationItem.rightBarButtonItem = UIBarButtonItem(customView: activityIndicator)
            
            APIClient.sharedInstance.fetchAlbumsForUserId(user.id.integerValue) { [unowned self] result, error in
                self.navigationItem.rightBarButtonItem = nil
                guard error == nil,
                    let albums = result as? [[String: AnyObject]] else {
                    Alert.showWithTitle(error?.localizedDescription ?? "Unknown Error", message: nil, controller: self)
                    return
                }
                albums.forEach {
                    let album = Album(dictionary: $0, insertIntoManagedObjectContext: self.managedObjectContext)
                    album.user = self.user
                }
                self.managedObjectContext.saveContext()
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK: - Table view controller delegate
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let controller = storyboard?.instantiateViewControllerWithIdentifier("PhotosViewController") as! PhotosViewController
        controller.managedObjectContext = managedObjectContext
        controller.album = fetchedResultsController.objectAtIndexPath(indexPath) as! Album
        navigationController?.pushViewController(controller, animated: true)
    }

}

extension AlbumsViewController: FetchedResultsControllerDataSourceDelegate {
    
    // MARK: - FetchedResultsControllerDataSourceDelegate
    
    func configureCell(cell: UITableViewCell, withObject object: NSManagedObject) {
        cell.textLabel?.text = (object as! Album).title
    }
}
