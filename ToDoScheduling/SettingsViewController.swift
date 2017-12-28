//
//  SettingsViewController.swift
//  ToDoScheduling
//
//  Created by Oussama Ayed on 28/12/2017.
//  Copyright © 2017 Oussama Ayed. All rights reserved.
//

import UIKit
import UserNotifications
class SettingsViewController: UIViewController {

    @IBOutlet weak var sortSwitch: UISwitch!
    override func viewDidLoad() {
        super.viewDidLoad()
        let defaults = UserDefaults.standard
        let sort = defaults.bool(forKey: "sort")
        if (sort == false)
        {
            sortSwitch.isOn = false
        }else{
            sortSwitch.isOn = true
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func sortBy(_ sender: UISwitch) {
    let defaults = UserDefaults.standard
        if (sortSwitch.isOn == true){
            
            defaults.set(true, forKey: "sort")
        }else{
            defaults.set(false, forKey: "sort")

        }
        
    }
    @IBAction func removeAllNotification(_ sender: UIButton) {
        let alertController = UIAlertController(title: "Notifications", message: "Are you sure that you want remove all the notifications ?", preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: "yes", style: UIAlertActionStyle.default) {
            UIAlertAction in
            let center = UNUserNotificationCenter.current()
            center.removeAllPendingNotificationRequests()
        }
        let cancelAction = UIAlertAction(title: "no", style: UIAlertActionStyle.cancel) {
            UIAlertAction in
           self.dismiss(animated: true, completion: nil)
        }
        
        alertController.addAction(okAction)
        alertController.addAction(cancelAction)
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
