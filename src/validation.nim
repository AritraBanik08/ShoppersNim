import
  mike,
  segfaults,
  strutils,
  ./a3pkg/[models, mics, htmx],
  ./a3c/[products, users, cart, orders]

proc validationCheckOut*(ctx: Context) =
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

proc validationLName*(ctx: Context) =
  var lname = ctx.urlForm["c_lname"]
  var val: Validity
  if lname == "":
    val.message = "Last Name is Required"
    val.mark = "is-invalid"
  else:
    val.message = ""
    val.mark = ""
  ctx.send sendLastName(lname, val)

proc validationFName*(ctx: Context) =
  var fname = ctx.urlForm["c_fname"]
  var val: Validity
  if fname == "":
    val.message = "First Name is Required"
    val.mark = "is-invalid"
  else:
    val.message = ""
    val.mark = ""
  ctx.send sendFirstName(fname, val)

proc validationAddress*(ctx: Context) =
  var address = ctx.urlForm["c_address"]
  var val: Validity
  if address == "":
    val.message = "Address is Required"
    val.mark = "is-invalid"
  else:
    val.message = ""
    val.mark = ""
  ctx.send sendAddress(address, val)

proc validationState*(ctx: Context) =
  var state = ctx.urlForm["c_state_country"]
  var val: Validity
  if state == "":
    val.message = "State is Required"
    val.mark = "is-invalid"
  else:
    val.message = ""
    val.mark = ""
  ctx.send sendState(state, val)

proc validationZip*(ctx: Context) =
  var zip = ctx.urlForm["c_postal_zip"]
  var val: Validity
  if zip == "":
    val.message = "Zip is Required"
    val.mark = "is-invalid"
  else:
    val.message = ""
    val.mark = ""
  ctx.send sendZip(zip, val)

proc validationEmail*(ctx: Context) =
  var email = ctx.urlForm["c_email_address"]
  var val: Validity
  if email == "":
    val.message = "Email is Required"
    val.mark = "is-invalid"
  else:
    val.message = ""
    val.mark = ""
  ctx.send sendEmail(email, val)

proc validationPhone*(ctx: Context) =
  var phone = ctx.urlForm["c_phone"]
  var val: Validity
  if phone == "":
    val.message = "Phone is Required"
    val.mark = "is-invalid"
  else:
    val.message = ""
    val.mark = ""
  ctx.send sendPhone(phone, val)

proc validationCountry*(ctx: Context) =
  var country = ctx.urlForm["c_country"]
  var val: Validity
  if country == "1":
    val.message = ""
    val.mark = "is-invalid"
  else:
    val.message = ""
    val.mark = ""
  ctx.send sendCountry(country, val)