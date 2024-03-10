import
  mike,
  segfaults,
  os,
  nimja/parser,
  strutils,
  ./a3pkg/[models, mics],
  ./a3c/[products, users, cart]

proc checkOut*(ctx: Context): string=
  var
    db = newDatabase()
    cart: seq[Cart] = newSeq[Cart]()  # Initialize empty cart
    products: seq[Products]
    productCount = 0
    ch = ""
    cookies = ctx.cookies
    qParams = ctx.queryParams

    email = cookies.getOrDefault("email", "")
    password = cookies.getOrDefault("password", "")

    productName = qParams.getOrDefault("prod", "")
    quantity = parseInt(qParams.getOrDefault("quantity", "0"))

  if email != "":
    productCount = micsCartProductCount(email, password)

  if productName == "" and email == "":
    ctx.redirect("/login")

  if productName != "":
    var
      product: Products
      ca: Cart

    product.id = 1
    product.name = productName
    product.price = db.getPriceByProductName(productName)
    ca.quantity = quantity
    products.add(product)
    cart.add(ca)
    ch = "d"

  else:
    var
      userId = db.getUserId(email, password)
    cart = db.getUserCart(userId)
      
    for c, d in cart:
      var product = db.getProductById(d.productId)
      products.add(product)

  compileTemplateFile(getScriptDir() / "a3a" / "checkout.nimja")