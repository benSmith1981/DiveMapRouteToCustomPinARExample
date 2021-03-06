//
//  SearchTableViewController.swift
//  DiveMapExample
//
//  Created by ben on 02/11/2017.
//  Copyright © 2017 ben. All rights reserved.
//

import UIKit

class SearchTableViewController: UITableViewController, UISearchBarDelegate {
    var sites: [DiveSite] = []
    var selectedDiveSite: DiveSite?
    var delegate: MapSearch?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //put notification to pick up search string results
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(SearchTableViewController.notifySearchResults),
                                               name:  NSNotification.Name(rawValue: "searchResults" ),
                                               object: nil)
        
    }
    
    //notification function
    @objc func notifySearchResults(notification: NSNotification) {
        var matchesDict = notification.userInfo as! Dictionary<String,[DiveSite]>
        self.sites = matchesDict["data"]!
        self.tableView.reloadData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return self.sites.count
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //here we some how call back to the map with the site that was tapped
        //Dismiss our search table
        let selectedDiveSite = self.sites[indexPath.row]
        delegate?.showDiveSiteSelected(diveSite: selectedDiveSite)
        dismiss(animated: true, completion: nil)
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        cell.textLabel?.text = sites[indexPath.row].name

        return cell
    }
    
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        DiveMapService.diveSearchString(searchString: searchBar.text!)
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
