
//
//  ViewController.swift
//  ToDoScheduling
//
//  Created by Oussama Ayed on 27/12/2017.
//  Copyright © 2017 Oussama Ayed. All rights reserved.
//

import UIKit
import CoreData
class ViewController: UIViewController ,UITableViewDataSource{

    @IBOutlet weak var tableView: UITableView!
    var tasks = [NSManagedObject]()
    var categoryData = NSManagedObject()
    var sortedTasks = [NSManagedObject]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view, typically from a nib.
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func viewWillAppear(_ animated: Bool) {
        
        let defaults = UserDefaults.standard

        if !UserDefaults.standard.bool(forKey: "HasLaunchedOnce") {
            UserDefaults.standard.set(true, forKey: "HasLaunchedOnce")
            UserDefaults.standard.synchronize()
            
            getCategories()
            // false for sort by ABC
            defaults.set(false, forKey: "sort")
            
        }
        
        fetchTasks()
        if(tasks.isEmpty == false){
            let sort = defaults.bool(forKey: "sort")
            if(sort == false){
                sortedTasks = tasks.sorted(by: { ($0.value(forKey: "title") as? String)!.compare($1.value(forKey: "title") as! String ) == .orderedAscending  })
            }else{
                sortedTasks = tasks.sorted(by: { ($0.value(forKey: "taskDate") as? Date)!.compare($1.value(forKey: "taskDate") as! Date) == .orderedDescending  })
            }
        }
        
        
        tableView.dataSource = self
        self.tableView.reloadData()
    }
    func getCategories()  {
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        
        let managedContext = appDelegate.persistentContainer.viewContext
        let dataHelp = DataHelperCategories(context: managedContext)
        dataHelp.seedCategories()
        
        
    }
    func getCategoryColor(category : String) -> String{
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        
        let managedContext = appDelegate.persistentContainer.viewContext
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Categories")
        fetchRequest.predicate = NSPredicate(format: "%K == %@","name","\(category)")
        do{
            let result = try managedContext.fetch(fetchRequest)
            
            self.categoryData = result.first as! NSManagedObject
            
        }
        catch let error as NSError {
            print("Could not fetch \(error)")
            
            
        }
        let color = categoryData.value(forKey: "categoryColor")! as! String
        return color
    }
    func fetchTasks()  {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        
        let managedContext = appDelegate.persistentContainer.viewContext
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Tasks")
        do{
            let result = try managedContext.fetch(fetchRequest)
            
            self.tasks = result as! [NSManagedObject]
            
        }
        catch let error as NSError {
            print("Could not fetch \(error)")
            
            
        }
        
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sortedTasks.count
    }
    func isOverdue(date:NSDate) -> Bool {
        return (Date().compare(date as Date) == ComparisonResult.orderedDescending)
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let todoItem = sortedTasks[(indexPath as NSIndexPath).row] as! Tasks
        let lblTask:UILabel = cell.viewWithTag(1) as! UILabel
        let lblDate:UILabel = cell.viewWithTag(2) as! UILabel

        lblTask.text = todoItem.title as String!
        if (isOverdue(date: todoItem.taskDate!)) {
            lblDate.textColor = UIColor.red
        } else {
            lblDate.textColor = UIColor.black
        }
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = " MMM dd yyyy 'at' h:mm a"
        lblDate.text = dateFormatter.string(from: todoItem.taskDate! as Date)
        let c = todoItem.value(forKey: "category") as! String
        let categoryColor = getCategoryColor(category: c )
        cell.backgroundColor = hexStringToUIColor(hex: categoryColor)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true // all cells are editable
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            
            let managedContext = appDelegate.persistentContainer.viewContext
            
            managedContext.delete(tasks[indexPath.row])
            self.sortedTasks.remove(at: (indexPath as NSIndexPath).row)
            self.tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
    func hexStringToUIColor (hex:String) -> UIColor {
        var cString:String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        
        if (cString.hasPrefix("#")) {
            cString.remove(at: cString.startIndex)
        }
        
        if ((cString.count) != 6) {
            return UIColor.gray
        }
        
        var rgbValue:UInt32 = 0
        Scanner(string: cString).scanHexInt32(&rgbValue)
        
        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if let destination = segue.destination as? EditTaskViewController {
            let path = self.tableView.indexPathForSelectedRow!
            let selectedRow:NSManagedObject = sortedTasks[path.row]
            destination.nameTask = selectedRow.value(forKey: "title") as! String
            
        }
    }
}





