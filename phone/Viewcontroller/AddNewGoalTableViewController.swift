//
//  AddNewGoalTableViewController.swift
//  CoolCraig
//
//  Created by InfProjCourse2 on 11/5/19.
//  Copyright © 2019 InfProjCourse2. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseCore
import FirebaseFirestore
import Firebase

class AddNewGoalTableViewController: UITableViewController {

    @IBOutlet weak var focusGoalButton: UIButton!
    
    @IBOutlet weak var doHomeworkGoalButton: UIButton!
    
    @IBOutlet weak var sayHiGoalButton: UIButton!
    
    @IBOutlet weak var answerSurveyGoalButton: UIButton!
    
    @IBOutlet weak var brushTeethGoalButton: UIButton!
    
    @IBOutlet weak var completeStepsGoalButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    // MARK: - Table view data source

    //override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
       // return 0
    //}

    //override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        //return 0
    //}

    /*
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        // Configure the cell...

        return cell
    }
    */

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
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
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    func transitionToGoalsNavigationController() {
        let goalsNavigationController = storyboard?.instantiateViewController(identifier: Constants.Storyboard.goalsNavigationController) as? GoalsNavigationController
        
        view.window?.rootViewController = goalsNavigationController
        view.window?.makeKeyAndVisible()
    }


    
    @IBAction func focusGoalTapped(_ sender: Any) {
        let db = Firestore.firestore()
        //let beginTime = Date()
               let currentUserID = Auth.auth().currentUser!.uid
               let param : [String:Any] = [
               "goalCategory": "School",
               "goalTitle": "Stay Focus on Task",
               "goalPoints": "10",
               //"beginTimeOfGoal": beginTime,
               "isCompleted": false]
               db.collection("users").whereField("uid", isEqualTo: currentUserID)
                   .getDocuments() { (querySnapshot, err) in
                       if let err = err {
                           print("Error getting documents: \(err)")
                       } else {
                           for document in querySnapshot!.documents {
                               let goalDB = Firestore.firestore().collection("users").document(document.documentID)
                               goalDB.updateData(["goals": FieldValue.arrayUnion([param])])
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
               transitionToGoalsNavigationController()
    }
    
    @IBAction func homeworkGoalTapped(_ sender: Any) {
        let db = Firestore.firestore()
        let currentUserID = Auth.auth().currentUser!.uid
        //let beginTime = Date()
        let param : [String:Any] = [
        "goalCategory": "School",
        "goalTitle": "Do Homework",
        "goalPoints": "10",
        //"beginTimeOfGoal": beginTime,
        "isCompleted": false]
        db.collection("users").whereField("uid", isEqualTo: currentUserID)
            .getDocuments() { (querySnapshot, err) in
                if let err = err {
                    print("Error getting documents: \(err)")
                } else {
                    for document in querySnapshot!.documents {
                        let goalDB = Firestore.firestore().collection("users").document(document.documentID)
                        goalDB.updateData(["goals": FieldValue.arrayUnion([param])])
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
        transitionToGoalsNavigationController()
    }
    
    @IBAction func emotionsGoalTapped(_ sender: Any) {
        let db = Firestore.firestore()
        let currentUserID = Auth.auth().currentUser!.uid
        //let beginTime = Date()
        let param : [String:Any] = [
        "goalCategory": "Emotions",
        "goalTitle": "Answer Survey",
        "goalPoints": "10",
        //"beginTimeOfGoal": beginTime,
        "isCompleted": false]
        db.collection("users").whereField("uid", isEqualTo: currentUserID)
            .getDocuments() { (querySnapshot, err) in
                if let err = err {
                    print("Error getting documents: \(err)")
                } else {
                    for document in querySnapshot!.documents {
                        let goalDB = Firestore.firestore().collection("users").document(document.documentID)
                        goalDB.updateData(["goals": FieldValue.arrayUnion([param])])
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
        transitionToGoalsNavigationController()
    }
    
    @IBAction func socialGoalTapped(_ sender: Any) {
        let db = Firestore.firestore()
        let currentUserID = Auth.auth().currentUser!.uid
        //let beginTime = Date()
        let param : [String:Any] = [
        "goalCategory": "Scocial",
        "goalTitle": "Say Hi to A Friend",
        "goalPoints": "10",
        //"beginTimeOfGoal": beginTime,
        "isCompleted": false]
        db.collection("users").whereField("uid", isEqualTo: currentUserID)
            .getDocuments() { (querySnapshot, err) in
                if let err = err {
                    print("Error getting documents: \(err)")
                } else {
                    for document in querySnapshot!.documents {
                        let goalDB = Firestore.firestore().collection("users").document(document.documentID)
                        goalDB.updateData(["goals": FieldValue.arrayUnion([param])])
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
        transitionToGoalsNavigationController()
    }
    
    @IBAction func hygieneGoalTapped(_ sender: Any) {
        let db = Firestore.firestore()
        let currentUserID = Auth.auth().currentUser!.uid
        //let beginTime = Date()
        let param : [String:Any] = [
        "goalCategory": "Hygiene",
        "goalTitle": "Brush Your Teeth",
        "goalPoints": "10",
        //"beginTimeOfGoal": beginTime,
        "isCompleted": false]
        db.collection("users").whereField("uid", isEqualTo: currentUserID)
            .getDocuments() { (querySnapshot, err) in
                if let err = err {
                    print("Error getting documents: \(err)")
                } else {
                    for document in querySnapshot!.documents {
                        let goalDB = Firestore.firestore().collection("users").document(document.documentID)
                        goalDB.updateData(["goals": FieldValue.arrayUnion([param])])
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
        transitionToGoalsNavigationController()
    }
    
    @IBAction func generalGoalTapped(_ sender: Any) {
        let db = Firestore.firestore()
        let currentUserID = Auth.auth().currentUser!.uid
        //let beginTime = Date()
        let param : [String:Any] = [
        "goalCategory": "General",
        "goalTitle": "Complete 5000 Steps",
        "goalPoints": "10",
        //"beginTimeOfGoal": beginTime,
        "isCompleted": false]
        db.collection("users").whereField("uid", isEqualTo: currentUserID)
            .getDocuments() { (querySnapshot, err) in
                if let err = err {
                    print("Error getting documents: \(err)")
                } else {
                    for document in querySnapshot!.documents {
                        let goalDB = Firestore.firestore().collection("users").document(document.documentID)
                        goalDB.updateData(["goals": FieldValue.arrayUnion([param])])
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
        transitionToGoalsNavigationController()
    }
}
