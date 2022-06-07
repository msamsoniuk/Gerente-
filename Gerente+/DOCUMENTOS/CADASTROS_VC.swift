//
//  CADASTROS_VC.swift
//  Gerente+
//
//  Created by Marcos Samsoniuk on 20/11/18.
//  Copyright © 2018 Marcos Samsoniuk. All rights reserved.
//

import UIKit

var negocioFlag         = false
var documentosFlag      = false
var colaboradoresFlag   = false
var materiaPrimaFlag    = false
var receitasFlag        = false

class CADASTROS_VC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        if firstTime {btnFechar.isHidden = false} else {
           btnFechar.isHidden = true
        }
    }

    @IBAction func fecharPvez(_ sender: UIButton) {
        if((self.presentingViewController) != nil){
            self.dismiss(animated: false, completion: nil)
        }
    }
    @IBOutlet weak var btnFechar: UIButton!
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.checkstatus()
        
        if firstTime {btnFechar.isHidden = false} else {
            btnFechar.isHidden = true
        }
    }
    
    func checkstatus() {
        
        negocioFlag         = UserDefaults.standard.bool(forKey: "negocioFlag")
        documentosFlag      = UserDefaults.standard.bool(forKey: "documentosFlag")
        colaboradoresFlag   = UserDefaults.standard.bool(forKey: "colaboradoresFlag")
        materiaPrimaFlag    = UserDefaults.standard.bool(forKey: "materiaPrimaFlag")
        receitasFlag        = UserDefaults.standard.bool(forKey: "receitasFlag")
        
        //print(negocioFlag, documentosFlag,colaboradoresFlag,materiaPrimaFlag,receitasFlag)
        
        if negocioFlag       {status1.image = UIImage(named: "sign_green")}
        else {status1.image = UIImage(named: "sign_red")}
        if documentosFlag    {status2.image = UIImage(named: "sign_green")}
        else {status2.image = UIImage(named: "sign_red")}
        if colaboradoresFlag {status3.image = UIImage(named: "sign_green")}
        else {status3.image = UIImage(named: "sign_red")}
        if materiaPrimaFlag  {status4.image = UIImage(named: "sign_green")}
        else {status4.image = UIImage(named: "sign_red")}
        if receitasFlag      {status5.image = UIImage(named: "sign_green")}
        else {status5.image = UIImage(named: "sign_red")}
    }
    
    @IBOutlet weak var status1: UIImageView!
    @IBOutlet weak var status2: UIImageView!
    @IBOutlet weak var status3: UIImageView!
    @IBOutlet weak var status4: UIImageView!
    @IBOutlet weak var status5: UIImageView!
   
   // negocioFlag = true
   // let defaults = UserDefaults.standard
   // defaults.set(true, forKey: "negocioFlag")
    //  boolValue = UserDefaults.standard.bool(forKey: "sound")
}
