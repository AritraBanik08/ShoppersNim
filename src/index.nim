import
  mike,
  segfaults,
  os,
  httpclient,
  json,
  marshal,
  nimja/parser,
  dotenv,
  ./a3pkg/[models, mics],
  ./a3c/users

proc index*(ctx: Context): string =
  dotenv.load()
  var
    products: seq[Products]
    cookies = ctx.cookies
    user: User
    db = newDatabase()

    email = cookies.getOrDefault("email", "")
    password = cookies.getOrDefault("password", "")

    url = getEnv("DATABASE_URL")
    auth_token = getEnv("AUTH_TOKEN")

    client = newHttpClient()

    body = """
      "requests": [
        { "type": "execute", "stmt": { "sql": "CREATE TABLE IF NOT EXISTS users (id INTEGER PRIMARY KEY AUTOINCREMENT, first_name VARCHAR(255) NOT NULL)" } },
        { "type": "close" }
      ]
    """
      # "requests": [
      #   { "type": "execute", "stmt": { "sql": "SELECT * FROM users" } },
      #   { "type": "close" }
      # ]

  ctx.addHeader("Authorization", "Bearer " & auth_token)
  ctx.addHeader("Content-Type", "application/json")

  # echo ctx.headers
  var res = client.request(url, HttpPost, body, ctx.headers)
  echo $$res

  if email != "":
    products = micsGetProducts(email, password)
    user = db.getUser(email, password)

  compileTemplateFile(getScriptDir() / "a3a" / "index.nimja")
