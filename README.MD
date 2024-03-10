# E-Commerce

This is the repository for my e-commerce project made using the [Nim](https://nim-lang.org) Programming language, [SQLite3](https://www.sqlite.org/) and [HTMX](https://htmx.org/)

## Getting Started

Download links:

HTTPS clone URL: https://github.com/AritraBanik08/ShoppersNim.git



These instructions will get you a copy of the project up and running on your local machine for development and testing purposes.

## Prerequisites

Must have [Nim](https://nim-lang.org) version 2.0.2 or higher as well as [SQLite3](https://www.sqlite.org/) must be installed.

## Dependencies

- [mike](https://github.com/ire4ever1190/mike)
- [db_connector/db_sqlite](https://nim-lang.org/docs/db_sqlite.html)
- [times](https://nim-lang.org/docs/times.html)
- [nimja](https://github.com/enthus1ast/nimja)

## Setup

### Setup Database
Firstly you need to create the database using the following command
```
nim c -r src/a3c/database_up.nim
```
Then add the rooms in the rooms table there.
