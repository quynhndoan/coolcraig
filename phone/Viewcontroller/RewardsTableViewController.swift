//
//  RewardsTableViewController.swift
//  CoolCraig
//
//  Created by InfProjCourse2 on 11/21/19.
//  Copyright © 2019 InfProjCourse2. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseCore
import FirebaseFirestore
import Firebase

class RewardsTableViewController: UITableViewController {
    var rewards : [reward?] = []
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
           return rewards.count
       }

       
       override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
           let cell = tableView.dequeueReusableCell(withIdentifier: "rewardCell", for: indexPath) as! RewardTableViewCell
           let newRewards = rewards[indexPath.row]
           cell.rewardTitle?.text = newRewards?.rewardTitle
           cell.rewardPoints?.text = newRewards?.rewardPoints
           
             return cell
           
       }


       
       // Override to support conditional editing of the table view.
       override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
           // Return false if you do not want the specified item to be editable.
           return true
       }
       
       // Override to support editing the table view.
          override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
              let cell = tableView.dequeueReusableCell(withIdentifier: "rewardCell", for: indexPath) as! RewardTableViewCell
              let claimedRewards = rewards[indexPath.row]
              //let endTime = Date()
              cell.rewardTitle!.text = claimedRewards?.rewardTitle
              cell.rewardPoints!.text = claimedRewards?.rewardPoints
              
          
              
              if editingStyle == UITableViewCell.EditingStyle.delete {
                  rewards.remove(at: indexPath.row)
                  let db = Firestore.firestore()
                  let currentUserID = Auth.auth().currentUser!.uid
                   let points = Int(claimedRewards?.rewardPoints ?? String())!
                  let temp : [String:Any] = [
                  "rewardTitle": claimedRewards?.rewardTitle ?? String(),
                  "rewardPoints": claimedRewards?.rewardPoints ?? String(),
                  "claimed": false]
                  
                  
                  let param : [String:Any] = [
                      "rewardTitle": claimedRewards?.rewardTitle ?? String(),
                      "rewardPoints": points,
                      "claimed": true]
                  db.collection("users").whereField("uid", isEqualTo: currentUserID)
                      .getDocuments() { (querySnapshot, err) in
                          if let err = err {
                              print("Error getting documents: \(err)")
                          } else {
                              for document in querySnapshot!.documents {
                                  let rewardDB = Firestore.firestore().collection("users").document(document.documentID)
                                  let currentPoints = document.data()["totalPoints"] as? Int
                                  if (currentPoints! >= points)
                                  {
                                  rewardDB.updateData(["rewards":  FieldValue.arrayRemove([temp])])
                                  rewardDB.updateData(["claimedRewards": FieldValue.arrayUnion([param])])
                                  rewardDB.updateData(["totalPoints": currentPoints!-points])
                                  {
                                      err in
                                    
                                    
                                      if let err = err {
                                          print("Error writing document: \(err)")
                                      } else {
                                          print("Document successfully updated!")
                                      }
                              
                                  }
                                }
                                  else {
                                    let alert = UIAlertController(title: "Error!", message: "You do not have enough point to claim this reward. You have \(currentPoints!).", preferredStyle: .alert)

                                    alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))

                                    self.present(alert, animated: true)
                                    rewardDB.updateData(["claimedRewards": FieldValue.arrayUnion([param])])
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
        
       
       func fetchRewards(completed: @escaping ([reward?], Error?)->Void) {
        let db = Firestore.firestore()
            let currentUserID = Auth.auth().currentUser!.uid
            db.collection("users").whereField("uid", isEqualTo: currentUserID)
                .getDocuments() { (querySnapshot, err) in
                    if let err = err {
                        print("Error getting documents: \(err)")
                    } else {
                        for document in querySnapshot!.documents {
                            let rewardDB = Firestore.firestore().collection("users")
                            var rewardsArray : [reward?] = []
                            rewardDB.document(document.documentID).getDocument { (document, err) in
                            
                            if let document = document, document.exists  {
                                let rewards = document.data()?["rewards"] as? [[String:Any]]
                              if rewards == nil {
                                   print("NO REWARD")
                               }
                               else {
                                   for data in rewards! {
                                    rewardsArray.append(reward(dictionary: data))
                                   }
                               }
                              completed(rewardsArray, nil)
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
         return indexPath.row >= rewards.count
       }

       
       func fetchData() {
           guard !isFetchInProgress else {
               
                 return
               }
               
               isFetchInProgress = true
               self.fetchRewards(completed:  { (newRewards, err) in
                   guard err == nil else {
                     print("Error when get users: \(err!)")
                     return
                   }
    
                   for g in newRewards{
                       self.rewards.append(g)
                   }
                   self.tableView.reloadData()
                   self.isFetchInProgress = false
                 })
               }
             }

        
   
       extension RewardsTableViewController: UITableViewDataSourcePrefetching {
               func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
                 print("prefetch rows at index paths: \(indexPaths)")
                 if indexPaths.contains(where: isLoadingCell) {
                   fetchData()
                 }
               }
             }


