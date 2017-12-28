//
//  EditTaskViewController.swift
//  ToDoScheduling
//
//  Created by Oussama Ayed on 27/12/2017.
//  Copyright © 2017 Oussama Ayed. All rights reserved.
//

import UIKit
import CoreData
import UserNotifications
class EditTaskViewController: UIViewController {
    @IBOutlet weak var txtTitle: UITextField!
    @IBOutlet weak var datePicker: UIDatePicker!
    
    var nameTask = ""
    var task = NSManagedObject()
    func fetchTaskByName(name:String) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        
        let managedContext = appDelegate.persistentContainer.viewContext
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Tasks")
        fetchRequest.predicate = NSPredicate(format: "%K == %@","title","\(name)")
        do{
            let result = try managedContext.fetch(fetchRequest)
            
            self.task = result.first! as! NSManagedObject
            
        }
        catch let error as NSError {
            print("Could not fetch \(error)")
            
            
        }
    }
    @IBAction func editTask(_ sender: UIButton) {
        guard let appDelegate =
            UIApplication.shared.delegate as? AppDelegate else {
                return
        }
        let managedContext = appDelegate.persistentContainer.viewContext
      
        task.setValue(nameTask, forKey: "title")
        
        task.setValue(datePicker.date, forKey: "taskDate")
        task.setValue(task.value(forKey: "category"), forKey: "category")
    
        do {
            try managedContext.save()
            
            
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func removeNotification(_ sender: UIButton) {
        let alertController = UIAlertController(title: "Notification", message: "Are you sure that you want remove the notifications ?", preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: "yes", style: UIAlertActionStyle.default) {
            UIAlertAction in
            let center = UNUserNotificationCenter.current()
            center.removePendingNotificationRequests(withIdentifiers: ["\(self.nameTask)"])
        }
        let cancelAction = UIAlertAction(title: "no", style: UIAlertActionStyle.cancel) {
            UIAlertAction in
            self.dismiss(animated: true, completion: nil)
        }
        
        alertController.addAction(okAction)
        alertController.addAction(cancelAction)
        
        self.present(alertController, animated: true, completion: nil)
       
    }
    override func viewDidAppear(_ animated: Bool) {
        
        fetchTaskByName(name: nameTask)
        txtTitle.isEnabled = false
        txtTitle.text = task.value(forKey: "title") as? String
        datePicker.date = task.value(forKey: "taskDate") as! Date
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

}
