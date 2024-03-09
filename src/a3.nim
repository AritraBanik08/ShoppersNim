import
  mike,
  segfaults,
  os,
  nimja/parser,
  strutils,
  strformat,
  ./a3pkg/[models, mics, htmx],
  ./a3c/[products, users, cart, orders]

"/" -> [get, post]:

  var
    products: seq[Products]
    cookies = ctx.cookies

    email = cookies.getOrDefault("email", "")
    password = cookies.getOrDefault("password", "")

  if email == "":
    echo "No cookie found."
  else:
    products = micsGetProducts(email, password)

  compileTemplateFile(getScriptDir() / "a3a" / "index.nimja")

"/about" -> get:
  
  var
    products: seq[Products]
    cookies = ctx.cookies

    email = cookies.getOrDefault("email", "")
    password = cookies.getOrDefault("password", "")

  if email == "":
    echo "No cookie found."
  else:
    products = micsGetProducts(email, password)
    echo "Cookie found."

  compileTemplateFile(getScriptDir() / "a3a" / "about.nimja")

"/cart" -> get:

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

"/update-cart" -> get:
    
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

"/add-to-cart" -> get:
    
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

"/remove-from-cart" -> get:
  
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

"/checkout" -> get:
  echo "get"
  
  var
    db = newDatabase()
    cart: seq[Cart]
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
    ch = "d"

  else:
    var
      userId = db.getUserId(email, password)
    cart = db.getUserCart(userId)
      
    for c, d in cart:
      var product = db.getProductById(d.productId)
      products.add(product)

  compileTemplateFile(getScriptDir() / "a3a" / "checkout.nimja")

"/checkout" -> post:
  echo "post"
  var
    db = newDatabase()
    cart: seq[Cart]
    products: seq[Products]
    productCount = 0
    form = ctx.urlForm
    val: Validity
    validity = initTable[string, Validity]()
    cookies = ctx.cookies

    email = cookies.getOrDefault("email", "")
    password = cookies.getOrDefault("password", "")

    productName = form.getOrDefault("prod", "")
    quantity = parseInt(form.getOrDefault("quantity", "0"))

  var
    country = form["c_country"]
    firstName = form["c_fname"]
    lastName = form["c_lname"]
    address = form["c_address"]
    state = form["c_state_country"]
    zip = form["c_postal_zip"]
    email1 = form["c_email_address"]
    phone = form["c_phone"]
    password1: string

  password1 = form.getOrDefault("password", "")

  if email != "":
    productCount = micsCartProductCount(email, password)

  if country != "" and firstName != "" and lastName != "" and address != "" and state != "" and zip != "" and email != "" and phone != "":
    var
      userId = db.getUserId(email, password)
      cart = db.getUserCart(userId)
      order: Orders
      user: User

    order.userId = userId
    order.country = country
    order.address = address
    order.state = state
    order.postalCode = zip
    order.phoneNumber = phone

    user.firstName = firstName
    user.lastName = lastName
    user.email = email1

    if email == "":
      user.password = password1
      user.accessLevel = 1
      db.createPost(user)
      db.clearCart(userId)

    var _ = db.createOrder(order)

    for c, d in cart:
      var product = db.getProductById(d.productId)
      products.add(product)

    ctx.send(sendThankYou())

  else:

    for a, b in form:
      if form[a] == "":
        val.name = ""
        val.message = "Field is Required"
        val.mark = "is-invalid"
        validity[a] = val
      else:
        val.name = b
        val.message = ""
        val.mark = ""
        if form[a] == "1": # This checks if the country is selected or not
          val.mark = "is-invalid"
        validity[a] = val

    if productName == "":
      var
        userId = db.getUserId(email, password)
      cart = db.getUserCart(userId)
        
      for c, d in cart:
        var product = db.getProductById(d.productId)
        products.add(product)

    else:
      var
        product: Products
        ca: Cart

      product.id = 1
      product.name = productName
      product.price = db.getPriceByProductName(productName)
      ca.quantity = quantity
      products.add(product)
      cart.add(ca)

    ctx.send(sendCheckOut(validity, totalPriceHTML(products, cart)))

"/validation/lname" -> post:
  var lname = ctx.urlForm["c_lname"]
  var val: Validity
  if lname == "":
    val.message = "Last Name is Required"
    val.mark = "is-invalid"
  else:
    val.message = ""
    val.mark = ""
  ctx.send sendLastName(lname, val)

"/validation/fname" -> post:
  var fname = ctx.urlForm["c_fname"]
  var val: Validity
  if fname == "":
    val.message = "First Name is Required"
    val.mark = "is-invalid"
  else:
    val.message = ""
    val.mark = ""
  ctx.send sendFirstName(fname, val)

"/validation/address" -> post:
  var address = ctx.urlForm["c_address"]
  var val: Validity
  if address == "":
    val.message = "Address is Required"
    val.mark = "is-invalid"
  else:
    val.message = ""
    val.mark = ""
  ctx.send sendAddress(address, val)

"/validation/state" -> post:
  var state = ctx.urlForm["c_state_country"]
  var val: Validity
  if state == "":
    val.message = "State is Required"
    val.mark = "is-invalid"
  else:
    val.message = ""
    val.mark = ""
  ctx.send sendState(state, val)

"/validation/zip" -> post:
  var zip = ctx.urlForm["c_postal_zip"]
  var val: Validity
  if zip == "":
    val.message = "Zip is Required"
    val.mark = "is-invalid"
  else:
    val.message = ""
    val.mark = ""
  ctx.send sendZip(zip, val)

"/validation/email" -> post:
  var email = ctx.urlForm["c_email_address"]
  var val: Validity
  if email == "":
    val.message = "Email is Required"
    val.mark = "is-invalid"
  else:
    val.message = ""
    val.mark = ""
  ctx.send sendEmail(email, val)

"/validation/phone" -> post:
  var phone = ctx.urlForm["c_phone"]
  var val: Validity
  if phone == "":
    val.message = "Phone is Required"
    val.mark = "is-invalid"
  else:
    val.message = ""
    val.mark = ""
  ctx.send sendPhone(phone, val)

"/validation/country" -> post:
  var country = ctx.urlForm["c_country"]
  var val: Validity
  if country == "1":
    val.message = ""
    val.mark = "is-invalid"
  else:
    val.message = ""
    val.mark = ""
  ctx.send sendCountry(country, val)

"/contact" -> get:
  
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

"/shop" -> get:
  
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

"/shop-single" -> get:
  
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

"/thankyou" -> get:
  var
    products: seq[Products]
    cookies = ctx.cookies

    email = cookies.getOrDefault("email", "")
    password = cookies.getOrDefault("password", "")

  if email == "":
    ctx.redirect("/login")
  else:
    products = micsGetProducts(email, password)
    
    ctx &= initCookie("c_country", "")
    ctx &= initCookie("c_fname", "")
    ctx &= initCookie("c_lname", "")
    ctx &= initCookie("c_address", "")
    ctx &= initCookie("c_state_country", "")
    ctx &= initCookie("c_postal_zip", "")
    ctx &= initCookie("c_email_address", "")
    ctx &= initCookie("c_phone", "")
    
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
  echo ctx.queryParams
  var
    email = ctx.urlForm["email"]
    password = ctx.urlForm["password"]

    db = newDatabase()

    user = db.userAvailability(email, password)

    loginError = ""
    emailError = ""
    passwordError = ""

    qParams = ctx.queryParams

    productName = qParams.getOrDefault("prod", "")
    quantity = parseInt(qParams.getOrDefault("quantity", "0"))

  if user == true:

    ctx &= initCookie("email", email)
    ctx &= initCookie("password", password)

    if quantity != 0:
      # ctx.redirect("/checkout?prod=" & productName & "&quantity=" & $quantity)
      ctx.redirect(fmt"/checkout?prod={productName}&quantity={quantity}")
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
