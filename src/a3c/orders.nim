import db_connector/db_sqlite

import ../a3pkg/models

proc close*(db: DbConn) =
  db.close()

proc setupOrders*(db: DbConn) =
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

# proc createPost*(db: DbConn, order:Orders): int64 =
#   var newID = db.insertID(sql"INSERT INTO orders (user_id, product_id, quantity, order_status, order_date) VALUES (?, ?, ?, ?, ?);",
#   order.userId, order.productId, order.quantity, order.orderStatus, order.orderDate)
#   return newID

proc createPost*(db: DbConn, order:Orders): int64 =
  result = db.insertID(sql"INSERT INTO orders (user_id, country, address, state, postal_code, phone_number, product_id, quantity, order_status, order_date) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?);", order.userId, order.country, order.address, order.state, order.postalCode, order.phoneNumber, order.productId, order.quantity, order.orderStatus, order.orderDate)

proc drop*(db: DbConn) =
  db.exec(sql"DROP TABLE IF EXISTS orders")