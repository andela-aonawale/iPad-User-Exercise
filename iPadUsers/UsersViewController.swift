//
//  UsersViewController.swift
//  iPadUsers
//
//  Created by Ahmed Onawale on 3/21/16.
//  Copyright © 2016 Ahmed Onawale. All rights reserved.
//

import UIKit
import CoreData

class UsersViewController: UITableViewController {
    
    // MARK: - Properties
    
    var managedObjectContext: NSManagedObjectContext!
    var fetchedResultsControllerDataSource: FetchedResultsControllerDataSource!
    
    lazy var fetchedResultsController: NSFetchedResultsController = {
        let fetchRequest = NSFetchRequest(entityName: "User")
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "id", ascending: true)]
        let fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest,
            managedObjectContext: self.managedObjectContext,
            sectionNameKeyPath: nil,
            cacheName: "UserCache")
        return fetchedResultsController
    }()
    
    // MARK: - View controller life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.tableFooterView = UIView()
        splitViewController?.delegate = self
        // initialize fetchedResultsControllerDataSource
        fetchedResultsControllerDataSource = FetchedResultsControllerDataSource(tableView: tableView, reuseIdentifier: "User Cell", fetchedResultsController: fetchedResultsController)
        fetchedResultsControllerDataSource.delegate = self
        
        // fetch users if fetchedResultsController cannot find any peristed user
        if fetchedResultsController.fetchedObjects!.isEmpty {
            let activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: .Gray)
            activityIndicator.startAnimating()
            navigationItem.rightBarButtonItem = UIBarButtonItem(customView: activityIndicator)
            
            APIClient.sharedInstance.fetchAllUsers { [unowned self] result, error in
                self.navigationItem.rightBarButtonItem = nil
                guard error == nil,
                    let users = result as? [[String: AnyObject]] else {
                    Alert.showWithTitle(error?.localizedDescription ?? "Unknown Error", message: nil, controller: self)
                    return
                }
                users.forEach {
                    _ = User(dictionary: $0, insertIntoManagedObjectContext: self.managedObjectContext)
                }
                self.managedObjectContext.saveContext()
            }
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        self.clearsSelectionOnViewWillAppear = self.splitViewController!.collapsed
        super.viewWillAppear(animated)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK: - Segues
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        super.prepareForSegue(segue, sender: sender)
        guard let identifier = segue.identifier else { return }
        switch identifier {
        case "showAlbums":
            let indexPath = tableView.indexPathForSelectedRow!
            let controller = (segue.destinationViewController).contentViewController as! AlbumsViewController
            controller.managedObjectContext = managedObjectContext
            controller.user = fetchedResultsController.objectAtIndexPath(indexPath) as! User
            controller.navigationItem.leftBarButtonItem = splitViewController?.displayModeButtonItem()
            controller.navigationItem.leftItemsSupplementBackButton = true
        default:
            break
        }
    }

}

extension UsersViewController: FetchedResultsControllerDataSourceDelegate {
    
    // MARK: - FetchedResultsControllerDataSourceDelegate
    
    func configureCell(cell: UITableViewCell, withObject object: NSManagedObject) {
        (cell as! UserTableViewCell).user = object as? User
    }
}

extension UsersViewController: UISplitViewControllerDelegate {
    
    // MARK: - Split view
    
    func splitViewController(splitViewController: UISplitViewController, collapseSecondaryViewController secondaryViewController:UIViewController, ontoPrimaryViewController primaryViewController:UIViewController) -> Bool {
        guard let secondaryAsNavController = secondaryViewController as? UINavigationController else { return false }
        guard let albumViewController = secondaryAsNavController.topViewController as? AlbumsViewController else { return false }
        // Return true to indicate that we have handled the collapse by doing nothing;
        //the secondary controller will be discarded.
        return albumViewController.user == nil
    }
}
