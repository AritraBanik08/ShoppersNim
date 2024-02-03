import db_connector/db_sqlite, strutils

import ../a3pkg/models

type
  Database = ref object
    db: DbConn

proc newDatabase1*(filename = "db5.sqlite3"): Database =
  new result
  result.db = open(filename, "", "", "")

proc close*(database: Database) =
  database.db.close()

proc setupProducts*(database: Database) =
    database.db.exec(sql"""
      CREATE TABLE IF NOT EXISTS products (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name VARCHAR(255) NOT NULL,
        description VARCHAR(1000) NOT NULL,
        type VARCHAR(255) NOT NULL,
        name_page VARCHAR(255) NOT NULL,
        price REAL NOT NULL,
        created_at TEXT DEFAULT CURRENT_TIMESTAMP NOT NULL,
        updated_at TEXT DEFAULT CURRENT_TIMESTAMP NOT NULL,
        pic_URL VARCHAR(255) NOT NULL,
        quantity INTEGER NOT NULL
      );
    """)

proc setupProductsIndex*(database: Database) =
  database.db.exec(sql"""
    CREATE UNIQUE INDEX IF NOT EXISTS products_name_idx ON products (name);
  """)

proc createPost*(database: Database, product:Products): int64 =
  var newID = database.db.insertID(sql"INSERT INTO products (name, description, type, Page_name, price, pic_URL, quantity) VALUES (?, ?, ?, ?, ?);",
  product.name, product.description, product.productType, product.pageName, product.price, product.pic_URL, product.quantity)
  return newID

proc availableProducts*(database: Database): seq[Products]=
  var rows = database.db.getAllRows(sql"SELECT * FROM products WHERE quantity > 0")
  var products: seq[Products]
  for a, b in rows:
    var product: Products
    product.id = parseInt(b[0])
    product.name = b[1]
    product.description = b[2]
    product.productType = b[3]
    product.pageName = b[4]
    product.price = parseFloat(b[5])
    product.picURL = b[8]
    product.quantity = parseInt(b[9])

    products.add(product)

  return products

proc getProduct*(database: Database, name: string): Products =
  var row = database.db.getRow(sql"SELECT * FROM products WHERE name = ?", name)
  var product: Products
  product.id = parseInt(row[0])
  product.name = row[1]
  product.description = row[2]
  product.productType = row[3]
  product.pageName = row[4]
  product.price = parseFloat(row[5])
  product.picURL = row[8]
  product.quantity = parseInt(row[9])

  return product

proc getProductById*(database: Database, id: int): Products =
  var row = database.db.getRow(sql"SELECT * FROM products WHERE id = ?", id)
  var product: Products
  product.id = parseInt(row[0])
  product.name = row[1]
  product.description = row[2]
  product.productType = row[3]
  product.pageName = row[4]
  product.price = parseFloat(row[5])
  product.picURL = row[8]
  product.quantity = parseInt(row[9])

  return product

proc drop*(database: Database) =
  database.db.exec(sql"DROP TABLE IF EXISTS products")