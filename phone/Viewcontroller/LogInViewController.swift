//
//  LogIn2ViewController.swift
//  CoolCraig
//
//  Created by InfProjCourse2 on 11/11/19.
//  Copyright © 2019 InfProjCourse2. All rights reserved.
//

import UIKit
import FirebaseAuth

class LogInViewController: UIViewController {

    @IBOutlet weak var emailTextField: UITextField!
    
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBOutlet weak var logInButton: UIButton!
    
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
        Utilities.styleTextField(emailTextField)
        Utilities.styleTextField(passwordTextField)
        Utilities.styleFilledButton(logInButton)
        
    }
    
    func showError(_ message:String) {
        errorLabel.text = message
        errorLabel.alpha = 1
    }
    
    func transitionToGoalsNavigationController() {
        let goalsNavigationController = storyboard?.instantiateViewController(identifier: Constants.Storyboard.goalsNavigationController) as? GoalsNavigationController
        
        view.window?.rootViewController = goalsNavigationController
        view.window?.makeKeyAndVisible()
    }
    
    func validateFields() -> String? {
        
        // Check that all fields are filled in
        if emailTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            passwordTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" {
            
            return "Please fill in all fields."
        }
        
        // Check if the password is secure
        let cleanedPassword = passwordTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        
        if Utilities.isPasswordValid(cleanedPassword) == false {
            // Password isn't secure enough
            return "Incorrect email/password"
        }
        
        return nil
    }
    


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

    @IBAction func logInTapped(_ sender: Any) {
        // validate the fields
              let error = validateFields()
              
              if error != nil {
                  
                  // There's something wrong with the fields, show error message
                  showError(error!)
              }
              else {
                  let email = emailTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
                  let password = passwordTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
                      
                      // Signing in the user
                  Auth.auth().signIn(withEmail: email, password: password) { (result, error) in
                          
                      if error != nil {
                              // Couldn't sign in
                          self.errorLabel.text = "Incorrect email/password"
                          self.errorLabel.alpha = 1
                      }
                      else {
                              
                          self.transitionToGoalsNavigationController()
                          }
                      }
                  }
              }

}
