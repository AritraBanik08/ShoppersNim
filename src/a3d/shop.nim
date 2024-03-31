import
  mike,
  segfaults,
  os,
  nimja/parser,
  ../a3pkg/[models, mics],
  ../a3c/[products]

proc shop*(ctx: Context): string=
  var
    db = newDatabase()

    availableProducts = db.availableProducts()
    products: seq[Products]
    cookies = ctx.cookies

    email = cookies.getOrDefault("email", "")
    password = cookies.getOrDefault("password", "")

  if email != "" and password != "":
    products = micsGetProducts(email, password)

  compileTemplateFile(getScriptDir() / "a3a" / "shop.nimja")

proc shopSingle*(ctx: Context): string=
  var
    db = newDatabase()

    productName = ctx.queryParams["prod"]

    product = db.getProductByName(productName)

    products: seq[Products]
    cookies = ctx.cookies

    email = cookies.getOrDefault("email", "")
    password = cookies.getOrDefault("password", "")

  if email != "" and password != "":
    products = micsGetProducts(email, password)

  compileTemplateFile(getScriptDir() / "a3a" / "shop-single.nimja")