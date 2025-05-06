//
//  MealTableViewController.swift
//  FoodManagement2024
//
//  Created by  User on 06.05.2024.
//

import UIKit

class MealTableViewController: UITableViewController {
    // MARK: Properties
    private var meals = [Meal]()
    @IBOutlet weak var navigation: UINavigationItem!
    private let mealDetailID = "MealDetailController"
    
    // Tao doi tuong truy van CSDL
    private let dao = Database()
    
    // Dinh nghia kieu du lieu enum dung danh dau duong di
    enum NavigationType {
        case newMeal
        case editMeal
    }
    
    // Dinh nghia bien danh dau duong di
    var navigationType:NavigationType = .newMeal
    
    // Bien luu gia tri Indexpath
    private var selectedIndexpath:IndexPath?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Them Edit Button cho Navigation Bar
        navigation.leftBarButtonItem = editButtonItem
        
        // Doc toan bo du lieu meals tu CSDL neu co
        dao.readMeals(meals: &meals)
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    
    // MARK: - Table view data source
    // So luong layouts (cell) trong tableView
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    // So luong phan tu trong Array
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return meals.count
    }
    
    // indexPath = vi tri phan tu trong Array
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let reuseCell = "MealCell"
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: reuseCell, for: indexPath) as? MealCell {
            
            // Lay du lieu tu DataSource
            let meal = meals[indexPath.row]
            
            // Do du lieu tu meal vao cell
            cell.mealName.text = meal.name
            cell.mealImage.image = meal.image
            cell.rating.rating = meal.ratingValue
            
            /*
             // Bo sung them cho bat su kien theo cach 1
             if cell.onTap == nil {
             // Khoi tao cho doi tuong onTap
             cell.onTap = UITapGestureRecognizer()
             // Bat su kien cho doi tuong onTap
             cell.onTap!.addTarget(self, action: #selector(editMeal))
             
             // Ket noi doi tuong onTap voi cell
             cell.addGestureRecognizer(cell.onTap!)
             }
             */
            
            return cell
        }
        
        // Khong tao duoc cell
        fatalError("Khong the tao cell!")
        
    }
    
    // Dinh nghia ham xu ly su kien cho cell
    @objc private func editMeal(_ sender: UITapGestureRecognizer) {
        //print("Cell tapped")
        // Tao doi tuong man hinh MealDetailController
        if let mealDetail = self.storyboard!.instantiateViewController(withIdentifier: mealDetailID) as? MealDetailController {
            // Lay doi tuong cell duoc tap
            if let cell = sender.view as? MealCell {
                // Xac dinh vi tri cua cell trong table view
                if let indexPath = tableView.indexPath(for: cell) {
                    // Truyen meal sang mealDetailController
                    mealDetail.meal = meals[indexPath.row]
                    
                    // Danh dau duong di
                    navigationType = .editMeal
                    
                    // Luu vi tri cell duoc chon
                    selectedIndexpath = indexPath
                    
                    // Chuyen sang man hinh khac
                    present(mealDetail, animated: true)
                }
            }
        }
    }
    
    /*
     // Override to support conditional editing of the table view.
     override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the specified item to be editable.
     return true
     }
     */
    
    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Xoa phan tu tu datasource
            meals.remove(at: indexPath.row)
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }
    }
    
    
    /*
     // Override to support rearranging the table view.
     override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {
     
     }
     */
    
    /*
     // Override to support conditional rearranging of the table view.
     override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the item to be re-orderable.
     return true
     }
     */
    
    
    // MARK: - Navigation
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //print("Cell tapped")
        // Tao doi tuong man hinh MealDetailController
        if let mealDetail = self.storyboard!.instantiateViewController(withIdentifier: mealDetailID) as? MealDetailController {
            // Lay doi tuong cell duoc tap
            // Truyen meal sang mealDetailController
            mealDetail.meal = meals[indexPath.row]
            
            // Danh dau duong di
            navigationType = .editMeal
            
            // Luu vi tri cell duoc chon
            selectedIndexpath = indexPath
            
            // Chuyen sang man hinh khac
            present(mealDetail, animated: true)
        }
    }
    
    @IBAction func newMeal(_ sender: UIBarButtonItem) {
        // Tao doi tuong man hinh MealDetailController
        if let mealDetail = self.storyboard!.instantiateViewController(withIdentifier: mealDetailID) as? MealDetailController {
            // Danh dau duong di
            navigationType = .newMeal
            
            // Chuyen sang man hinh khac
            present(mealDetail, animated: true)
        }
    }
    
    // Dinh nghia ham unwind quay ve tu mealDetailController
    @IBAction func unwindFromMealDetailController(_ segue: UIStoryboardSegue) {
        //print("unwind from meal detail")
        // Lay doi tuong man hinh MealDetailController
        if let mealDetail = segue.source as? MealDetailController {
            if let meal = mealDetail.meal {
                switch navigationType {
                case .newMeal:
                    // Them meal moi vao datasource
                    meals.append(meal)
                    // Tao mot dong (cell) moi cho tableView
                    let newIndexPath = IndexPath(row: meals.count - 1, section: 0)
                    tableView.insertRows(at: [newIndexPath], with: .left)
                    // Them meal moi vao CSDL
                    let _ = dao.insertMeal(meal: meal)
                case .editMeal :
                    
                    if let indexPath = selectedIndexpath {
                        // Update datasource
                        meals[indexPath.row] = meal
                        
                        // Update tableView cell
                        tableView.reloadRows(at: [indexPath], with: .left)
                    }
                }
            }
        }
    }
    
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Lay doi tuong man hinh MealDetailController
        if let mealDetail = segue.destination as? MealDetailController {
            // Lay doi tuong cell duoc tap
            if let cell = sender as? MealCell {
                // Xac dinh vi tri cua cell trong table view
                if let indexPath = tableView.indexPath(for: cell) {
                    // Truyen meal sang mealDetailController
                    mealDetail.meal = meals[indexPath.row]
                    
                    // Danh dau duong di
                    navigationType = .editMeal
                    
                    // Luu vi tri cell duoc chon
                    selectedIndexpath = indexPath
                    
                    // Chuyen sang man hinh khac
                    //present(mealDetail, animated: true)
                }
            }
        }
    }
    
    
}
