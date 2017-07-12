//
//  RhymeViewController.swift
//  
//
//  Created by Nathan Lewis on 7/12/17.
//
//

import UIKit
import Alamofire

class RhymeViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate {

    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    
    var rhymeList =  [RhymeDto]()
    var maxSylla = [Int]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        searchBar.delegate = self

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        var word = searchBar.text
        var rhymeURL = "https://api.datamuse.com/words?rel_rhy=" + word!
        Alamofire.request(rhymeURL, method: .get, parameters: ["":""], encoding: URLEncoding.default, headers: nil).responseJSON { (response:DataResponse<Any>) in
            switch(response.result) {
            case .success(_):
                if response.result.value != nil{
                    
                    if let result = response.result.value {
                        let JSON = result as! NSArray
                        print(JSON)
                        guard let rhymeResults = [RhymeDto].from(jsonArray: result as! [JSON]) else{
                            // handle decoding failure here
                            return
                        }
                        self.rhymeList = rhymeResults
                        self.tableView.reloadData()
                    }}
            case .failure(_):
                print(response.result.error!)
                break
            }
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if rhymeList == nil{
            return 0
        }
        else{
            for word in rhymeList{
                if (maxSylla.contains(word.syllables) == false){
                    maxSylla.append(word.syllables)
                }
            }
            return maxSylla.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
