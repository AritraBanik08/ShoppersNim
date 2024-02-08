import
  ./[products, users, cart, orders],
  ../a3pkg/mics

var
  db = newDatabase()

db.setupProducts()
# db1.availableProducts()
db.setupUsers()
db.setupCart()
db.setupOrders()

db.setupProductsIndex()