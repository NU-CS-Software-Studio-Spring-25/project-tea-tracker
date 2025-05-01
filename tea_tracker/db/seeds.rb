# Clear existing records
User.destroy_all
Tea.destroy_all

# === User 1 ===
user1 = User.create!(
  username: "testuser",
  password: "SecurePass1!",
  bio: "I love exploring oolongs and pu’er teas.",
  avatar_url: "https://example.com/avatar.jpg"
)

# Teas for user1
user1.teas.create!([
  {
    name: "Da Hong Pao",
    category: "Oolong",
    rank: 9,
    price: 38.00,
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
    rank: 8,
    price: 24.00,
    vendor: "Geow Yong",
    known_for: "heicha",
    ship_from: "China",
    popularity: 4,
    shopping_platform: "Taobao",
    product_url: "https://shop352670532.taobao.com/"
  }
])

# === User 2 ===
user2 = User.create!(
  username: "oolongfan",
  password: "AnotherSecure1!",
  bio: "Big fan of Taiwanese oolongs.",
  avatar_url: "https://example.com/avatar2.jpg"
)

# Teas for user2
user2.teas.create!([
  {
    name: "Ali Shan",
    category: "Oolong",
    rank: 9,
    price: 40.00,
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
    rank: 8,
    price: 32.00,
    vendor: "Eco-Cha",
    known_for: "traditional roasted oolong",
    ship_from: "Taiwan",
    popularity: 4,
    shopping_platform: "EcoCha",
    product_url: "https://eco-cha.com"
  }
])
