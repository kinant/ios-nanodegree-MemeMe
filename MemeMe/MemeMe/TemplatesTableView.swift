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
        self.dismissViewControllerAnimated(false, completion: nil)
    }
}
