import
  ./models,
  ../a3c/[cart, products, users]

proc micsGetProducts*(email, password: string): seq[Products]=
  var
    db1 = newDatabase1()
    db2 = newDatabase2()
    db3 = newDatabase3()

    userId = db2.getUserId(email, password)
    cart = db3.getUserCart(userId)
    products: seq[Products]
      
  for c, d in cart:
    var product = db1.getProductById(d.productId)
    products.add(product)

  return products
