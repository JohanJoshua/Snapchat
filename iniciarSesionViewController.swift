//
//  iniciarSesionViewController.swift
//  Snapchat
//
//  Created by Johan Miranda on 5/12/18.
//  Copyright © 2018 Tecsup. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth

class iniciarSesionViewController: UIViewController {

    
    @IBAction func iniciarSesionTapped(_ sender: Any) {
        Auth.auth().signIn(withEmail: emailTextField.text!,
                           password: passwordTextField.text!){
                            (user, error) in print("Intentando Iniciar Sesion")
                            if error != nil{
                                print("Se presento el siguiente error: \(error)")
                            }else{
                                print("Inicio de Sesion Exitoso")
                            }
        }
    }
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
}

