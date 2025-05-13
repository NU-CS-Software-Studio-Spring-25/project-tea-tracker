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

# Create teas
200.times do
  Tea.create!(
    name: Faker::Tea.variety,
    category: Faker::Tea.type,
    price: Faker::Commerce.price(range: 2.0..10.0),
    vendor: Faker::Company.name,
    known_for: Faker::Marketing.buzzwords,
    ship_from: Faker::Address.city,
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
  username: "oolongfann",
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
    popularity: 5,
    shopping_platform: "Taobao",
    product_url: "https://shop71393784.taobao.com/"
  },
  {
    name: "Liu Bao",
    category: "Heicha",
    price: 0.3,
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
    price: 0.4,
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
    price: 0.4,
    vendor: "Eco-Cha",
    known_for: "traditional roasted oolong",
    ship_from: "Taiwan",
    popularity: 4,
    shopping_platform: "EcoCha",
    product_url: "https://eco-cha.com"
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
["Ali Shan", "Dong Ding"].each_with_index do |name, index|
  tea = Tea.find_by(name: name)
  Entry.create!(
    user: user2,
    tea: tea,
    position: (index + 1) * 1000  # Use floating island method
  )
end

# Add CSV teas for user3
csv_teas = [
  { name: "Wild Laocong Shuixian", category: "Oolong", price: 0.96, vendor: "Daxue Jiadao", year: 2017, ship_from: "China", known_for: "Shui Xian", grams: 16 },
  { name: "Longjing #108", category: "White", price: 2.0, vendor: "One River Tea", year: 2024, ship_from: "Hangzhou", known_for: "Mingqian Dragonwell", grams: 9 },
  { name: "Yongchun Shuixian Kaishan", category: "Oolong", price: 1.51, vendor: "Daxue Jiadao", year: 2023, ship_from: "China", known_for: "Shui Xian", grams: 50 },
  { name: "Yongchun Laocong Shuixian Bainian", category: "Oolong", price: 1.26, vendor: "Daxue Jiadao", year: 2022, ship_from: "China", known_for: "Yongchun Shui Xian", grams: 8 },
  { name: "Honey Orchid Supreme", category: "Oolong", price: 0.9, vendor: "Teahong", year: 2023, ship_from: "China", known_for: "Milan Xiang", grams: 5 },
  { name: "Biyun Hao Zhengjialiangzi", category: "Puer", price: 1.19, vendor: "Teas We Like", year: 2011, ship_from: "China", known_for: "Mahei Single Cultivar", grams: 40 },
  { name: "Yongchun Shuixian Annual", category: "Oolong", price: 0.77, vendor: "Daxue Jiadao", year: 2023, ship_from: "China", known_for: "Shui Xian", grams: 50 },
  { name: "Orchid Literati", category: "Oolong", price: 1.0, vendor: "Teahong", year: 2024, ship_from: "China", known_for: "Yashi Xiang", grams: 5 },
  { name: "Wudong Old Tree Aofuhou", category: "Oolong", price: 1.32, vendor: "Zoeys Teas", year: 2024, ship_from: "China", known_for: "Ao Fu Hou", grams: 50 },
  { name: "Ba Xian", category: "Oolong", price: 1.0, vendor: "Zoeys Teas", year: 2024, ship_from: "China", known_for: "Ba Xian", grams: 5 },
  { name: "Silver Needle", category: "White", price: 1.20, vendor: "One River Tea", year: 2024, ship_from: "Fuding", known_for: "Dabaihao", grams: 25 },
  { name: "Qunti Zhong", category: "Green", price: 2.0, vendor: "One River Tea", year: 2025, ship_from: "Fuding", known_for: "Dabaihao", grams: 15 },
  { name: "Wudong Cassia", category: "Oolong", price: 0.7, vendor: "Teahong", year: 2024, ship_from: "China", known_for: "Rougui Xiang", grams: 20 },
  { name: "Yongchun Fo Shou Kaishan", category: "Oolong", price: 1.47, vendor: "Daxue Jiadao", year: 2023, ship_from: "China", known_for: "Fo Shou", grams: 50 },
  { name: "Yongchun Fo Shou Annual", category: "Oolong", price: 0.77, vendor: "Daxue Jiadao", year: 2023, ship_from: "China", known_for: "Fo Shou", grams: 50 },
  { name: "Ping Keng Tou Yashi Xiang", category: "Oolong", price: 0.70, vendor: "Zoeys Teas", year: 2024, ship_from: "China", known_for: "Yashi Xiang", grams: 60 },
  { name: "Zhang Hui Chun Strong Roast Shui Xian", category: "Oolong", price: 0.5, vendor: "Essence of Tea", year: 2019, ship_from: "China", known_for: "Shui Xian", grams: 9 },
  { name: "Real Zheng Yan Hui Yuan Keng Pure Da Hong Pao", category: "Oolong", price: 1.0, vendor: "Zoeys Teas", year: nil, ship_from: "China", known_for: "Blend", grams: 8 },
  { name: "Duck Tale Yashi Xiang", category: "Oolong", price: 0.82, vendor: "Bitterleaf", year: 2023, ship_from: "China", known_for: "Yashi Xiang", grams: 25 },
  { name: "Qingteng", category: "Puer", price: 1.12, vendor: "Wistaria", year: 2003, ship_from: "China", known_for: "Aged Sheng Blend", grams: 8 },
  { name: "Nantou Dark Sequel", category: "Oolong", price: 0.53, vendor: "Song Tea", year: 2023, ship_from: "China", known_for: "Qing Xin", grams: 10 },
  { name: "Laocong Shuixian", category: "Oolong", price: 0.67, vendor: "Old Ways Tea", year: 2022, ship_from: "China", known_for: "Shui Xian", grams: 64 },
  { name: "Dayi Golden TAE", category: "Puer", price: 2.50, vendor: "Friend's relative", year: 2011, ship_from: "China", known_for: "Aged Sheng Blend", grams: 30 },
  { name: "Jade Peak High Montain", category: "Oolong", price: 0.52, vendor: "Floating Leaves", year: 2024, ship_from: "Taiwan", known_for: "Qing Xin", grams: 30 },
  { name: "Chen Yuan Hao Shanzhong Chuanqi", category: "Puer", price: 1.74, vendor: "Teas We Like", year: 2005, ship_from: "China", known_for: "Aged Sheng Gushu Blend", grams: 20 },
  { name: "Chunzhong Da Hong Pao", category: "Oolong", price: 0.67, vendor: "Old Ways Tea", year: 2021, ship_from: "China", known_for: "Qi Dan", grams: 8 },
  { name: "King Peony", category: "White", price: 0.40, vendor: "One River Tea", year: 2024, ship_from: "Fuding", known_for: "Dabaihao", grams: 50 },
  { name: "Dong Ding Trad. A", category: "Oolong", price: 0.41, vendor: "Floating Leaves", year: 2024, ship_from: "Taiwan", known_for: "Qing Xin", grams: 60 },
  { name: "Mo Li Xiang", category: "Oolong", price: 1.0, vendor: "Tea Habitat", year: nil, ship_from: "China", known_for: "Mo Li Xiang", grams: 8 },
  { name: "Boseong Sejak", category: "Green", price: 1.75, vendor: "TShop", year: 2024, ship_from: "Korea", known_for: "Boseong", grams: 5 },
  { name: "Bei Dou", category: "Oolong", price: 0.33, vendor: "Old Ways Tea", year: 2022, ship_from: "China", known_for: "Bei Dou", grams: 40 },
  { name: "Top Shelf Hatsugana Matcha", category: "Green", price: 1.0, vendor: "Ryuouen", year: 2024, ship_from: "Japan", known_for: "Uji Matcha Blend", grams: 20 },
  { name: "Kyogoko no Mukashi", category: "Green", price: 0.59, vendor: "Ippodo", year: 2024, ship_from: "Japan", known_for: "Uji Matcha Blend", grams: 20 },
  { name: "Saiko", category: "Green", price: 0.33, vendor: "Ryuouen", year: 2024, ship_from: "Japan", known_for: "Sencha Blend", grams: 50 },
  { name: "Farmers Choice Baozhong", category: "Oolong", price: 0.35, vendor: "Floating Leaves", year: 2023, ship_from: "Taiwan", known_for: "Man Zhong", grams: 60 },
  { name: "Light Roast Da Hong Pao", category: "Oolong", price: 0.3, vendor: "Old Ways Tea", year: 2024, ship_from: "China", known_for: "Bei Dou", grams: 40 },
  { name: "First Roast Shui Xian", category: "Oolong", price: 0.25, vendor: "Old Ways Tea", year: 2023, ship_from: "China", known_for: "Shui Xian", grams: 40 },
  { name: "Second Roast Shui Xian", category: "Oolong", price: 0.25, vendor: "Old Ways Tea", year: 2023, ship_from: "China", known_for: "Shui Xian", grams: 40 },
  { name: "Guoxiang Rougui", category: "Oolong", price: 0.40, vendor: "Daxue Jiadao", year: 2022, ship_from: "China", known_for: "Rou Gui", grams: 8 },
  { name: "Mi no mukashi", category: "Green", price: 1.45, vendor: "Ippodo", year: 2024, ship_from: "Japan", known_for: "Matcha Blend", grams: 2 },
  { name: "Competition Baozhong", category: "Oolong", price: 0.45, vendor: "Floating Leaves", year: 2024, ship_from: "Taiwan", known_for: "Qing Xin", grams: 30 },
  { name: "High Mountain Diva", category: "Oolong", price: 0.45, vendor: "Floating Leaves", year: 2024, ship_from: "Taiwan", known_for: "Qing Xin", grams: 60 },
  { name: "Yongchun Fo Shou Trad", category: "Oolong", price: 0.77, vendor: "Daxue Jiadao", year: 2022, ship_from: "China", known_for: "Fo Shou", grams: 8 },
  { name: "Charcoal Roast Dong Ding", category: "Oolong", price: 0.65, vendor: "Floating Leaves", year: 2024, ship_from: "Taiwan", known_for: "Ruan Zhi", grams: 30 },
  { name: "Biyun Hao Lishan Gongcha", category: "Puer", price: 0.6, vendor: "Unknown", year: 2015, ship_from: "China", known_for: "Yiwu Blend", grams: 8 },
  { name: "Kim Jeong Yeol Chungiljem Sejak", category: "Green", price: 0.75, vendor: "Morning Crane", year: 2024, ship_from: "Korea", known_for: "Sejak", grams: 15 },
  { name: "Sanxia Green", category: "Green", price: 0.50, vendor: "Mountain Stream Teas", year: 2023, ship_from: "Taiwan", known_for: "Qinxin Gan Zhong", grams: 10 },
  { name: "Asahi", category: "Green", price: 0.20, vendor: "Ryuouen", year: 2024, ship_from: "Japan", known_for: "Sencha Blend", grams: 5 },
  { name: "Niu Rou Huangpian", category: "Oolong", price: 0.25, vendor: "Old Ways Tea", year: 2023, ship_from: "China", known_for: "Rou Gui", grams: 50 },
  { name: "Praise Bee Milan Xiang", category: "Oolong", price: 0.90, vendor: "Bitterleaf", year: 2023, ship_from: "China", known_for: "Milan Xiang", grams: 25 },
  { name: "Red Ribbon", category: "Puer", price: 0.53, vendor: "Teas We Like", year: 2001, ship_from: "China", known_for: "Blend", grams: 15 },
  { name: "MKRS Creme Florale", category: "Puer", price: 0.22, vendor: "PJ", year: 2011, ship_from: "China", known_for: "Blend", grams: 30 },
  { name: "Baiyun Rougui", category: "Oolong", price: 0.70, vendor: "Daxue Jiadao", year: 2022, ship_from: "China", known_for: "Rou Gui", grams: 8 },
  { name: "First Flush Darjeeling", category: "Black", price: 0.32, vendor: "Ketlee", year: 2023, ship_from: "India", known_for: "Darjeeling", grams: 8 },
  { name: "Mong Rong Ya Bao", category: "White", price: 0.25, vendor: "Viet Sun", year: 2023, ship_from: "Vietnam", known_for: "Ya Bao", grams: 8 },
  { name: "Yellow Twig", category: "Oolong", price: 0.40, vendor: "West China Tea", year: 2024, ship_from: "China", known_for: "Huangzhi Xiang", grams: 5 },
  { name: "Chi Lai High Mountain Black", category: "Black", price: 0.6, vendor: "Mountain Stream Teas", year: 2024, ship_from: "Taiwan", known_for: "Qin Xin", grams: 5 },
  { name: "Lai Chau Deep Forest Green", category: "Green", price: 0.23, vendor: "Viet Sun", year: 2024, ship_from: "Vietnam", known_for: "NSV", grams: 25 },
  { name: "Loon-call in the Dark", category: "Puer", price: 0.45, vendor: "White2Tea", year: 2022, ship_from: "China", known_for: "Shou", grams: 25 },
  { name: "Mingqian Longjing", category: "Green", price: 0.52, vendor: "One River Tea", year: 2024, ship_from: "China", known_for: "Longjing", grams: 25 },
  { name: "Kawane, Moto-Fujikawa Shizu-7132", category: "Green", price: 0.20, vendor: "Thes du Japon", year: 2023, ship_from: "Japan", known_for: "Shizu-7132", grams: 100 },
  { name: "Ha Giang Black", category: "Black", price: 0.19, vendor: "Viet Sun", year: 2024, ship_from: "Vietnam", known_for: "", grams: 25 },
  { name: "Fuji-Kaori", category: "Black", price: 0.25, vendor: "Thes du Japon", year: 2023, ship_from: "Japan", known_for: "Wakocha Fuji-Kaori", grams: 8 },
  { name: "Tong Mu Charcoal Roast", category: "Black", price: 0.32, vendor: "Old Ways Tea", year: 2024, ship_from: "China", known_for: "Xiao Zhong", grams: 50 },
  { name: "Lan Shan Xiao Zhong", category: "Black", price: 0.32, vendor: "Old Ways Tea", year: 2024, ship_from: "China", known_for: "Xiao Zhong", grams: 40 },
  { name: "Qian Li Xiang", category: "Oolong", price: 0.22, vendor: "Old Ways Tea", year: 2023, ship_from: "China", known_for: "Qian Li Xiang", grams: 8 },
  { name: "Pu Ta Leng White", category: "White", price: 0.28, vendor: "Viet Sun", year: 2023, ship_from: "Vietnam", known_for: "NSV", grams: 25 },
  { name: "Shui Di Xiang Xiao Zhong", category: "Black", price: 0.32, vendor: "Old Ways Tea", year: 2024, ship_from: "China", known_for: "Xiao Zhong", grams: 40 },
  { name: "Traditional Charcoal Roast Tie Guan Yin", category: "Oolong", price: 0.50, vendor: "Zoeys Teas", year: nil, ship_from: "China", known_for: "Tie Guan Yin", grams: 25 },
  { name: "Aged Da Hong Pao", category: "Oolong", price: 0.28, vendor: "Old Ways Tea", year: 2015, ship_from: "China", known_for: "Bei Dou", grams: 25 },
  { name: "Red Jade", category: "White", price: 0.52, vendor: "Liquid Proust", year: 2024, ship_from: "Taiwan", known_for: "T-18", grams: 30 },
  { name: "Jeong Jae Yoon Halmonicha", category: "Balhyocha", price: 0.4, vendor: "Morning Crane", year: 2023, ship_from: "Korea", known_for: "", grams: 60 },
  { name: "Sweet Cream Alishan High Mountain", category: "Oolong", price: 0.45, vendor: "Floating Leaves", year: 2024, ship_from: "Taiwan", known_for: "Qing Xin", grams: 15 },
  { name: "Smooth Water Baozhong", category: "Oolong", price: 0.35, vendor: "Floating Leaves", year: 2024, ship_from: "Taiwan", known_for: "Qing Xin", grams: 15 },
  { name: "Xiaguan Jiaji", category: "Puer", price: 0.22, vendor: "Teas We Like", year: 2004, ship_from: "China", known_for: "Aged Sheng", grams: 12 },
  { name: "Cao Bo Shou", category: "Puer", price: 0.15, vendor: "Viet Sun", year: 2021, ship_from: "Vietnam", known_for: "", grams: 20 },
  { name: "Snow Orchid", category: "Oolong", price: 0.5, vendor: "Teahong", year: 2024, ship_from: "China", known_for: "Yashi Xiang", grams: 12 },
  { name: "MKRS Da Xue Shan", category: "Puer", price: 0.18, vendor: "PJ", year: 2009, ship_from: "China", known_for: "NSV", grams: 8 },
  { name: "Handmade Rou Gui", category: "Oolong", price: 0.6, vendor: "Old Ways Tea", year: 2022, ship_from: "China", known_for: "Rou Gui", grams: 8 },
  { name: "Ma Ton Yan Rou Gui", category: "Oolong", price: 1.32, vendor: "Old Ways Tea", year: 2022, ship_from: "China", known_for: "Rou Gui", grams: 40 },
  { name: "Old Tree Rou Gui", category: "Oolong", price: 0.56, vendor: "Old Ways Tea", year: 2024, ship_from: "China", known_for: "Rou Gui", grams: 40 },
  { name: "New Tree Rou Gui", category: "Oolong", price: 0.32, vendor: "Old Ways Tea", year: 2024, ship_from: "China", known_for: "Rou Gui", grams: 12 },
  { name: "Cao Bo White", category: "White", price: 0.14, vendor: "Viet Sun", year: 2024, ship_from: "Vietnam", known_for: "", grams: 12 },
  { name: "Zhangping Shui Xian", category: "Oolong", price: 0.22, vendor: "Old Ways Tea", year: 2022, ship_from: "China", known_for: "Shui Xian", grams: 8 },
  { name: "Sun Moon Ruby 18", category: "Black", price: 0.5, vendor: "Mountain Stream Teas", year: 2023, ship_from: "Taiwan", known_for: "Ruby 18", grams: 25 },
  { name: "Thai Nguyen Fish Hook Green", category: "Green", price: 0.10, vendor: "Viet Sun", year: 2023, ship_from: "Vietnam", known_for: "", grams: 25 },
  { name: "Wild Cultivar Red", category: "Black", price: 0.5, vendor: "Mountain Stream Teas", year: 2023, ship_from: "Taiwan", known_for: "Camellia Formosensis", grams: 5 },
  { name: "Bi Luo Chun", category: "Green", price: 0.46, vendor: "One River Tea", year: 2024, ship_from: "China", known_for: "Bi Luo Chun", grams: 12 },
  { name: "Yoneta Goko Gyokuro", category: "Green", price: 0.70, vendor: "Thes du Japon", year: 2023, ship_from: "Japan", known_for: "Goko", grams: 25 },
  { name: "Jin Jun Mei", category: "Black", price: 0.82, vendor: "Old Ways Tea", year: 2024, ship_from: "China", known_for: "Jin Jun Mei", grams: 15 },
  { name: "Assam Autumn Gold", category: "Black", price: 0.52, vendor: "Ketlee", year: 2023, ship_from: "India", known_for: "Indian Assam", grams: 10 },
  { name: "Huang Guan Yin Batch #1", category: "Oolong", price: 0.25, vendor: "Old Ways Tea", year: 2023, ship_from: "China", known_for: "Huang Guan Yin", grams: 40 },
  { name: "Goddess Roast Tie Guan Yin", category: "Oolong", price: 0.21, vendor: "Bitterleaf", year: 2013, ship_from: "China", known_for: "Tie Guan Yin", grams: 50 },
  { name: "Dark Roast Tie Guan Yin", category: "Oolong", price: 0.30, vendor: "Floating Leaves", year: 2023, ship_from: "Taiwan", known_for: "Tie Guan Yin", grams: 25 },
  { name: "Lao Cai Secret Forest Black", category: "Black", price: 0.25, vendor: "Viet Sun", year: 2024, ship_from: "Vietnam", known_for: "NSV", grams: 25 },
  { name: "The Chens New Garden Medium Roast", category: "Oolong", price: 1.1, vendor: "Song Tea", year: 2021, ship_from: "Taiwan", known_for: "", grams: 8 },
  { name: "Puer", category: "Puer", price: 0.12, vendor: "Yee On Best Taste", year: nil, ship_from: "China", known_for: "", grams: 25 },
  { name: "Cookie Counselor", category: "Puer", price: 0.28, vendor: "Liquid Proust", year: 2015, ship_from: "China", known_for: "", grams: 25 },
  { name: "Sayama, Hokumei", category: "Green", price: 0.22, vendor: "Thes du Japon", year: 2023, ship_from: "Japan", known_for: "Hokumei", grams: 25 },
  { name: "Baka", category: "Puer", price: 0.50, vendor: "Farmer Leaf", year: 2021, ship_from: "China", known_for: "", grams: 10 },
  { name: "Future Sailor", category: "White", price: 0.24, vendor: "Bitterleaf", year: 2022, ship_from: "China", known_for: "NSV", grams: 25 },
  { name: "Seiun/Shoin", category: "Green", price: 0.68, vendor: "Ippodo", year: 2024, ship_from: "Japan", known_for: "Matcha Blend", grams: 30 },
  { name: "Cousins Fo Shou", category: "Oolong", price: 0.22, vendor: "Old Ways Tea", year: 2022, ship_from: "China", known_for: "Fo Shou", grams: 40 },
  { name: "Huang Guan Yin Batch #2", category: "Oolong", price: 0.25, vendor: "Old Ways Tea", year: 2023, ship_from: "China", known_for: "Huang Guan Yin", grams: 40 },
  { name: "Menghai Purple Ripe Pu-erh Tea Cake", category: "Puer", price: 0.08, vendor: "Yee On", year: 2009, ship_from: "China", known_for: "Shou Blend", grams: 25 },
  { name: "Classic Rougui", category: "Oolong", price: 1.2, vendor: "Song Tea", year: 2021, ship_from: "China", known_for: "Rou Gui", grams: 8 },
  { name: "Lai Chau Deep Forest White", category: "White", price: 0.29, vendor: "Viet Sun", year: 2024, ship_from: "Vietnam", known_for: "NSV", grams: 100 },
  { name: "In the Rough Songzhong Dancong", category: "Oolong", price: 0.63, vendor: "Bitterleaf", year: 2023, ship_from: "China", known_for: "Songzhong", grams: 25 },
  { name: "Competition Muzha Tieguanyin", category: "Oolong", price: 0.38, vendor: "Mountain Stream Teas", year: 2024, ship_from: "Taiwan", known_for: "Jinxuan", grams: 25 },
  { name: "Double Scoop Dancong", category: "Oolong", price: 0.25, vendor: "Bitterleaf", year: 2023, ship_from: "China", known_for: "Yashi Xiang", grams: 25 },
  { name: "Lao Cai Black", category: "Black", price: 0.19, vendor: "Viet Sun", year: 2024, ship_from: "Vietnam", known_for: "NSV", grams: 25 },
  { name: "Mimasaka Ryofu", category: "Green", price: 0.15, vendor: "Thes du Japon", year: 2023, ship_from: "Japan", known_for: "Sencha Ryofu", grams: 25 },
  { name: "Chiran Fukamushi", category: "Green", price: 0.14, vendor: "Uji-cha-en", year: 2024, ship_from: "Japan", known_for: "Sencha Blend", grams: 20 },
  { name: "Nilgiri Highland Oolong", category: "Oolong", price: 0.54, vendor: "Ketlee", year: 2023, ship_from: "India", known_for: "Indian", grams: 25 },
  { name: "Lung Vai", category: "White", price: 0.21, vendor: "Viet Sun", year: 2024, ship_from: "Vietnam", known_for: "NSV", grams: 20 },
  { name: "Nilgiri Candy Black", category: "Black", price: 0.30, vendor: "Ketlee", year: 2023, ship_from: "India", known_for: "Nilgiri", grams: 25 },
  { name: "Charing Cross", category: "White", price: 0.42, vendor: "White2Tea", year: 2023, ship_from: "China", known_for: "White", grams: 25 },
  { name: "Zairai Heirloom Hand Roast Hojicha", category: "Green", price: 0.56, vendor: "Kettl", year: 2022, ship_from: "Japan", known_for: "Hojicha Zarai", grams: 10 },
  { name: "GABA Oolong", category: "Oolong", price: 0.35, vendor: "Floating Leaves", year: 2023, ship_from: "Taiwan", known_for: "Qing Xin", grams: 30 },
  { name: "Golden Green", category: "Green", price: 0.34, vendor: "One River Tea", year: 2024, ship_from: "China", known_for: "CN Green", grams: 64 },
  { name: "CNNP Water Blue Mark", category: "Puer", price: 0.17, vendor: "PJ", year: 2007, ship_from: "China", known_for: "Aged Sheng Blend", grams: 12 },
  { name: "Friends Fo Shou", category: "Oolong", price: 0.21, vendor: "Old Ways Tea", year: 2022, ship_from: "China", known_for: "Fo Shou", grams: 40 },
  { name: "Yesheng Gushu Baicha", category: "White", price: 0.46, vendor: "White2Tea", year: 2022, ship_from: "China", known_for: "NSV", grams: 20 },
  { name: "Ba Da Ye", category: "Puer", price: 0.13, vendor: "Farmer Leaf", year: 2022, ship_from: "China", known_for: "Jinggu", grams: 10 },
  { name: "Kin Hojicha", category: "Green", price: 0.38, vendor: "Ryuouen", year: nil, ship_from: "Japan", known_for: "Hojicha", grams: 10 },
  { name: "Jou Yanagi Hojicha", category: "Green", price: 0.13, vendor: "Ryuouen", year: nil, ship_from: "Japan", known_for: "Hojicha", grams: 10 },
  { name: "Okukuji Yabukita", category: "Green", price: 0.20, vendor: "Thes du Japon", year: 2023, ship_from: "Japan", known_for: "Sencha Yabukita", grams: 15 },
  { name: "Wild Tree Purple Moonlight White", category: "White", price: 0.28, vendor: "Yunnan Sourcing", year: 2023, ship_from: "China", known_for: "Jinggu NSV", grams: 15 },
  { name: "Enshi Yulu", category: "Green", price: 0.42, vendor: "One River Tea", year: 2024, ship_from: "China", known_for: "Enshi Yulu", grams: 12 },
  { name: "Nilgiri Needle Green", category: "Green", price: 0.13, vendor: "Ketlee", year: 2024, ship_from: "India", known_for: "Indian", grams: 25 },
  { name: "Coastal Mountain Deep Water", category: "Oolong", price: 0.24, vendor: "Mountain Stream Teas", year: 2023, ship_from: "Taiwan", known_for: "Jin Xuan", grams: 25 },
  { name: "Gongmei", category: "White", price: 0.32, vendor: "White2Tea", year: 2013, ship_from: "China", known_for: "Aged White", grams: 25 },
  { name: "Shoumei", category: "White", price: 0.13, vendor: "White2Tea", year: 2014, ship_from: "China", known_for: "Aged White", grams: 25 },
  { name: "Tiltshift", category: "White", price: 0.16, vendor: "White2Tea", year: 2021, ship_from: "China", known_for: "White", grams: 25 },
  { name: "Yanhong", category: "Black", price: 0.12, vendor: "White2Tea", year: 2023, ship_from: "China", known_for: "Black Yunnan", grams: 15 },
  { name: "CNNP Fuhai 7536 Mincemeat", category: "Puer", price: 0.11, vendor: "PJ", year: 2007, ship_from: "China", known_for: "Aged Sheng Blend", grams: 12 },
  { name: "Boundless", category: "Puer", price: 0.44, vendor: "Essence of Tea", year: 2021, ship_from: "China", known_for: " Gushu", grams: 10 },
  { name: "Black Gold Bi Luo Chun", category: "Black", price: 0.12, vendor: "Yunnan Sourcing", year: 2023, ship_from: "China", known_for: "Yunnan", grams: 40 },
  { name: "Aged Shui Xian", category: "Oolong", price: 0.20, vendor: "Old Ways Tea", year: 2015, ship_from: "China", known_for: "Shui Xian", grams: 40 },
  { name: "Aged Qi Dan", category: "Oolong", price: 0.29, vendor: "Old Ways Tea", year: 2013, ship_from: "China", known_for: "Qi Dan", grams: 40 },
  { name: "Purple Needle Black Tea", category: "Black", price: 0.11, vendor: "Yunnan Sourcing", year: 2023, ship_from: "China", known_for: "NSV", grams: 20 },
  { name: "Forest Echo Zhilan Xiang", category: "Oolong", price: 0.22, vendor: "Bitterleaf", year: 2023, ship_from: "China", known_for: "Zhilan Xiang", grams: 12 },
  { name: "941", category: "Puer", price: 0.14, vendor: "White2Tea", year: 2023, ship_from: "China", known_for: " Yiwu", grams: 8 },
  { name: "Easy Breezy Duck Shit", category: "Oolong", price: 0.27, vendor: "Bitterleaf", year: 2023, ship_from: "China", known_for: "Yashi Xiang", grams: 25 },
  { name: "CNNP Bulang Peacock", category: "Puer", price: 0.18, vendor: "PJ", year: 2014, ship_from: "China", known_for: "Aged Sheng Bulang", grams: 12 },
  { name: "Sunset Oolong", category: "Oolong", price: 0.35, vendor: "Viet Sun", year: 2023, ship_from: "Vietnam", known_for: "Assam", grams: 25 },
  { name: "Nilgiri Candy Oolong", category: "Oolong", price: 0.30, vendor: "Ketlee", year: 2023, ship_from: "India", known_for: "Nilgiri", grams: 25 },
  { name: "Year of the Bull", category: "Puer", price: 0.11, vendor: "Bitterleaf", year: 2022, ship_from: "China", known_for: " Yiwu", grams: 10 },
  { name: "Light Roast Tie Guan Yin", category: "Oolong", price: 0.36, vendor: "Zoeys Teas", year: nil, ship_from: "China", known_for: "Tie Guan Yin", grams: 8 },
  { name: "Son La Wild Tree", category: "Puer", price: 0.28, vendor: "Viet Sun", year: 2023, ship_from: "Vietnam", known_for: " NSV", grams: 25 },
  { name: "CNNP Thick Zen", category: "Puer", price: 0.16, vendor: "PJ", year: 2007, ship_from: "China", known_for: "Aged Sheng", grams: 12 },
  { name: "Jeju Volcanic Rock Half-Balhyocha", category: "Balhyocha", price: 0.34, vendor: "Osulloc", year: 2023, ship_from: "Korea", known_for: "Korean", grams: 10 },
  { name: "Zhenghe Red", category: "Black", price: 0.11, vendor: "White2Tea", year: 2023, ship_from: "China", known_for: "Black", grams: 10 },
  { name: "Light Roast Tie Guan Yin", category: "Oolong", price: 0.5, vendor: "Zoeys Teas", year: nil, ship_from: "China", known_for: "Tie Guan Yin", grams: 8 },
  { name: "Xiaguan Love Forever Paper Tong", category: "Puer", price: 0.40, vendor: "Jade Leaf", year: 2013, ship_from: "China", known_for: "Aged Sheng", grams: 10 },
  { name: "Nanhu Mountain Spring", category: "Oolong", price: 0.36, vendor: "Mountain Stream Teas", year: 2024, ship_from: "Taiwan", known_for: "Qinxin", grams: 10 },
  { name: "Oh Deer", category: "Puer", price: 0.29, vendor: "Bitterleaf", year: 2022, ship_from: "China", known_for: "", grams: 8 },
  { name: "Veldt", category: "Puer", price: 0.17, vendor: "White2Tea", year: 2023, ship_from: "China", known_for: "", grams: 8 },
  { name: "Whipped Lemon Purple Sheng", category: "Puer", price: 1.25, vendor: "Liquid Proust", year: 2018, ship_from: "China", known_for: " NSV", grams: 12 },
  { name: "Plum Beauty", category: "Puer", price: 0.23, vendor: "Bitterleaf", year: 2023, ship_from: "China", known_for: "", grams: 10 },
  { name: "Wintergreen Ruby 18", category: "White", price: 0.5, vendor: "Mountain Stream Teas", year: 2025, ship_from: "Taiwan", known_for: "T-18", grams: 5 },
  { name: "Phoenix Valley", category: "Oolong", price: 0.32, vendor: "Mountain Stream Teas", year: 2024, ship_from: "Taiwan", known_for: "Qinxin", grams: 10 },
  { name: "Snow Pick Chi Lai", category: "Oolong", price: 0.32, vendor: "Mountain Stream Teas", year: 2024, ship_from: "Taiwan", known_for: "Qing Xin", grams: 10 }
]

# Create CSV teas and entries for user3
csv_teas.each_with_index do |tea_data, index|
  tea = Tea.create!(
    name: tea_data[:name],
    category: tea_data[:category],
    price: tea_data[:price],
    vendor: tea_data[:vendor],
    year: tea_data[:year],
    ship_from: tea_data[:ship_from],
    known_for: tea_data[:known_for],
    grams: tea_data[:grams],
    popularity: rand(1..tea_data.count),
    shopping_platform: "Various",
    product_url: "https://example.com"
  )
  Entry.create!(
    user: user3,
    tea: tea,
    position: (index + 1) * 1000  # Use floating island method
  )
end

