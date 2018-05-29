//
//  RegistroViewController.swift
//  Snapchat
//
//  Created by Johan Miranda on 5/21/18.
//  Copyright © 2018 Tecsup. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth

class RegistroViewController: UIViewController {

    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()

    }

    @IBAction func crearCuentaTapped(_ sender: Any) {
        Auth.auth().createUser(withEmail: self.emailTextField.text!, password:
            self.passwordTextField.text!, completion: {(user, error) in
                print("Intentando crear un usuario")
                if error != nil{
                    self.mostrarAlerta(title: "Error", message: "Algo salio mal vuelva a intentarlo", action: "Aceptar")
                }else{
                    self.mostrarAlerta(title: "Exito", message: "Usuario creado correctamente", action: "Aceptar"); Database.database().reference().child("usuarios").child(user!.user.uid).child("email").setValue(user!.user.email)
                }
        })
    }
    
    func mostrarAlerta(title: String, message: String, action: String){
        let alertaGuia = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let defaultAction = UIAlertAction(title: "Yes", style: .default, handler: { _ in
            let VC = self.storyboard?.instantiateViewController(withIdentifier: "Login")
            self.present(VC!, animated: true, completion: nil)
        })
        alertaGuia.addAction(defaultAction)
        present(alertaGuia, animated: true, completion: nil)
    }
    
}
