# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
Product.create(buyer: "João Silva", description: "R$10 off R$20 of food" , unit_price: 10.0, amount: 2, address: "987 Fake St", provider: "Bob's Pizza")
Product.create(buyer: "Amy Pond", description: "R$30 of awesome for R$10" , unit_price: 10.0, amount: 5, address: "Unreal Rd", provider: "Tom's Awesome Shop")
Product.create(buyer: "Marty McFly", description: "R$20 Sneakers for R$5" , unit_price: 5.0, amount: 1, address: "123 Fake St", provider: "Sneaker Store Emporium")
Product.create(buyer: "Snake Plissken", description: "R$20 Sneakers for R$5" , unit_price: 5.0, amount: 4, address: "123 Fake St", provider: "Sneaker Store Emporium")

