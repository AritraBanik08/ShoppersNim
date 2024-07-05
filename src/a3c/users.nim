import
  db_connector/db_sqlite,
  strutils

import ../a3pkg/models

proc close*(db: DbConn) =
  db.close()

proc setupUsers*(db: DbConn) =
    db.exec(sql"""
      CREATE TABLE IF NOT EXISTS users (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        first_name VARCHAR(255) NOT NULL,
        last_name VARCHAR(255) NOT NULL,
        email VARCHAR(255) NOT NULL UNIQUE,
        password VARCHAR(255) NOT NULL,
        created_at TEXT DEFAULT CURRENT_TIMESTAMP NOT NULL,
        updated_at TEXT DEFAULT CURRENT_TIMESTAMP NOT NULL,
        access_level INTEGER NOT NULL
      )
    """)

proc createPost*(db: DbConn, user: User) =
  db.exec(sql"INSERT INTO users (first_name, last_name, email, password, access_level) VALUES (?, ?, ?, ?, ?);", user.firstName, user.lastName, user.email, user.password, user.accessLevel)

proc drop*(db: DbConn) =
  db.exec(sql"DROP TABLE IF EXISTS users")

proc userAvailability*(db: DbConn, user, password: string): bool =
  ## Check if user exists in db
  var row = db.getRow(sql"SELECT * FROM users WHERE email = ? and password = ?;", user, password)

  if row[0] != "":
    return true
  else:
    return false

proc getUserId*(db: DbConn, user, password: string): int =
  ## Get user id from db
  var row = db.getRow(sql"SELECT * FROM users WHERE email = ? and password = ?;", user, password)

  result = parseInt(row[0])

proc getUser*(db: DbConn, email, password: string): User =
  ## Get user from db
  var
    row = db.getRow(sql"SELECT * FROM users WHERE email = ? and password = ?;", email, password)

    user: User

  user.id = parseInt(row[0])
  user.firstName = row[1]
  user.lastName = row[2]
  user.email = row[3]
  user.password = row[4]
  user.accessLevel = parseInt(row[7])

  return user

proc getUserOrdersAmount*(db: DbConn, userId: int): (int, float)=
  var
    row = db.getAllRows(sql"SELECT * FROM orders WHERE user_id=?", userId)
    totalQuantity = 0
    totalPrice = 0.0
  # echo row
  for b, c in row:
    var
      quantity = c[8]
      row1 = db.getValue(sql"SELECT price FROM products WHERE id=?", c[7])
  
    totalQuantity = totalQuantity + parseInt(quantity)
    totalPrice = totalPrice + parseFloat(quantity) * parseFloat(row1)
  return (totalQuantity, totalPrice)

proc getUserCartTable*(db: DbConn): seq[User]=
  var
    row = db.getAllRows(sql"SELECT * FROM users;")
    users: seq[User]

  for a, b in row:
    var
      c = db.getUserOrdersAmount(parseInt(b[0]))
      user: User

    user.id = parseInt(b[0])
    user.firstName = b[1]
    user.lastName = b[2]
    user.email = b[3]
    user.totalQuantity = c[0]
    user.totalPrice = c[1]

    users.add(user)

  return users

proc getUserByID*(db: DbConn, id: int): User=
  var row = db.getRow(sql"SELECT * FROM users WHERE id=?", id)
 
  result.id = parseInt(row[0])
  result.firstName = row[1]
  result.lastName = row[2]
  result.email = row[3]
  result.password = row[4]
  result.accessLevel = parseInt(row[7])
