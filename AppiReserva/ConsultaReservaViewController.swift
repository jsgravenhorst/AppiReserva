//
//  ConsultaReservaViewController.swift
//  AppiReserva
//
//  Created by Johann Stig Gravenhorst R. on 1/25/16.
//  Copyright © 2016 Olonte Apps. All rights reserved.
//

import UIKit
import CoreData

class ConsultaReservaViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource, JSONParserDelegate {
    

    @IBOutlet weak var sedePickerView: UIPickerView!
    @IBOutlet weak var bloquePickerView: UIPickerView!
    @IBOutlet weak var areaPickerView: UIPickerView!
    @IBOutlet weak var programaPickerView: UIPickerView!
    @IBOutlet weak var asignaturaPickerView: UIPickerView!
    @IBOutlet weak var grupoPickerView: UIPickerView!
    
    fileprivate let url = "http://localhost/AppiReserva/mod_aplicacion/appireserva_consultar_reserva.php"
    /*private let url =  "http://www.olonte.com/APPS/USC/Admin/mod_aplicacion/appireserva_consultar_reserva.php"*/
    fileprivate var jsonParserViewController : JSONParserViewController = JSONParserViewController()
    fileprivate var arraySedesDO               = [SedeDO]()
    fileprivate var arrayBloquesDO             = [BloqueDO]()
    fileprivate var arrayAreasDO               = [AreaDO]()
    fileprivate var arrayProgramasDO           = [ProgramaDO]()
    fileprivate var arrayAsignaturasDO         = [AsignaturaDO]()
    fileprivate var arrayGruposDO              = [GrupoDO]()
    fileprivate var arrayPlanillasDO           = [PlanillaDO]()
    fileprivate var arrayRecursosDO            = [RecursoDO]()
    fileprivate var arrayPensumsDO             = [PensumDO]()
    fileprivate var arrayReservasDO            = [ReservaDO]()
    fileprivate var arrrayConsultaEstudianteDO = [ConsultaReservaEstudianteDO]()
    
    fileprivate var arrayBloques         = [BloqueDO]()
    fileprivate var arrayProgramas       = [ProgramaDO]()
    fileprivate var arrayAsignaturas     = [AsignaturaDO]()
    fileprivate var arrayGrupos          = [GrupoDO]()
    
    fileprivate var idSedeSelec:          String?
    fileprivate var idBloqueSelec:        String?
    fileprivate var idAreaSelec:          String?
    fileprivate var idProgramaSelec:      String?
    fileprivate var idAsignaturaSelec:    String?
    fileprivate var idGrupoSelec:         String?
    
    fileprivate var bandSede:       Bool  = false
    fileprivate var bandArea:       Bool  = false
    fileprivate var bandPrograma:   Bool  = false
    fileprivate var bandAsignatura: Bool  = false
  
    fileprivate let reservaTlt = "7"
    fileprivate let reservaCons = "9"

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        iniciarArreglos()
        jsonParserViewController.delegateJSON = self
        jsonParserViewController.makeHttpAsynchronousRequest(url, params: nil, method: Util.getJSON)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
            
            arrayBloques.append(bloque)
            arrayProgramas.append(programa)
            arrayAsignaturas.append(asignatura)
            arrayGrupos.append(grupo)
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
                    
                    let datosJSON = jsonObject["consulta"] as! [[String : AnyObject]]
                    var bandObjDF : Bool = true
                    
                    for indice in 0 ..< datosJSON.count  {
                        
                        switch(indice) {
                            
                        case 0: /* Sede */
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
                            }
                            self.sedePickerView.reloadAllComponents()
                        case 1: /* Bloque */
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
                                
                            }
                        case 2: /* Area */
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
                            }
                            self.areaPickerView.reloadAllComponents()
                        case 3: /* Planilla */
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
                            }
                        case 4: /* Programa */
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
                            }
                        case 5: /* Asignatura */
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
                            }
                        case 6: /* Grupo */
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
                            }
                        case 7: /* Recurso */
                            let recursoDictionary = datosJSON[indice] as NSDictionary
                            let datosJSONRecurso  = recursoDictionary["recurso"] as! [[String : AnyObject]]
                            bandObjDF = true
                            
                            for jsonRecurso in datosJSONRecurso {
                                /*************************arrayRecursosDO*********************************************************************/
                                let recursoDO : RecursoDO = RecursoDO(idRecurso: (jsonRecurso["idRecurso"] as? String)!,
                                    nombreRecurso: (jsonRecurso["nombreRecurso"] as? String)!,
                                    capacidad:     ((jsonRecurso["capacidad"] as? NSString)?.integerValue)!)
                                self.arrayRecursosDO.append(recursoDO)
                            }
                        case 8: /* Pensum */
                            let pensumDictionary = datosJSON[indice] as NSDictionary
                            let datosJSONPensum  = pensumDictionary["pensum"] as! [[String : AnyObject]]
                            
                            for jsonPensum in datosJSONPensum {
                                let pensumDO : PensumDO = PensumDO(idPensum: (jsonPensum["idPensum"] as? String)!,
                                    idArea:       (jsonPensum["idArea"] as? String)!,
                                    idPrograma:   (jsonPensum["idPrograma"] as? String)!,
                                    idAsignatura: (jsonPensum["idAsignatura"] as? String)!)
                                self.arrayPensumsDO.append(pensumDO)
                            }
                        case 9: /* Reserva */
                            let reservaDictionary = datosJSON[indice] as NSDictionary
                            let datosJSONReserva  = reservaDictionary["reserva"] as! [[String : AnyObject]]
                            
                            for jsonReserva in datosJSONReserva {
                                let arrrayConsultaEstudianteDO : ConsultaReservaEstudianteDO = ConsultaReservaEstudianteDO(
                                    idReserva:       (jsonReserva["idReserva"] as? String)!,
                                    idSede:          (jsonReserva["idSede"] as? String)!,
                                    idBloque:        (jsonReserva["idBloque"] as? String)!,
                                    idArea:          (jsonReserva["idArea"] as? String)!,
                                    idPrograma:      (jsonReserva["idPrograma"] as? String)!,
                                    idAsignatura:    (jsonReserva["idAsignatura"] as? String)!,
                                    idGrupo:         (jsonReserva["idGrupo"] as? String)!,
                                    idTipoActividad: (jsonReserva["idTipoActividad"] as? String)!,
                                    idRecurso:       (jsonReserva["idRecurso"] as? String)!,
                                    fechaInicial:    (jsonReserva["fechaInicial"] as? String)!,
                                    horaInicial:     (jsonReserva["horaInicial"] as? String)!,
                                    fechaFinal:      (jsonReserva["fechaFinal"] as? String)!,
                                    horaFinal:       (jsonReserva["horaFinal"] as? String)!,
                                    nombreProfesor:  (jsonReserva["nombreProfesor"] as? String)!)
                                self.arrrayConsultaEstudianteDO.append(arrrayConsultaEstudianteDO)
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
    }
    
    func validarCampos() -> Bool {
        return true
    }
    
    func obtenerNombreRecurso(_ idRecurso: String) -> String {
        var nombreRecurso: String = ""
        for recurso in arrayRecursosDO {
            if recurso.idRecurso == idRecurso {
                nombreRecurso = recurso.nombreRecurso
            }
        }
        
        return nombreRecurso
    }
    
    func consultarReserva(_ idSedeSelec: String, idBloqueSelec: String, idAreaSelec: String, idProgramaSelec: String,
        idAsignaturaSelec: String, idGrupoSelec:  String) -> [ConsultaReservaDO] {
            var arrayConsultaReservaDO = [ConsultaReservaDO]()
            for consutaEstudianteDO in arrrayConsultaEstudianteDO {
                if consutaEstudianteDO.idSede == idSedeSelec &&
                    consutaEstudianteDO.idBloque == idBloqueSelec &&
                    consutaEstudianteDO.idArea == idAreaSelec &&
                    consutaEstudianteDO.idPrograma == idProgramaSelec &&
                    consutaEstudianteDO.idAsignatura == idAsignaturaSelec &&
                    consutaEstudianteDO.idGrupo == idGrupoSelec {
                        let consultaReservaDO: ConsultaReservaDO = ConsultaReservaDO(
                            nombreProfesor: consutaEstudianteDO.nombreProfesor,
                            nombreRecurso:  obtenerNombreRecurso(consutaEstudianteDO.idRecurso),
                            fechaInicial:   consutaEstudianteDO.fechaInicial,
                            horaInicial:    consutaEstudianteDO.horaIncial,
                            horaFinal:      consutaEstudianteDO.horaFinal)
                        arrayConsultaReservaDO.append(consultaReservaDO)
                }
            }
            return arrayConsultaReservaDO
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
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
        if segue.identifier == "sgConsultaReserva" {
            
            let arrayConsultaReservaDO = consultarReserva(self.idSedeSelec!, idBloqueSelec: self.idBloqueSelec!, idAreaSelec: self.idAreaSelec!, idProgramaSelec: self.idAreaSelec!, idAsignaturaSelec: self.idAsignaturaSelec!, idGrupoSelec:  self.idGrupoSelec!) as [ConsultaReservaDO]
            
            if arrayConsultaReservaDO.count > 0 {
                let tableViewController = segue.destination as! UITableViewController
                let consultaReservaTableViewController = tableViewController as! ConsultaReservaTableViewController
                consultaReservaTableViewController.arrayConsultaReservaDO = arrayConsultaReservaDO
            }else{
                self.alerta(self.reservaTlt, msg: self.reservaCons, caller: nil)
            }
        }
    }

}
