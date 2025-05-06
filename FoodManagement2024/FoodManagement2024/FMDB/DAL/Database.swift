//
//  Database.swift
//  FoodManagement2024
//
//  Created by  User on 20.05.2024.
//

import Foundation
import UIKit
import os.log

class Database{
    // MARK: Dinh ngia cac thuoc tinh chung cua CSDL
    private let DB_NAME = "meals.sqlite"
    private let DB_PATH:String?
    private let database:FMDatabase?
    // MARK: Dinh nghia thuoc tinh cua cac bang du lieu
    // 1. Bang meals
    private let MEAL_TABLE_NAME = "meals"
    private let MEAL_ID = "_id"
    private let MEAL_NAME = "name"
    private let MEAL_IMAGE = "image"
    private let MEAL_RATING = "rating"
    
    // MARK: Constructors
    init() {
        // Lay cac thu muc co san trong ung dung ios
        let directories = NSSearchPathForDirectoriesInDomains(.documentDirectory, .allDomainsMask, true)
        // Khoi tao DB_PATH
        DB_PATH=directories[0] + "/" + DB_NAME
        // Khoi tao CSDL
        database = FMDatabase(path: DB_PATH)
        // Thong bao su thanh cong cua CSDL
        if database != nil {
            os_log("Khoi tao CSDL thanh cong")
            // Tao cac bang du lieu o day
            // 1 Tao bang meals
            let sql = "CREATE TABLE \(MEAL_TABLE_NAME)("
            + "\(MEAL_ID) INTEGER PRIMARY KEY AUTOINCREMENT, "
            + "\(MEAL_NAME) TEXT, "
            + "\(MEAL_IMAGE) TEXT, "
            + "\(MEAL_RATING) INTEGER)"
            let _ = tableCreate(sql: sql, tableName: MEAL_TABLE_NAME)
        }
        else{
            os_log("Khoi tao CSDL khong thanh cong")
        }
    }
    ////////////////////////////////////////////////////////////////////////////////////
    // MARK: Dinh nghia cac ham primitives cua CSDL
    ////////////////////////////////////////////////////////////////////////////////////
    // 1 Mo CSDL
    private func open()->Bool{
        var OK = false
        if database != nil {
            if database!.open() {
                os_log("Mo CSDL thanh cong")
                OK = true
            }
            else{
                os_log("Mo CSDL khong thanh cong")
            }
        }
        return OK
    }
    // 2 Dong CSDL
    private func close(){
        if database != nil {
            database!.close()
        }
    }
    // 3 Ham tao bang du lieu
    private func tableCreate(sql:String, tableName:String)->Bool {
        var OK = false
        if open(){
            // Kiem tra xem bang du lieu ton tai hay chua
            if !database!.tableExists(tableName) {
                // Goi ham tao bang trong FMDB
                if database!.executeStatements(sql) {
                    os_log("Tao bang du lieu \(tableName) thanh cong")
                    OK = true
                }
                else{
                    os_log("Tao bang du lieu \(tableName) khong thanh cong")
                }
            }
        }
        return OK
    }
    ////////////////////////////////////////////////////////////////////////////////////
    // MARK: Dinh nghia cac ham APIS cua CSDL
    ////////////////////////////////////////////////////////////////////////////////////
    // 1 Them meal vao CSDL
    func insertMeal(meal:Meal)->Bool {
        var OK = false
        if open() {
            if database!.tableExists(MEAL_TABLE_NAME){
                // Cau lenh SQL
                let sql = "INSERT INTO \(MEAL_TABLE_NAME)(\(MEAL_NAME), \(MEAL_IMAGE), \(MEAL_RATING)) VALUES (?, ?, ?)"
                // Chuyen anh thanh chuoi
                var strImage = ""
                if let image = meal.image {
                    // B1 Chuyen anh thanh ns data
                    let nsdataImage = image.pngData()! as NSData
                    // B2 Chuyen nsdataImage thanh chuoi
                    strImage = nsdataImage.base64EncodedString(options: .lineLength64Characters)
                }
                // Ghi du lieu vao bang meals cua CSDL
                if database!.executeUpdate(sql, withArgumentsIn: [meal.name, strImage, meal.ratingValue]){
                    os_log("Them du lieu thanh cong")
                    OK = true
                }
                else{
                    os_log("Them du lieu khong thanh cong")
                }
                // Dong CSDL
                close()
            }
            else{
                os_log("Bang du lieu chua ton tai ")
            }
        }
        return OK
    }
    // 2 Doc toan bo meals tu CSDL
    func readMeals(meals: inout [Meal]) {
        if open(){
            if database!.tableExists(MEAL_TABLE_NAME){
                // Cau lenh SQL
                let sql = "SELECT * FROM \(MEAL_TABLE_NAME) ORDER BY \(MEAL_RATING) DESC"
                // Khai bao bien chua du lieu doc ve tu CSDL
                var result:FMResultSet?
                do{
                    result = try database!.executeQuery(sql, values: nil)
                }
                catch{
                    os_log("Khong the truy van CSDL")
                }
                // Doc du lieu tu bien result
                if let result = result {
                    while result.next(){
                        let name = result.string(forColumn: MEAL_NAME) ?? ""
                        let rating = result.int(forColumn: MEAL_RATING)
                        var image:UIImage? = nil
                        if let strImage = result.string(forColumn: MEAL_IMAGE){
                            if !strImage.isEmpty{
                                // Chuyen chuoi thanh anh image
                                // B1 Chuyen chuoi thanh Data
                                let dataImage = Data(base64Encoded: strImage, options: .ignoreUnknownCharacters)
                                // B2 Chuyen dataImage thanh UIImage
                                image = UIImage(data: dataImage!)
                            }
                        }
                        // Tao doi tuong meal tu CSDL
                        if let meal = Meal(name: name, image: image, ratingValue: Int(rating)){
                            // Dua vao datasource cua TableView
                            meals.append(meal)
                        }
                    }
                }
            }
        }
    }
}
