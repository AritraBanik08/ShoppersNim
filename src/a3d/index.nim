import
  mike,
  segfaults,
  os,
  nimja/parser,
  ../a3pkg/[models, mics],
  ../a3c/users

proc index*(ctx: Context): string =
  var
    products: seq[Products]
    cookies = ctx.cookies
    user: User
    db = newDatabase()

    email = cookies.getOrDefault("email", "")
    password = cookies.getOrDefault("password", "")

  if email != "":
    products = micsGetProducts(email, password)
    user = db.getUser(email, password)

  compileTemplateFile(getScriptDir() / "a3a" / "index.nimja")
