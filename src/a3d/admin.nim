import
  mike,
  nimja,
  ../a3pkg/mics,
  ../a3c/[users, orders]

proc admin*(ctx: Context): string=
  var
    db = newDatabase()
    users = db.getOrderAdmin()
    # users = db.getUserCartTable()

  # echov v
  # var users = db.getUserCartTable()

  # echo users

  compileTemplateFile(getScriptDir() / "a3a" / "admin" / "index.html")
