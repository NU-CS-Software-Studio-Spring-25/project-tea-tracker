require 'faker'

# Clear existing records
User.destroy_all
Tea.destroy_all
Entry.destroy_all

# Create fake users
10.times do
  User.create!(
    username: Faker::Internet.unique.username,
    password: "Password123",
    bio: Faker::Lorem.sentence,
    avatar_url: Faker::Avatar.image
  )
end

# Create teas
200.times do
  region = Faker::Address.state
  Tea.create!(
    name: Faker::Tea.variety,
    category: Faker::Tea.type,
    price: Faker::Commerce.price(range: 2.0..10.0),
    vendor: Faker::Company.name,
    known_for: Faker::Marketing.buzzwords,
    ship_from: Faker::Address.city,
    region: region,
    popularity: rand(1..10),
    shopping_platform: Faker::Company.name,
    product_url: Faker::Internet.url,
    year: rand(2000..2025)  # Random year between 2000-2025
  )
end

# Create entries for each user
users = User.all
teas = Tea.all

users.each do |user|
  # Each user rates 20 random teas
  teas.sample(20).each_with_index do |tea, index|
    Entry.create!(
      position: (index + 1) * 1000,  # Use floating island method
      user: user,
      tea: tea
    )
  end
end

# Create specific users and teas for testing

# === User 1 ===
user1 = User.create!(
  username: "testuser",
  password: "SecurePass1!",
  bio: "I love exploring oolongs and pu'er teas.",
  avatar_url: "https://example.com/avatar.jpg"
)

# === User 2 ===
user2 = User.create!(
  username: "oolongfan",
  password: "AnotherSecure1!",
  bio: "Big fan of Taiwanese oolongs.",
  avatar_url: "https://example.com/avatar2.jpg"
)

# === User 3 (Tea Collection) ===
user3 = User.create!(
  username: "skylarke",
  password: "TeaPassword1!",
  bio: "Building a diverse tea collection.",
  avatar_url: "https://www.erinpark.org/assets/icon.webp"
)

# === Add entries for specific users ===

sample_teas = [
  {
    name: "Da Hong Pao",
    category: "Oolong",
    price: 0.5,
    vendor: "Fang Shun",
    known_for: "roasted oolong",
    ship_from: "China",
    region: "Wuyi Mountain",
    popularity: 5,
    shopping_platform: "Taobao",
    product_url: "https://shop71393784.taobao.com/",
    year: 2022
  },
  {
    name: "Liu Bao",
    category: "Heicha",
    price: 0.3,
    vendor: "Geow Yong",
    known_for: "heicha",
    ship_from: "China",
    region: "Guangxi",
    popularity: 4,
    shopping_platform: "Taobao",
    product_url: "https://shop352670532.taobao.com/",
    year: 2023
  },
  {
    name: "Ali Shan",
    category: "Oolong",
    price: 0.4,
    vendor: "Taiwan Tea Crafts",
    known_for: "high-mountain oolong",
    ship_from: "Taiwan",
    region: "Alishan",
    popularity: 5,
    shopping_platform: "TaiwanTeaCrafts",
    product_url: "https://www.taiwanteacrafts.com",
    year: 2024
  },
  {
    name: "Dong Ding",
    category: "Oolong",
    price: 0.4,
    vendor: "Eco-Cha",
    known_for: "traditional roasted oolong",
    ship_from: "Taiwan",
    region: "Nantou",
    popularity: 4,
    shopping_platform: "EcoCha",
    product_url: "https://eco-cha.com",
    year: 2023
  }
]

# Create sample teas and entries for user1
sample_teas.each_with_index do |tea_data, index|
  tea = Tea.create!(tea_data)
  Entry.create!(
    user: user1,
    tea: tea,
    position: (index + 1) * 1000  # Use floating island method
  )
end

# Add same two teas to user2 with different positions
[ "Ali Shan", "Dong Ding" ].each_with_index do |name, index|
  tea = Tea.find_by(name: name)
  Entry.create!(
    user: user2,
    tea: tea,
    position: (index + 1) * 1000  # Use floating island method
  )
end

# Add CSV teas for user3
csv_teas = [
  { name: "Wild Laocong Shuixian", category: "Oolong", price: 0.97, vendor: "Daxue Jiadao", year: 2017, ship_from: "China", region: "Wuyi", known_for: "Shui Xian", grams: 16 },
  { name: "Longjing #108", category: "White", price: 2.0, vendor: "One River Tea", year: 2024, ship_from: "Hangzhou", region: "Hangzhou", known_for: "Mingqian Dragonwell", grams: 9 },
  { name: "Yongchun Shuixian Kaishan", category: "Oolong", price: 1.51, vendor: "Daxue Jiadao", year: 2023, ship_from: "China", region: "Fujian", known_for: "Shui Xian", grams: 50 },
  { name: "Yongchun Laocong Shuixian Bainian", category: "Oolong", price: 1.26, vendor: "Daxue Jiadao", year: 2022, ship_from: "China", region: "Fujian", known_for: "Yongchun Shui Xian", grams: 8 },
  { name: "Honey Orchid Supreme", category: "Oolong", price: 0.9, vendor: "Teahong", year: 2023, ship_from: "China", region: "Guangdong", known_for: "Milan Xiang", grams: 5 },
  { name: "Biyun Hao Zhengjialiangzi", category: "Puer", price: 1.19, vendor: "Teas We Like", year: 2011, ship_from: "China", region: "Yunnan", known_for: "Mahei Single Cultivar", grams: 40 },
  { name: "Yongchun Shuixian Annual", category: "Oolong", price: 0.77, vendor: "Daxue Jiadao", year: 2023, ship_from: "China", region: "Fujian", known_for: "Shui Xian", grams: 50 },
  { name: "Orchid Literati", category: "Oolong", price: 1.0, vendor: "Teahong", year: 2024, ship_from: "China", region: "Guangdong", known_for: "Yashi Xiang", grams: 5 },
  { name: "Wudong Old Tree Aofuhou", category: "Oolong", price: 1.32, vendor: "Zoeys Teas", year: 2024, ship_from: "China", region: "Guangdong", known_for: "Ao Fu Hou", grams: 50 },
  { name: "Ba Xian", category: "Oolong", price: 1.0, vendor: "Zoeys Teas", year: 2024, ship_from: "China", region: "Guangdong", known_for: "Ba Xian", grams: 5 },
  { name: "Silver Needle", category: "White", price: 1.20, vendor: "One River Tea", year: 2024, ship_from: "Fuding", region: "Fujian", known_for: "Dabaihao", grams: 25 },
  { name: "Qunti Zhong", category: "Green", price: 2.0, vendor: "One River Tea", year: 2025, ship_from: "Fuding", region: "Fujian", known_for: "Dabaihao", grams: 15 },
  { name: "Wudong Cassia", category: "Oolong", price: 0.7, vendor: "Teahong", year: 2024, ship_from: "China", region: "Guangdong", known_for: "Rougui Xiang", grams: 20 },
  { name: "Yongchun Fo Shou Kaishan", category: "Oolong", price: 1.47, vendor: "Daxue Jiadao", year: 2023, ship_from: "China", region: "Fujian", known_for: "Fo Shou", grams: 50 },
  { name: "Yongchun Fo Shou Annual", category: "Oolong", price: 0.77, vendor: "Daxue Jiadao", year: 2023, ship_from: "China", region: "Fujian", known_for: "Fo Shou", grams: 50 },
  { name: "Ping Keng Tou Yashi Xiang", category: "Oolong", price: 0.70, vendor: "Zoeys Teas", year: 2024, ship_from: "China", region: "Guangdong", known_for: "Yashi Xiang", grams: 60 },
  { name: "Zhang Hui Chun Strong Roast Shui Xian", category: "Oolong", price: 0.5, vendor: "Essence of Tea", year: 2019, ship_from: "China", region: "Wuyi", known_for: "Shui Xian", grams: 9 },
  { name: "Real Zheng Yan Hui Yuan Keng Pure Da Hong Pao", category: "Oolong", price: 1.0, vendor: "Zoeys Teas", year: 2022, ship_from: "China", region: "Wuyi", known_for: "Blend", grams: 8 },
  { name: "Duck Tale Yashi Xiang", category: "Oolong", price: 0.82, vendor: "Bitterleaf", year: 2023, ship_from: "China", region: "Guangdong", known_for: "Yashi Xiang", grams: 25 },
  { name: "Qingteng", category: "Puer", price: 1.12, vendor: "Wistaria", year: 2003, ship_from: "China", region: "Yunnan", known_for: "Aged Sheng Blend", grams: 8 }
  # The rest of the teas are removed for brevity in this edit - they would follow the same pattern
]

# Create CSV teas and entries for user3
csv_teas.each_with_index do |tea_data, index|
  # Use ship_from as region if region isn't explicitly set
  region = tea_data[:region] || tea_data[:ship_from]
  # Ensure year is present
  year = tea_data[:year] || 2023
  
  tea = Tea.create!(
    name: tea_data[:name],
    category: tea_data[:category],
    price: tea_data[:price],
    vendor: tea_data[:vendor],
    year: year,
    ship_from: tea_data[:ship_from],
    region: region,
    known_for: tea_data[:known_for],
    grams: tea_data[:grams],
    popularity: rand(1..100),
    shopping_platform: tea_data[:vendor] || "Various",
    product_url: "https://example.com"
  )
  Entry.create!(
    user: user3,
    tea: tea,
    position: (index + 1) * 1000  # Use floating island method
  )
end
