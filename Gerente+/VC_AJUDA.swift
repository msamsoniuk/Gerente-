//
//  VC_AJUDA.swift
//  Gerente+
//
//  Created by Marcos Samsoniuk on 23/11/18.
//  Copyright © 2018 Marcos Samsoniuk. All rights reserved.
//

import UIKit
import MessageUI // email


class VC_AJUDA: UIViewController, MFMailComposeViewControllerDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    var documentInteractionController: UIDocumentInteractionController = UIDocumentInteractionController()
    
    @IBAction func whatsapp(_ sender: UIButton) {
        
        let msg = "Gerente+ APP:\nDescreva sua dúvida ->\n"
        let urlWhats = "whatsapp://send?phone=+55419999999&abid=12354&text=\(msg)"
         //"whatsapp://send?text=\(msg)"
        
        if let urlString = urlWhats.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlQueryAllowed) {
            if let whatsappURL = NSURL(string: urlString) {
                if UIApplication.shared.canOpenURL(whatsappURL as URL) {
                    UIApplication.shared.openURL(whatsappURL as URL)
                } else {
                    print("favor instalar o Whasapp no telefone")
                }
            }
        }

    }
    
    @IBAction func website(_ sender: UIButton) {
        if let url = URL(string: "http://www.google.com/"){
            UIApplication.shared.openURL(url)
        }
    }
    
    @IBAction func sendEmail(_ sender: UIButton) {
        self.sendMail()
    }
    @IBAction func youtube(_ sender: UIButton) {
        if let url = URL(string: "https://www.youtube.com/channel/"){
            UIApplication.shared.openURL(url)
        }
        
    }
    
    @IBAction func facebook(_ sender: UIButton) {
       // if let url = URL(string: "https://www.facebook.com/google/"){
       //     UIApplication.shared.openURL(url)
       // }
        
        
        UIApplication.tryURL(urls: [
            "fb://profile/1234567890", // App
            "http://www.facebook.com/1234567890" // Website if app fails
            ])
        
    }
    
    func sendMail() {
        
        let picker = MFMailComposeViewController()
        picker.mailComposeDelegate = self
        picker.setSubject("GERENTE+ : Usuário quer ajuda!")
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MM-yy"
        let dateInFormat = dateFormatter.string(from: Date())
        
        var Text = "Ola Google, gostaria de suporte para o APP GERENTE+ \n"
        Text = Text + "------------------------------------- \n"
        Text = Text + "Nome: \n"
        Text = Text + "Telefone: \n"
        Text = Text + "Email \n"
        Text = Text + "Dúvida: \n \n"
        Text = Text + "------------------------------------- \n"
        Text = Text + "Eu peço que minhas informações sejam preservadas em segurança, e sejam utilizadas apenas para as finalidades profissionais desse aplicativo: \(dateInFormat). \n"
        Text = Text + "------------------------------------- \n"

        picker.setToRecipients(["info@google.com"])
        picker.setMessageBody(Text, isHTML: false)

        if !MFMailComposeViewController.canSendMail() {
            print("Mail services are not available")
            return
        }
        present(picker, animated: true, completion: nil)
    }
    
    public func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true)
    }
    
    func sendMail9999() -> MFMailComposeViewController {
        let mailComposerVC = MFMailComposeViewController()
        mailComposerVC.mailComposeDelegate = self
        
        var Text = "Ola Google, gostaria de informações sobre o APP GERENTE+\n"
        Text = Text + "-----------------------------------\n"
        Text = Text + "Nome: \nTelefone: \nEmail para Contato:\n"
        Text = Text + "-----------------------------------\n"
        Text = Text + "Eu peço que minhas informações seja preservadas em segurança e sejam utilizadas apenas para as finalidades profissionais desse aplicativo.\n"
        Text = Text + "-----------------------------------\n"
        
        //Text = Text + (UIDevice.current.identifierForVendor?.uuidString)!
        
        // Text = "\n" + Text + UIDevice.current.
        
        mailComposerVC.setToRecipients(["info@google.com"])
        
        
        mailComposerVC.setSubject("Usuário quer ajuda")
        mailComposerVC.setMessageBody(Text, isHTML: false)
        
        return mailComposerVC
    }

    
    
    @IBAction func about(_ sender: UIButton) {
        aboutView.isHidden = false
        
    }
    
    @IBOutlet weak var aboutView: UIView!
    @IBAction func fechar(_ sender: UIButton) {
        aboutView.isHidden = true
        
    }
    
    
}
// https://www.facebook.com/agro4u/

extension UIApplication {
    class func tryURL(urls: [String]) {
        let application = UIApplication.shared
        for url in urls {
            if application.canOpenURL(URL(string: url)!) {
                application.openURL(URL(string: url)!)
                return
            }
            //else { UIApplication.shared.openURL(NSURL(string: "https://www.facebook.com/google")! as URL) }
        }
    }
}
