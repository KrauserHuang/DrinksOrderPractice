//
//  MenuTableViewController.swift
//  DrinksOrderPractice
//
//  Created by Tai Chin Huang on 2021/5/3.
//

import UIKit

class MenuTableViewController: UITableViewController {
    
    var menus = [DrinkData]()
    var selectedDrink: DrinkData?
    var allDrinkImages: [String : UIImage] = [:]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchItem()
    }
    // fetch google sheet all datas and store in menus
    func fetchItem() {
        let urlStr = "https://spreadsheets.google.com/feeds/list/1g9Q8-OFQGaVkVb1ON_zbtoeSbCoNjoJM_sGnd4V_rOw/od6/public/values?alt=json"
        if let url = URL(string: urlStr) {
            URLSession.shared.dataTask(with: url) { (data, response, error) in
                if let data = data {
                    let decoder = JSONDecoder()
                    do {
                        let searchResponse = try decoder.decode(Menu.self, from: data)
                        DispatchQueue.main.async {
                            self.menus = searchResponse.feed.entry
                            self.tableView.reloadData()
                        }
                    } catch {
                        print(error)
                    }
                }
            }.resume()
        }
    }
    // 用IBSegueAction傳送資料到DetailTableViewController
    @IBSegueAction func goToDetail(_ coder: NSCoder) -> DetailTableViewController? {
        guard let row = tableView.indexPathForSelectedRow?.row else { return nil }
        let menu = menus[row]
//        controller?.selectedDrink = selectedDrink!
        let controller = DetailTableViewController(coder: coder, selectedDrink: menu)
        controller?.drinkName = menu.drink.value
        return controller
    }
    
    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return menus.count
    }
    // cell顯示，包括name/description/price/image
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MenuCell", for: indexPath) as! MenuTableViewCell
        let menu = menus[indexPath.row]
        cell.nameLabel.text = menu.drink.value
        cell.descriptionLabel.text = menu.description.value
        cell.priceLabel.text = menu.priceM.value
        let url = URL(string: menu.imageUrl.value)!
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let data = data {
                DispatchQueue.main.async {
                    cell.drinkImageView.image = UIImage(data: data)
                    cell.indicatorView.isHidden = true
                }
            }
        }.resume()
        return cell
    }
    //MARK: - Table view delegate
    // cell點選灰階背景取消
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
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

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        // Get the new view controller using segue.destination.
//        // Pass the selected object to the new view controller.
//        let destination = segue.destination as! DetailTableViewController
//    }

}
