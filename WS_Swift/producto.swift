//
//  producto.swift
//  WS_Swift
//
//  Created by Labdesarrollo5 on 26/04/20.
//  Copyright © 2020 Labdesarrollo5. All rights reserved.
//

import Foundation
class Producto {
    
    var idprod: String?
    var nomprod: String?
    var existe: String?
    var pre: String?
    
    init(idProd: String?, nomProd: String?, Existencia: String?, Precio: String?) {
        self.idprod  = idProd
        self.nomprod = nomProd
        self.existe = Existencia
        self.pre = Precio
    }
}
