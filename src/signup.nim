import
  mike,
  segfaults,
  os,
  nimja/parser,
  strutils,
  ./a3pkg/[models, mics],
  ./a3c/[users]

proc getLogin*(ctx: Context): string=
  
  var
    loginError = ""
    emailError = ""
    passwordError = ""

    email = ""
    password = ""

  compileTemplateFile(getScriptDir() / "a3a" / "login.nimja")

proc postLogin*(ctx: Context): string=
  
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
      ctx.redirect("/cart/checkout?prod=" & productName & "&quantity=" & $quantity)
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

proc logout*(ctx: Context)=
  ctx &= initCookie("email", "")
  ctx &= initCookie("password", "")

  ctx.redirect("/login")

proc getSignup*(ctx: Context): string=
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

proc postSignup*(ctx: Context): string= 
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
