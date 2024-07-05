import
  mike,
  segfaults,
  os,
  httpclient,
  json,
  nimja/parser,
  dotenv
  # ./a3pkg/[models, mics],
  # ./a3c/[users]

proc tro*(ctx: Context): JsonNode =
  dotenv.load()
  var
    url = getEnv("DATABASE_URL")
    auth_token = getEnv("AUTH_TOKEN")

    client = newHttpClient()

    ss = """DROP TABLE users;"""

    body = %*{
      "requests": [
        { "type": "execute", "stmt": { "sql": ss } },
        { "type": "close" }
      ]
    }

  #   user: User
  #   db = newDatabase()
  # user.firstName = "Kalpak"
  # user.lastName = "Lahiri"
  # user.email = "kalpak@lahiri.kl"
  # user.password = "kalpak"
  # user.accessLevel = 1
  # db.createPost(user)

  echo body
  client.headers = newHttpHeaders({ "Authorization": "Bearer " & auth_token, "Content-Type": "application/json" })
  echo client.headers

  var
    res = client.request(url, httpMethod = HttpPost, body = $body, headers = client.headers)
    bb = parseJson(res.body)
    g = bb["results"][0]["result"]["data"]

  echo g
  return g