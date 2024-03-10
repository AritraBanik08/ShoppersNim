import
  mike,
  nimja

proc admin*(ctx: Context): string=

  compileTemplateFile(getScriptDir() / "a3a" / "admin" / "index.html")