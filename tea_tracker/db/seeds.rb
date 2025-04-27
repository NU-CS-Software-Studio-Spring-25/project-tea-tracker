# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end

user = User.first || User.create!(username: "tealover02")

Tea.create!([
    { name: "Gyokuro",           rank: 9, price: 42.00, category: "Green",  user: user },
    { name: "Sencha",            rank: 8, price: 22.50, category: "Green",  user: user },
    { name: "Matcha Uji",        rank: 10, price: 55.00, category: "Green", user: user },
    { name: "Hōjicha",           rank: 7, price: 18.00, category: "Roasted Green", user: user },

    { name: "Ostfriesen Mischung", rank: 8, price: 20.00, category: "Black", user: user },
    { name: "Ronnefeldt Darjeeling", rank: 9, price: 28.00, category: "Black", user: user },
    { name: "Schwarztee Assam", rank: 7, price: 25.00, category: "Black", user: user },

    { name: "Mariage Frères Marco Polo", rank: 10, price: 45.00, category: "Flavored Black", user: user },
    { name: "Kusmi Tea Anastasia", rank: 8, price: 30.00, category: "Earl Grey", user: user },
    { name: "Palais des Thés Thé du Hammam", rank: 9, price: 35.00, category: "Green", user: user }
])