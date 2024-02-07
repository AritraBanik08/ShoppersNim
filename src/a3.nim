import
  mike,
  segfaults,
  os,
  nimja/parser,
  strutils,
  strformat,
  ./a3pkg/[models, mics],
  ./a3c/[products, users, cart]

"/" -> [get, post]:

  var
    email: string
    password: string
    products: seq[Products]

  try:
    email = ctx.cookies["email"]
    password = ctx.cookies["password"]
  except:
    email = ""
    password = ""

  if email == "":
    echo "No cookie found."
  else:
    products = micsGetProducts(email, password)
    echo "Cookie found."

  compileTemplateFile(getScriptDir() / "a3a" / "index.nimja")

"/about" -> get:
  
  var
    email: string
    password: string
    products: seq[Products]

  try:
    email = ctx.cookies["email"]
    password = ctx.cookies["password"]
  except:
    email = ""
    password = ""

  if email == "":
    echo "No cookie found."
  else:
    products = micsGetProducts(email, password)
    echo "Cookie found."

  compileTemplateFile(getScriptDir() / "a3a" / "about.nimja")

"/cart" -> get:

  var
    email: string
    password: string
    db = newDatabase()

  try:
    email = ctx.cookies["email"]
    password = ctx.cookies["password"]
  except:
    email = ""
    password = ""

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

"/update-cart" -> get:
    
  var
    email: string
    password: string
    db = newDatabase()
    products: seq[Products]
    form = ctx.urlForm
  echo form

  try:
    email = ctx.cookies["email"]
    password = ctx.cookies["password"]
  except:
    email = ""
    password = ""

  if email == "":
    ctx.redirect("/login")

  else:
    products = micsGetProducts(email, password)
    var
      userId = db.getUserId(email, password)
      cart = db.getUserCart(userId)
      cook = ctx.cookies

    # echo cart
    # echo cook
    # db.updateCart(cook)

    for d, e in cook:
      if d.contains("_quantity") == true:
        var h = d.split("_")
        echo h
        for i, j in cart:
          # echo i
          # echo j
          if j.productId == parseInt(h[0]):
            db.updateCart(e, j.id)

    ctx.redirect("/cart")

"/add-to-cart" -> get:
    
  var
    email: string
    password: string
    db = newDatabase()

  try:
    email = ctx.cookies["email"]
    password = ctx.cookies["password"]
  except:
    email = ""
    password = ""

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

"/remove-from-cart" -> get:
  
  var
    email: string
    password: string
    db = newDatabase()

  try:
    email = ctx.cookies["email"]
    password = ctx.cookies["password"]
  except:
    email = ""
    password = ""

  if email == "":
    ctx.redirect("/login")

  else:
    var
      cart: Cart

    cart.userId = db.getUserId(email, password)
    cart.productId = db.getProductByName(ctx.queryParams["prod"]).id
      
    db.removeFromCart(cart)

    ctx.redirect("/cart")

"/checkout" -> get:
  
  var
    email: string
    password: string
    db = newDatabase()

  try:
    email = ctx.cookies["email"]
    password = ctx.cookies["password"]
  except:
    email = ""
    password = ""

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

  compileTemplateFile(getScriptDir() / "a3a" / "checkout.nimja")

"/contact" -> get:
  
  var
    email: string
    password: string
    db = newDatabase()

    products: seq[Products]

  try:
    email = ctx.cookies["email"]
    password = ctx.cookies["password"]
  except:
    email = ""
    password = ""

  if email != "" and password != "":
    var
      userId = db.getUserId(email, password)
      cart = db.getUserCart(userId)
      
    for c, d in cart:
      var product = db.getProductById(d.productId)
      products.add(product)

  compileTemplateFile(getScriptDir() / "a3a" / "contact.nimja")

"/shop" -> get:
  
  var
    email: string
    password: string
    db = newDatabase()

    availableProducts = db.availableProducts()
    products: seq[Products]

  try:
    email = ctx.cookies["email"]
    password = ctx.cookies["password"]
  except:
    email = ""
    password = ""

  if email != "" and password != "":
    products = micsGetProducts(email, password)

  compileTemplateFile(getScriptDir() / "a3a" / "shop.nimja")

"/shop-single" -> get:
  
  var
    email: string
    password: string
    db = newDatabase()

    productName = ctx.queryParams["prod"]

    product = db.getProductByName(productName)

    products: seq[Products]

  try:
    email = ctx.cookies["email"]
    password = ctx.cookies["password"]
  except:
    email = ""
    password = ""

  if email != "" and password != "":
    products = micsGetProducts(email, password)

  compileTemplateFile(getScriptDir() / "a3a" / "shop-single.nimja")

"/thankyou" -> get:
  var
    email: string
    password: string
    products: seq[Products]

  try:
    email = ctx.cookies["email"]
    password = ctx.cookies["password"]
  except:
    email = ""
    password = ""

  if email == "":
    echo "No cookie found."
  else:
    products = micsGetProducts(email, password)
    echo "Cookie found."
    
  compileTemplateFile(getScriptDir() / "a3a" / "thankyou.nimja")

"/login" -> get:
  var
    loginError = ""
    emailError = ""
    passwordError = ""

    email = ""
    password = ""

  compileTemplateFile(getScriptDir() / "a3a" / "login.nimja")

"/login" -> post:
  var
    email = ctx.urlForm["email"]
    password = ctx.urlForm["password"]

    db = newDatabase()

    user = db.userAvailability(email, password)

    loginError = ""
    emailError = ""
    passwordError = ""
  echo user

  if user == true:

    ctx &= initCookie("email", email)
    ctx &= initCookie("password", password)
    echo ctx.cookies

    ctx.redirect("/")

  else:

    if email == "":
      emailError = "Email is Required"

    if password == "":
      passwordError = "Password is Required"

    if user == false:
      loginError = "Invalid Login or Password"

    compileTemplateFile(getScriptDir() / "a3a" / "login.nimja")

"/logout" -> get:
  ctx &= initCookie("email", "")
  ctx &= initCookie("password", "")

  ctx.redirect("/login")

"/signup" -> get:
  var
    firstNameError = ""
    lastNameError = ""
    emailError = ""
    passwordError = ""
    user: User

  user.firstName = ""
  user.lastName = ""
  user.email = ""
  user.password = ""

  compileTemplateFile(getScriptDir() / "a3a" / "signup.nimja")

"/signup" -> post:
  var
    form = ctx.urlForm

    db = newDatabase()
    user: User

    firstNameError = ""
    lastNameError = ""
    emailError = ""
    passwordError = ""

  user.firstName = form["firstName"]
  user.lastName = form["lastName"]
  user.email = form["email"]
  user.password = form["password"]

  if user.firstName == "":
    firstNameError = "First Name is Required"

  if user.lastName == "":
    lastNameError = "Last Name is Required"
  
  if user.email == "":
    emailError = "Email is Required"

  if user.password == "":
    passwordError = "Password is Required"

  if firstNameError == "" and lastNameError == "" and emailError == "" and passwordError == "":
    user.accessLevel = 1

    db.createPost(user)
    ctx.redirect("/login")

  compileTemplateFile(getScriptDir() / "a3a" / "signup.nimja")

servePublic("src/a3b", "/a3b")

run()
