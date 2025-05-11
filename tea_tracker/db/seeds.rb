require 'faker'

# Clear existing records
User.destroy_all
Tea.destroy_all
Entry.destroy_all

# Create fake users
10.times do
  User.create!(
    username: Faker::Internet.unique.username,
    password: "password123",
    bio: Faker::Lorem.sentence,
    avatar_url: Faker::Avatar.image
  )
end

# Assign teas to random users
users = User.all

200.times do
  Tea.create!(
    name: Faker::Tea.variety,
    category: Faker::Tea.type,
    price: Faker::Commerce.price(range: 2.0..10.0),
    grams: rand(20..100),
    vendor: Faker::Company.name,
    known_for: Faker::Marketing.buzzwords,
    ship_from: Faker::Address.city,
    popularity: rand(1..10),
    shopping_platform: Faker::Company.name,
    product_url: Faker::Internet.url
  )
end

teas = Tea.all
200.times do
  Entry.create!(
    rank: rand(1..10),
    user_id: users.sample.id,
    tea_id: teas.sample.id
  )
end

# === Specific users for testing ===
user1 = User.create!(
  username: "testuser",
  password: "SecurePass1!",
  bio: "I love exploring oolongs and pu’er teas.",
  avatar_url: "https://example.com/avatar.jpg"
)

user2 = User.create!(
  username: "oolongfan",
  password: "AnotherSecure1!",
  bio: "Big fan of Taiwanese oolongs.",
  avatar_url: "https://example.com/avatar2.jpg"
)

# === Teas for user1 ===
sample_teas_user1 = [
  {
    name: "Da Hong Pao",
    category: "Oolong",
    price: 38.00,
    grams: 50,
    vendor: "Fang Shun",
    known_for: "roasted oolong",
    ship_from: "China",
    popularity: 5,
    shopping_platform: "Taobao",
    product_url: "https://shop71393784.taobao.com/"
  },
  {
    name: "Liu Bao",
    category: "Heicha",
    price: 24.00,
    grams: 40,
    vendor: "Geow Yong",
    known_for: "heicha",
    ship_from: "China",
    popularity: 4,
    shopping_platform: "Taobao",
    product_url: "https://shop352670532.taobao.com/"
  },
  {
    name: "Ali Shan",
    category: "Oolong",
    price: 40.00,
    grams: 25,
    vendor: "Taiwan Tea Crafts",
    known_for: "high-mountain oolong",
    ship_from: "Taiwan",
    popularity: 5,
    shopping_platform: "TaiwanTeaCrafts",
    product_url: "https://www.taiwanteacrafts.com"
  },
  {
    name: "Dong Ding",
    category: "Oolong",
    price: 32.00,
    grams: 30,
    vendor: "Eco-Cha",
    known_for: "traditional roasted oolong",
    ship_from: "Taiwan",
    popularity: 4,
    shopping_platform: "EcoCha",
    product_url: "https://eco-cha.com"
  }
]

sample_teas_user1.each_with_index do |tea_data, index|
  tea = Tea.create!(tea_data)
  Entry.create!(user: user1, tea: tea, rank: 9 - index)
end

# === More diverse teas for user2 ===
sample_teas_user2 = [
  {
    name: "Shan Lin Xi",
    category: "Oolong",
    price: 28.00,
    grams: 28,
    vendor: "Taiwan Sourcing",
    known_for: "floral and buttery flavor",
    ship_from: "Taiwan",
    popularity: 6,
    shopping_platform: "Taiwan Sourcing",
    product_url: "https://taiwansourcing.com"
  },
  {
    name: "Mei Zhan",
    category: "Oolong",
    price: 28.00, # same price as above
    grams: 25,
    vendor: "Essence of Tea",
    known_for: "rare varietal",
    ship_from: "Fujian",
    popularity: 5,
    shopping_platform: "Essence of Tea",
    product_url: "https://essenceoftea.com"
  },
  {
    name: "Oriental Beauty",
    category: "Oolong",
    price: 35.00,
    grams: 20,
    vendor: "Floating Leaves",
    known_for: "bug-bitten style",
    ship_from: "Taiwan",
    popularity: 7,
    shopping_platform: "Floating Leaves",
    product_url: "https://floatingleavestea.com"
  },
  {
    name: "Baozhong",
    category: "Oolong",
    price: 18.00,
    grams: 40,
    vendor: "Wistaria",
    known_for: "light and vegetal",
    ship_from: "Taipei",
    popularity: 3,
    shopping_platform: "Wistaria Tea House",
    product_url: "https://wistariateahouse.com"
  },
  {
    name: "Red Oolong",
    category: "Oolong",
    price: 35.00, # same price as Oriental Beauty
    grams: 30,
    vendor: "Tea from Taiwan",
    known_for: "heavier oxidation",
    ship_from: "Taiwan",
    popularity: 6,
    shopping_platform: "Tea from Taiwan",
    product_url: "https://teafromtaiwan.com"
  }
]

oolong_prices = [25.00, 28.00, 30.00, 35.00, 38.00]
oolong_grams   = [25, 28, 30, 35, 40, 50]

oolong_styles = [
  "light roast", "medium roast", "heavy roast", "green oolong",
  "bug-bitten", "aged", "charcoal roasted", "traditional style"
]

oolong_vendors = [
  "Floating Leaves", "Taiwan Tea Crafts", "Eco-Cha", "Mountain Stream",
  "Wistaria", "Tea From Taiwan", "Essence of Tea"
]

oolong_ship_from = ["Taiwan", "Fujian", "Alishan", "Nantou", "Pinglin"]

oolong_sites = {
  "Floating Leaves" => "https://floatingleavestea.com",
  "Taiwan Tea Crafts" => "https://www.taiwanteacrafts.com",
  "Eco-Cha" => "https://eco-cha.com",
  "Mountain Stream" => "https://mountainstreamteas.com",
  "Wistaria" => "https://wistariateahouse.com",
  "Tea From Taiwan" => "https://teafromtaiwan.com",
  "Essence of Tea" => "https://essenceoftea.com"
}

# === Generate 100 realistic oolong teas with overlap ===
100.times do
  grams = oolong_grams.sample
  price = oolong_prices.sample

  vendor = oolong_vendors.sample
  Entry.create!(
    user: user2,
    tea: Tea.create!(
      name: Faker::Tea.variety + " Oolong",
      category: "Oolong",
      price: price,
      grams: grams,
      vendor: vendor,
      known_for: oolong_styles.sample,
      ship_from: oolong_ship_from.sample,
      popularity: rand(3..10),
      shopping_platform: vendor,
      product_url: oolong_sites[vendor]
    ),
    rank: rand(5..10)
  )
end

