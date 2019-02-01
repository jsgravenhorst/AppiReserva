//
//  LoguinViewController.swift
//  AppiReserva
//
//  Created by Johann Stig Gravenhorst R. on 12/2/15.
//  Copyright © 2015 Olonte Apps. All rights reserved.
//

import UIKit

class LoguinViewController: UIViewController {
    
    let errorLoguin = "0"
  
    @IBOutlet weak var usuarioTextField: UITextField!
    @IBOutlet weak var claveTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        usuarioTextField.text = ""
        claveTextField.text = ""
        usuarioTextField.becomeFirstResponder()
    }

    func alerta(_ tlt : String!, msg : String!) {
        
        let titulo   : String = tlt
        let mensaje : String  = msg
        let messageHandler     = MessageHandler()
        
        let _titutlo   = messageHandler.getTitle(titulo)
        let _mensaje   = messageHandler.getMessage(mensaje)
            
        let alertController = UIAlertController( title : _titutlo, message: _mensaje, preferredStyle: UIAlertControllerStyle.alert)
            
        let cancelAction = UIAlertAction(title: "Ok", style: .cancel, handler: nil)
            
        alertController.addAction(cancelAction)
            
        self.present(alertController, animated: true, completion: nil)
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
        if segue.identifier == "sgSoyProfesor" {
            if usuarioTextField.text as String! == "" || claveTextField.text as String! == "" {
                alerta(errorLoguin, msg: errorLoguin)
            }else{
                let tabBarController      = segue.destination as! UITabBarController
                let reservaViewController = tabBarController.viewControllers![0] as! ReservaViewController
                reservaViewController.usuario = usuarioTextField.text as String!
                reservaViewController.clave   = claveTextField.text as String!
            }
        }
    }

}
