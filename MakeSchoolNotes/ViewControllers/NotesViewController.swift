//
//  ViewController.swift
//  MakeSchoolNotes
//
//  Created by Martin Walsh on 29/05/2015.
//  Copyright (c) 2015 MakeSchool. All rights reserved.
//

import UIKit
import Foundation
import RealmSwift

class NotesViewController: UIViewController {

    var selectedNote: Note?
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    
    enum State {
        case DefaultMode
        case SearchMode
    }
    func searchNotes(searchString: String) -> Results<Note> {
        let realm = Realm()
        let searchPredicate = NSPredicate(format: "title CONTAINS[c] %@ OR content CONTAINS[c] %@", searchString, searchString)
        return realm.objects(Note).filter(searchPredicate)
    }
    var state: State = .DefaultMode {
        didSet {
            // update notes and search bar whenever State changes
            switch (state) {
            case .DefaultMode:
                let realm = Realm()
                notes = realm.objects(Note).sorted("modificationDate", ascending: false) //1
                self.navigationController!.setNavigationBarHidden(false, animated: true) //2
                searchBar.resignFirstResponder() // 3
                searchBar.text = ""
                searchBar.showsCancelButton = false
            case .SearchMode:
                let searchText = searchBar?.text ?? ""
                searchBar.setShowsCancelButton(true, animated: true) //4
                notes = searchNotes(searchText) //5
                self.navigationController!.setNavigationBarHidden(true, animated: true) //6
            }
        }
    }
    
    override func viewDidLoad() {
        let realm = Realm()
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
            
        notes = realm.objects(Note).sorted("modificationDate", ascending: false)
        
        // Do any additional setup after loading the view, typically from a nib.
        
        //creating new note but not storing it
//        let myNote = Note()
//        myNote.title = "Super Simple Test Note"
//        myNote.content = "A long piece of content"
        
        //storing new note in realm
//        let realm = Realm()
//        realm.write() {
//            realm.add(myNote)
//      Before you can add it to Realm you must first grab the default Realm.
//      All changes to an object (addition, modification and deletion) must be done within a write transaction/closure.
//      Add your new note to Realm
        
        //DELETES ALL REALM DATA 
        //realm.deleteAll();
            
        //Loads all new notes
        //self.notes = realm.objects(Note)
        
        tableView.dataSource = self
        tableView.delegate = self
    }

    override func viewWillAppear(animated: Bool) {
        
        let realm = Realm()
        notes = realm.objects(Note).sorted("modificationDate", ascending: false)
        state = .DefaultMode
        super.viewWillAppear(animated)
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
   
    
    var notes: Results<Note>! {
        didSet {
            // Whenever notes update, update the table view
            tableView?.reloadData()
        }
    }
    @IBAction func unwindToSegue(segue: UIStoryboardSegue){
        if let identifier = segue.identifier { let realm = Realm()

            println("Identifier \(identifier)")
            
            switch identifier {
            case "Save":
                let source = segue.sourceViewController as! NewNoteViewController //1
                
                realm.write() {
                    realm.add(source.currentNote!)
                }
            case "Delete":
                realm.write(){
                    realm.delete(self.selectedNote!)
                }
                let source = segue.sourceViewController as! NoteDisplayViewController
                source.note=nil
            default:
                println("No one loves \(identifier)")
            }
            
            notes = realm.objects(Note).sorted("modificationDate", ascending: false) //2
        }
    
}
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == "ShowExistingNote") {
            let noteViewController = segue.destinationViewController as! NoteDisplayViewController
            noteViewController.note = selectedNote
        }
    }
}

extension NotesViewController: UITableViewDataSource {
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("NoteCell", forIndexPath: indexPath) as! NoteTableViewCell //1
        
        let row = indexPath.row
        let note = notes[row] as Note
        cell.note = note
        
        
        return cell
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Int(notes?.count ?? 0)
//        if let notes = notes {
//            return Int(notes.count)
//        } else {
//            return 0
        }
}

extension NotesViewController: UITableViewDelegate {
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
         selectedNote = notes[indexPath.row]      //1
//        When a note has been selected, we want to assign this note to a variable for easy access. When a row is selected, the row index is passed as a parameter so we can grab the correct note object using the objectAtIndex method.
        self.performSegueWithIdentifier("ShowExistingNote", sender: self)     //2
    }
//We will be performing a segue to a new Note Display View Controller (you will add this soon) that will display the selected note.
    
    // 3
    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    // This function is used to check if a row can be edited. In our app we would always like this behaviour, so it will always return true.
    }
    
    // 4
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if (editingStyle == .Delete) {
            let note = notes[indexPath.row] as Object
            
            let realm = Realm()
            
            realm.write() {
                realm.delete(note)
            }
            
            notes = realm.objects(Note).sorted("modificationDate", ascending: false)
    // This function is activated when you left swipe your Table View to enter edit mode and are presented with the option to Delete the selected row.
        }
    }
    
}
extension NotesViewController: UISearchBarDelegate {
    
    func searchBarTextDidBeginEditing(searchBar: UISearchBar) {
        state = .SearchMode
    }
    
    func searchBarCancelButtonClicked(searchBar: UISearchBar) {
        state = .DefaultMode
    }
    
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        notes = searchNotes(searchText)
    }
    
}




