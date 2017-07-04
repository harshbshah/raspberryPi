//
//  ViewController.swift
//  note_CD
//
//  Created by Marcel Harvan on 2017-04-08.
//  Copyright © 2017 The Marcel's fake Company. All rights reserved.
//

import UIKit

import CoreData

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, NSFetchedResultsControllerDelegate{
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var infoCinstrain: NSLayoutConstraint!
    @IBOutlet weak var infoView: UIView!
    
    var controller: NSFetchedResultsController<Notes>!
    var infoShowing = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        tableView.delegate = self
        tableView.dataSource = self
        attemptFetch()
        
    }
    
    @IBAction func infoBut(_ sender: Any) {
        if (infoShowing) {
            infoCinstrain.constant = -255
        } else {
            infoCinstrain.constant = 5
            UIView.animate(withDuration: 0.3, animations: {self.view.layoutIfNeeded()})
        }
        infoShowing = !infoShowing
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "NoteCell", for: indexPath) as! NoteCell
        configureCell(cell: cell, indexPath: indexPath as NSIndexPath)
        return cell
        
    }
    
    func configureCell(cell: NoteCell, indexPath: NSIndexPath) {
        
        let notes = controller.object(at: indexPath as IndexPath)
        cell.configureCell(notes: notes)
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let objs = controller.fetchedObjects , objs.count > 0 {
            
            let notes = objs[indexPath.row]
            performSegue(withIdentifier: "NoteVC", sender: notes)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "NoteVC" {
            if let destination = segue.destination as? NoteVC {
                if let notes = sender as? Notes {
                    destination.notesToEdit = notes
                }
            }
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let sections = controller.sections {
            
            let sectionInfo = sections[section]
            return sectionInfo.numberOfObjects
        }
        
        return 0
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        if let sections = controller.sections {
            return sections.count
        }
        
        return 0
    }
    
    func attemptFetch(){
        let fetchRequest: NSFetchRequest<Notes> = Notes.fetchRequest()
        let dateSort = NSSortDescriptor(key: "created", ascending: false)
        let var1 = 1
        
        if (var1 == 1){
            fetchRequest.sortDescriptors = [dateSort]
        }
        
        let controller = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
        
        controller.delegate = self
        
        self.controller = controller
        
        do {
            
            try controller.performFetch()
            
        } catch {
            
            let error = error as NSError
            print("\(error)")
            
        }
        
    }
    
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.beginUpdates()
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.endUpdates()
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        
        switch(type) {
            
        case.insert:
            if let indexPath = newIndexPath {
                tableView.insertRows(at: [indexPath], with: .fade)
            }
            break
        case.delete:
            if let indexPath = indexPath {
                tableView.deleteRows(at: [indexPath], with: .fade)
            }
            break
        case.update:
            if let indexPath = indexPath {
                let cell = tableView.cellForRow(at: indexPath) as! NoteCell
                configureCell(cell: cell, indexPath: indexPath as NSIndexPath)
            }
            break
        case.move:
            if let indexPath = indexPath {
                tableView.deleteRows(at: [indexPath], with: .fade)
            }
            if let indexPath = newIndexPath {
                tableView.insertRows(at: [indexPath], with: .fade)
            }
            break
            
        }
    }
    
    
}
