//
//  TemplatesTableView.swift
//  MemeMe
//
//  Created by Kinan Turjman on 4/9/15.
//  Copyright (c) 2015 Kinan Turjman. All rights reserved.
//

import UIKit

/* This class is used for the templates table view. It creates a table view with pre-determined
 * templates that the user can pick from to make a Meme. It uses the same custom table cell as the one
 * that is used for the Sent memes table.
*/
class TemplatesTableViewController: UITableViewController, UITableViewDataSource {
    
    // Variables
    var templates = [Template]() // the array of template objects
    
    // an array of all the template titles
    var titles = [
        "One Does Not Simply",
        "Ancient Aliens",
        "The Most Interesting Man In The World",
        "X, X Everywhere",
        "Futurama Fry",
        "First World Problems",
        "Bad Luck Brian",
        "Y U No",
        "Leonardo Dicaprio Cheers",
        "Brace Yourselves X is Coming",
        "Grumpy Cat",
        "Success Kid",
        "That Would Be Great",
        "Captain Picard Facepalm",
        "Am I The Only One Around Here",
        "Philosoraptor",
        "Skeptical Baby",
        "Conspiracy Keanu",
        "Overly Attached Girlfriend",
        "Liam Neeson Taken"
    ]
    // array that will contain the paths to all the images
    var images = [String]()
    
    // definie the Template Struct
    struct Template {
        var image: UIImage // image of the template
        var title: String // template's title
        
        init(image: UIImage, title: String){
            self.image = image
            self.title = title
        }
    }
    
    // delegate View Conterller (in this case it will be the editor view
    var delegate: ViewController? = nil
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(false)
        
        // fill the templates array
        fillTemplates()
    }
    
    // MARK: TableView Functions
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return templates.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        // deque the cell as a custom table view cell
        let cell = tableView.dequeueReusableCellWithIdentifier("MemeTableCell") as CustomTableViewCell
        
        // create a template
        let template = templates[indexPath.row]
        
        // Set the name and image
        cell.topText.text = template.title
        cell.memeImage.image = template.image
        cell.bottomText.text = ""
        
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        // enable the share button in the Edit View
        delegate?.leftBarButton.enabled = true
        
        // call the function in the edit view ViewController to display the chosen Meme
        delegate?.showTemplate(templates[indexPath.row].image)
        
        // dismiss the tableView
        dismissViewControllerAnimated(false, completion: nil)
    }
    
    // MARK: OTHER FUNCTIONS
    // function to fill the templates array
    // this is much quicker than doing each template by itself
    func fillTemplates(){
        // iterates over each title, creates a new template and appends it to the array
        for(var i = 0; i < titles.count; i++){
            
            // set the image
            var image = UIImage(named: "t\(i + 1).jpg")
            
            // create the template
            var template = Template(image: image!, title: titles[i])
            
            // append
            templates.append(template)
        }
    }
}
