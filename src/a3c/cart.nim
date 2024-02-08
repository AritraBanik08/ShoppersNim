import db_connector/db_sqlite, strutils, strtabs

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
  ## get the cart details of the user
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

proc addToCart*(db: DbConn, cart: Cart) =
  ## add the product to the cart
  var cartDetails = getUserCart(db, cart.userId)
  for d, f in cartDetails:
    if f.userId == cart.userId and f.productId == cart.productId:
      db.exec(sql"UPDATE cart SET quantity=? WHERE user_id=? AND product_id=?", f.quantity + cart.quantity, cart.userId, cart.productId)
      return

  db.exec(sql"INSERT INTO cart (user_id, product_id, quantity) VALUES (?, ?, ?)", cart.userId, cart.productId, cart.quantity)

proc removeFromCart*(db: DbConn, cart: Cart) =
  ## remove the product from the cart
  db.exec(sql"DELETE FROM cart WHERE user_id=? AND product_id=?", cart.userId, cart.productId)

proc updateCart*(db: DbConn, quantity: string, id: int) =
  ## update the quantity of the product in the cart
  db.exec(sql"UPDATE cart SET quantity=? WHERE id=?", quantity, id)