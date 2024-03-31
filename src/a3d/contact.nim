import
  mike,
  segfaults,
  os,
  nimja/parser,
  ../a3pkg/[models, mics],
  ../a3c/[products, users, cart]

proc contact*(ctx: Context): string=
  var
    db = newDatabase()

    products: seq[Products]
    cookies = ctx.cookies

    email = cookies.getOrDefault("email", "")
    password = cookies.getOrDefault("password", "")

  if email != "" and password != "":
    var
      userId = db.getUserId(email, password)
      cart = db.getUserCart(userId)
      
    for c, d in cart:
      var product = db.getProductById(d.productId)
      products.add(product)

  compileTemplateFile(getScriptDir() / "a3a" / "contact.nimja")