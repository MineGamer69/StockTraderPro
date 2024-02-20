//
//  Finnhub.swift
//  StockTraderPro
//
//  Created by Aaryan Kapoor on 2/14/24.
//

import Foundation

class APIRequest{
    static let instance = APIRequest()
    
    //api variable
    private var url = "https://finnhub.io/api/v1/"
    private var key = "&token=ADDTOKENHERE"
    
    public func getTicker(symbol: String){
        let query: String = "quote?symbol=\(symbol)"
        let url = URL(string: url + query + key)
        
        if let url = url{
            let task = URLSession.shared.dataTask(with: url) { data, response, error in
                if let error = error{
                    print("Error while getting quote from API: \(error)")
                    return
                }
                guard let quoteData = data else{
                    print("Ticker Search not found!")
                    return
                }
                let returnedTicker = try? JSONDecoder().decode(Ticker.self, from: quoteData)
                
                print(returnedTicker)
            }
            task.resume()
        }
    }
    
    public func getTickerLookup(searchQuery: String){
        let query: String = "search?q=\(searchQuery)"
        
        let url = URL(string: url + query + key)
        
        if let url = url {
            let task = URLSession.shared.dataTask(with: url) { data, response, error in
                if let error = error{
                    print("Error while searching for symbol: \(error)")
                    return
                }else{
                    guard let searchData = data else{
                        print("Symbol search NOT VALID!")
                        return
                    }
                    let returnedTickers = try? JSONDecoder().decode(StockSymbolSearch.self, from: searchData)
                    print(returnedTickers)
                }
            }
            task.resume()
        }
    }
    
    public func getCandles(symbol:String, hourLength: Int){
        let endDate = Int(Date().timeIntervalSince1970)
        let startDate = Int((Calendar.current.date(byAdding: .day, value: -(hourLength), to: Date())?.timeIntervalSince1970 ?? Date().timeIntervalSince1970))
        let query = "stock/candle?symbol=\(symbol)&resolution=5&from=\(startDate)"
    }
}
