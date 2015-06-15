//
//  PropertyMapController.swift
//  TabletPLUS
//
//  Created by Ruchi Salvi on 02/06/15.
//  Copyright (c) 2015 dhaval shah. All rights reserved.
//
import UIKit
import Foundation
import QuartzCore
import MapKit


class PropertyMapController: UIViewController, MKMapViewDelegate  {

    @IBOutlet var lblPropStatus: UILabel!
    
    @IBOutlet var labelView: UIView!
    var property = Property()
   
    @IBOutlet var propertyMapView: MKMapView!
    
    var gecoder = CLGeocoder()
    
    var latitude: CLLocationDegrees=0.0
    var longitude: CLLocationDegrees=0.0
    
    
    var latDelta: CLLocationDegrees=13
    var longDelta: CLLocationDegrees=13
    
    var menuImg : UIImage = UIImage(named: "Slider")!
    var menuBtn : UIBarButtonItem = UIBarButtonItem()
    
    var utility = Utility()
    var constants = Constants()
   
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        super.title = property.address as String
        
        let titleDict: NSDictionary = [NSForegroundColorAttributeName: UIColor.whiteColor()]
        if self.navigationController != nil {
            self.navigationController!.navigationBar.titleTextAttributes = titleDict as [NSObject : AnyObject]
        }
        
       
        lblPropStatus.text =  utility.getStatusFromXmlStatus(property.status as String)
        if(property.status == constants.status.STATUS_DRAFT_XML){
            lblPropStatus.backgroundColor = UIColor.yellowColor()
        }
        else if(property.status == constants.status.STATUS_PENDING_XML){
            lblPropStatus.backgroundColor = UIColor.redColor()
        }
        else if(property.status == constants.status.STATUS_COMPLETED_XML){
            lblPropStatus.backgroundColor = UIColor.greenColor()
        }
        lblPropStatus.textColor = UIColor.blackColor()
        lblPropStatus.layer.cornerRadius = 4.0;
        lblPropStatus.layer.masksToBounds = true
        labelView.addSubview(lblPropStatus)
        
        menuBtn = UIBarButtonItem(image: menuImg,  style: UIBarButtonItemStyle.Plain, target: self, action: Selector ("menuPressed:"))
        
        menuBtn.tintColor = UIColor.whiteColor()
        self.navigationItem.rightBarButtonItem = menuBtn
        self.navigationItem.setRightBarButtonItem(menuBtn, animated: true)
        
        
        //Side menu Start
        if self.revealViewController() != nil {
            menuBtn.target = self.revealViewController()
            menuBtn.action = "rightRevealToggle:"
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
            self.revealViewController().rightViewRevealWidth = 270
        }
        
        
        //Side menu End
        
        loadPropertyMap()
        
    }
    
    func loadPropertyMap()
    {
        var latStr = property.lat as NSString
        var latDbl : Double  = Double(latStr.intValue)
        latitude = latDbl
        
        var langStr = property.lang as NSString
        var langDbl : Double = Double(langStr.intValue)
        longitude = langDbl
        
        let location = CLLocationCoordinate2D(
            latitude: latitude,
            longitude:longitude
        )
      
        let span = MKCoordinateSpanMake(latDelta, longDelta)
        let region = MKCoordinateRegion(center: location, span: span)
        self.propertyMapView.setRegion(region, animated: true)
      
        let annotation = CustomPointAnnotation()
        annotation.coordinate = location
        annotation.title = property.buildingName as String
        annotation.subtitle = property.address as String
        annotation.imageName = "map-marker-new"
        
        
        self.propertyMapView.addAnnotation(annotation)
    }
    
    func mapView(mapView: MKMapView!, viewForAnnotation annotation: MKAnnotation!) -> MKAnnotationView! {
        
        println("mapView call ")
        
        if !(annotation is CustomPointAnnotation) {
            return nil
        }
        
        let reuseId = "IndividualPropertyMap"
        
        var anView = mapView.dequeueReusableAnnotationViewWithIdentifier(reuseId)
        if anView == nil {
            anView = MKAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            anView.canShowCallout = true
        }
        else {
            anView.annotation = annotation
        }
        
        //Set annotation-specific properties **AFTER**
        //the view is dequeued or created...
        
        let cpa = annotation as! CustomPointAnnotation
        anView.image = UIImage(named:cpa.imageName)
        
        return anView
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    class CustomPointAnnotation: MKPointAnnotation {
        var imageName: String!
    }
    
    
  }


