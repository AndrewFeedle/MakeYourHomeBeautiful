//
//  File.swift
//  Make home beautiful
//
//  Created by Feedle on 26.07.2022.
//

import Foundation

struct Filter{
    let text:String
    let image:String
    var isSelected = false
}

let filterMasive = [Filter(text: "Все", image: "furniture", isSelected: true),
                    Filter(text: "Шкафы", image: "wardrobe"),
                    Filter(text: "Тумбы", image: "side-table"),
                    Filter(text: "Кровати", image: "bed"),
                    Filter(text: "Диваны", image: "sofa"),
                    Filter(text: "Столы", image: "table"),
                    Filter(text: "Стулья", image: "chair"),
                    Filter(text: "Свет", image: "lamp")]
