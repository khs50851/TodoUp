//
//  ViewController.swift
//  TodoUp
//
//  Created by user on 2023/04/05.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    var dataManager = CoreDataManager.shared
    let searchController = UISearchController()
    var searchItemText: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpDelegate()
        setupSearchBar()
        setUpNavBar()
        tableView.keyboardDismissMode = .onDrag
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }
   
    func setupSearchBar() {
        navigationItem.searchController = searchController
        
        searchController.automaticallyShowsCancelButton = true
        searchController.searchBar.delegate = self
        searchController.searchBar.searchTextField.backgroundColor = .white
        searchController.searchBar.placeholder = "Input your keyword"
        searchController.searchBar.autocapitalizationType = .none
        
    }
    
    func setUpNavBar() {
        self.title = Constants.title
        self.navigationItem.searchController = searchController
        self.navigationController?.navigationBar.tintColor = .white
        let plusBtn = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(plusBtnTapped))
        plusBtn.tintColor = .white
        navigationItem.rightBarButtonItem = plusBtn
    }
    
    func setUpDelegate() {
        tableView.dataSource = self
        tableView.delegate = self
    }

    @objc func plusBtnTapped() {
        performSegue(withIdentifier: Constants.itemCell, sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == Constants.itemCell {
            let detailVC = segue.destination as! DetailViewController
            
            guard let indexpath = sender as? IndexPath else {return}
            detailVC.item = dataManager.getItemListFromCoreDataByKeyword(content: searchItemText)[indexpath.row]
            
        }
    }
    
    func deleteCheckAlert(completion: @escaping (Bool) -> Void){
        
        let alert = UIAlertController(title: "Delete Item", message: "Are you sure to delete this item?", preferredStyle: .alert)
        let yes = UIAlertAction(title: "YES", style: .default){ yesAction in
            completion(true)
        }
        let no = UIAlertAction(title: "NO", style: .default){ noAction in
            completion(false)
        }
        alert.addAction(yes)
        alert.addAction(no)
        self.present(alert, animated: true)
    }
}

extension ViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataManager.getItemListFromCoreDataByKeyword(content: searchItemText).count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
       let cell = tableView.dequeueReusableCell(withIdentifier: Constants.itemCell, for: indexPath) as! ToDoItemCell

        let toDoItemData = dataManager.getItemListFromCoreDataByKeyword(content: searchItemText)
        
        cell.item = toDoItemData[indexPath.row]
        
        cell.deleteBtnPressed = {[weak self] (senderCell) in
            self?.deleteCheckAlert(completion: { deleteAction in
                if deleteAction {
                    guard let deleteTargetItem = cell.item else {return}
                    self?.dataManager.deleteItem(data: deleteTargetItem) {
                        self?.tableView.reloadData()
                    }
                }
            })
        }
        
        cell.checkBtnPressed = { [weak self] (senderCell) in
    
            guard let item = senderCell.item else {return}

            if item.checkdone {
                item.checkdone = false
            } else {
                item.checkdone = true
            }
            self?.dataManager.updateCheckDone(updateItem: item) {

            }
        }
        cell.selectionStyle = .none
        return cell
    }
    
}



extension ViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: Constants.itemCell, sender: indexPath)
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}

extension ViewController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        searchItemText = searchText
        self.tableView.reloadData()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchItemText = ""
        self.tableView.reloadData()
    }
    
}
