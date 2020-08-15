//
//  CreateNewAccountViewController.swift
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

class CreateNewAccountViewController: UIViewController {

    @IBOutlet weak var firstNameTextField: UITextField!
    
    @IBOutlet weak var lastNameTextField: UITextField!
    
    @IBOutlet weak var emailTextField: UITextField!
    
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBOutlet weak var selectUserTypeTextField: UITextField!
    
    @IBOutlet weak var userType: UISegmentedControl!
    
    @IBOutlet weak var createNewAccountButton: UIButton!
    
    @IBOutlet weak var errorLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpElements()
        // Do any additional setup after loading the view.
    }
    
    func setUpElements() {
        
        // Hide the error label
        errorLabel.alpha = 0
        passwordTextField.isSecureTextEntry = true
        // Style the elements
        Utilities.styleTextField(firstNameTextField)
        Utilities.styleTextField(lastNameTextField)
        Utilities.styleTextField(emailTextField)
        Utilities.styleTextField(passwordTextField)
        Utilities.styleFilledButton(createNewAccountButton)
    }

    func validateFields() -> String? {
        
        // check that all fields are filled in
        if firstNameTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" || lastNameTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" || emailTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" || passwordTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" {
            return "Please fill in all the fileds!"
        }
        
        // check if the password is secure
        let cleanedPassword = passwordTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        
        if Utilities.isPasswordValid(cleanedPassword) == false {
            // password isn't secure enough
            return "Please make sure your password is at least 8 characters, contains a special character and a number."
            
        }
        
        return nil
    }
    
    func showError(_ message:String) {
        errorLabel.text = message
        errorLabel.alpha = 1
    }
    
    func transitionToLogIn() {
        let logInViewController = storyboard?.instantiateViewController(identifier: Constants.Storyboard.logInViewController) as? LogInViewController
        
        view.window?.rootViewController = logInViewController
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

    @IBAction func createNewAccountTapped(_ sender: Any) {
    // Validate the fields
        let error = validateFields()
                
            if error != nil {
                // There is something wrong with the fields, show error message
                showError(error!)
            }
                    
            else {
                    
                // Create cleaned version of the data
                let firstName = firstNameTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
                    
                let lastName = lastNameTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
                    
                let email = emailTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
                    
                let password = passwordTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
                    
                //let userTypes = userType
                    
    
                    
                // Create the user
                Auth.auth().createUser(withEmail: email, password: password) { (result, err) in
                        // Check for errors
                    if err != nil {
                            
                            // there is an error creating the user
                        self.showError("Error creating user")
                    }
                    else{
                            // user was created successfully
                            // now we will store the user's info
                        let db = Firestore.firestore()
                            db.collection("users").addDocument(data: ["firstName":firstName, "lastName":lastName,"uid": result!.user.uid ]) { (error) in
                            
                            if error != nil {
                                // Show error message
                                self.showError("Error saving user data")
                            }
                            }
                        self.transitionToLogIn()
                        }
                    }
                            
        }
    }
}
