import
  mike,
  segfaults,
  ./a3d/[admin, cart, about, index, checkout, contact, shop, signup],
  ./a3pkg/validation

"/" -> [get, post]: ctx.index()

"/about" -> get: ctx.about()
  
"/cart" -> get: ctx.cart()
"/update-cart" -> get: ctx.updateCart()
"/add-to-cart" -> get: ctx.addToCart()
"/remove-from-cart" -> get: ctx.removeFromCart()
  
"/cart/checkout" -> [get, post]: ctx.checkOut()

"/validation/checkout" -> post: ctx.validationCheckOut()
"/validation/lname" -> post: ctx.validationLName()
"/validation/fname" -> post: ctx.validationFName()
"/validation/address" -> post: ctx.validationAddress()
"/validation/state" -> post: ctx.validationState()
"/validation/zip" -> post: ctx.validationZip()
"/validation/email" -> post: ctx.validationEmail()
"/validation/phone" -> post: ctx.validationPhone()
"/validation/country" -> post: ctx.validationCountry()

"/contact" -> get: ctx.contact()
  
"/shop" -> get: ctx.shop()
"/shop-single" -> get: ctx.shopSingle()

"/login" -> get: ctx.getLogin()
"/login" -> post: ctx.postLogin()
"/logout" -> get: ctx.logout()
"/signup" -> get: ctx.getSignup()
"/signup" -> post: ctx.postSignup()

"/admin/dashboard" -> get: ctx.admin()

servePublic("src/a3b", "/a3b")

run()
