import
  ./[products, users, cart, orders]

var
  db1 = newDatabase1()
  db2 = newDatabase2()
  db3 = newDatabase3()
  db4 = newDatabase4()

db1.drop()
db2.drop()
db3.drop()
db4.drop()