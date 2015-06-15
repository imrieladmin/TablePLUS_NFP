//
//  MenuItem.swift
//  TabletPLUS
//
//  Created by Ruchi Salvi on 09/06/15.
//  Copyright (c) 2015 dhaval shah. All rights reserved.
//

import Foundation
import UIKit

class MenuItem{
    let title: String
    let image: UIImage?
    
    init(title: String, image: UIImage?) {
        self.title = title
        self.image = image
    }
    
    class func sideMenuArr() -> Array<MenuItem> {
        return [
            MenuItem(title: "Casa", image: UIImage(named: "Home_Menu")),
            MenuItem(title: "Novo Ediffcio",  image: UIImage(named: "New_Build_Menu")),
            MenuItem(title: "Sair", image: UIImage(named: "Logout_Menu")),
            MenuItem(title: "Alterar indioma",  image: UIImage(named: "Lang_Menu")),
            MenuItem(title: "Registro De Atividate", image: UIImage(named: "Activity_Menu")),
            MenuItem(title: "Reportar um problema",  image: UIImage(named: "Report_Bug_Menu"))
        ]
        
    }
    
    
}