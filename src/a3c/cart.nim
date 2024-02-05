import db_connector/db_sqlite, strutils

import ../a3pkg/models

proc close*(db: DbConn) =
  db.close()

proc setupCart*(db: DbConn) =
    db.exec(sql"""
      CREATE TABLE IF NOT EXISTS cart (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        user_id INTEGER NOT NULL REFERENCES users(id) ON DELETE CASCADE ON UPDATE CASCADE,
        product_id INTEGER NOT NULL REFERENCES products(id) ON DELETE CASCADE ON UPDATE CASCADE,
        quantity INTEGER NOT NULL,
        created_at TEXT DEFAULT CURRENT_TIMESTAMP NOT NULL,
        updated_at TEXT DEFAULT CURRENT_TIMESTAMP NOT NULL
      )
    """)

proc createPost*(db: DbConn, cart: Cart) =
  db.exec(sql"INSERT INTO cart (?, ?, ?, ?, ?);", cart.userId, cart.productId, cart.quantity, cart.created_at, cart.updated_at)

proc drop*(db: DbConn) =
  db.exec(sql"DROP TABLE IF EXISTS cart")

proc getUserCart*(db: DbConn, userId: int): seq[Cart] =
  var
    row = db.getAllRows(sql"SELECT * FROM cart WHERE user_id=?", userId)
    cartDetails: seq[Cart]

  for b, c in row:
    var product: Cart
    product.id = parseInt(c[0])
    product.userId = parseInt(c[1])
    product.productId = parseInt(c[2])
    product.quantity = parseInt(c[3])

    cartDetails.add(product)

  return cartDetails