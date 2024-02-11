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

    for d, e in cook:
      if d.contains("_quantity") == true:
        var h = d.split("_")
        for i, j in cart:
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
    productName= ""
    quantity = 0
    cart: seq[Cart]
    products: seq[Products]
    productCount = 0
    countryError = ""
    firstNameError = ""
    lastNameError = ""
    addressError = ""
    stateError = ""
    zipError = ""
    emailError = ""
    phoneError = ""

  try:
    email = ctx.cookies["email"]
    password = ctx.cookies["password"]
  except:
    email = ""
    password = ""

  try:
    productName = ctx.queryParams["prod"]
    quantity = parseInt(ctx.queryParams["quantity"])
  except:
    productName = ""
    quantity = 0

  if email != "":
    productCount = micsCartProductCount(email, password)

  if productName == "" and email == "":
    ctx.redirect("/login")

  elif productName != "":
    var
      product: Products
      ca: Cart

    product.id = 1
    product.name = productName
    product.price = db.getPriceByProductName(productName)
    ca.quantity = quantity
    products.add(product)
    cart.add(ca)

  else:
    var
      userId = db.getUserId(email, password)
    cart = db.getUserCart(userId)
      
    for c, d in cart:
      var product = db.getProductById(d.productId)
      echo product
      products.add(product)

  compileTemplateFile(getScriptDir() / "a3a" / "checkout.nimja")

"/checkout" -> post:
  var
    email: string
    password: string
    db = newDatabase()
    productName= ""
    quantity = 0
    cart: seq[Cart]
    products: seq[Products]
    productCount = 0
    cookies = ctx.cookies
    countryError = ""
    firstNameError = ""
    lastNameError = ""
    addressError = ""
    stateError = ""
    zipError = ""
    emailError = ""
    phoneError = ""

  try:
    email = ctx.cookies["email"]
    password = ctx.cookies["password"]
  except:
    email = ""
    password = ""

  try:
    productName = ctx.queryParams["prod"]
    quantity = parseInt(ctx.queryParams["quantity"])
  except:
    productName = ""
    quantity = 0

  if email != "":
    productCount = micsCartProductCount(email, password)

  # if productName == "" and email == "":
    # ctx.redirect("/login")

  var
    country = cookies["c_country"]
    firstName = cookies["c_fname"]
    lastName = cookies["c_lname"]
    address = cookies["c_address"]
    state = cookies["c_state_country"]
    zip = cookies["c_postal_zip"]
    email1 = cookies["c_email_address"]
    phone = cookies["c_phone"]

  if country == "": countryError = "Country is Required"

  if firstName == "": firstNameError = "First Name is Required"

  if lastName == "": lastNameError = "Last Name is Required"

  if address == "": addressError = "Address is Required"

  if state == "": stateError = "State is Required"

  if zip == "": zipError = "Zip is Required"

  if email1 == "": emailError = "Email is Required"

  if phone == "": phoneError = "Phone is Required"

  # if countryError == "" and firstNameError == "" and lastNameError == "" and addressError == "" and stateError == "" and zipError == "" and emailError == "" and phoneError == "":
  #   var
  #     userId = db.getUserId(email, password)
  #     cart = db.getUserCart(userId)
  #     order: Order

  #   order.userId = userId
  #   order.country = country
  #   order.firstName = firstName
  #   order.lastName = lastName
  #   order.address = address
  #   order.state = state
  #   order.zip = zip
  #   order.email = email1
  #   order.phone = phone

  #   db.createOrder(order)

  #   for c, d in cart:
  #     var product = db.getProductById(d.productId)
  #     products.add(product)

  #   db.clearCart(userId)

  #   compileTemplateFile(getScriptDir() / "a3a" / "thankyou.nimja")

  # else:
  #   compileTemplateFile(getScriptDir() / "a3a" / "checkout.nimja")

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

  else:
    var
      userId = db.getUserId(email, password)
    cart = db.getUserCart(userId)
      
    for c, d in cart:
      var product = db.getProductById(d.productId)
      echo product
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

    productName: string
    quantity: int

  try:
    productName = ctx.queryParams["prod"]
    quantity = parseInt(ctx.queryParams["quantity"])

  except:
      productName = ""
      quantity = 0

  if user == true:

    ctx &= initCookie("email", email)
    ctx &= initCookie("password", password)

    if quantity != 0:
      ctx.redirect("/checkout?prod=" & productName & "&quantity=" & $quantity)
      # ctx.redirect(fmt"/checkout?prod={productName}&quantity={quantity}")
    else:

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
