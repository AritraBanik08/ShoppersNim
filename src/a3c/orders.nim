import db_connector/db_sqlite

import
  strutils,
  ../a3pkg/models,
  ./users

proc close*(db: DbConn) =
  db.close()

proc setupOrders*(db: DbConn) =
    ## setupOrders creates the orders table if it does not exist
    db.exec(sql"""
      CREATE TABLE IF NOT EXISTS orders (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        user_id INTEGER NOT NULL REFERENCES users(id) ON DELETE CASCADE ON UPDATE CASCADE,
        country VARCHAR(255) NOT NULL,
        address VARCHAR(255) NOT NULL,
        state VARCHAR(255) NOT NULL,
        postal_code VARCHAR(255) NOT NULL,
        phone_number VARCHAR(255) NOT NULL,
        product_id INTEGER NOT NULL REFERENCES products(id) ON DELETE CASCADE ON UPDATE CASCADE,
        quantity INTEGER NOT NULL,
        created_at TEXT DEFAULT CURRENT_TIMESTAMP NOT NULL,
        updated_at TEXT DEFAULT CURRENT_TIMESTAMP NOT NULL,
        order_status VARCHAR(255) NOT NULL,
        order_date VARCHAR(255) NOT NULL
      );
    """)

proc createOrder*(db: DbConn, order:Orders): int64 =
  ## createPost creates a new post and returns the id of the new post
  result = db.insertID(sql"INSERT INTO orders (user_id, country, address, state, postal_code, phone_number, product_id, quantity, order_status, order_date) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?);", order.userId, order.country, order.address, order.state, order.postalCode, order.phoneNumber, order.productId, order.quantity, order.orderStatus, order.orderDate)

proc drop*(db: DbConn) =
  db.exec(sql"DROP TABLE IF EXISTS orders")

proc getOrderAdmin*(db: DbConn): seq[User]=
  var
    row = db.getAllRows(sql"SELECT DISTINCT user_id FROM orders;")
    users: seq[User]
  for a, b in row:
    var
      u = db.getRow(sql"SELECT * FROM users WHERE id=?", b[0])
      user: User
      c = db.getUserOrdersAmount(parseInt(b[0]))

    user.id = parseInt(u[0])
    user.firstName = u[1]
    user.lastName = u[2]
    user.email = u[3]
    user.totalQuantity = c[0]
    user.totalPrice = c[1]

    users.add(user)
  
  return users
