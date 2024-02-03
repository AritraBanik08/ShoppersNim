import db_connector/db_sqlite

import ../a3pkg/models

type
  Database = ref object
    db: DbConn

proc newDatabase4*(filename = "db5.sqlite3"): Database =
  new result
  result.db = open(filename, "", "", "")

proc close*(database: Database) =
  database.db.close()

proc setupOrders*(database: Database) =
    database.db.exec(sql"""
      CREATE TABLE IF NOT EXISTS orders (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        user_id INTEGER NOT NULL REFERENCES users(id) ON DELETE CASCADE ON UPDATE CASCADE,
        product_id INTEGER NOT NULL REFERENCES products(id) ON DELETE CASCADE ON UPDATE CASCADE,
        quantity INTEGER NOT NULL,
        created_at TEXT DEFAULT CURRENT_TIMESTAMP NOT NULL,
        updated_at TEXT DEFAULT CURRENT_TIMESTAMP NOT NULL,
        order_status VARCHAR(255) NOT NULL,
        order_date VARCHAR(255) NOT NULL
      );
    """)

proc createPost*(database: Database, order:Orders): int64 =
  var newID = database.db.insertID(sql"INSERT INTO orders (user_id, product_id, quantity, order_status, order_date) VALUES (?, ?, ?, ?, ?);",
  order.userId, order.productId, order.quantity, order.orderStatus, order.orderDate)
  return newID

proc drop*(database: Database) =
  database.db.exec(sql"DROP TABLE IF EXISTS orders")