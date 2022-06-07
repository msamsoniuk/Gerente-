//
//  AJUST_VC.swift
//  Gerente+
//
//  Created by Marcos Samsoniuk on 10/11/18.
//  Copyright © 2018 Marcos Samsoniuk. All rights reserved.
//

import UIKit

class AJUST_VC: UIViewController, UITextFieldDelegate {
    
    var defaults = UserDefaults.standard
    @IBOutlet weak var setsView: UIView!
    @IBOutlet weak var equiView: UIView!
    @IBOutlet weak var pulse: UIButton!
    @IBOutlet weak var textoCompressao: UILabel!
    
    //var myview:CGRect
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        DiasArq.addDoneButtonToKeyboard(myAction:  #selector(self.DiasArq.resignFirstResponder))
        
        // retrive memory
        let defaults = UserDefaults.standard
        
        var mem = defaults.string(forKey: "TextEqui1")
        if mem != nil { TextEqui1.text = mem}
        mem = defaults.string(forKey: "equi1")
        if mem != nil  { equi1.selectedSegmentIndex = Int(mem!)! }
        
        mem = defaults.string(forKey: "TextEqui2")
        if mem != nil { TextEqui2.text = mem}
        mem = defaults.string(forKey: "equi2")
        if mem != nil  { equi2.selectedSegmentIndex = Int(mem!)! }
        
        mem = defaults.string(forKey: "TextEqui3")
        if mem != nil { TextEqui3.text = mem}
        mem = defaults.string(forKey: "equi3")
        if mem != nil  { equi3.selectedSegmentIndex = Int(mem!)! }
        
        mem = defaults.string(forKey: "TextEqui4")
        if mem != nil { TextEqui4.text = mem}
        mem = defaults.string(forKey: "equi4")
        if mem != nil  { equi4.selectedSegmentIndex = Int(mem!)! }
        
        mem = defaults.string(forKey: "TextEqui5")
        if mem != nil { TextEqui5.text = mem}
        mem = defaults.string(forKey: "equi5")
        if mem != nil  { equi5.selectedSegmentIndex = Int(mem!)! }
        
        mem = defaults.string(forKey: "TextEqui6")
        if mem != nil { TextEqui6.text = mem}
        mem = defaults.string(forKey: "equi6")
        if mem != nil  { equi6.selectedSegmentIndex = Int(mem!)! }
        
        mem = defaults.string(forKey: "TextEqui7")
        if mem != nil { TextEqui7.text = mem}
        mem = defaults.string(forKey: "equi7")
        if mem != nil  { equi7.selectedSegmentIndex = Int(mem!)! }
        
        mem = defaults.string(forKey: "TextEqui8")
        if mem != nil { TextEqui8.text = mem}
        mem = defaults.string(forKey: "equi8")
        if mem != nil  { equi8.selectedSegmentIndex = Int(mem!)! }
        
        mem = defaults.string(forKey: "Textbluet")
        if mem != nil { Textbluet.text = mem}
        mem = defaults.string(forKey: "bluet")
        if mem != nil  { bluet.selectedSegmentIndex = Int(mem!)! }
        
        mem = defaults.string(forKey: "DiasArq")
        if mem != nil { DiasArq.text = mem}
    
        mem = defaults.string(forKey: "compressao")
        if mem != nil  { compressao.value = Float(mem!)!
           textoCompressao.text = "Compressão \(compressao.value)"
        }
        
        mem = defaults.string(forKey: "resetDay")
        if mem != nil  {  } //resetDay
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        //print("fechar teclado 1")
        self.memoryall()
        return true
    }
    
    // up down keyboard
    func textFieldDidBeginEditing(_ textField: UITextField) {
        var  heigth = 200 - ((self.view.frame.maxY - 570) / 2)
        if  heigth < 0 {heigth = 0}
        
        if textField == Textbluet || textField == DiasArq {
            equiView.isHidden = true
            UIView.animate(withDuration: 0.3, animations: {
                self.setsView.frame = CGRect(x:self.setsView.frame.origin.x, y:self.setsView.frame.origin.y - heigth, width:self.setsView.frame.size.width, height:self.setsView.frame.size.height);
            })
        }
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        var  heigth = 200 - ((self.view.frame.maxY - 570) / 2)
        if  heigth < 0 {heigth = 0}
        
        if textField == Textbluet || textField == DiasArq {
            UIView.animate(withDuration: 0.3, animations: {
                self.setsView.frame = CGRect(x:self.setsView.frame.origin.x, y:self.setsView.frame.origin.y + heigth, width:self.setsView.frame.size.width, height:self.setsView.frame.size.height);
            })
            equiView.isHidden = false
            //print("fechar teclado 2")
            self.memoryall()
        }
    }
    
    func memoryall() {
       defaults.set(TextEqui1.text, forKey: "TextEqui1")
        tools[0].item = TextEqui1.text!
       defaults.set(TextEqui2.text, forKey: "TextEqui2")
        tools[1].item = TextEqui2.text!
       defaults.set(TextEqui3.text, forKey: "TextEqui3")
        tools[2].item = TextEqui3.text!
       defaults.set(TextEqui4.text, forKey: "TextEqui4")
        tools[3].item = TextEqui4.text!
       defaults.set(TextEqui5.text, forKey: "TextEqui5")
        tools[4].item = TextEqui5.text!
       defaults.set(TextEqui6.text, forKey: "TextEqui6")
        tools[5].item = TextEqui6.text!
       defaults.set(TextEqui7.text, forKey: "TextEqui7")
        tools[6].item = TextEqui7.text!
       defaults.set(TextEqui8.text, forKey: "TextEqui8")
        tools[7].item = TextEqui8.text!
       defaults.set(Textbluet.text, forKey: "Textbluet")
       defaults.set(DiasArq.text,   forKey: "DiasArq")
    }
    
    func upMemory() {
        for i in 0...tools.count-1 {
            if let index = Matrix.firstIndex(where: {
                $0.mC == 3
                    && $0.mD == 3
                    && $0.mU == i+1}) {
                Matrix[index].use = tools[i].ativo
            }
            if let index = tarefas.firstIndex(where: {
                $0.mC == 3
                    && $0.mD == 3
                    && $0.mU == i+1}) {
                tarefas[index].ativo = tools[i].ativo
                tarefas[index].item  = tools[i].item
            }
        }

    }

    // EQUIP 1
    @IBOutlet weak var equi1: UISegmentedControl!
    @IBAction func Equip1(_ sender: UISegmentedControl) {
        defaults.set(equi1.selectedSegmentIndex, forKey: "equi1")
        tools[0].ativo = equi1.selectedSegmentIndex
        self.upMemory()
    }
    @IBOutlet weak var TextEqui1: UITextField!
    
    // EQUIP 2
    @IBOutlet weak var equi2: UISegmentedControl!
    @IBAction func Equip2(_ sender: UISegmentedControl) {
        defaults.set(equi2.selectedSegmentIndex, forKey: "equi2")
        tools[1].ativo = equi1.selectedSegmentIndex
        self.upMemory()
    }
    @IBOutlet weak var TextEqui2: UITextField!
    
    // EQUIP 3
    @IBOutlet weak var equi3: UISegmentedControl!
    @IBAction func Equip3(_ sender: UISegmentedControl) {
        defaults.set(equi3.selectedSegmentIndex, forKey: "equi3")
        tools[2].ativo = equi1.selectedSegmentIndex
        self.upMemory()
    }
    @IBOutlet weak var TextEqui3: UITextField!
    
    // EQUIP 4
    @IBOutlet weak var equi4: UISegmentedControl!
    @IBAction func Equip4(_ sender: UISegmentedControl) {
        defaults.set(equi4.selectedSegmentIndex, forKey: "equi4")
        tools[3].ativo = equi1.selectedSegmentIndex
        self.upMemory()
    }
    @IBOutlet weak var TextEqui4: UITextField!
    
    // EQUIP 5
    @IBOutlet weak var equi5: UISegmentedControl!
    @IBAction func Equip5(_ sender: UISegmentedControl) {
        defaults.set(equi5.selectedSegmentIndex, forKey: "equi5")
        tools[4].ativo = equi1.selectedSegmentIndex
        self.upMemory()
    }
    @IBOutlet weak var TextEqui5: UITextField!
    
    // EQUIP 6
    @IBOutlet weak var equi6: UISegmentedControl!
    @IBAction func Equip6(_ sender: UISegmentedControl) {
        defaults.set(equi6.selectedSegmentIndex, forKey: "equi6")
        tools[5].ativo = equi1.selectedSegmentIndex
        self.upMemory()
    }
    @IBOutlet weak var TextEqui6: UITextField!
    
    // EQUIP 7
    @IBOutlet weak var equi7: UISegmentedControl!
    @IBAction func Equip7(_ sender: UISegmentedControl) {
        defaults.set(equi7.selectedSegmentIndex, forKey: "equi7")
        tools[6].ativo = equi1.selectedSegmentIndex
        self.upMemory()
    }
    @IBOutlet weak var TextEqui7: UITextField!
    
    // EQUIP 8
    @IBOutlet weak var equi8: UISegmentedControl!
    @IBAction func Equip8(_ sender: UISegmentedControl) {
        defaults.set(equi8.selectedSegmentIndex, forKey: "equi8")
        tools[7].ativo = equi1.selectedSegmentIndex
        self.upMemory()
    }
    @IBOutlet weak var TextEqui8: UITextField!

    // BLUETOOTH
    @IBOutlet weak var bluet: UISegmentedControl!
    @IBAction func Bluetooth(_ sender: UISegmentedControl) {
        defaults.set(bluet.selectedSegmentIndex, forKey: "bluet")
        if bluet.selectedSegmentIndex == 1 {bluetoooth = true} else {bluetoooth = false}
    }
    @IBOutlet weak var Textbluet: UITextField!
    @IBOutlet weak var DiasArq: UITextField!
    @IBOutlet weak var compressao: UISlider!
    @IBAction func CompFoto(_ sender: UISlider) {
        defaults.set(compressao.value, forKey: "compressao")
        textoCompressao.text = "Compressão \(compressao.value)"
        compressFotos = compressao.value
    }
    @IBAction func GoPulse(_ sender: UIButton) {
        defaults.set(true, forKey: "resetDay")
        pulse.setTitleColor(UIColor.red, for: UIControl.State())
    }
    
}
