import
  ./[products, users, cart, orders]

var
  db1 = newDatabase1()
  db2 = newDatabase2()
  db3 = newDatabase3()
  db4 = newDatabase4()

db1.setupProducts()
# db1.availableProducts()
db2.setupUsers()
db3.setupCart()
db4.setupOrders()

db1.setupProductsIndex()