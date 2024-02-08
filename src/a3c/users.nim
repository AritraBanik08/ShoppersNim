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