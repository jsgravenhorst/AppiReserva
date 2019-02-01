//
//  ListadoReservaTableViewController.swift
//  AppiReserva
//
//  Created by Johann Stig Gravenhorst R. on 12/29/15.
//  Copyright © 2015 Olonte Apps. All rights reserved.
//

import UIKit
import CoreData

class ListadoReservaTableViewController: UITableViewController, JSONParserDelegate {
    
    @IBOutlet var reservaTableView: UITableView!
    fileprivate var datosJSON            = Dictionary<String,AnyObject>()
    fileprivate var datosSendJSONReserva = Dictionary<String,AnyObject>()
    fileprivate var jsonParserViewController : JSONParserViewController = JSONParserViewController()
    
    fileprivate var reservas: [Reserva]! = []
    fileprivate var arrayRecursosDO = [RecursoDO]()
    
   /* private let urlEliminarReserva = "http://localhost/AppiReserva/mod_aplicacion/appireserva_eliminar_reserva.php"*/
    fileprivate let urlEliminarReserva = "http://www.olonte.com/APPS/USC/Admin//mod_aplicacion/appireserva_eliminar_reserva.php"
    fileprivate let reservaTlt       = "7"
    fileprivate let reservaVacia     = "7"
    fileprivate let reservaElim      = "8"
    fileprivate let errorReservaTlt  = "8"
    var band : Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        cargarDatos()
         self.reservaTableView.reloadData()
    }
    
    func cargarDatos() {
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let managedObjectContext = appDelegate.managedObjectContext
        let fetchRequest = NSFetchRequest<Reserva>(entityName: "Reserva")
        
        do {
            if let resultadoReserva = try managedObjectContext.fetch(fetchRequest) as [Reserva]? {
                reservas = resultadoReserva
            }
            
            if reservas.count == 0 {
                self.alerta(self.reservaTlt, msg: self.reservaVacia )
            }else{
                do {
                    let fetchRequest = NSFetchRequest<Recurso>(entityName: "Recurso")
                    let capacidadDf = 0
                     if let resultadoRecursos = try managedObjectContext.fetch(fetchRequest) as [Recurso]? {
                        for recurso in resultadoRecursos {
                            let recursoDO : RecursoDO = RecursoDO(idRecurso: recurso.idRecurso! as String,
                                nombreRecurso: recurso.nombreRecurso! as String,
                                capacidad: capacidadDf )
                            self.arrayRecursosDO.append(recursoDO)
                        }
                    }
                } catch let error as NSError {
                    let mensaje = "No se pudo cargar el Recurso del CoreData \(error). \(error.userInfo)"
                    self.alerta(self.errorReservaTlt, msg: mensaje)
                }
            }
        }catch let error as NSError {
            let mensaje = "No se pudo cargar la Reserva del CoreData \(error). \(error.userInfo)"
            self.alerta(self.errorReservaTlt, msg: mensaje)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return reservas.count
    }
    
   
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellListadoReserva", for: indexPath) as! ListadoReservaTableViewCell
        let reserva = reservas[(indexPath as NSIndexPath).row]
        cell.labelRecurso.text      = obtenerNombreRecurso(reserva.idRecurso! as String)
        cell.labelFechaReserva.text = reserva.fechaInicial! as String
        
        return cell
    }
    
    func obtenerNombreRecurso(_ idRecurso: String) -> String {
        
        var nombreRecurso = ""
        
        for recurso in arrayRecursosDO {
            if recurso.idRecurso == idRecurso {
                nombreRecurso = recurso.nombreRecurso
                break
            }
        }
        
        return nombreRecurso
    }
    
    func eliminarReserva(_ reserva: Reserva, index: Int) {
        
        datosJSON["idReserva"] = reserva.idReserva! as String as AnyObject?
        
        /******************************Eliminar Reserva Arreglo Reservas********************************/
        reservas.remove(at: index)
        
        /*************************Eliminar Reserva CoreData********************************************/
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let managedObjectContext = appDelegate.managedObjectContext
        managedObjectContext.delete(reserva)
        do{
            try managedObjectContext.save()
        }catch let error as NSError{
            let mensaje = "No se pudo eliminar la Reserva del CoreData \(error). \(error.userInfo)"
            self.alerta(Util.errorTltCoreData, msg: mensaje)
        }
        
        /*************************Eliminar Reserva Base de Datos**************************************/
        jsonParserViewController.delegateJSON = self
        jsonParserViewController.makeHttpAsynchronousRequest(urlEliminarReserva, params: datosJSON, method: Util.sendJSON)
    }
    
    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */
    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            self.eliminarReserva(reservas[(indexPath as NSIndexPath).row] as Reserva, index: (indexPath as NSIndexPath).row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }

    /*
    override func tableView(tableView: UITableView, editActionsForRowAtIndexPath indexPath: NSIndexPath) -> [UITableViewRowAction]? {
       
        let deleteAction = UITableViewRowAction(style: UITableViewRowActionStyle.Default, title: "Eliminar") { (action: UITableViewRowAction, indexPath: NSIndexPath) -> Void in
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        }
        
        let editAction = UITableViewRowAction(style: .Normal, title: "Editar") { [weak self] _ in
               /*let viewController = ...
               viewController.modalPresentationStyle = .Custom
               self?.presentViewController(viewController, animated: true, completion: nil)*/
         }
        
        return [deleteAction, editAction]
    }
    */
    
    /*
    override func tableView(tableView: UITableView, editActionsForRowAtIndexPath indexPath: NSIndexPath) -> [UITableViewRowAction]? {
        
    }*/
    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "sgEditarReserva" {
            let indexPath = reservaTableView.indexPath(for: sender as! UITableViewCell)
            let editarReservaViewController  = segue.destination as! EditarReservaViewController
            editarReservaViewController.idReservaSelecc =  reservas[((indexPath as NSIndexPath?)?.row)!].idReserva! as String
        }
    }
    
    func jsonParserGET(_ jsonObject : AnyObject){
    }
  
    func jsonParserSEND(_ jsonObject : AnyObject){
        
        DispatchQueue.main.async {
            
            if jsonObject is NSDictionary { // Si hay datos
                if jsonObject["success"] as! String == Util.exito { // Si exito
                    self.alerta(self.reservaTlt, msg: self.reservaElim)
                }else {
                    let mensaje = jsonObject["error"] as! String
                    self.alerta(self.errorReservaTlt, msg: mensaje)
                }
            }else if jsonObject is String {
                if jsonObject as! String == Util.exito {
                    self.alerta(self.reservaTlt, msg: self.reservaElim)
                }else {
                    let jsonError = jsonObject as? String
                    self.alerta(jsonError, msg: jsonError)
                }
            }
        }
    }
    
    func alerta(_ tlt : String!, msg : String!) {
        
        DispatchQueue.main.async(execute: {
            
            let titulo   : String = tlt
            let mensaje : String = msg
            let messageHandler = MessageHandler()
            
            let _titutlo   = messageHandler.getTitle(titulo)
            let _mensaje   = messageHandler.getMessage(mensaje)
            
            let alertController = UIAlertController(title : _titutlo, message: _mensaje, preferredStyle: UIAlertControllerStyle.alert)
            
            let cancelAction = UIAlertAction(title: "Ok", style: .cancel, handler: nil)
            alertController.addAction(cancelAction)
            
            self.present(alertController, animated: true, completion: nil)
            
        })
    }
    

}
