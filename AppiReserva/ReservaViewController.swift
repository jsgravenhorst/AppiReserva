//
//  ReservaViewController.swift
//  AppiReserva
//
//  Created by Johann Stig Gravenhorst R. on 12/2/15.
//  Copyright © 2015 Olonte Apps. All rights reserved.
//

import UIKit
import CoreData
fileprivate func < <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l < r
  case (nil, _?):
    return true
  default:
    return false
  }
}

fileprivate func <= <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l <= r
  default:
    return !(rhs < lhs)
  }
}


class ReservaViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource, JSONParserDelegate {
    
    @IBOutlet weak var nombreProfesorLabel: UILabel!
   
    @IBOutlet weak var sedePickerView:          UIPickerView!
    @IBOutlet weak var areaPickerView:          UIPickerView!
    @IBOutlet weak var bloquePickerView:        UIPickerView!
    @IBOutlet weak var programaPickerView:      UIPickerView!
    @IBOutlet weak var asignaturaPickerView:    UIPickerView!
    @IBOutlet weak var grupoPickerView:         UIPickerView!
    @IBOutlet weak var tipoActividadPickerView: UIPickerView!
    @IBOutlet weak var recursoPickerView:       UIPickerView!
    @IBOutlet weak var fchHrInicialPickerView:  UIDatePicker!
    @IBOutlet weak var fchHrFinalPickerView:    UIDatePicker!
    
    fileprivate var datosJSON            = Dictionary<String,AnyObject>()
    fileprivate var datosSendJSONReserva = Dictionary<String,AnyObject>()
    fileprivate var jsonParserViewController: JSONParserViewController = JSONParserViewController()
   
   /* private let urlCargarDatos    = "http://localhost/AppiReserva/mod_aplicacion/appireserva_cargar_datos.php"
    private let urlGuardarReserva = "http://localhost/AppiReserva/mod_aplicacion/appireserva_guardar_reserva.php"*/
    fileprivate let urlCargarDatos    = "http://www.olonte.com/APPS/USC/Admin/mod_aplicacion/appireserva_cargar_datos.php"
    fileprivate let urlGuardarReserva = "http://www.olonte.com/APPS/USC/Admin/mod_aplicacion/appireserva_guardar_reserva.php"
      
    var usuario : String?
    var clave   : String?
    
    fileprivate var profesor : ProfesorDO = ProfesorDO()
    fileprivate var arraySedesDO           = [SedeDO]()
    fileprivate var arrayBloquesDO         = [BloqueDO]()
    fileprivate var arrayAreasDO           = [AreaDO]()
    fileprivate var arrayProgramasDO       = [ProgramaDO]()
    fileprivate var arrayAsignaturasDO     = [AsignaturaDO]()
    fileprivate var arrayGruposDO          = [GrupoDO]()
    fileprivate var arrayTipoActividadesDO = [TipoActividadDO]()
    fileprivate var arrayRecursosDO        = [RecursoDO]()
    fileprivate var arrayReservasDO        = [ReservaDO]()
    fileprivate var arrayPlanillasDO       = [PlanillaDO]()
    fileprivate var arrayPensumsDO         = [PensumDO]()

    fileprivate var arrayBloques     = [BloqueDO]()
    fileprivate var arrayProgramas   = [ProgramaDO]()
    fileprivate var arrayAsignaturas = [AsignaturaDO]()
    fileprivate var arrayGrupos      = [GrupoDO]()
    fileprivate var arrayRecursos    = [RecursoDO]()
    
    fileprivate var idSedeSelec:          String?
    fileprivate var idBloqueSelec:        String?
    fileprivate var idAreaSelec:          String?
    fileprivate var idProgramaSelec:      String?
    fileprivate var idAsignaturaSelec:    String?
    fileprivate var idGrupoSelec:         String?
    fileprivate var idTipoActividadSelec: String?
    fileprivate var idRecursoSelec:       String?
    fileprivate var fechaHoraIniSelec:    String?
    fileprivate var fechaHoraFinSelec:    String?
    
    fileprivate var bandSede:       Bool  = false
    fileprivate var bandArea:       Bool  = false
    fileprivate var bandPrograma:   Bool  = false
    fileprivate var bandAsignatura: Bool  = false
    fileprivate var bandGrupo:      Bool  = false
    
   
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        iniciarCoreData()
        iniciarArreglos()
        datosJSON["usuario"] = usuario as AnyObject?
        datosJSON["clave"]   = clave as AnyObject?
        jsonParserViewController.delegateJSON = self
        jsonParserViewController.makeHttpAsynchronousRequest(urlCargarDatos, params: datosJSON, method: Util.getJSON)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func iniciarCoreData() {
        
        DispatchQueue.main.async {
            
            let appDelegate      = UIApplication.shared.delegate as! AppDelegate
            let managedObjectContext = appDelegate.managedObjectContext
            
            /***************************Eliminar Profesor CoreData*****************************************/
            do {
                //let fetchRequestProfesor = NSFetchRequest(entityName: "Profesor") Swift 2
                
                // Swift 3
                let fetchRequestProfesor = NSFetchRequest<Profesor>(entityName: "Profesor")
                
                if let profesor = try managedObjectContext.fetch(fetchRequestProfesor) as [Profesor]? {
                    
                    if profesor.count > 0 {
                        
                        let deleteRequestProfesor = NSBatchDeleteRequest(fetchRequest: fetchRequestProfesor as! NSFetchRequest<NSFetchRequestResult>)
                        try managedObjectContext.execute(deleteRequestProfesor)
                        try managedObjectContext.save()
                    }
                }
            } catch let error as NSError {
                let mensaje = "No se pudo eliminar el Profesor del CoreData \(error). \(error.userInfo)"
                self.alerta(Util.errorTltCoreData, msg: mensaje, caller: Util.loginCaller)
            }
            /************************Eliminar Sede CoreData**********************************************/
            do {
                let fetchRequestSede = NSFetchRequest<Sede>(entityName: "Sede")
                
                
                if let sede = try managedObjectContext.fetch(fetchRequestSede) as [Sede]? {
                    
                    if sede.count > 0 {
                        
                        let deleteRequestSede = NSBatchDeleteRequest(fetchRequest: fetchRequestSede as! NSFetchRequest<NSFetchRequestResult>)
                        try managedObjectContext.execute(deleteRequestSede)
                        try managedObjectContext.save()
                    }
                }
            } catch let error as NSError {
                let mensaje = "No se pudo eliminar la Sede del CoreData \(error). \(error.userInfo)"
                self.alerta(Util.errorTltCoreData, msg: mensaje,  caller: Util.loginCaller)
            }
            /**************************Eliminar Bloque CoreData*****************************************/
            do {
                let fetchRequestBloque = NSFetchRequest<Bloque>(entityName: "Bloque")
                
                if let bloque = try managedObjectContext.fetch(fetchRequestBloque) as [Bloque]? {
                    
                    if bloque.count > 0 {
                        
                        let deleteRequestBloque = NSBatchDeleteRequest(fetchRequest: fetchRequestBloque as! NSFetchRequest<NSFetchRequestResult>)
                        try managedObjectContext.execute(deleteRequestBloque)
                        try managedObjectContext.save()
                    }
                }
            } catch let error as NSError {
                let mensaje = "No se pudo eliminar el Bloque del CoreData \(error). \(error.userInfo)"
                self.alerta(Util.errorTltCoreData, msg: mensaje,  caller: Util.loginCaller)
            }
            /************************Eliminar Area CoreData***********************************************/
            do {
                
                 let fetchRequestArea = NSFetchRequest<Area>(entityName: "Area")
                
                if let area = try managedObjectContext.fetch(fetchRequestArea) as [Area]? {
                    
                    if area.count > 0 {
                        
                        let deleteRequestArea = NSBatchDeleteRequest(fetchRequest: fetchRequestArea as! NSFetchRequest<NSFetchRequestResult>)
                        try managedObjectContext.execute(deleteRequestArea)
                        try managedObjectContext.save()
                    }
                }
            } catch let error as NSError {
                let mensaje = "No se pudo eliminar la Area del CoreData \(error). \(error.userInfo)"
                self.alerta(Util.errorTltCoreData, msg: mensaje,  caller: Util.loginCaller)
            }
             /**************************Eliminar Programa CoreData******************************************************************/
            do {
                
                let fetchRequestPrograma = NSFetchRequest<Programa>(entityName: "Programa")
                
                if let programa = try managedObjectContext.fetch(fetchRequestPrograma) as [Programa]? {
                    
                    if programa.count > 0 {
                        
                        let deleteRequestPrograma = NSBatchDeleteRequest(fetchRequest: fetchRequestPrograma as! NSFetchRequest<NSFetchRequestResult>)
                        try managedObjectContext.execute(deleteRequestPrograma)
                        try managedObjectContext.save()
                    }
                }
            } catch let error as NSError {
                let mensaje = "No se pudo eliminar el Programa del CoreData \(error). \(error.userInfo)"
                self.alerta(Util.errorTltCoreData, msg: mensaje, caller: Util.loginCaller)
            }
            /**************************Eliminar Asignatura CoreData******************************************************************/
            do {
                
                let fetchRequestAsignatura = NSFetchRequest<Asignatura>(entityName: "Asignatura")
                
                if let asignatura = try managedObjectContext.fetch(fetchRequestAsignatura) as [Asignatura]? {
                    
                    if asignatura.count > 0 {
                        
                        let deleteRequestAsignatura = NSBatchDeleteRequest(fetchRequest: fetchRequestAsignatura as! NSFetchRequest<NSFetchRequestResult>)
                        try managedObjectContext.execute(deleteRequestAsignatura)
                        try managedObjectContext.save()
                    }
                }
            } catch let error as NSError {
                let mensaje = "No se pudo eliminar la Asignatura del CoreData \(error). \(error.userInfo)"
                self.alerta(Util.errorTltCoreData, msg: mensaje, caller: Util.loginCaller)
            }
            /**************************Eliminar Grupo CoreData******************************************************************/
            do {
                let fetchRequestGrupo = NSFetchRequest<Grupo>(entityName: "Grupo")
                
                if let grupo = try managedObjectContext.fetch(fetchRequestGrupo) as [Grupo]? {
                    
                    if grupo.count > 0 {
                        
                        let deleteRequestGrupo = NSBatchDeleteRequest(fetchRequest: fetchRequestGrupo as! NSFetchRequest<NSFetchRequestResult>)
                        try managedObjectContext.execute(deleteRequestGrupo)
                        try managedObjectContext.save()
                    }
                }
            } catch let error as NSError {
                let mensaje = "No se pudo eliminar el Grupo del CoreData \(error). \(error.userInfo)"
                self.alerta(Util.errorTltCoreData, msg: mensaje, caller: Util.loginCaller)
            }
            /**************************Eliminar TipoActividad CoreData**************************************************************/
            do {
                let fetchRequestTipoActividad = NSFetchRequest<TipoActividad>(entityName: "TipoActividad")
                
                if let tipoActividad = try managedObjectContext.fetch(fetchRequestTipoActividad) as [TipoActividad]? {
                    
                    if tipoActividad.count > 0 {
                        
                        let deleteRequestTipoActividad = NSBatchDeleteRequest(fetchRequest: fetchRequestTipoActividad as! NSFetchRequest<NSFetchRequestResult>)
                        try managedObjectContext.execute(deleteRequestTipoActividad)
                        try managedObjectContext.save()
                    }
                }
            } catch let error as NSError {
                let mensaje = "No se pudo eliminar el TipoAcitividad del CoreData \(error). \(error.userInfo)"
                self.alerta(Util.errorTltCoreData, msg: mensaje, caller: Util.loginCaller)
            }
            /**************************Eliminar Recurso CoreData********************************************************/
            do {
                let fetchRequestRecurso = NSFetchRequest<Recurso>(entityName: "Recurso")
                
                if let recurso = try managedObjectContext.fetch(fetchRequestRecurso) as [Recurso]? {
                    
                    if recurso.count > 0 {
                        
                        let deleteRequestRecurso = NSBatchDeleteRequest(fetchRequest: fetchRequestRecurso as! NSFetchRequest<NSFetchRequestResult>)
                        try managedObjectContext.execute(deleteRequestRecurso)
                        try managedObjectContext.save()
                    }
                }
            } catch let error as NSError {
                let mensaje = "No se pudo eliminar el Recurso del CoreData \(error). \(error.userInfo)"
                self.alerta(Util.errorTltCoreData, msg: mensaje, caller: Util.loginCaller)
            }
            /*********************************Eliminar Reserva CoreData*****************************************************/
            do {
                let fetchRequestReserva = NSFetchRequest<Reserva>(entityName: "Reserva")
                
                if let reserva = try managedObjectContext.fetch(fetchRequestReserva) as [Reserva]? {
                    
                    if reserva.count > 0 {
                        
                        let deleteRequestReserva = NSBatchDeleteRequest(fetchRequest: fetchRequestReserva as! NSFetchRequest<NSFetchRequestResult>)
                        try managedObjectContext.execute(deleteRequestReserva)
                        try managedObjectContext.save()
                    }
                }
            } catch let error as NSError {
                let mensaje = "No se pudo eliminar el Recurso del CoreData \(error). \(error.userInfo)"
                self.alerta(Util.errorTltCoreData, msg: mensaje, caller: Util.loginCaller)
            }
            /*******************************Eliminar Planilla CoreData*********************************************/
            do {
                let fetchRequestPlanilla = NSFetchRequest<Planilla>(entityName: "Planilla")
                
                if let planilla = try managedObjectContext.fetch(fetchRequestPlanilla) as [Planilla]? {
                    
                    if planilla.count > 0 {
                        
                        let deleteRequestPlanilla = NSBatchDeleteRequest(fetchRequest: fetchRequestPlanilla as! NSFetchRequest<NSFetchRequestResult>)
                        try managedObjectContext.execute(deleteRequestPlanilla)
                        try managedObjectContext.save()
                    }
                }
            } catch let error as NSError {
                let mensaje = "No se pudo eliminar la Planilla del CoreData \(error). \(error.userInfo)"
                self.alerta(Util.errorTltCoreData, msg: mensaje,  caller: Util.loginCaller)
            }
            /*******************************Eliminar Pensum CoreData*********************************************/
            do {
                let fetchRequestPensum = NSFetchRequest<Pensum>(entityName: "Pensum")
                
                if let pensum = try managedObjectContext.fetch(fetchRequestPensum) as [Pensum]? {
                    
                    if pensum.count > 0 {
                        
                        let deleteRequestPensum = NSBatchDeleteRequest(fetchRequest: fetchRequestPensum as! NSFetchRequest<NSFetchRequestResult>)
                        try managedObjectContext.execute(deleteRequestPensum)
                        try managedObjectContext.save()
                    }
                }
            } catch let error as NSError {
                let mensaje = "No se pudo eliminar el Pensum del CoreData \(error). \(error.userInfo)"
                self.alerta(Util.errorTltCoreData, msg: mensaje,  caller: Util.loginCaller)
            }
            
        }
        
    }
    
    func iniciarArreglos(){
        for _ in 0 ..< 2 {
           
            let bloque: BloqueDO = BloqueDO(idBloque: Util.idDefault,
                nombreBloque: Util.nombreDefault,
                idSede:       Util.idDefault)
            
            let programa: ProgramaDO = ProgramaDO(idPrograma: Util.idDefault,
                nombrePrograma: Util.nombreDefault,
                idArea:         Util.idDefault)
           
            let asignatura: AsignaturaDO = AsignaturaDO(idAsignatura: Util.idDefault,
                nombreAsignatura: Util.nombreDefault)
            
            let grupo: GrupoDO = GrupoDO(idGrupo: Util.idDefault,
                nombreGrupo: Util.nombreDefault)
            
            let recurso : RecursoDO = RecursoDO(idRecurso: Util.idDefault,
                nombreRecurso: Util.nombreDefault,
                capacidad:     Util.capacidadDefault)
            
            arrayBloques.append(bloque)
            arrayProgramas.append(programa)
            arrayAsignaturas.append(asignatura)
            arrayGrupos.append(grupo)
            arrayRecursos.append(recurso)
        }
    }
    
    func reIniciarBloque(){
        for _ in 0 ..< 2 {
            let bloque: BloqueDO = BloqueDO(idBloque: Util.idDefault,
                nombreBloque: Util.nombreDefault,
                idSede:       Util.idDefault)
            arrayBloques.append(bloque)
        }
        bloquePickerView.reloadComponent(Util.componentDF)
        bloquePickerView.selectRow(Util.rowDF, inComponent: Util.componentDF, animated: Util.boolDF)
    }
    
    func reIniciarPrograma(){
         for _ in 0 ..< 2 {
            let programa: ProgramaDO = ProgramaDO(idPrograma: Util.idDefault,
                nombrePrograma: Util.nombreDefault,
                idArea:         Util.idDefault)
             arrayProgramas.append(programa)
        }
        programaPickerView.reloadComponent(Util.componentDF)
        programaPickerView.selectRow(Util.rowDF, inComponent: Util.componentDF, animated: Util.boolDF)
    }
    
    func reIniciarAsignatura(){
        for _ in 0 ..< 2 {
            let asignatura: AsignaturaDO = AsignaturaDO(idAsignatura: Util.idDefault,
                nombreAsignatura: Util.nombreDefault)
            arrayAsignaturas.append(asignatura)
        }
        asignaturaPickerView.reloadComponent(Util.componentDF)
        asignaturaPickerView.selectRow(Util.rowDF, inComponent: Util.componentDF, animated: Util.boolDF)
    }
    
    func reIniciarGrupo(){
        for _ in 0 ..< 2 {
            let grupo: GrupoDO = GrupoDO(idGrupo: Util.idDefault,
            nombreGrupo: Util.nombreDefault)
            arrayGrupos.append(grupo)
        }
        grupoPickerView.reloadComponent(Util.componentDF)
        grupoPickerView.selectRow(Util.rowDF, inComponent: Util.componentDF, animated: Util.boolDF)
    }
    
    func reIniciarRecurso(){
        for _ in 0 ..< 2 {
            let recurso : RecursoDO = RecursoDO(idRecurso: Util.idDefault,
                nombreRecurso: Util.nombreDefault,
                capacidad:     Util.capacidadDefault)
             arrayRecursos.append(recurso)
        }
        recursoPickerView.reloadComponent(Util.componentDF)
        recursoPickerView.selectRow(Util.rowDF, inComponent: Util.componentDF, animated: Util.boolDF)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    // MARK:-
    // MARK: Picker Data Source Methods
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        // print(arrayAsignaturasDO.count)
            switch pickerView.tag {
            case 1:
                return arraySedesDO.count
            case 2:
                return arrayBloques.count
            case 3:
                return arrayAreasDO.count
            case 4:
                return arrayProgramas.count
            case 5:
                return arrayAsignaturas.count
            case 6:
                return arrayGrupos.count
            case 7:
                return arrayTipoActividadesDO.count
            case 8:
                return arrayRecursos.count
            default:
               return 0
            }
    }
    
    // MARK: Picker Delegate Methods
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        switch pickerView.tag {
        case 1:
            return arraySedesDO[row].nombreSede
        case 2:
            return arrayBloques[row].nombreBloque
        case 3:
            return arrayAreasDO[row].nombreArea
        case 4:
            return arrayProgramasDO[row].nombrePrograma
        case 5:
            return arrayAsignaturas[row].nombreAsignatura
        case 6:
            return arrayGrupos[row].nombreGrupo
        case 7:
            return arrayTipoActividadesDO[row].nombreTipoAct
        case 8:
            return arrayRecursos[row].nombreRecurso
        default:
            return " "
        }
        
    }
    
    /*
    * Se selecciona valor en el pickerView
    */
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        var bandObjDF : Bool = true
       
        switch pickerView.tag { /* Sede */
        case 1:
           idSedeSelec = arraySedesDO[row].idSede
           arrayBloques = [BloqueDO]()
           if arraySedesDO[row].idSede != Util.idDefault {
            bandSede = true
            for bloque in arrayBloquesDO {
                if bloque.idSede == arraySedesDO[row].idSede {
                    if bandObjDF {
                        let bloqueDO : BloqueDO = BloqueDO(idBloque: Util.idDefault,
                            nombreBloque: Util.nombreDefault,
                            idSede:       Util.idDefault)
                        arrayBloques.append(bloqueDO)
                        bandObjDF = false
                    }
                    arrayBloques.append(bloque)
                }
            }
            bloquePickerView.selectRow(Util.rowDF, inComponent: Util.componentDF, animated: Util.boolDF)
           }else{
              reIniciarBloque()
            }
        case 2: /* Bloque */
            idBloqueSelec = arrayBloques[row].idBloque
        case 3: /* Area */
           idAreaSelec = arrayAreasDO[row].idArea
           arrayProgramas = [ProgramaDO]()
           if arrayAreasDO[row].idArea != Util.idDefault {
             bandArea = true
             for programa in arrayProgramasDO {
                if programa.idArea == arrayAreasDO[row].idArea {
                    if bandObjDF {
                        let programaDO: ProgramaDO = ProgramaDO(idPrograma: Util.idDefault,
                            nombrePrograma: Util.nombreDefault,
                            idArea:         Util.idDefault)
                        arrayProgramas.append(programaDO)
                        bandObjDF = false
                     }
                     arrayProgramas.append(programa)
                 }
              }
              programaPickerView.selectRow(Util.rowDF, inComponent: Util.componentDF, animated: Util.boolDF)
            }else{
              reIniciarPrograma()
            }
        case 4: /* Programa */
            idProgramaSelec = arrayProgramas[row].idPrograma
            arrayAsignaturas = [AsignaturaDO]()
            if arrayProgramas[row].idPrograma != Util.idDefault {
                bandPrograma = true
                for pensum in arrayPensumsDO {
                    if pensum.idPrograma == arrayProgramas[row].idPrograma {
                        for asignatura in arrayAsignaturasDO {
                            if asignatura.idAsignatura == pensum.idAsignatura {
                                if bandObjDF {
                                   let asignaturaDO: AsignaturaDO = AsignaturaDO(idAsignatura: Util.idDefault, nombreAsignatura: Util.nombreDefault)
                                   arrayAsignaturas.append(asignaturaDO)
                                   bandObjDF = false
                                }
                                arrayAsignaturas.append(asignatura)
                            }
                        }
                    }
                }
                asignaturaPickerView.selectRow(Util.rowDF, inComponent: Util.componentDF, animated: Util.boolDF)
            }else{
                reIniciarAsignatura()
            }
        case 5: /* Asignatura */
            idAsignaturaSelec = arrayAsignaturas[row].idAsignatura
            arrayGrupos = [GrupoDO]()
            if arrayAsignaturas[row].idAsignatura != Util.idDefault {
                bandAsignatura = true
                for planilla in arrayPlanillasDO {
                    if planilla.idAsignatura == idAsignaturaSelec {
                        for grupo in arrayGruposDO {
                            if grupo.idGrupo == planilla.idGrupo {
                                if bandObjDF {
                                    let grupo: GrupoDO = GrupoDO(idGrupo: Util.idDefault,
                                        nombreGrupo: Util.nombreDefault)
                                    arrayGrupos.append(grupo)
                                    bandObjDF = false
                                }
                                arrayGrupos.append(grupo)
                            }
                        }
                    }
                }
                grupoPickerView.selectRow(Util.rowDF, inComponent: Util.componentDF, animated: Util.boolDF)
            }else {
                reIniciarGrupo()
            }
        case 6: /* Grupo */
            idGrupoSelec = arrayGrupos[row].idGrupo
            bandGrupo = true
            arrayRecursos = [RecursoDO]()
            if arrayGrupos[row].idGrupo != Util.idDefault {
                bandGrupo = true
                for planilla in arrayPlanillasDO {
                    for recurso in arrayRecursosDO {
                        if planilla.idPrograma == idProgramaSelec &&
                            planilla.idAsignatura == idAsignaturaSelec &&
                            planilla.idGrupo == arrayGrupos[row].idGrupo &&
                            planilla.cantidad <= recurso.capacidad {
                                if bandObjDF {
                                    let recurso : RecursoDO = RecursoDO(idRecurso: Util.idDefault,
                                        nombreRecurso: Util.nombreDefault,
                                        capacidad:     Util.capacidadDefault)
                                    arrayRecursos.append(recurso)
                                    bandObjDF = false
                                }
                                arrayRecursos.append(recurso)
                        }
                    }
                }
                recursoPickerView.selectRow(Util.rowDF, inComponent: Util.componentDF, animated: Util.boolDF)
            }else{
                reIniciarRecurso()
            }
        case 7: /* TipoActividad */
            idTipoActividadSelec = arrayTipoActividadesDO[row].idTipoActividad
        case 8: /* Recurso */
            idRecursoSelec = arrayRecursos[row].idRecurso
        default:
            print( " ")
            
        }
    }
    
    /**
     * Se asigna el valor al pickerView
     *
     */
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        
        let pickerLabel = UILabel()
        var titleData: String!
        
        switch pickerView.tag {
        case 1: /* Sede */
            titleData =  arraySedesDO[row].nombreSede
        case 2: /* Bloque */
            if bandSede {
                pickerView.reloadComponent(component)
                bandSede = false
            }
            titleData =  arrayBloques[row].nombreBloque
        case 3: /* Area */
            titleData =  arrayAreasDO[row].nombreArea
        case 4: /* Programa */
            if bandArea {
                pickerView.reloadComponent(component)
                bandArea = false
            }
            titleData =  arrayProgramas[row].nombrePrograma
        case 5: /* Asignatura */
            if bandPrograma {
                pickerView.reloadComponent(component)
                bandPrograma = false
            }
            titleData =  arrayAsignaturas[row].nombreAsignatura
        case 6: /* Grupo */
            if bandAsignatura {
                pickerView.reloadComponent(component)
                bandAsignatura = false
            }
            titleData =  arrayGrupos[row].nombreGrupo
        case 7: /* TipoAcitvidad */
            titleData = arrayTipoActividadesDO[row].nombreTipoAct
        case 8: /* Recurso */
            if bandGrupo {
                pickerView.reloadComponent(component)
                 bandGrupo = false
            }
            titleData =  arrayRecursos[row].nombreRecurso
        default:
            titleData =  " "
        }
        
        let pickerTitle = NSAttributedString(string: titleData, attributes: [NSFontAttributeName:UIFont(name: "Georgia", size: 15.0)!,NSForegroundColorAttributeName:UIColor.black])
        
        pickerLabel.attributedText = pickerTitle
        
        return pickerLabel
    }
    
    func jsonParserGET(_ jsonObject: AnyObject) {
       
        DispatchQueue.main.async {
        
        if jsonObject is NSDictionary { // Si hay datos
            
            if jsonObject["success"] as! String == Util.exito { // Si exito
                
                let appDelegate          = UIApplication.shared.delegate as! AppDelegate
                let managedObjectContext = appDelegate.managedObjectContext
                let datosJSON = jsonObject["consulta"] as! [[String : AnyObject]]
                var bandObjDF : Bool = true
                
                for indice in 0 ..< datosJSON.count  {
                    
                    switch(indice) {
                        
                    case 0: /* Profesor */
                        
                        let profesorDictionary = datosJSON[indice] as NSDictionary
                        let datosJSONProfesor  = profesorDictionary["profesor"] as! [[String : AnyObject]]
                        
                        for jsonProfesor in datosJSONProfesor {
                            
                            self.profesor.idProfesor     = (jsonProfesor["idProfesor"] as? String)!
                            self.profesor.nombreProfesor = (jsonProfesor["nombreProfesor"] as? String)!
                            self.nombreProfesorLabel.text = jsonProfesor["nombreProfesor"] as? String
                            
                            /*******************************Profesor CoreData*************************************/
                            let entity   = NSEntityDescription.entity(forEntityName: "Profesor", in: managedObjectContext)!
                            let profesor = NSManagedObject(entity: entity, insertInto: managedObjectContext) as! Profesor
                            profesor.idProfesor     = jsonProfesor["idProfesor"] as? String
                            profesor.nombreProfesor = jsonProfesor["nombreProfesor"] as? String
                            /************************************************************************************/
                        }
                        do{
                            try managedObjectContext.save()
                        }catch let error as NSError {
                            let mensaje = "No se pudo insertar en el Profesor del CoreData \(error). \(error.userInfo)"
                            self.alerta(Util.errorTltCoreData, msg: mensaje, caller: nil)
                        }
                    case 1: /* Sede */
                        
                        let sedeDictionary = datosJSON[indice] as NSDictionary
                        let datosJSONSede = sedeDictionary["sede"] as! [[String : AnyObject]]
                        
                        for jsonSede in datosJSONSede {
                            /************************************Objeto Default Sede ******************************************/
                            if bandObjDF {
                                let sedeDO: SedeDO = SedeDO(idSede: Util.idDefault, nombreSede: Util.nombreDefault )
                                self.arraySedesDO.append(sedeDO)
                                bandObjDF = false
                            }
                            /************************************arraySedesDO***************************************************************/
                            let sedeDO: SedeDO = SedeDO(idSede: (jsonSede["idSede"] as? String)!,
                                nombreSede: (jsonSede["nombreSede"] as? String)! )
                            self.arraySedesDO.append(sedeDO)
                            /**********************************************Sede CoreData******************************************/
                            let entity   = NSEntityDescription.entity(forEntityName: "Sede", in: managedObjectContext)!
                            let sede = NSManagedObject(entity: entity, insertInto: managedObjectContext) as! Sede
                            sede.idSede = jsonSede["idSede"] as? String
                            sede.nombreSede = jsonSede["nombreSede"] as? String
                            /********************************************************************************************************/
                           
                        }
                        do{
                            try managedObjectContext.save()
                        } catch let error as NSError {
                            let mensaje = "No se pudo insertar en la Sede del CoreData \(error). \(error.userInfo)"
                            self.alerta(Util.errorTltCoreData, msg: mensaje, caller: nil)
                        }
                         self.sedePickerView.reloadAllComponents()
                    case 2: /* Bloque */
                        
                        let bloqueDictionary = datosJSON[indice] as NSDictionary
                        let datosJSONBloque = bloqueDictionary["bloque"] as! [[String : AnyObject]]
                        bandObjDF = true
                   
                        for jsonBloque in datosJSONBloque {
                       
                            /******************************Objeto Default Bloque****************************************************/
                            if bandObjDF {
                                let bloqueDO: BloqueDO = BloqueDO(idBloque: Util.idDefault,
                                    nombreBloque: Util.nombreDefault,
                                    idSede:       Util.idDefault)
                                self.arrayBloquesDO.append(bloqueDO)
                                bandObjDF = false
                            }
                            /*****************************arrayBloquesDO************************************************************************/
                            let bloqueDO: BloqueDO = BloqueDO(idBloque: (jsonBloque["idBloque"] as? String)!,
                                nombreBloque: (jsonBloque["nombreBloque"] as? String)!,
                                idSede: (jsonBloque["idSede"] as? String)! )
                            self.arrayBloquesDO.append(bloqueDO)
                            
                             /********************************Bloque CoreData*************************************/
                            let entity   = NSEntityDescription.entity(forEntityName: "Bloque", in: managedObjectContext)!
                            let bloque = NSManagedObject(entity: entity, insertInto: managedObjectContext) as! Bloque
                            bloque.idBloque     = jsonBloque["idBloque"] as? String
                            bloque.nombreBloque = jsonBloque["nombreBloque"] as? String
                            bloque.idSede       = jsonBloque["idSede"] as? String
                           /*************************************************************************************/
                        }
                        do{
                            try managedObjectContext.save()
                        } catch let error as NSError {
                            let mensaje = "No se pudo insertar en el Bloque del CoreData \(error). \(error.userInfo)"
                            self.alerta(Util.errorTltCoreData, msg: mensaje, caller: nil)
                        }
                    case 3: /* Area */
                        
                        let areaDictionary = datosJSON[indice] as NSDictionary
                        let datosJSONArea  = areaDictionary["area"] as! [[String : AnyObject]]
                       
                        bandObjDF = true
                        for jsonArea in datosJSONArea {
                            /**************************Objeto Default Area*****************************************************/
                            if bandObjDF {
                                let areaDO: AreaDO = AreaDO(idArea: Util.idDefault, nombreArea: Util.nombreDefault)
                                self.arrayAreasDO.append(areaDO)
                                 bandObjDF = false
                            }
                            /***************************************arrayAreasDO************************************************************/
                            let areaDO: AreaDO = AreaDO(idArea: (jsonArea["idArea"] as? String)!, nombreArea: (jsonArea["nombreArea"] as? String)!)
                            self.arrayAreasDO.append(areaDO)
                            /*************************************Area CoreData*********************************************/
                            let entity = NSEntityDescription.entity(forEntityName: "Area", in: managedObjectContext)!
                            let area   = NSManagedObject(entity: entity, insertInto: managedObjectContext) as! Area
                            area.idArea     = jsonArea["idArea"] as? String
                            area.nombreArea = jsonArea["nombreArea"] as? String
                            /**********************************************************************************************/
                        }
                        do{
                            try managedObjectContext.save()
                        } catch let error as NSError {
                            let mensaje = "No se pudo insertar en la Area del CoreData \(error). \(error.userInfo)"
                            self.alerta(Util.errorTltCoreData, msg: mensaje, caller: nil)
                        }
                        self.areaPickerView.reloadAllComponents()
                    case 4: /* Planilla */
                        
                        let planillaDictionary = datosJSON[indice] as NSDictionary
                        let datosJSONPlanilla  = planillaDictionary["planilla"] as! [[String : AnyObject]]
                       
                        for jsonPlanilla in datosJSONPlanilla {
                            
                            let planillaDO: PlanillaDO = PlanillaDO(idPlanilla: (jsonPlanilla["idPlanilla"]   as? String)!,
                                idGrupo:      (jsonPlanilla["idGrupo"] as? String)!,
                                idPrograma:   (jsonPlanilla["idPrograma"] as? String)!,
                                idArea:       (jsonPlanilla["idArea"] as? String)!,
                                idAsignatura: (jsonPlanilla["idAsignatura"] as? String)!,
                                cantidad:     ((jsonPlanilla["cantidad"] as? NSString)?.integerValue)!)
                             self.arrayPlanillasDO.append(planillaDO)
                            
                            /*************************************Planilla CoreData*********************************************/
                            let entity   = NSEntityDescription.entity(forEntityName: "Planilla", in: managedObjectContext)!
                            let planilla = NSManagedObject(entity: entity, insertInto: managedObjectContext) as! Planilla
                            planilla.idPlanilla   = jsonPlanilla["idPlanilla"]   as? String
                            planilla.idGrupo      = jsonPlanilla["idGrupo"] as? String
                            planilla.idPrograma   = jsonPlanilla["idPrograma"] as? String
                            planilla.idArea       = jsonPlanilla["idArea"] as? String
                            planilla.idAsignatura = jsonPlanilla["idAsignatura"] as? String
                            planilla.cantidad     = (jsonPlanilla["cantidad"] as? NSString)!.integerValue as NSNumber?
                            /**************************************************************************************************/
                        }
                        do{
                            try managedObjectContext.save()
                        } catch let error as NSError {
                            let mensaje = "No se pudo insertar en la Planilla del CoreData \(error). \(error.userInfo)"
                            self.alerta(Util.errorTltCoreData, msg: mensaje, caller: nil)
                        }
                    case 5: /* Programa */
                        
                        let programaDictionary = datosJSON[indice] as NSDictionary
                        let datosJSONPrograma  = programaDictionary["programa"] as! [[String : AnyObject]]
                        bandObjDF = true
                        
                        for jsonPrograma in datosJSONPrograma {
                            
                            /******************************Objeto Default Programa*******************************************************/
                            if bandObjDF {
                                let programaDO : ProgramaDO = ProgramaDO(idPrograma: Util.idDefault,
                                    nombrePrograma: Util.nombreDefault,
                                    idArea:         Util.idDefault)
                                self.arrayProgramasDO.append(programaDO)
                                bandObjDF = false
                            }
                            /**********************************arrayProgramasDO*****************************************************************/
                            let programaDO : ProgramaDO = ProgramaDO(idPrograma: (jsonPrograma["idPrograma"] as? String)!,
                                nombrePrograma : (jsonPrograma["nombrePrograma"] as? String)!,
                                idArea         : (jsonPrograma["idArea"] as? String)!)
                             self.arrayProgramasDO.append(programaDO)
                            /******************************Programa CoreData***********************************************************/
                            let entity   = NSEntityDescription.entity(forEntityName: "Programa", in: managedObjectContext)!
                            let programa = NSManagedObject(entity: entity, insertInto: managedObjectContext) as! Programa
                            programa.idPrograma     = jsonPrograma["idPrograma"] as? String
                            programa.nombrePrograma = jsonPrograma["nombrePrograma"] as? String
                            programa.idArea         = jsonPrograma["idArea"] as? String
                            /*************************************************************************************************/
                        }
                        do{
                            try managedObjectContext.save()
                        } catch let error as NSError {
                            let mensaje = "No se pudo insertar en el Programa del CoreData \(error). \(error.userInfo)"
                            self.alerta(Util.errorTltCoreData, msg: mensaje, caller: nil)
                        }
                    case 6: /* Asignatura */
                        
                        let asignaturaDictionary = datosJSON[indice] as NSDictionary
                        let datosJSONAsignatura  = asignaturaDictionary["asignatura"] as! [[String : AnyObject]]
                        bandObjDF = true
                        
                        for jsonAsignatura in datosJSONAsignatura {
                            
                            /*********************Objeto Asignatura Default*************************************************************/
                            if bandObjDF {
                                let asignaturaDO: AsignaturaDO = AsignaturaDO(idAsignatura: Util.idDefault,
                                    nombreAsignatura: Util.nombreDefault)
                                self.arrayAsignaturasDO.append(asignaturaDO)
                                bandObjDF = false
                            }
                            /****************************arrayAsignaturasDO*****************************************************************/
                            let asignaturaDO: AsignaturaDO = AsignaturaDO(idAsignatura: (jsonAsignatura["idAsignatura"] as? String)!,
                                nombreAsignatura: (jsonAsignatura["nombreAsignatura"] as? String)!)
                            self.arrayAsignaturasDO.append(asignaturaDO)
                            /*******************************Asignatura CoreData****************************************************************/
                            let entity     = NSEntityDescription.entity(forEntityName: "Asignatura", in: managedObjectContext)!
                            let asignatura = NSManagedObject(entity: entity, insertInto: managedObjectContext) as! Asignatura
                            asignatura.idAsignatura     = jsonAsignatura["idAsignatura"] as? String
                            asignatura.nombreAsignatura = jsonAsignatura["nombreAsignatura"] as? String
                            /********************************************************************************************************/
                        }
                        do{
                            try managedObjectContext.save()
                        } catch let error as NSError {
                            let mensaje = "No se pudo insertar en la Asignatura del CoreData \(error). \(error.userInfo)"
                            self.alerta(Util.errorTltCoreData, msg: mensaje, caller: nil)
                        }
                    case 7: /* Grupo */
                        let grupoDictionary = datosJSON[indice] as NSDictionary
                        let datosJSONGrupo  = grupoDictionary["grupo"] as! [[String : AnyObject]]
                        bandObjDF = true
                        
                        for jsonGrupo in datosJSONGrupo {
                            
                            /*********************Objeto Grupo Default************************************************************************/
                            if bandObjDF {
                                let grupoDO: GrupoDO = GrupoDO(idGrupo: Util.idDefault,
                                    nombreGrupo: Util.nombreDefault)
                                self.arrayGruposDO.append(grupoDO)
                                bandObjDF = false
                            }
                            /***************************arrayGruposDO**************************************************************************/
                            let grupoDO: GrupoDO = GrupoDO(idGrupo: (jsonGrupo["idGrupo"] as? String)!,
                                nombreGrupo: (jsonGrupo["nombreGrupo"] as? String)!)
                             self.arrayGruposDO.append(grupoDO)
                            /**********************************Grupo CoreData*********************************************************/
                            let entity     = NSEntityDescription.entity(forEntityName: "Grupo", in: managedObjectContext)!
                            let grupo = NSManagedObject(entity: entity, insertInto: managedObjectContext) as! Grupo
                            grupo.idGrupo     = jsonGrupo["idGrupo"] as? String
                            grupo.nombreGrupo = jsonGrupo["nombreGrupo"] as? String
                            /************************************************************************************************/
                        }
                        do{
                            try managedObjectContext.save()
                        } catch let error as NSError {
                            let mensaje = "No se pudo insertar en el Grupo del CoreData \(error). \(error.userInfo)"
                            self.alerta(Util.errorTltCoreData, msg: mensaje, caller: nil)
                        }
                    case 8: /* TipoActividad */
                       
                        let tipoActividadDictionary = datosJSON[indice] as NSDictionary
                        let datosJSONTipoActividad  = tipoActividadDictionary["tipoActividad"] as! [[String : AnyObject]]
                        bandObjDF = true
                        
                        for jsonTipoActividad in datosJSONTipoActividad {
                            
                            /*******************************Objeto TipoActividad Default**********************************************************/
                            if bandObjDF {
                                let tipoActividadDO: TipoActividadDO = TipoActividadDO(idTipoActividad: Util.idDefault,
                                    nombreTipoAct: Util.nombreDefault)
                                self.arrayTipoActividadesDO.append(tipoActividadDO)
                                bandObjDF = false
                            }
                           /********************************arrayTipoActividadesDO****************************************************/
                            let tipoActividadDO : TipoActividadDO = TipoActividadDO(idTipoActividad: (jsonTipoActividad["idTipoActividad"] as? String)!, nombreTipoAct: (jsonTipoActividad["nombreTipoAct"] as? String)!)
                            self.arrayTipoActividadesDO.append(tipoActividadDO)
                            /***********************************TipoActividad CoreData*************************************************************/
                            let entity        = NSEntityDescription.entity(forEntityName: "TipoActividad", in: managedObjectContext)!
                            let tipoActividad = NSManagedObject(entity: entity, insertInto: managedObjectContext) as! TipoActividad
                            tipoActividad.idTipoActividad = jsonTipoActividad["idTipoActividad"] as? String
                            tipoActividad.nombreTipoAct   = jsonTipoActividad["nombreTipoAct"] as? String
                            /*************************************************************************************************************/
                        }
                        do{
                            try managedObjectContext.save()
                        } catch let error as NSError {
                            let mensaje = "No se pudo insertar en el TipoActividad del CoreData \(error). \(error.userInfo)"
                            self.alerta(Util.errorTltCoreData, msg: mensaje, caller: nil)
                        }
                        self.tipoActividadPickerView.reloadAllComponents()
                    case 9: /* Recurso */
                        
                        let recursoDictionary = datosJSON[indice] as NSDictionary
                        let datosJSONRecurso  = recursoDictionary["recurso"] as! [[String : AnyObject]]
                        bandObjDF = true
                        
                        for jsonRecurso in datosJSONRecurso {
                            
                            /***********************Objeto Recurso Default****************************************************************/
                            if bandObjDF {
                                let recursoDO : RecursoDO = RecursoDO(idRecurso: Util.idDefault,
                                    nombreRecurso: Util.nombreDefault,
                                    capacidad:     Util.capacidadDefault)
                                self.arrayRecursosDO.append(recursoDO)
                                bandObjDF = false
                            }
                            /*************************arrayRecursosDO*********************************************************************/
                            let recursoDO : RecursoDO = RecursoDO(idRecurso: (jsonRecurso["idRecurso"] as? String)!,
                                nombreRecurso: (jsonRecurso["nombreRecurso"] as? String)!,
                                capacidad:     ((jsonRecurso["capacidad"] as? NSString)?.integerValue)!)
                            self.arrayRecursosDO.append(recursoDO)
                            /*************************Recurso CoreData********************************************************/
                            let entity        = NSEntityDescription.entity(forEntityName: "Recurso", in: managedObjectContext)!
                            let recurso = NSManagedObject(entity: entity, insertInto: managedObjectContext) as! Recurso
                            recurso.idRecurso     = jsonRecurso["idRecurso"] as? String
                            recurso.nombreRecurso = jsonRecurso["nombreRecurso"] as? String
                            recurso.capacidad     = (jsonRecurso["capacidad"] as? NSString)!.integerValue as NSNumber?
                            /************************************************************************************************/
                        }
                        do{
                            try managedObjectContext.save()
                        } catch let error as NSError {
                            let mensaje = "No se pudo insertar en el Recurso del CoreData \(error). \(error.userInfo)"
                            self.alerta(Util.errorTltCoreData, msg: mensaje, caller: nil)
                        }
                    case 10: /* Pensum */
                        let pensumDictionary = datosJSON[indice] as NSDictionary
                        let datosJSONPensum  = pensumDictionary["pensum"] as! [[String : AnyObject]]
                  
                        for jsonPensum in datosJSONPensum {
                            
                            let pensumDO : PensumDO = PensumDO(idPensum: (jsonPensum["idPensum"] as? String)!,
                                idArea:       (jsonPensum["idArea"] as? String)!,
                                idPrograma:   (jsonPensum["idPrograma"] as? String)!,
                                idAsignatura: (jsonPensum["idAsignatura"] as? String)!)
                           self.arrayPensumsDO.append(pensumDO)
                          
                            /********************************Pensum CoreData********************************************************/
                            let entity = NSEntityDescription.entity(forEntityName: "Pensum", in: managedObjectContext)!
                            let pensum = NSManagedObject(entity: entity, insertInto: managedObjectContext) as! Pensum
                            pensum.idPensum     = jsonPensum["idPensum"] as? String
                            pensum.idArea       = jsonPensum["idArea"] as? String
                            pensum.idPrograma   = jsonPensum["idPrograma"] as? String
                            pensum.idAsignatura = jsonPensum["idAsignatura"] as? String
                            /*********************************************************************************************/
                        }
                        
                        do{
                            try managedObjectContext.save()
                        } catch let error as NSError {
                            let mensaje = "No se pudo insertar en el Pensum del CoreData \(error). \(error.userInfo)"
                            self.alerta(Util.errorTltCoreData, msg: mensaje, caller: nil)
                        }
                        
                    case 11: /* Reserva */
                        
                        let reservaDictionary = datosJSON[indice] as NSDictionary
                        let datosJSONReserva  = reservaDictionary["reserva"] as! [[String : AnyObject]]
                       
                        for jsonReserva in datosJSONReserva {
                            
                            let reservaDO : ReservaDO = ReservaDO(idReserva : (jsonReserva["idReserva"] as? String)!,
                                    idSede:          (jsonReserva["idSede"] as? String)!,
                                    idBloque:        (jsonReserva["idBloque"] as? String)!,
                                    idArea:          (jsonReserva["idArea"] as? String)!,
                                    idPrograma:      (jsonReserva["idPrograma"] as? String)!,
                                    idAsignatura:    (jsonReserva["idAsignatura"] as? String)!,
                                    idGrupo:         (jsonReserva["idGrupo"] as? String)!,
                                    idTipoActividad: (jsonReserva["idTipoActividad"] as? String)!,
                                    idRecurso:       (jsonReserva["idRecurso"] as? String)!,
                                    fechaInicial:    (jsonReserva["fechaInicial"] as? String)!,
                                    horaInicial:      (jsonReserva["horaInicial"] as? String)!,
                                    fechaFinal:      (jsonReserva["fechaFinal"] as? String)!,
                                    horaFinal:       (jsonReserva["horaFinal"] as? String)!)
                            self.arrayReservasDO.append(reservaDO)
                            
                            /********************************Reserva CoreData*************************************************/
                            let entity = NSEntityDescription.entity(forEntityName: "Reserva", in: managedObjectContext)!
                            let reserva = NSManagedObject(entity: entity, insertInto: managedObjectContext) as! Reserva
                            reserva.idReserva       = jsonReserva["idReserva"] as? String
                            reserva.idSede          = jsonReserva["idSede"] as? String
                            reserva.idBloque        = jsonReserva["idBloque"] as? String
                            reserva.idArea          = jsonReserva["idArea"] as? String
                            reserva.idPrograma      = jsonReserva["idPrograma"] as? String
                            reserva.idAsignatura    = jsonReserva["idAsignatura"] as? String
                            reserva.idGrupo         = jsonReserva["idGrupo"] as? String
                            reserva.idTipoActividad = jsonReserva["idTipoActividad"] as? String
                            reserva.idRecurso       = jsonReserva["idRecurso"] as? String
                            reserva.fechaInicial    = jsonReserva["fechaInicial"] as? String
                            reserva.horaInicial     = jsonReserva["horaInicial"] as? String
                            reserva.fechaFinal      = jsonReserva["fechaFinal"] as? String
                            reserva.horaFinal       = jsonReserva["horaFinal"] as? String
                            /***************************************************************/
                        }
                        do{
                            try managedObjectContext.save()
                        } catch let error as NSError {
                            let mensaje = "No se pudo insertar en la Reserva del CoreData \(error). \(error.userInfo)"
                            self.alerta(Util.errorTltCoreData, msg: mensaje, caller: nil)
                        }
                    default: break
                    }
                }
            } else { // Error cargando los datos
                let mensaje = jsonObject["error"] as! String
                self.alerta(Util.errorTltBD, msg: mensaje, caller: Util.loginCaller)
            }
        } else if jsonObject is String {
            let jsonError = jsonObject as? String
            self.alerta(jsonError, msg: jsonError, caller: Util.loginCaller)
        }
      }
    }
    
    func jsonParserSEND(_ jsonObject: AnyObject) {
        
        DispatchQueue.main.async {
            
            if jsonObject is NSDictionary { // Si hay datos
                 if jsonObject["success"] as! String == Util.exito { // Si exito
                    /************************Reserva CoreData*************************************/
                    self.insertarReservaCoreData((jsonObject["idReserva"] as? String)!,
                        idProfesor: self.profesor.idProfesor,
                        idSede: self.idSedeSelec!,
                        idBloque: self.idBloqueSelec!,
                        idArea: self.idAreaSelec!,
                        idPrograma: self.idProgramaSelec!,
                        idAsignatura: self.idAsignaturaSelec!,
                        idGrupo: self.idGrupoSelec!,
                        idTipoActividad: self.idTipoActividadSelec!,
                        idRecurso: self.idRecursoSelec!,
                        fechaInicial: Util.dateFromString(self.fchHrInicialPickerView.date, dateFormat: Util.dateEEE_DD_MMM_YYYY),
                        horaInicial: Util.dateFromString(self.fchHrInicialPickerView.date, dateFormat: Util.dateHH_MM_AAA),
                        fechaFinal: Util.dateFromString(self.fchHrFinalPickerView.date, dateFormat: Util.dateEEE_DD_MMM_YYYY),
                        horaFinal: Util.dateFromString(self.fchHrFinalPickerView.date,dateFormat: Util.dateHH_MM_AAA))
                    /***********************************************************************************************/
                    self.alerta(Util.reservaTlt, msg: Util.reservaMsg, caller: nil)
                 }else {
                    let mensaje = jsonObject["error"] as! String
                    self.alerta(Util.errorTltBD, msg: mensaje, caller: nil)
                }
            }else if jsonObject is String {
                if jsonObject as! String == Util.exito {
                    self.alerta(Util.reservaTlt, msg: Util.reservaMsg, caller: nil)
                }else {
                    let jsonError = jsonObject as? String
                    self.alerta(jsonError, msg: jsonError, caller: nil)
                }
            }
        }
    }
    
    func insertarReservaCoreData(_ idReserva: String, idProfesor: String, idSede: String, idBloque: String, idArea: String,
        idPrograma: String, idAsignatura: String, idGrupo: String, idTipoActividad: String, idRecurso: String,
        fechaInicial: String, horaInicial: String, fechaFinal: String, horaFinal: String) {
           
            let appDelegate          = UIApplication.shared.delegate as! AppDelegate
            let managedObjectContext = appDelegate.managedObjectContext
            let entity = NSEntityDescription.entity(forEntityName: "Reserva", in: managedObjectContext)!
            let reserva = NSManagedObject(entity: entity, insertInto: managedObjectContext) as! Reserva
            
            reserva.idReserva       = idReserva
            reserva.idSede          = idSede
            reserva.idBloque        = idBloque
            reserva.idArea          = idArea
            reserva.idPrograma      = idPrograma
            reserva.idAsignatura    = idAsignatura
            reserva.idGrupo         = idGrupo
            reserva.idTipoActividad = idTipoActividad
            reserva.idRecurso       = idRecurso
            reserva.fechaInicial    = fechaInicial
            reserva.horaInicial     = horaInicial
            reserva.fechaFinal      = fechaFinal
            reserva.horaFinal       = horaFinal
            
            do{
                try managedObjectContext.save()
            } catch let error as NSError {
                let mensaje = "No se pudo insertar en la Reserva del CoreData \(error). \(error.userInfo)"
                self.alerta(Util.errorTltCoreData, msg: mensaje, caller: nil)
            }
    }
    
    @IBAction func guardarReserva(_ sender: UIButton) {
        if validarCampos(){
            datosSendJSONReserva["idProfesor"]        = profesor.idProfesor as AnyObject?
            datosSendJSONReserva["idSede"]            = idSedeSelec as AnyObject?
            datosSendJSONReserva["idBloque"]          = idBloqueSelec as AnyObject?
            datosSendJSONReserva["idArea"]            = idAreaSelec as AnyObject?
            datosSendJSONReserva["idPrograma"]        = idProgramaSelec as AnyObject?
            datosSendJSONReserva["idAsignatura"]      = idAsignaturaSelec as AnyObject?
            datosSendJSONReserva["idGrupo"]           = idGrupoSelec as AnyObject?
            datosSendJSONReserva["idTipoActividad"]   = idTipoActividadSelec as AnyObject?
            datosSendJSONReserva["idRecurso"]         = idRecursoSelec as AnyObject?
            datosSendJSONReserva["fechaInicial"]      = Util.dateFromString(fchHrInicialPickerView.date, dateFormat: Util.dateEEE_DD_MMM_YYYY) as AnyObject?
            datosSendJSONReserva["horaInicial"]       = Util.dateFromString(fchHrInicialPickerView.date, dateFormat: Util.dateHH_MM_AAA) as AnyObject?
            datosSendJSONReserva["fechaFinal"]        = Util.dateFromString(fchHrFinalPickerView.date, dateFormat: Util.dateEEE_DD_MMM_YYYY) as AnyObject?
            datosSendJSONReserva["horaFinal"]         = Util.dateFromString(fchHrFinalPickerView.date,dateFormat: Util.dateHH_MM_AAA) as AnyObject?
            jsonParserViewController.makeHttpAsynchronousRequest(urlGuardarReserva, params: datosSendJSONReserva, method: Util.sendJSON)
        }
    }
    
    func validarCampos() -> Bool {
      return true
    }
    
    func alerta(_ tlt : String!, msg : String!, caller: String?) {
        
        DispatchQueue.main.async(execute: {
            
            let titulo   : String = tlt
            let mensaje : String = msg
            let messageHandler = MessageHandler()
            
            let _titutlo   = messageHandler.getTitle(titulo)
            let _mensaje   = messageHandler.getMessage(mensaje)
            
            let alertController = UIAlertController(title : _titutlo, message: _mensaje, preferredStyle: UIAlertControllerStyle.alert)
            
            if caller == Util.loginCaller {
                let cancelAction = UIAlertAction(title: "Ok", style: .cancel){ (action) -> Void  in
                    self.navigationController?.popViewController(animated: true)
                }
                alertController.addAction(cancelAction)
            }else {
                let cancelAction = UIAlertAction(title: "Ok", style: .cancel, handler: nil)
                alertController.addAction(cancelAction)
            }
            
            self.present(alertController, animated: true, completion: nil)
            
        })
    }
    
   
}
