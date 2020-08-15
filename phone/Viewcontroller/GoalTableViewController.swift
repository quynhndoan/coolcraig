//
//  GoalTableViewController.swift
//  CoolCraig
//
//  Created by InfProjCourse2 on 11/19/19.
//  Copyright © 2019 InfProjCourse2. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseCore
import FirebaseFirestore
import Firebase

class GoalTableViewController: UITableViewController {

    var goals : [goal?] = []
    let addedCount = 200
    let countPerPage = 10
    var lastCurrentPageDoc: DocumentSnapshot?
    var docRef: DocumentReference!
    private var isFetchInProgress = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        
        self.tableView.reloadData()
            
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    
    
    
    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return goals.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "goalCell", for: indexPath) as! GoalTableViewCell
        let newGoals = goals[indexPath.row]
        cell.goalCategory!.text = newGoals?.category
        cell.goalTitle!.text = newGoals?.title
        cell.goalPoints!.text = newGoals?.points
        
        // cell.completeButtonTapped((Any).self)
          return cell
        
    }


    
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        let cell = tableView.dequeueReusableCell(withIdentifier: "goalCell", for: indexPath) as! GoalTableViewCell
        let completedGoals = goals[indexPath.row]
        let endTime = Date()
        cell.goalCategory!.text = completedGoals?.category
        cell.goalTitle!.text = completedGoals?.title
        cell.goalPoints!.text = completedGoals?.points
        if editingStyle == UITableViewCell.EditingStyle.delete {
            goals.remove(at: indexPath.row)
            let db = Firestore.firestore()
            let currentUserID = Auth.auth().currentUser!.uid
            
            let temp : [String:Any] = [
            "goalCategory": completedGoals?.category ?? String(),
            "goalTitle": completedGoals?.title ?? String(),
            "goalPoints": completedGoals?.points ?? String(),
            "isCompleted": false]
            
            let points = Int(completedGoals?.points ?? String())!
            
            let param : [String:Any] = [
                "goalCategory": completedGoals?.category ?? String(),
                "goalTitle": completedGoals?.title ?? String(),
                "goalPoints": completedGoals?.points ?? String(),
                "endTimeOfGoal": endTime,
                "isCompleted": true]
            db.collection("users").whereField("uid", isEqualTo: currentUserID)
                .getDocuments() { (querySnapshot, err) in
                    if let err = err {
                        print("Error getting documents: \(err)")
                    } else {
                        for document in querySnapshot!.documents {
                            let goalDB = Firestore.firestore().collection("users").document(document.documentID)
                            let currentPoints = document.data()["totalPoints"] as? Int
                            goalDB.updateData(["goals": FieldValue.arrayRemove([temp])])
                            goalDB.updateData(["completedGoals": FieldValue.arrayUnion([param])])
                            goalDB.updateData(["totalPoints": currentPoints!+points])
                            {
                                err in
                                if let err = err {
                                    print("Error writing document: \(err)")
                                } else {
                                    print("Document successfully updated!")
                                }
                        
                            }
                        }
                    }
            }
            self.tableView.beginUpdates()
            tableView.deleteRows(at: [indexPath], with: UITableView.RowAnimation.automatic)
            tableView.deleteRows(at: [indexPath], with: .fade)
            self.tableView.endUpdates()
        
    }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchData()
    }
    
    func fetchGoals(completed: @escaping ([goal?], Error?)->Void) {
        let db = Firestore.firestore()
        let currentUserID = Auth.auth().currentUser!.uid
        db.collection("users").whereField("uid", isEqualTo: currentUserID)
            .getDocuments() { (querySnapshot, err) in
                if let err = err {
                    print("Error getting documents: \(err)")
                } else {
                    for document in querySnapshot!.documents {
                        let goalDB = Firestore.firestore().collection("users")
                        var goalsArray : [goal?] = []
                        goalDB.document(document.documentID).getDocument { (document, err) in
                        
                            if let document = document, document.exists {
                            let goals = document.data()?["goals"] as? [[String:Any]]
                                if goals == nil {
                               print("NO GOAL")
                           }
                           else {
                               for data in goals! {
                                goalsArray.append(goal(dictionary: data))
                               }
                           }
                          completed(goalsArray, nil)
                            } else {
                          print("Document does not exist")
                           }
                        }
                    }
                }
        }
        
    }
    
    
    func visibleIndexPathsToReload(intersecting indexPaths: [IndexPath]) -> [IndexPath] {
      let indexPathsForVisibleRows = tableView.indexPathsForVisibleRows ?? []
      let indexPathsIntersection = Set(indexPathsForVisibleRows).intersection(indexPaths)
      return Array(indexPathsIntersection)
    }
      
    func isLoadingCell(for indexPath: IndexPath) -> Bool {
      return indexPath.row >= goals.count
    }

    
    func fetchData() {
        guard !isFetchInProgress else {
            
              return
            }
            
            isFetchInProgress = true
            self.fetchGoals(completed:  { (newGoals, err) in
                guard err == nil else {
                  print("Error when get users: \(err!)")
                  return
                }
 
                for g in newGoals{
                    self.goals.append(g)
                }
                self.tableView.reloadData()
                self.isFetchInProgress = false
              })
            }
          }
          
    extension GoalTableViewController: UITableViewDataSourcePrefetching {
            func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
              print("prefetch rows at index paths: \(indexPaths)")
              if indexPaths.contains(where: isLoadingCell) {
                fetchData()
              }
            }
          }


