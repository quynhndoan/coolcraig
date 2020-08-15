//
//  CreateNewGoalViewController.swift
//  CoolCraig
//
//  Created by InfProjCourse2 on 11/11/19.
//  Copyright © 2019 InfProjCourse2. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseCore
import FirebaseFirestore
import Firebase

class CreateNewGoalViewController: UIViewController {

    @IBOutlet weak var categoryTextField: UITextField!
    
    @IBOutlet weak var titleTextField: UITextField!
    
    @IBOutlet weak var pointsTextField: UITextField!
 
    @IBOutlet weak var createNewGoalButton: UIButton!
    
    @IBOutlet weak var errorLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpElements()
        // Do any additional setup after loading the view.
    }
    
    func setUpElements() {
        
        // Hide the error label
        errorLabel.alpha = 0
        
        // Style the elements
        Utilities.styleTextField(categoryTextField)
        Utilities.styleTextField(titleTextField)
        Utilities.styleTextField(pointsTextField)
        Utilities.styleFilledButton(createNewGoalButton)
    }
    
    func validateFields() -> String? {
    
    // check that all fields are filled in
        if categoryTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" || titleTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" || pointsTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" {
            return "Please fill in all the fileds!"
        }
        return nil
        
    }
    
    func transitionToGoalsNavigationController() {
        let goalsNavigationController = storyboard?.instantiateViewController(identifier: Constants.Storyboard.goalsNavigationController) as? GoalsNavigationController
        
        view.window?.rootViewController = goalsNavigationController
        view.window?.makeKeyAndVisible()
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

    @IBAction func createButtonTapped(_ sender: Any) {
        
        let category = categoryTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        
        let title = titleTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
               
        let points = pointsTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        
        //let beginTime = Date()
        
        let db = Firestore.firestore()
        let currentUserID = Auth.auth().currentUser!.uid
        let param : [String:Any] = [
        "goalCategory": category,
        "goalTitle": title,
        "goalPoints": points,
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

//        docRef.updateData(["goals": FieldValue.arrayUnion([param])])
//         { err in
//            if let err = err {
//                print("Error writing document: \(err)")
//            } else {
//                print("Document successfully updated!")
//            }
//        }
        transitionToGoalsNavigationController()
    }
    
}

