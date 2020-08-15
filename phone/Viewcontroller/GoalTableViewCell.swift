//
//  GoalTableViewCell.swift
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

class GoalTableViewCell: UITableViewCell {
    

    @IBOutlet weak var goalCategory: UILabel!
    
    @IBOutlet weak var goalTitle: UILabel!
    
    @IBOutlet weak var goalPoints: UILabel!
    
    @IBOutlet weak var completeButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
    @IBAction func completeButtonTapped(_ sender: Any) {
        let title = goalTitle.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        let totalPoints = 0
        let newPoints = Int(goalPoints.text!.trimmingCharacters(in: .whitespacesAndNewlines))!
        let db = Firestore.firestore()
        let currentUserID = Auth.auth().currentUser!.uid
        db.collection("users").whereField("uid", isEqualTo: currentUserID)
            .getDocuments() { (querySnapshot, err) in
                if let err = err {
                    print("Error getting documents: \(err)")
                } else {
                    for document in querySnapshot!.documents {
                        let goalDB = Firestore.firestore().collection("users").document(document.documentID)
                        let currentGoal = document.get("goals.goalTitle") as? String
                        if title == currentGoal {
                            goalDB.updateData(["goals.isCompleted": true,"totalPoints" : (totalPoints + newPoints)])
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
        }
        
    }

}
