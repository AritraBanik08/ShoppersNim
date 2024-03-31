import
  mike,
  segfaults,
  os,
  nimja/parser,
  ../a3pkg/[models, mics]

proc about*(ctx: Context): string =
  var
    products: seq[Products]
    cookies = ctx.cookies

    email = cookies.getOrDefault("email", "")
    password = cookies.getOrDefault("password", "")

  if email != "":
    products = micsGetProducts(email, password)

  compileTemplateFile(getScriptDir() / "a3a" / "about.nimja")