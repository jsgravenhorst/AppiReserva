//
//  EditarReservaViewController.swift
//  AppiReserva
//
//  Created by Johann Stig Gravenhorst R. on 1/31/16.
//  Copyright © 2016 Olonte Apps. All rights reserved.
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


class EditarReservaViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource, JSONParserDelegate {

    @IBOutlet weak var nombreProfesorLabel: UILabel!
    @IBOutlet weak var sedePickerView:             UIPickerView!
    @IBOutlet weak var bloquePickerView:           UIPickerView!
    @IBOutlet weak var areaPickerView:             UIPickerView!
    @IBOutlet weak var programaPickerView:         UIPickerView!
    @IBOutlet weak var asignaturaPickerView:       UIPickerView!
    @IBOutlet weak var grupoPickerView:            UIPickerView!
    @IBOutlet weak var tipoActividadPickerView:    UIPickerView!
    @IBOutlet weak var recursoPickerView:          UIPickerView!
    @IBOutlet weak var fechaHoraInicialPickerView: UIDatePicker!
    @IBOutlet weak var fechaHoraFinalPickerView:   UIDatePicker!
    
    fileprivate var datosSendJSONReserva = Dictionary<String,AnyObject>()
    fileprivate var jsonParserViewController: JSONParserViewController = JSONParserViewController()
    /*private let urlEditarReserva = "http://localhost/AppiReserva/mod_aplicacion/appireserva_editar_reserva.php"*/
    fileprivate let urlEditarReserva = "http://www.olonte.com/APPS/USC/Admin/mod_aplicacion/appireserva_editar_reserva.php"
    
    var idReservaSelecc: String?
    fileprivate var profesor: ProfesorDO  = ProfesorDO()
    fileprivate let reserva:  ReservaDO   = ReservaDO()
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
        // Do any additional setup after loading the view.
        //
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        cargarDatosPickerView()
        configurarPickersView()
    }
    
    // MARK:-
    // MARK: Picker Data Source Methods
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func cargarDatosPickerView(){
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let managedObjectContext = appDelegate.managedObjectContext
        var bandObjDf: Bool = true
        
        /********************************Profesor*****************************************************/
        do{
            let fetchRequestProfesor =  NSFetchRequest<Profesor>(entityName: "Profesor")
            
            if let resultadoProfesor = try managedObjectContext.fetch(fetchRequestProfesor) as [Profesor]? {
                for profesor in resultadoProfesor {
                    self.profesor.idProfesor = profesor.idProfesor! as String
                    nombreProfesorLabel.text = profesor.nombreProfesor! as String
                }
            }
        }catch let error as NSError {
            let mensaje = "No se pudo cargar el profesor del CoreData \(error). \(error.userInfo)"
            self.alerta(Util.errorTltCoreData, msg: mensaje)
        }
        
        /************************************Sede*********************************************************/
        
        do {
            let fetchRequestSede =  NSFetchRequest<Sede>(entityName: "Sede")
            
            let sorDescriptorSede = NSSortDescriptor(key: "idSede", ascending: true)
            
            fetchRequestSede.sortDescriptors = [sorDescriptorSede]
            
            if let resultadoSede = try managedObjectContext.fetch(fetchRequestSede) as [Sede]? {
                
                for sede in resultadoSede {
                    
                    /******************Objeto Default Sede ***********************************************************/
                    if bandObjDf {
                        let sedeDO: SedeDO = SedeDO(idSede: Util.idDefault, nombreSede: Util.nombreDefault)
                        self.arraySedesDO.append(sedeDO)
                        bandObjDf = false
                    }
                    /*******************************arraySedesDO********************************************************************/
                    let sedeDO: SedeDO = SedeDO(idSede: sede.idSede! as String, nombreSede: sede.nombreSede! as String )
                    self.arraySedesDO.append(sedeDO)
                }
            }
        }catch let error as NSError {
            let mensaje = "No se pudo cargar la Sede del CoreData \(error). \(error.userInfo)"
            self.alerta(Util.errorTltCoreData, msg: mensaje)
        }
    
         /***************************************Bloque***********************************************/
        
        do {
            bandObjDf = true
            
            let fetchRequestBloque =  NSFetchRequest<Bloque>(entityName: "Bloque")
            
           /* let sorDescriptorBloque = NSSortDescriptor(key: "idBloque", ascending: true)
            
            fetchRequestBloque.sortDescriptors = [sorDescriptorBloque]*/
            
            if let resultadoBloque = try managedObjectContext.fetch(fetchRequestBloque) as [Bloque]? {
               
                for bloque in resultadoBloque {
           
                    /*****************************Objeto Default Bloque**********************************************/
                    if bandObjDf {
                        let bloqueDO: BloqueDO = BloqueDO(idBloque: Util.idDefault, nombreBloque: Util.nombreDefault, idSede: Util.idDefault)
                        self.arrayBloquesDO.append(bloqueDO)
                        bandObjDf = false
                    }
                    /*********************************arrayBloquesDO***************************************************************/
                    let bloqueDO: BloqueDO = BloqueDO(idBloque: bloque.idBloque! as String,
                        nombreBloque: bloque.nombreBloque! as String,
                        idSede: bloque.idSede! as String)
                    self.arrayBloquesDO.append(bloqueDO)
                }
            }
        }catch let error as NSError {
            let mensaje = "No se pudo cargar el Bloque del CoreData \(error). \(error.userInfo)"
            self.alerta(Util.errorTltCoreData, msg: mensaje)
        }
        
        /****************************************Area***************************************************/
        
        do{
            bandObjDf = true
            
            let fetchRequestArea =  NSFetchRequest<Area>(entityName: "Area")
            
            let sorDescriptorArea = NSSortDescriptor(key: "idArea", ascending: true)
            
            fetchRequestArea.sortDescriptors = [sorDescriptorArea]
            
             if let resultadoArea = try managedObjectContext.fetch(fetchRequestArea) as [Area]? {
                
                for area in resultadoArea {
                    
                    /********************************Objeto Default Area**********************************************************/
                    if bandObjDf {
                        let areaDO: AreaDO = AreaDO(idArea: Util.idDefault, nombreArea: Util.nombreDefault)
                        self.arrayAreasDO.append(areaDO)
                        bandObjDf = false
                    }
                    /**********************************arrayAreasDO*********************************************************/
                    let areaDO: AreaDO = AreaDO(idArea: area.idArea! as String, nombreArea: area.nombreArea! as String)
                    self.arrayAreasDO.append(areaDO)
                }
            }
        }catch let error as NSError {
            let mensaje = "No se pudo cargar el Area del CoreData \(error). \(error.userInfo)"
            self.alerta(Util.errorTltCoreData, msg: mensaje)
        }
        
        /**************************************Programa**************************************************/
        do{
            bandObjDf = true
            
            let fetchRequestPrograma = NSFetchRequest<Programa>(entityName: "Programa")
            
            let sorDescriptorPrograma = NSSortDescriptor(key: "idPrograma", ascending: true)
            
            fetchRequestPrograma.sortDescriptors = [sorDescriptorPrograma]
            
            if let resultadoPrograma = try managedObjectContext.fetch(fetchRequestPrograma) as [Programa]? {
                
                for programa in resultadoPrograma {
                    /*****************************Objeto Default Programa******************************************************/
                    if bandObjDf {
                        let programaDO: ProgramaDO = ProgramaDO(idPrograma: Util.idDefault, nombrePrograma: Util.nombreDefault, idArea: Util.idDefault)
                        self.arrayProgramasDO.append(programaDO)
                        bandObjDf = false
                    }
                    /***************************************arrayProgramasDO********************************************************************/
                    let programaDO: ProgramaDO = ProgramaDO(idPrograma: programa.idPrograma!, nombrePrograma: programa.nombrePrograma!, idArea: programa.idArea!)
                    self.arrayProgramasDO.append(programaDO)
                }
            }
        }catch let error as NSError {
            let mensaje = "No se pudo cargar el Programa del CoreData \(error). \(error.userInfo)"
            self.alerta(Util.errorTltCoreData, msg: mensaje)
        }
        /**********************************Asignatura*************************************************************/
        do{
            bandObjDf = true
            
            let fetchRequestAsignatura = NSFetchRequest<Asignatura>(entityName: "Asignatura")
            
            let sorDescriptorAsignatura = NSSortDescriptor(key: "idAsignatura", ascending: true)
            
            fetchRequestAsignatura.sortDescriptors = [sorDescriptorAsignatura]

            
            if let resultadoAsignatura = try managedObjectContext.fetch(fetchRequestAsignatura) as [Asignatura]? {
                
                for asignatura in resultadoAsignatura {
                     /***********************************Objeto Default Asignatura*****************************************/
                    if bandObjDf {
                        let asignaturaDO: AsignaturaDO = AsignaturaDO(idAsignatura: Util.idDefault, nombreAsignatura: Util.nombreDefault)
                        self.arrayAsignaturasDO.append(asignaturaDO)
                        bandObjDf = false
                    }
                    /*******************************arrayAsignaturasDO**************************************************************/
                    let asignaturaDO: AsignaturaDO = AsignaturaDO(idAsignatura: asignatura.idAsignatura!, nombreAsignatura: asignatura.nombreAsignatura!)
                    self.arrayAsignaturasDO.append(asignaturaDO)
                }
            }
        }catch let error as NSError {
            let mensaje = "No se pudo cargar la Asignatura del CoreData \(error). \(error.userInfo)"
            self.alerta(Util.errorTltCoreData, msg: mensaje)
        }
        /***************************************Grupo*******************************************************************/
        do{
            bandObjDf = true
            
            let fetchRequestGrupo = NSFetchRequest<Grupo>(entityName: "Grupo")
            
            let sorDescriptorGrupo = NSSortDescriptor(key: "idGrupo", ascending: true)
            
            fetchRequestGrupo.sortDescriptors = [sorDescriptorGrupo]
            
            if let resultadoGrupo = try managedObjectContext.fetch(fetchRequestGrupo) as [Grupo]? {
            
                for grupo in resultadoGrupo {
                    /*************************Objeto Grupo Default***************************************************/
                    if bandObjDf {
                        let grupoDO: GrupoDO = GrupoDO(idGrupo: Util.idDefault, nombreGrupo: Util.nombreDefault)
                        self.arrayGruposDO.append(grupoDO)
                        bandObjDf = false
                    }
                    /**************************arrayGruposDO***************************************************/
                    let grupoDO: GrupoDO = GrupoDO(idGrupo: grupo.idGrupo!, nombreGrupo: grupo.nombreGrupo!)
                    self.arrayGruposDO.append(grupoDO)
                }
            }
           
        }catch let error as NSError {
            let mensaje = "No se pudo cargar el Grupo del CoreData \(error). \(error.userInfo)"
            self.alerta(Util.errorTltCoreData, msg: mensaje)
        }
        /********************************TipoActividad*******************************************************************/
        do{
            bandObjDf = true
            
            let fetchRequestTipoActividad = NSFetchRequest<TipoActividad>(entityName: "TipoActividad")
            
            let sorDescriptorTipoActividad = NSSortDescriptor(key: "idTipoActividad", ascending: true)
            
            fetchRequestTipoActividad.sortDescriptors = [sorDescriptorTipoActividad]
            
            if let resultadoTipoActividad = try managedObjectContext.fetch(fetchRequestTipoActividad) as [TipoActividad]? {
                
                for tipoAcitividad in resultadoTipoActividad {
                    /*****************************Objeto Default TipoActividad***************************************************/
                    if bandObjDf {
                        let tipoActividadDO: TipoActividadDO = TipoActividadDO(idTipoActividad: Util.idDefault, nombreTipoAct: Util.nombreDefault)
                        self.arrayTipoActividadesDO.append(tipoActividadDO)
                         bandObjDf = false
                    }
                    /**********************************arrayTipoActividadesDO*****************************************************/
                    let tipoActividadDO: TipoActividadDO = TipoActividadDO(idTipoActividad: tipoAcitividad.idTipoActividad!,
                        nombreTipoAct: tipoAcitividad.nombreTipoAct!)
                    self.arrayTipoActividadesDO.append(tipoActividadDO)
                }
            }
        }catch let error as NSError {
            let mensaje = "No se pudo cargar el TipoActividad del CoreData \(error). \(error.userInfo)"
            self.alerta(Util.errorTltCoreData, msg: mensaje)
        }
        /*************************************************Recurso*********************************************************************/
        do{
            bandObjDf = true
            
            let fetchRequestRecurso = NSFetchRequest<Recurso>(entityName: "Recurso")
            
            let sorDescriptorRecurso = NSSortDescriptor(key: "idRecurso", ascending: true)
            
            fetchRequestRecurso.sortDescriptors = [sorDescriptorRecurso]
            
            if let resultadoRecurso = try managedObjectContext.fetch(fetchRequestRecurso) as [Recurso]? {
            
                for recurso in resultadoRecurso {
                    /****************************Objeto Default Recurso****************************************************************/
                    if bandObjDf {
                        let recursoDO: RecursoDO = RecursoDO(idRecurso: Util.idDefault, nombreRecurso: Util.nombreDefault, capacidad: Util.capacidadDefault)
                        self.arrayRecursosDO.append(recursoDO)
                        bandObjDf = false
                    }
                    /***********************************arrayRecursosDO********************************************************************/
                  let recursoDO: RecursoDO = RecursoDO(idRecurso: recurso.idRecurso!, nombreRecurso: recurso.nombreRecurso!, capacidad: recurso.capacidad! as Int)
                  self.arrayRecursosDO.append(recursoDO)
                }
            }
        }catch let error as NSError {
            let mensaje = "No se pudo cargar el Recurso del CoreData \(error). \(error.userInfo)"
            self.alerta(Util.errorTltCoreData, msg: mensaje)
        }
        /*********************************************Planilla********************************************************************************/
        do{
            let fetchRequestPlanilla = NSFetchRequest<Planilla>(entityName: "Planilla")
            
              if let resultadoPlanilla = try managedObjectContext.fetch(fetchRequestPlanilla) as [Planilla]? {
                
                for planilla in resultadoPlanilla {
                    let planillaDO: PlanillaDO = PlanillaDO(idPlanilla: planilla.idPlanilla!, idGrupo: planilla.idGrupo!, idPrograma: planilla.idPrograma!, idArea: planilla.idArea!, idAsignatura: planilla.idAsignatura!, cantidad: planilla.cantidad! as Int)
                    self.arrayPlanillasDO.append(planillaDO)
                }
              }
            
        }catch let error as NSError {
            let mensaje = "No se pudo cargar la Planilla del CoreData \(error). \(error.userInfo)"
            self.alerta(Util.errorTltCoreData, msg: mensaje)
        }
         /*******************************************************Pensum********************************************************************************/
        do{
            let fetchRequestPensum = NSFetchRequest<Pensum>(entityName: "Pensum")
            if let resultadoPensum = try managedObjectContext.fetch(fetchRequestPensum) as [Pensum]? {
                
                for pensum in resultadoPensum {
                    let pensumDO: PensumDO = PensumDO(idPensum: pensum.idPensum!, idArea: pensum.idArea!, idPrograma: pensum.idPrograma!, idAsignatura: pensum.idAsignatura!)
                    self.arrayPensumsDO.append(pensumDO)
                }
            }
        }catch let error as NSError {
            let mensaje = "No se pudo cargar el Pensum del CoreData \(error). \(error.userInfo)"
            self.alerta(Util.errorTltCoreData, msg: mensaje)
        }
        
        do{
            let fetchRequestReserva = NSFetchRequest<Reserva>(entityName: "Reserva")
            let predicate_idReserva = NSPredicate(format: "idReserva == %@", idReservaSelecc!)
            
            fetchRequestReserva.predicate = predicate_idReserva
            let resultadoReserva = try managedObjectContext.fetch(fetchRequestReserva) as [Reserva]?
            
            for objReserva in resultadoReserva! {
                reserva.idReserva       = objReserva.idReserva! as String
                reserva.idSede          = objReserva.idSede! as String
                reserva.idBloque        = objReserva.idBloque! as String
                reserva.idArea          = objReserva.idArea! as String
                reserva.idPrograma      = objReserva.idPrograma! as String
                reserva.idAsignatura    = objReserva.idAsignatura! as String
                reserva.idGrupo         = objReserva.idGrupo! as String
                reserva.idTipoActividad = objReserva.idTipoActividad! as String
                reserva.idRecurso       = objReserva.idRecurso! as String
                reserva.fechaInicial    = objReserva.fechaInicial! as String
                reserva.horaIncial      = objReserva.horaInicial! as String
                reserva.fechaFinal      = objReserva.fechaFinal! as String
                reserva.horaFinal       = objReserva.horaFinal! as String
            }
            
        }catch let error as NSError {
            let mensaje = "No se pudo cargar la Reserva del CoreData \(error). \(error.userInfo)"
            self.alerta(Util.errorTltCoreData, msg: mensaje)
        }
    }
    
    func configurarPickersView(){
        configurarSede()
        configurarBloque()
        configurarArea()
        configurarPrograma()
        configurarAsignatura()
        configurarGrupo()
        configurarTipoActividad()
        configurarRecurso()
    }
    
    func configurarSede(){
        sedePickerView.selectRow(getPosSede(reserva.idSede), inComponent: Util.componentDF, animated: Util.boolDF)
    }
    
    func configurarBloque() {
       var bandObjDf: Bool  = true
        arrayBloques = [BloqueDO]()
        for bloque in arrayBloquesDO {
            if bloque.idSede == reserva.idSede {
                if bandObjDf {
                    let bloqueDO : BloqueDO = BloqueDO(idBloque: Util.idDefault,
                        nombreBloque: Util.nombreDefault,
                        idSede:       Util.idDefault)
                    arrayBloques.append(bloqueDO)
                    bandObjDf = false
                }
                arrayBloques.append(bloque)
            }
        }
        bloquePickerView.reloadComponent(Util.componentDF)
        bloquePickerView.selectRow(getPosBloque(reserva.idBloque), inComponent: Util.componentDF, animated: Util.boolDF)
    }
    
    func configurarArea(){
        areaPickerView.selectRow(getPosArea(reserva.idArea), inComponent: Util.componentDF, animated: Util.boolDF)
    }
    
    func configurarPrograma() {
        var bandObjDf: Bool  = true
        arrayProgramas = [ProgramaDO]()
        for programa in arrayProgramasDO {
            if programa.idArea == reserva.idArea {
                if bandObjDf {
                    let programaDO: ProgramaDO = ProgramaDO(idPrograma: Util.idDefault,
                        nombrePrograma: Util.nombreDefault,
                        idArea:         Util.idDefault)
                    arrayProgramas.append(programaDO)
                    bandObjDf = false
                }
                arrayProgramas.append(programa)
            }
        }
        programaPickerView.reloadComponent(Util.componentDF)
        programaPickerView.selectRow(getPosPrograma(reserva.idPrograma), inComponent: Util.componentDF, animated: Util.boolDF)
    }
    
    func configurarAsignatura(){
        var bandObjDf: Bool  = true
        arrayAsignaturas = [AsignaturaDO]()
        for pensum in arrayPensumsDO {
            if pensum.idPrograma == reserva.idPrograma {
                for asignatura in arrayAsignaturasDO {
                    if asignatura.idAsignatura == pensum.idAsignatura {
                        if bandObjDf {
                            let asignaturaDO: AsignaturaDO = AsignaturaDO(idAsignatura: Util.idDefault, nombreAsignatura: Util.nombreDefault)
                            arrayAsignaturas.append(asignaturaDO)
                            bandObjDf = false
                        }
                        arrayAsignaturas.append(asignatura)
                    }
                }
            }
        }
        asignaturaPickerView.reloadComponent(Util.componentDF)
        asignaturaPickerView.selectRow(getPosAsignatura(reserva.idAsignatura), inComponent: Util.componentDF, animated: Util.boolDF)
    }
    
    func configurarGrupo() {
        var bandObjDf: Bool  = true
        arrayGrupos = [GrupoDO]()
        for planilla in arrayPlanillasDO {
            if planilla.idAsignatura == reserva.idAsignatura {
                for grupo in arrayGruposDO {
                    if grupo.idGrupo == planilla.idGrupo {
                        if bandObjDf {
                            let grupo: GrupoDO = GrupoDO(idGrupo: Util.idDefault,
                                nombreGrupo: Util.nombreDefault)
                            arrayGrupos.append(grupo)
                            bandObjDf = false
                        }
                        arrayGrupos.append(grupo)
                    }
                }
            }
        }
        grupoPickerView.reloadComponent(Util.componentDF)
        grupoPickerView.selectRow(getPosGrupo(reserva.idGrupo), inComponent: Util.componentDF, animated: Util.boolDF)
    }
    
    func configurarTipoActividad(){
        tipoActividadPickerView.selectRow(getPosTipoActividad(reserva.idTipoActividad), inComponent: Util.componentDF, animated: Util.boolDF)
    }
    
    func configurarRecurso(){
        var bandObjDf: Bool  = true
        arrayRecursos = [RecursoDO]()
        for planilla in arrayPlanillasDO {
            for recurso in arrayRecursosDO {
                if planilla.idPrograma == reserva.idPrograma &&
                    planilla.idAsignatura == reserva.idAsignatura &&
                    planilla.idGrupo == reserva.idGrupo &&
                    planilla.cantidad <= recurso.capacidad {
                        if bandObjDf {
                            let recurso : RecursoDO = RecursoDO(idRecurso: Util.idDefault,
                                nombreRecurso: Util.nombreDefault,
                                capacidad:     Util.capacidadDefault)
                            arrayRecursos.append(recurso)
                            bandObjDf = false
                        }
                        arrayRecursos.append(recurso)
                }
            }
        }
        recursoPickerView.reloadComponent(Util.componentDF)
        recursoPickerView.selectRow(getPosRecurso(reserva.idRecurso), inComponent: Util.componentDF, animated: Util.boolDF)
    }
    
    func getPosSede(_ idSede: String) -> Int {
        var index: Int = 0
        for i in 0 ..< arraySedesDO.count {
            if idSede == arraySedesDO[i].idSede {
                index = i
                break
            }
        }
        return index
    }
    
    func getPosBloque(_ idBloque: String) -> Int {
        var index: Int = 0
        for i in 0 ..< arrayBloques.count {
            if idBloque == arrayBloques[i].idBloque {
                index = i
                break
            }
        }
        return index
    }
    
    func getPosArea(_ idArea: String) -> Int {
        var index: Int = 0
        for i in 0 ..< arrayAreasDO.count {
            if idArea == arrayAreasDO[i].idArea {
                index = i
                break
            }
        }
        return index
    }
    
    func getPosPrograma(_ idPrograma: String) -> Int {
        var index: Int = 0
        for i in 0 ..< arrayProgramas.count {
            if idPrograma == arrayProgramas[i].idPrograma {
                index = i
                break
            }
        }
        return index
    }
    
    func getPosAsignatura(_ idAsignatura: String) -> Int {
        var index: Int = 0
        for i in 0 ..< arrayAsignaturas.count {
            if idAsignatura == arrayAsignaturas[i].idAsignatura {
                index = i
                break
            }
        }
        return index
    }
    
    func getPosGrupo(_ idGrupo: String) -> Int {
        var index: Int = 0
        for i in 0 ..< arrayGrupos.count {
            if idGrupo == arrayGrupos[i].idGrupo {
                index = i
                break
            }
        }
        return index
    }
    
    func getPosTipoActividad(_ idTipoActividad: String) -> Int {
        var index: Int = 0
        for i in 0 ..< arrayTipoActividadesDO.count {
            if idTipoActividad == arrayTipoActividadesDO[i].idTipoActividad {
                index = i
                break
            }
        }
        return index
    }
    
    func getPosRecurso(_ idRecurso: String) -> Int {
        var index: Int = 0
        for i in 0 ..< arrayRecursos.count {
            if idRecurso == arrayRecursos[i].idRecurso {
                index = i
                break
            }
        }
        return index
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
        
        var bandObjDF: Bool  = true
        
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
  
    func obtenerId(_ idSeleccionado: String?, idActualizar: String) -> String {
        
        if let idSelec = idSeleccionado {
           return idSelec
        }else{
            return idActualizar
        }
    }
    
    func actualizarReservaCoreData(){
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let managedObjectContext = appDelegate.managedObjectContext
            
        let batchUpdateRequestReserva = NSBatchUpdateRequest(entityName: "Reserva")
           batchUpdateRequestReserva.propertiesToUpdate = ["idSede" : obtenerId(idSedeSelec, idActualizar: reserva.idSede),
            "idBloque":         obtenerId(idBloqueSelec, idActualizar: reserva.idBloque),
            "idArea":           obtenerId(idAreaSelec, idActualizar: reserva.idArea),
            "idPrograma":       obtenerId(idProgramaSelec, idActualizar: reserva.idPrograma),
            "idAsignatura":     obtenerId(idAsignaturaSelec, idActualizar: reserva.idAsignatura),
            "idGrupo":          obtenerId(idGrupoSelec, idActualizar: reserva.idGrupo),
            "idTipoActividad": obtenerId(idTipoActividadSelec, idActualizar: reserva.idTipoActividad),
            "idRecurso":        obtenerId(idRecursoSelec, idActualizar: reserva.idRecurso),
            "fechaInicial":     Util.dateFromString(fechaHoraInicialPickerView.date, dateFormat: Util.dateEEE_DD_MMM_YYYY),
            "horaInicial":      Util.dateFromString(fechaHoraInicialPickerView.date, dateFormat: Util.dateHH_MM_AAA),
            "fechaFinal":       Util.dateFromString(fechaHoraFinalPickerView.date, dateFormat: Util.dateEEE_DD_MMM_YYYY),
            "horaFinal":        Util.dateFromString(fechaHoraFinalPickerView.date,dateFormat: Util.dateHH_MM_AAA)
        ]
        
        batchUpdateRequestReserva.predicate = NSPredicate(format: "idReserva == %@", idReservaSelecc!)
        batchUpdateRequestReserva.resultType = .updatedObjectsCountResultType
        
         do{
            let _: NSPersistentStoreResult? = try managedObjectContext.execute(batchUpdateRequestReserva)
         
         }catch let error as NSError {
            let mensaje = "No se pudo actualizar la Reserva del CoreData \(error). \(error.userInfo)"
            self.alerta(Util.errorTltCoreData, msg: mensaje)
        }
    }
    
    @IBAction func guardarReserva(_ sender: UIButton) {
        datosSendJSONReserva["idProfesor"]       = profesor.idProfesor as AnyObject?
        datosSendJSONReserva["idReserva"]        = reserva.idReserva as AnyObject?
        datosSendJSONReserva["idSede"]           = obtenerId(idSedeSelec, idActualizar: reserva.idSede) as AnyObject?
        datosSendJSONReserva["idBloque"]         = obtenerId(idBloqueSelec, idActualizar: reserva.idBloque) as AnyObject?
        datosSendJSONReserva["idArea"]           = obtenerId(idAreaSelec, idActualizar: reserva.idArea) as AnyObject?
        datosSendJSONReserva["idPrograma"]       = obtenerId(idProgramaSelec, idActualizar: reserva.idPrograma) as AnyObject?
        datosSendJSONReserva["idAsignatura"]     = obtenerId(idAsignaturaSelec, idActualizar: reserva.idAsignatura) as AnyObject?
        datosSendJSONReserva["idGrupo"]           = obtenerId(idGrupoSelec, idActualizar: reserva.idGrupo) as AnyObject?
        datosSendJSONReserva["idTipoActividad"]  = obtenerId(idTipoActividadSelec, idActualizar: reserva.idTipoActividad) as AnyObject?
        datosSendJSONReserva["idRecurso"]         = obtenerId(idRecursoSelec, idActualizar: reserva.idRecurso) as AnyObject?
        datosSendJSONReserva["fechaInicial"]      = Util.dateFromString(fechaHoraInicialPickerView.date, dateFormat: Util.dateEEE_DD_MMM_YYYY) as AnyObject?
        datosSendJSONReserva["horaInicial"]       = Util.dateFromString(fechaHoraInicialPickerView.date, dateFormat: Util.dateHH_MM_AAA) as AnyObject?
        datosSendJSONReserva["fechaFinal"]        = Util.dateFromString(fechaHoraFinalPickerView.date, dateFormat: Util.dateEEE_DD_MMM_YYYY) as AnyObject?
        datosSendJSONReserva["horaFinal"]         = Util.dateFromString(fechaHoraFinalPickerView.date,dateFormat: Util.dateHH_MM_AAA) as AnyObject?
        jsonParserViewController.delegateJSON = self
        jsonParserViewController.makeHttpAsynchronousRequest(urlEditarReserva, params: datosSendJSONReserva, method: Util.sendJSON)
        
        actualizarReservaCoreData()
    }
    
    func jsonParserGET(_ jsonObject : AnyObject){
    }
    
    func jsonParserSEND(_ jsonObject : AnyObject){
        DispatchQueue.main.async {
            if jsonObject is NSDictionary { // Si hay datos
                if jsonObject["success"] as! String == Util.exito { // Si exito
                    self.alerta(Util.reservaTlt, msg: Util.reservaMsg)
                }else {
                    let mensaje = jsonObject["error"] as! String
                    self.alerta(Util.errorTltBD, msg: mensaje)
                }
            }else if jsonObject is String {
                if jsonObject as! String == Util.exito {
                    self.alerta(Util.reservaTlt, msg: Util.reservaMsg)
                }else {
                    let jsonError = jsonObject as? String
                    self.alerta(jsonError, msg: jsonError)
                }
            }
        }
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
   /* override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if segue.identifier == "sgListadoReserva" {
        }
    }
   */
    
    func alerta(_ tlt : String!, msg : String!) {
    
        let titulo   : String = tlt
        let mensaje : String = msg
        let messageHandler    = MessageHandler()
    
        let _titutlo   = messageHandler.getTitle(titulo)
        let _mensaje   = messageHandler.getMessage(mensaje)
    
        let alertController = UIAlertController( title : _titutlo, message: _mensaje, preferredStyle: UIAlertControllerStyle.alert)
    
        let cancelAction = UIAlertAction(title: "Ok", style: .cancel, handler: nil)
    
        alertController.addAction(cancelAction)
    
        self.present(alertController, animated: true, completion: nil)
   }

}
