//
//  FoodItems.swift
//  Foods
//
//  Created by bennoui ihab on 5/19/20.
//  Copyright © 2020 bennoui ihab. All rights reserved.
//

import UIKit
let defaultPrice = 9.99
let salmon = Item(image: UIImage(named: "food1")!, name: "Salmon", price: defaultPrice)
let cheeseBurger = Item(image: UIImage(named: "food2")!, name: "cheeseBurger", price: defaultPrice)
let burrito = Item(image: UIImage(named: "food3")!, name: "burrito", price: defaultPrice)
let spagheti = Item(image: UIImage(named: "food4")!, name: "spagheti", price: defaultPrice)
let pizza = Item(image: UIImage(named: "food5")!, name: "pizza", price: defaultPrice)
let salad = Item(image: UIImage(named: "food6")!, name: "salad", price: defaultPrice)

let FoodItems : [Item] = [salmon , cheeseBurger , burrito, spagheti , pizza , salad]

