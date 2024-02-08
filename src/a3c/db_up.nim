import
  ./[products, users, cart, orders],
  ../a3pkg/mics

var
  db = newDatabase()
  # db2 = newDatabase2()
  # db3 = newDatabase3()
  # db4 = newDatabase4()

db.setupProducts()
# db1.availableProducts()
db.setupUsers()
db.setupCart()
db.setupOrders()

db.setupProductsIndex()