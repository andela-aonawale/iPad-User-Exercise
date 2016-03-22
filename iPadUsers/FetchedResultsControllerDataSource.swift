//
//  FetchedResultsControllerDataSource.swift
//  SHERPANY-Objects
//
//  Created by Ahmed Onawale on 3/21/16.
//  Copyright © 2016 Ahmed Onawale. All rights reserved.
//

import Foundation
import CoreData
import UIKit

protocol FetchedResultsControllerDataSourceDelegate {
    func configureCell(cell: UITableViewCell, withObject object: NSManagedObject)
}

class FetchedResultsControllerDataSource: NSObject {
    
    // MARK: - Properties
    var reuseIdentifier: String
    var tableView: UITableView
    var fetchedResultsController: NSFetchedResultsController!
    var delegate: FetchedResultsControllerDataSourceDelegate?
    
    // MARK: - Initialization
    init(tableView: UITableView, reuseIdentifier: String, fetchedResultsController: NSFetchedResultsController) {
        self.tableView = tableView
        self.reuseIdentifier = reuseIdentifier
        self.fetchedResultsController = fetchedResultsController
        super.init()
        self.tableView.dataSource = self
        fetchedResultsController.delegate = self
        performFetch()
    }
    
    private func performFetch() {
        do {
            try fetchedResultsController.performFetch()
        } catch {
            print("fetchedResultsController error: \(error)")
        }
    }
    
}

extension FetchedResultsControllerDataSource: UITableViewDataSource {
    
    // MARK: - Table View data source
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let sectionInfo = fetchedResultsController.sections![section]
        return sectionInfo.numberOfObjects
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return fetchedResultsController.sections?.count ?? 0
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(reuseIdentifier, forIndexPath: indexPath)
        delegate?.configureCell(cell, withObject: fetchedResultsController.objectAtIndexPath(indexPath) as! NSManagedObject)
        return cell
    }
    
}

extension FetchedResultsControllerDataSource: NSFetchedResultsControllerDelegate {
    
    // MARK: - NSFetchedResultsControllerDelegate
    
    func controllerWillChangeContent(controller: NSFetchedResultsController) {
        tableView.beginUpdates()
    }
    
    func controller(controller: NSFetchedResultsController, didChangeSection sectionInfo: NSFetchedResultsSectionInfo, atIndex sectionIndex: Int, forChangeType type: NSFetchedResultsChangeType) {
        switch type {
        case .Insert:
            tableView.insertSections(NSIndexSet(index: sectionIndex), withRowAnimation: .Automatic)
        case .Delete:
            tableView.deleteSections(NSIndexSet(index: sectionIndex), withRowAnimation: .Automatic)
        case .Update, .Move:
            break
        }
    }
    
    func controller(controller: NSFetchedResultsController, didChangeObject anObject: AnyObject, atIndexPath indexPath: NSIndexPath?, forChangeType type: NSFetchedResultsChangeType, newIndexPath: NSIndexPath?) {
        switch type {
        case .Insert:
            tableView.insertRowsAtIndexPaths([newIndexPath!], withRowAnimation: .Automatic)
        case .Delete:
            tableView.deleteRowsAtIndexPaths([indexPath!], withRowAnimation: .Automatic)
        case .Update:
            tableView.reloadRowsAtIndexPaths([indexPath!], withRowAnimation: .Automatic)
        case .Move:
            tableView.deleteRowsAtIndexPaths([indexPath!], withRowAnimation: .Automatic)
            tableView.insertRowsAtIndexPaths([indexPath!], withRowAnimation: .Automatic)
        }
    }
    
    func controllerDidChangeContent(controller: NSFetchedResultsController) {
        tableView.endUpdates()
    }
    
}