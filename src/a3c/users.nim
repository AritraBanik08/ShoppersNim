import
  db_connector/db_sqlite,
  strutils

import ../a3pkg/models

type
  Database = ref object
    db: DbConn

proc newDatabase2*(filename = "db5.sqlite3"): Database =
  new result
  result.db = open(filename, "", "", "")

proc close*(database: Database) =
  database.db.close()

proc setupUsers*(database: Database) =
    database.db.exec(sql"""
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

proc createPost*(database: Database, user: User) =
  database.db.exec(sql"INSERT INTO users (first_name, last_name, email, password, access_level) VALUES (?, ?, ?, ?, ?);", user.firstName, user.lastName, user.email, user.password, user.accessLevel)

proc drop*(database: Database) =
  database.db.exec(sql"DROP TABLE IF EXISTS users")

proc userAvailability*(database: Database, user, password: string): bool =
  var row = database.db.getRow(sql"SELECT * FROM users WHERE email = ? and password = ?;", user, password)

  if row[0] != "":
    return true
  else:
    return false

proc getUserId*(database: Database, user, password: string): int =
  var row = database.db.getRow(sql"SELECT * FROM users WHERE email = ? and password = ?;", user, password)

  result = parseInt(row[0])
