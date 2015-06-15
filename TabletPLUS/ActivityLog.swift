//
//  ActivityLog.swift
//  TabletPLUS
//
//  Created by Ruchi Salvi on 10/06/15.
//  Copyright (c) 2015 dhaval shah. All rights reserved.
//
import Foundation
import UIKit

class ActivityLog{
    let logStr: String
    let dateStr: String
    
    init(logStr: String, dateStr: String) {
        self.logStr = logStr
        self.dateStr = dateStr
    }
    
    class func AcrivityLogArr() -> Array<ActivityLog> {
        return [
            ActivityLog(logStr: "Ver todos os imoveis no mapa ", dateStr: "Hoje as 16:25:36"),
             ActivityLog(logStr: "Ver todos os imoveis no mapa ", dateStr: "Hoje as 16:25:36"),
             ActivityLog(logStr: "Ver todos os imoveis no mapa ", dateStr: "Hoje as 16:25:36"),
             ActivityLog(logStr: "Ver todos os imoveis no mapa ", dateStr: "Hoje as 16:25:36"),
             ActivityLog(logStr: "Ver todos os imoveis no mapa ", dateStr: "Hoje as 16:25:36"),
             ActivityLog(logStr: "Ver todos os imoveis no mapa ", dateStr: "Hoje as 16:25:36"),
             ActivityLog(logStr: "Ver todos os imoveis no mapa ", dateStr: "Hoje as 16:25:36")
            ]
        
    }
    
    
}