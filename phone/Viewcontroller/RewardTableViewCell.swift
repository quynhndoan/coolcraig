//
//  RewardTableViewCell.swift
//  CoolCraig
//
//  Created by InfProjCourse2 on 12/5/19.
//  Copyright © 2019 InfProjCourse2. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseCore
import FirebaseFirestore
import Firebase


class RewardTableViewCell: UITableViewCell {
        
    @IBOutlet weak var rewardTitle: UILabel!
    
    @IBOutlet weak var rewardPoints: UILabel!
        
    @IBOutlet weak var claimRewardButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    @IBAction func claimedRewardButtonTapped(_ sender: Any) {
        let claimedPoints = Int(rewardPoints.text!.trimmingCharacters(in: .whitespacesAndNewlines))!
        let db = Firestore.firestore()
        let currentUserID = Auth.auth().currentUser!.uid
        let docRef = db.collection("users").document(currentUserID)
        docRef.getDocument { (document, error) in
            if let document = document, document.exists {
                let totalPoints = (document.get("totalPoints")) as? Int
                if totalPoints == nil {
                    print("NO POINTS TO CLAIM REWARD!")
                }
                else {
                    docRef.updateData(["totalPoints" : (totalPoints! - claimedPoints)])
                     { err in
                        if let err = err {
                            print("Error writing document: \(err)")
                        } else {
                            print("Document successfully updated!")
                        }
                    }
                }
            }
            else {
                print("Document does not exist")
            }
        }
    }
    
}
