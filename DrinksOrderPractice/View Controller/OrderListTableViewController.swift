//
//  OrderListTableViewController.swift
//  DrinksOrderPractice
//
//  Created by Tai Chin Huang on 2021/5/3.
//

import UIKit

class OrderListTableViewController: UITableViewController {
    
    var targetList: [[String:String]] = []
    @IBOutlet weak var totalCountLabel: UILabel!
    @IBOutlet weak var totalPriceLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchData()
//        tableView.isUserInteractionEnabled = false
    }
    // 抓取訂單資料
    func fetchData() {
        let urlStr = "https://sheetdb.io/api/v1/ocn6qrzzdg1mn"
        let url = URL(string: urlStr)
        var request = URLRequest(url: url!)
        request.httpMethod = "GET"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let data = data {
                let decoder = JSONDecoder()
                do {
                    let targetResponse = try decoder.decode([[String:String]].self, from: data)
                    self.targetList = targetResponse
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                        self.totalCountLabel.text = "共計\(self.targetList.count)杯"
                        self.totalPriceLabel.text = "$\(self.computeTotal())"
                    }
                } catch {
                    print(error)
                }
            }
        }.resume()
    }
    
    func computeTotal() -> Int {
        var result = 0
        targetList.forEach({
            result += Int($0["totalPrice"]!) ?? 0
        })
        return result
    }

    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return targetList.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "OrderListCell", for: indexPath) as! OrderListTableViewCell
        let drinkInfo = targetList[indexPath.row]
        cell.drinkNameLabel.text = drinkInfo["drinkName"]
        cell.orderInfoLabel.text = "\(drinkInfo["sizeLevel"]!)、\(drinkInfo["iceLevel"]!)、\(drinkInfo["sugarLevel"]!)、\(drinkInfo["extraToppings"]!)"
        cell.ordererLabel.text = drinkInfo["orderer"]
        cell.priceLabel.text = "$\(drinkInfo["totalPrice"]!)"
        print(cell.drinkNameLabel.text!)
        return cell
    }
    //MARK: - Table view delegate
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        tableView.deselectRow(at: indexPath, animated: true)

    }
    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
