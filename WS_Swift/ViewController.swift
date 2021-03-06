//
//  ViewController.swift
//  WS_Swift
//
//  Created by Labdesarrollo5 on 26/04/20.
//  Copyright © 2020 Labdesarrollo5. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    //Creamos una instancia de nuestra clase manejadora de las peticiones al servidor remoto
    var Productos = [Producto]()
    let dataJsonUrlClass = JsonClass()
    
    @IBOutlet weak var idProd: UITextField!
    @IBOutlet weak var nomProd: UITextField!
    @IBOutlet weak var existencia: UITextField!
    @IBOutlet weak var precio: UITextField!
    
    @IBOutlet weak var mensajeLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    
    @IBAction func btnCargaProductos(_ sender: UIButton) {
            Productos.removeAll()
            let datos_a_enviar = ["id": ""] as NSMutableDictionary
            
            //ejecutamos la función arrayFromJson con los parámetros correspondientes (url archivo .php / datos a enviar)
            
            dataJsonUrlClass.arrayFromJson(url:"WS_Swift/getProductos.php",datos_enviados:datos_a_enviar){ (array_respuesta) in
                
                DispatchQueue.main.async {//proceso principal
                    
                    /*
                     recibimos un array de tipo:
                     (
                         [0] => Array
                         (
                             [success] => 200
                             [message] => Producto encontrado
                             [idProd] => 1
                             [nomProd] => Desarmador plus
                             [existencia] => 10
                             [precio] => 80
                         )
                     )
                     object(at: 0) as! NSDictionary -> indica que el elemento 0 de nuestro array lo vamos a convertir en un diccionario de datos.
                     */
                    let cuenta = array_respuesta?.count
                    
                    for indice in stride(from: 0, to: cuenta!, by: 1){
                        let product = array_respuesta?.object(at: indice) as! NSDictionary
                        let idprod = product.object(forKey: "idProd") as! String?
                        let nomprod = product.object(forKey: "nomProd") as! String?
                        let existe = product.object(forKey: "existencia") as! String?
                        let pre = product.object(forKey: "precio") as! String?
                        self.Productos.append(Producto(idProd: idprod, nomProd: nomprod, Existencia: existe, Precio: pre) )
                    }
                    self.performSegue(withIdentifier: "segue", sender: self)
                }
            }
    }
    
    @IBAction func btnConsultar(_ sender: UIButton) {
        //borramos el contenidod e todos los text
        nomProd.text = ""
        existencia.text = ""
        precio.text = ""
        
        //extraemos el valor del campo de texto (ID usuario)
        let id_usuario = idProd.text

        //si idText.text no tienen ningun valor terminamos la ejecución
        if id_usuario == ""{
            return
        }
        
        //Creamos un array (diccionario) de datos para ser enviados en la petición hacia el servidor remoto, aqui pueden existir N cantidad de valores
        let datos_a_enviar = ["idProd": id_usuario!] as NSMutableDictionary
        
        //ejecutamos la función arrayFromJson con los parámetros correspondientes (url archivo .php / datos a enviar)
        
        dataJsonUrlClass.arrayFromJson(url:"WS_Swift/getProducto.php",datos_enviados:datos_a_enviar){ (array_respuesta) in
            
            DispatchQueue.main.async {//proceso principal
                
                /*
                 recibimos un array de tipo:
                 (
                     [0] => Array
                     (
                         [success] => 200
                         [message] => Producto encontrado
                         [idProd] => 1
                         [nomProd] => Desarmador plus
                         [existencia] => 10
                         [precio] => 80
                     )
                 )
                 object(at: 0) as! NSDictionary -> indica que el elemento 0 de nuestro array lo vamos a convertir en un diccionario de datos.
                 */
                let diccionario_datos = array_respuesta?.object(at: 0) as! NSDictionary
                
                //ahora ya podemos acceder a cada valor por medio de su key "forKey"
                if let msg = diccionario_datos.object(forKey: "message") as! String?{
                    self.mensajeLabel.text = msg
                }
                
                if let nom = diccionario_datos.object(forKey: "nomProd") as! String?{
                    self.nomProd.text = nom
                }
                
                if let exi = diccionario_datos.object(forKey: "existencia") as! String?{
                    self.existencia.text = exi
                }
                
                if let pre = diccionario_datos.object(forKey: "precio") as! String?{
                    self.precio.text = pre
                }
            }
        }
    }
    
    @IBAction func btnAgregar(_ sender: UIButton) {
        if nomProd.text!.isEmpty || existencia.text!.isEmpty || precio.text!.isEmpty{
            showAlerta(Titulo: "Validacion de Entrada", Mensaje: "Error faltan de ingresar datos")
            nomProd.becomeFirstResponder()
            return
        }
        else{
                //extraemos el valor del campo de texto (ID usuario)
                let nomprod = nomProd.text
                let existe = existencia.text
                let pre = precio.text
            
            //Creamos un array (diccionario) de datos para ser enviados en la petición hacia el servidor remoto, aqui pueden existir N cantidad de va!lores
            let datos_a_enviar = ["nomProd": nomprod!,"existencia":existe,"precio":pre] as NSMutableDictionary
                
                //ejecutamos la función arrayFromJson con los parámetros correspondientes (url archivo .php / datos a enviar)
                
                dataJsonUrlClass.arrayFromJson(url:"WS_Swift/insertProducto.php",datos_enviados:datos_a_enviar){ (array_respuesta) in
                    
                    DispatchQueue.main.async {//proceso principal
                        
                        /*
                         recibimos un array de tipo:
                         (
                             [0] => Array
                             (
                                 [success] => 200
                                 [message] => Producto Insertado
                             )
                         )
                         object(at: 0) as! NSDictionary -> indica que el elemento 0 de nuestro array lo vamos a convertir en un diccionario de datos.
                         */
                        let diccionario_datos = array_respuesta?.object(at: 0) as! NSDictionary
                        
                        //ahora ya podemos acceder a cada valor por medio de su key "forKey"
                        if let msg = diccionario_datos.object(forKey: "message") as! String?{
                            self.showAlerta(Titulo: "Guardando", Mensaje: msg)
                        }
                        
                        self.idProd.text=""
                        self.nomProd.text = ""
                        self.existencia.text = "0"
                        self.precio.text = "0"
                    }
                }
        }// Fin del else
    }
    
    @IBAction func btnBorrar(_ sender: UIButton) {
        if idProd.text!.isEmpty {
            showAlerta(Titulo: "Validacion de Entrada", Mensaje: "Error faltan de ingresar datos")
            idProd.becomeFirstResponder()
            return
        }
        else{
                let idprod = idProd.text!
            
                //Creamos un array (diccionario) de datos para ser enviados en la petición hacia el servidor remoto, aqui pueden existir N cantidad de valores
            let datos_a_enviar = ["idProd":idprod] as NSMutableDictionary
                
                //ejecutamos la función arrayFromJson con los parámetros correspondientes (url archivo .php / datos a enviar)
                
                dataJsonUrlClass.arrayFromJson(url:"WS_Swift/deleteProducto.php",datos_enviados:datos_a_enviar){ (array_respuesta) in
                    
                    DispatchQueue.main.async {//proceso principal
                        
                        /*
                         recibimos un array de tipo:
                         (
                             [0] => Array
                             (
                                 [success] => 200
                                 [message] => Producto Actualizado
                             )
                         )
                         object(at: 0) as! NSDictionary -> indica que el elemento 0 de nuestro array lo vamos a convertir en un diccionario de datos.
                         */
                        let diccionario_datos = array_respuesta?.object(at: 0) as! NSDictionary
                        
                        //ahora ya podemos acceder a cada valor por medio de su key "forKey"
                        if let msg = diccionario_datos.object(forKey: "message") as! String?{
                            self.showAlerta(Titulo: "Eliminando", Mensaje: msg)
                        }
                        
                        self.idProd.text=""
                        self.nomProd.text = ""
                        self.existencia.text = "0"
                        self.precio.text = "0"
                    }
                }
        }// Fin del else
    }
    
    @IBAction func btnActualizar(_ sender: UIButton) {
        if idProd.text!.isEmpty || nomProd.text!.isEmpty || existencia.text!.isEmpty || precio.text!.isEmpty{
            showAlerta(Titulo: "Validacion de Entrada", Mensaje: "Error faltan de ingresar datos")
            idProd.becomeFirstResponder()
            return
        }
        else{
                let idprod = idProd.text!
                let nomprod = nomProd.text!
                let existe = existencia.text!
                let pre = precio.text!
            
                //Creamos un array (diccionario) de datos para ser enviados en la petición hacia el servidor remoto, aqui pueden existir N cantidad de valores
            let datos_a_enviar = ["idProd":idprod, "nomProd": nomprod,"existencia":existe,"precio":pre] as NSMutableDictionary
                
                //ejecutamos la función arrayFromJson con los parámetros correspondientes (url archivo .php / datos a enviar)
                
                dataJsonUrlClass.arrayFromJson(url:"WS_Swift/updateProducto.php",datos_enviados:datos_a_enviar){ (array_respuesta) in
                    
                    DispatchQueue.main.async {//proceso principal
                        
                        /*
                         recibimos un array de tipo:
                         (
                             [0] => Array
                             (
                                 [success] => 200
                                 [message] => Producto Actualizado
                             )
                         )
                         object(at: 0) as! NSDictionary -> indica que el elemento 0 de nuestro array lo vamos a convertir en un diccionario de datos.
                         */
                        let diccionario_datos = array_respuesta?.object(at: 0) as! NSDictionary
                        
                        //ahora ya podemos acceder a cada valor por medio de su key "forKey"
                        if let msg = diccionario_datos.object(forKey: "message") as! String?{
                            self.showAlerta(Titulo: "Guardando", Mensaje: msg)
                        }
                        
                        self.idProd.text=""
                        self.nomProd.text = ""
                        self.existencia.text = "0"
                        self.precio.text = "0"
                    }
                }
        }// Fin del else
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "segue"{
            let seguex = segue.destination as! TableViewController
            seguex.productos = Productos
        }
    }
    
    func showAlerta(Titulo: String, Mensaje: String ){
       // Crea la alerta
      let alert = UIAlertController(title: Titulo, message: Mensaje, preferredStyle: UIAlertController.Style.alert)
      // Agrega un boton
      alert.addAction(UIAlertAction(title: "Aceptar", style: UIAlertAction.Style.default, handler: nil))
     // Muestra la alerta
     self.present(alert, animated: true, completion: nil)
    }
}

