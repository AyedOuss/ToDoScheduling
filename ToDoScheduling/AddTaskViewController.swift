//
//  AddTaskViewController.swift
//  ToDoScheduling
//
//  Created by Oussama Ayed on 27/12/2017.
//  Copyright © 2017 Oussama Ayed. All rights reserved.
//

import UIKit
import CoreData
import UserNotifications
class AddTaskViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource, UNUserNotificationCenterDelegate {

    @IBOutlet weak var txtTitle: UITextField!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var categoryPicker: UIPickerView!
    var name = ""
    var deadline = NSDate()
    var category = ""
    var categories = [NSManagedObject]()
    var pickerData: [String] = [String]()
    func fetchCategories()  {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        
        let managedContext = appDelegate.persistentContainer.viewContext
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Categories")
        do{
            let result = try managedContext.fetch(fetchRequest)
            
            self.categories = result as! [NSManagedObject]
            
        }
        catch let error as NSError {
            print("Could not fetch \(error)")
            
            
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        UNUserNotificationCenter.current().requestAuthorization(options: [[.alert, .sound, .badge]], completionHandler: { (granted, error) in
        })
        UNUserNotificationCenter.current().delegate = self
        fetchCategories()
        self.categoryPicker.dataSource = self
        self.categoryPicker.delegate = self
        datePicker.minimumDate = NSDate().addingTimeInterval(60) as Date
        category = categories[0].value(forKey: "name") as! String
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        category = categories[row].value(forKey: "name") as! String
    }
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    // The number of rows of data
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return categories.count
    }
    
    // The data to return for the row and component (column) that's being passed in
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return categories[row].value(forKey: "name")! as? String
    }
    @IBAction func addTask(_ sender: UIButton) {
        name = txtTitle.text!
        if (name == "")
        {
            let alert = UIAlertController(title: "Missing title", message: "enter your title", preferredStyle: .alert)
            let ok = UIAlertAction(title: "OK", style:.default, handler: nil)
            alert.addAction(ok)
            present(alert, animated: true, completion: nil)
        }
        deadline = datePicker.date as NSDate
        // local notification begin
        let content = UNMutableNotificationContent()
        content.title = "To do scheduling"
        content.subtitle = "\(name) is done"
        content.body = "time out !!"
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval:deadline.timeIntervalSinceNow.rounded(),
                                                        repeats: false)
        
        let requestIdentifier = name
        let request = UNNotificationRequest(identifier: requestIdentifier,
                                            content: content, trigger: trigger)
        
        UNUserNotificationCenter.current().add(request,
                                               withCompletionHandler: { (error) in
        })
        // local notification End
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
                return
        }
        let managedContext = appDelegate.persistentContainer.viewContext
        let entity = NSEntityDescription.entity(forEntityName: "Tasks", in: managedContext)!
        let task = NSManagedObject(entity: entity, insertInto: managedContext)
        task.setValue(name, forKey: "title")
        task.setValue(deadline, forKey: "taskDate")
        task.setValue(category, forKey: "category")
        do {
            try managedContext.save()
            
            
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
        
        self.navigationController?.popViewController(animated: true)
    }
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        
        completionHandler([.alert, .sound])
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
