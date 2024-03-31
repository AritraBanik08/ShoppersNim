import
  mike,
  segfaults,
  os,
  nimja/parser,
  strutils,
  ../a3pkg/[models, mics],
  ../a3c/[products, users, cart]

proc cart*(ctx: Context): string=
  var
    db = newDatabase()
    cookies = ctx.cookies

    email = cookies.getOrDefault("email", "")
    password = cookies.getOrDefault("password", "")

  if email == "":
    ctx.redirect("/login")

  else:
    var
      userId = db.getUserId(email, password)
      cart = db.getUserCart(userId)
      products: seq[Products]
      
    for c, d in cart:
      var product = db.getProductById(d.productId)
      products.add(product)

    compileTemplateFile(getScriptDir() / "a3a" / "cart.nimja")

proc updateCart*(ctx: Context)=
  var
    db = newDatabase()
    products: seq[Products]
    cookies = ctx.cookies

    email = cookies.getOrDefault("email", "")
    password = cookies.getOrDefault("password", "")

  if email == "":
    ctx.redirect("/login")

  else:
    products = micsGetProducts(email, password)
    var
      userId = db.getUserId(email, password)
      cart = db.getUserCart(userId)
      cook = ctx.cookies

    for d, e in cook:
      if d.contains("_quantity") == true:
        var h = d.split("_")
        for i, j in cart:
          if j.productId == parseInt(h[0]):
            db.updateCart(e, j.id)

    ctx.redirect("/cart")

proc addToCart*(ctx: Context)=
  var
    db = newDatabase()
    cookies = ctx.cookies

    email = cookies.getOrDefault("email", "")
    password = cookies.getOrDefault("password", "")

  if email == "":
    ctx.redirect("/login")

  else:
    var
      cart: Cart

    cart.userId = db.getUserId(email, password)
    cart.productId = db.getProductByName(ctx.queryParams["prod"]).id
    cart.quantity = parseInt(ctx.queryParams["quantity"])

    if cart.quantity == 0:
      cart.quantity = 1
        
    db.addToCart(cart)

    ctx.redirect("/cart")

proc removeFromCart*(ctx: Context)=
  var
    db = newDatabase()
    cookies = ctx.cookies

    email = cookies.getOrDefault("email", "")
    password = cookies.getOrDefault("password", "")

  if email == "":
    ctx.redirect("/login")

  else:
    var
      cart: Cart

    cart.userId = db.getUserId(email, password)
    cart.productId = db.getProductByName(ctx.queryParams["prod"]).id
      
    db.removeFromCart(cart)

    ctx.redirect("/cart")