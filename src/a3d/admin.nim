import
  mike,
  nimja,
  ../a3pkg/mics,
  ../a3c/[orders, products]

proc admin*(ctx: Context): string=
  var
    db = newDatabase()
    users = db.getOrderAdmin()

  compileTemplateFile(getScriptDir() / "a3a" / "admin" / "index.html")

proc adminShow*(ctx: Context, id: int): string=
  var
    db = newDatabase()
    orders = db.getOrders(id)
  
  compileTemplateFile(getScriptDir() / "a3a" / "admin" / "show.html")
