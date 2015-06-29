//
//  NoteDisplayViewController.swift
//  MakeSchoolNotes
//
//  Created by Samuel Coby Anderson on 6/25/15.
//  Copyright (c) 2015 MakeSchool. All rights reserved.
//

import UIKit
import Foundation
import RealmSwift
import ConvenienceKit

class NoteDisplayViewController: UIViewController {
   
    @IBOutlet weak var titleTextField: UITextField!
    
    @IBOutlet weak var contentTextView: TextView!
    
    @IBOutlet weak var deleteButton: UIBarButtonItem!
    @IBOutlet weak var toolbarBottomSpace: NSLayoutConstraint!
    
    var keyboardNotificationHandler: KeyboardNotificationHandler?
    
    
    var note: Note? {
        didSet {
            displayNote(note)
        }
    }
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        displayNote(self.note)
        
        titleTextField.returnKeyType = .Next //1
        titleTextField.delegate = self       //2
        //1: We are renaming the 'Return' button on the keyboard to 'Next'. For our app it makes more sense from a user experience perspective that you most likely want to move on to the next input field after entering the title. We can handle this in the UITextFieldDelegate soon.
       // 2: Set the titleTextField delegate. We will implement the delegate as a class extension as we did with our Table View Delegate.
        keyboardNotificationHandler = KeyboardNotificationHandler()
        
        
        keyboardNotificationHandler!.keyboardWillBeHiddenHandler = { (height: CGFloat) in
            UIView.animateWithDuration(0.3){
                self.toolbarBottomSpace.constant = 0
                self.view.layoutIfNeeded()
            }
        }
        
        keyboardNotificationHandler!.keyboardWillBeShownHandler = { (height: CGFloat) in
            UIView.animateWithDuration(0.3) {
                self.toolbarBottomSpace.constant = height
                self.view.layoutIfNeeded()
            }
        
        }
        if editing {
            deleteButton.enabled = false
        }
        self.navigationController!.setNavigationBarHidden(false, animated: true)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func displayNote(note: Note?) {
        if let note = note, titleTextField = titleTextField, contentTextView = contentTextView  {
            titleTextField.text = note.title
            contentTextView.text = note.content
            
            if count(note.title)==0 && count(note.content)==0 { //1
                titleTextField.becomeFirstResponder()
            //1: Here we're checking the length of our note content strings. If there is no content, we'll assume 'Edit' mode and set the first responder. This will set focus to the titleTextField and prompt the user with the keyboard ready for title input. If we are not in 'Edit' mode, then the note will be displayed as is and no keyboard will pop up until the user initiates this action for themselves.
            }
        }
    }
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        
        saveNote()
    }
    
    func saveNote() {
        if let note = note {
            let realm = Realm()
            
            realm.write {
                if (note.title != self.titleTextField.text || note.content != self.contentTextView.textValue) {
                    note.title = self.titleTextField.text
                    note.content = self.contentTextView.textValue
                    note.modificationDate = NSDate()
                }
            }
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
extension NoteDisplayViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        
        if (textField == titleTextField) {  //1
            contentTextView.returnKeyType = .Done
            contentTextView.becomeFirstResponder()
        }
        
        return false
    }
}

