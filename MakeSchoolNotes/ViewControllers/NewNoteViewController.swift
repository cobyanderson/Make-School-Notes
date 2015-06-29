//
//  NewNoteViewController.swift
//  MakeSchoolNotes
//
//  Created by Samuel Coby Anderson on 6/24/15.
//  Copyright (c) 2015 MakeSchool. All rights reserved.
//

import UIKit
import ConvenienceKit
import RealmSwift
import Foundation

class NewNoteViewController: UIViewController {
    // had to add in the notes here
    var currentNote : Note?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
//    override func viewWillAppear(animated: Bool) {
//        currentNote = Note()
//        currentNote!.title = "new note"
//        currentNote!.content = "content"

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new View Controller using segue.destinationViewController.
        // Pass the selected object to the new View Controller.
        
        if (segue.identifier == "ShowNewNote") {
            // create a new Note and hold onto it, to be able to save it later
            currentNote = Note()
            
            let noteViewController = segue.destinationViewController as! NoteDisplayViewController
            noteViewController.note = currentNote
            noteViewController.editing = true

        }
        
        
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
