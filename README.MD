# E-Commerce

This is the repository for my e-commerce project.

## Getting Started

Download links:

SSH clone URL: ssh://git@bitbucket.org:ho004/4a1.git

HTTPS clone URL: https://MyAirPods2@bitbucket.org/ho004/4a1.git



These instructions will get you a copy of the project up and running on your local machine for development and testing purposes.

## Prerequisites

Must have [Nim](https://nim-lang.org) version 2.0.2 or higher installed.

## Dependencies

- [mike](https://github.com/ire4ever1190/mike)
- [db_connector/db_sqlite](https://nim-lang.org/docs/db_sqlite.html)
- [times](https://nim-lang.org/docs/times.html)
- [nimja](https://github.com/enthus1ast/nimja)

Firstly you need to create the database using the following command
```
nim c -r src/a3c/database_up.nim
```
Then add the rooms in the rooms table there.
