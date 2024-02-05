import
  db_connector/db_sqlite,
  ./models,
  ../a3c/[cart, products, users]

proc newDatabase*(filename = "db5.sqlite3"): DbConn =
  result = open(filename, "", "", "")

# proc newDatabase1*(filename = "db5.sqlite3"): DbConn =
#   result = open(filename, "", "", "")

proc micsGetProducts*(email, password: string): seq[Products]=
  var
    # db1 = newDatabase1()
    db = newDatabase()
    # db3 = newDatabase3()

    userId = db.getUserId(email, password)
    cart = db.getUserCart(userId)
    products: seq[Products]
      
  for c, d in cart:
    var product = db.getProductById(d.productId)
    products.add(product)

  return products
