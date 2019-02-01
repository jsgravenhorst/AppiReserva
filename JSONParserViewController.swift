//
//  JSONParserViewController.swift
//  AppiReserva
//
//  Created by Johann Stig Gravenhorst R. on 1/14/16.
//  Copyright © 2016 Olonte Apps. All rights reserved.
//

import UIKit
@objc protocol JSONParserDelegate {
    func jsonParserGET(_ jsonObject : AnyObject)
    func jsonParserSEND(_ jsonObject : AnyObject)
}

class JSONParserViewController: UIViewController {
    
    var delegateJSON : JSONParserDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    func makeHttpAsynchronousRequest(_ url: String!, params: Dictionary<String,AnyObject>?, method: String!) {
        
        self.validarConexion { (sw) -> () in
            
            if sw == true {
                
                self.deserializableJSON(url, _params: params, completion: { (jsonObject) -> () in
                    if method == "G" {
                        self.delegateJSON?.jsonParserGET(jsonObject)
                    }else{
                        self.delegateJSON?.jsonParserSEND(jsonObject)
                    }
                })
            } else { // No hay conexión a Internet
                let errorConnInt = "0"
                if method == "G" {
                  self.delegateJSON?.jsonParserGET(errorConnInt as AnyObject)
                }else {
                    self.delegateJSON?.jsonParserSEND(errorConnInt as AnyObject)
                }
            }
        }
    }
    
    func validarConexion( _ completion: @escaping (_ sw : Bool?) -> () ) {
        
        let statusCode  = 200
        let url  : URL = URL(string: "https://www.apple.com")!
        let request: URLRequest = URLRequest(url: url)
        let config  = URLSessionConfiguration.default
        let session = URLSession(configuration: config)
        var isConnectedToServer : Bool = false
        
        let task : URLSessionDataTask = session.dataTask( with: request,
            completionHandler: { (data,
                response,
                error) in
                if let httpResponse = response as? HTTPURLResponse {
                    if httpResponse.statusCode == statusCode {
                        isConnectedToServer = true
                    }
                }
                completion(isConnectedToServer)
        })
        
        task.resume()
    }
    
    func deserializableJSON(_ urlString : String, _params: Dictionary<String,AnyObject>?, completion: @escaping (_ jsonObject : AnyObject) -> () ) {
        
        let timeoutInterval = 10.0
        let url  : URL = URL(string: urlString)!
        
        let urlRequest = NSMutableURLRequest(url: url,
            cachePolicy: .reloadIgnoringLocalAndRemoteCacheData,
            timeoutInterval: timeoutInterval)
        
        if let params = _params {
            do {
                var jsonparameter = "jsonDatos="
                let jsonData = try JSONSerialization.data(withJSONObject: params, options: .prettyPrinted)
                
                if jsonData.count > 0 {
                    let jsonString = NSString(data: jsonData, encoding: String.Encoding.utf8.rawValue)
                    jsonparameter += jsonString! as String
                    let body = jsonparameter.data(using: String.Encoding.utf8, allowLossyConversion: false)
                    let httpMethod : String = "POST"
                    urlRequest.httpBody   = body
                    urlRequest.httpMethod = httpMethod
                }
                
            }catch let error as NSError{
               print("No se pudo generar los parametros \(error). \(error.userInfo)")
            }
        }
        
        let config = URLSessionConfiguration.default
        let session = URLSession(configuration: config)
        var deserializedJSON : AnyObject?
        
        let task : URLSessionDataTask = session.dataTask( with: urlRequest,
            completionHandler: { (data,
                response,
                error) in
                
                if data != nil && error == nil {
                    
                    if data!.count > 0 {
                        
                        var _error: NSError?
                        
                        let jsonObject: AnyObject?
                        do {
                            jsonObject = try JSONSerialization.jsonObject(with: data!,
                                options: .allowFragments)
                        } catch let error as NSError {
                            _error = error
                            jsonObject = nil
                        } catch {
                            fatalError()
                        }
                        
                        if _error == nil {
                            if jsonObject is NSDictionary {
                                deserializedJSON = jsonObject as! NSDictionary
                            } else if jsonObject is NSArray {
                                deserializedJSON = jsonObject as! NSArray
                            }
                        }else if _error != nil {
                            deserializedJSON = "2"
                        }
                    }else if data!.count == 0 {
                        deserializedJSON = "3"
                    }
                }
                if deserializedJSON == nil{
                    deserializedJSON = "4"
                }
                completion(jsonObject: deserializedJSON! )
        })
        task.resume()
    }


}
