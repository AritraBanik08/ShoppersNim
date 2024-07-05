import
  mike,
  nimja,
  ../a3pkg/mics,
  ../a3c/[orders, products, users]

proc admin*(ctx: Context): string=
  var
    db = newDatabase()
    users = db.getOrderAdmin()

  compileTemplateFile(getScriptDir() / "a3a" / "admin" / "index.html")

proc adminShow*(ctx: Context, id: int): string=
  var
    cookies = ctx.cookies
    adminEmail = cookies.getOrDefault("email", "")
    adminPassword = cookies.getOrDefault("password", "")
  if adminEmail == "":
    ctx.redirect("/login")
  else:
    var
      db = newDatabase()
      orders = db.getOrders(id)
      user = db.getUserByID(id)
      admin = db.getUser(adminEmail, adminPassword)
  
    compileTemplateFile(getScriptDir() / "a3a" / "admin" / "show.html")
