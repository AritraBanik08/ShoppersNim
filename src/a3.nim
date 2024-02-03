import
  mike,
  segfaults,
  os,
  nimja/parser,
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
    db2 = newDatabase2()
    db3 = newDatabase3()
    db1 = newDatabase1()

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
      userId = db2.getUserId(email, password)
      cart = db3.getUserCart(userId)
      products: seq[Products]
      
    for c, d in cart:
      var product = db1.getProductById(d.productId)
      products.add(product)

    compileTemplateFile(getScriptDir() / "a3a" / "cart.nimja")

"/checkout" -> get:
  
  var
    email: string
    password: string
    db2 = newDatabase2()
    db3 = newDatabase3()
    db1 = newDatabase1()

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
      userId = db2.getUserId(email, password)
      cart = db3.getUserCart(userId)
      products: seq[Products]
      
    for c, d in cart:
      var product = db1.getProductById(d.productId)
      products.add(product)

  compileTemplateFile(getScriptDir() / "a3a" / "checkout.nimja")

"/contact" -> get:
  
  var
    email: string
    password: string
    db2 = newDatabase2()
    db3 = newDatabase3()
    db1 = newDatabase1()

    products: seq[Products]

  try:
    email = ctx.cookies["email"]
    password = ctx.cookies["password"]
  except:
    email = ""
    password = ""

  if email != "" and password != "":
    var
      userId = db2.getUserId(email, password)
      cart = db3.getUserCart(userId)
      
    for c, d in cart:
      var product = db1.getProductById(d.productId)
      products.add(product)

  compileTemplateFile(getScriptDir() / "a3a" / "contact.nimja")

"/shop" -> get:
  
  var
    email: string
    password: string
    db1 = newDatabase1()

    availableProducts = db1.availableProducts()
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
    db1 = newDatabase1()

    productName = ctx.queryParams["prod"]

    product = db1.getProduct(productName)

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

    db2 = newDatabase2()

    user = db2.userAvailability(email, password)

    loginError = ""
    emailError = ""
    passwordError = ""

  if user == true:

    ctx &= initCookie("email", email)
    ctx &= initCookie("password", password)

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

    db2 = newDatabase2()
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

    db2.createPost(user)
    ctx.redirect("/login")

  compileTemplateFile(getScriptDir() / "a3a" / "signup.nimja")

servePublic("src/a3b", "/a3b")

run()
