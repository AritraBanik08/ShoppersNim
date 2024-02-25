import
  strformat,
  tables,
  strutils,
  ./models

type
  Validity* = object
    name*: string
    message*: string
    mark*: string

proc sendLastName*(lastName: string, input: Validity): string =
  result = fmt"""
    <div
      class="col-md-6"
      hx-target="this"
      hx-swap="outerHTML"
    >
      <label for="c_lname" class="text-black">Last Name <span class="text-danger">*</span></label>
      <input type="text" class="form-control {input.mark}" id="c_lname"
        placeholder="{input.message}"
        hx-post="lname"
        name="c_lname"
        value="{lastName}"
      >
    </div>
  """

proc sendFirstName*(firstName: string, input: Validity): string =
  result = fmt"""
    <div
      class="col-md-6"
      hx-target="this"
      hx-swap="outerHTML"
    >
      <label for="c_lname" class="text-black">First Name <span class="text-danger">*</span></label>
      <input type="text" class="form-control {input.mark}" id="c_fname"
        placeholder="{input.message}"
        hx-post="/validation/fname"
        name="c_fname"
        value="{firstName}"
      >
    </div>
  """

proc sendAddress*(address: string, input: Validity): string =
  result = fmt"""
    <div
      class="col-md-12"
      hx-target="this"
      hx-swap="outerHTML"
    >
      <label for="c_address" class="text-black">Address <span class="text-danger">*</span></label>
      <input type="text" class="form-control {input.mark}" id="c_address"
        placeholder="{input.message}"
        hx-post="/validation/address"
        name="c_address"
        value="{address}"
      >
    </div>
  """

proc sendState*(state: string, input: Validity): string =
  result = fmt"""
    <div
      class="col-md-6"
      hx-target="this"
      hx-swap="outerHTML"
    >
      <label for="c_state" class="text-black">State <span class="text-danger">*</span></label>
      <input type="text" class="form-control {input.mark}" id="c_state_country"
        placeholder="{input.message}"
        hx-post="/validation/state"
        name="c_state_country"
        value="{state}"
      >
    </div>
  """

proc sendZip*(zip: string, input: Validity): string =
  result = fmt"""
    <div
      class="col-md-6"
      hx-target="this"
      hx-swap="outerHTML"
    >
      <label for="c_zip" class="text-black">Posta / Zip <span class="text-danger">*</span></label>
      <input type="text" class="form-control {input.mark}" id="c_postal_zip"
        placeholder="{input.message}"
        hx-post="/validation/zip"
        name="c_postal_zip"
        value="{zip}"
      >
    </div>
  """

proc sendEmail*(email: string, input: Validity): string =
  result = fmt"""
    <div
      class="col-md-6"
      hx-target="this"
      hx-swap="outerHTML"
    >
      <label for="c_email" class="text-black">Email <span class="text-danger">*</span></label>
      <input type="text" class="form-control {input.mark}" id="c_email_address"
        placeholder="{input.message}"
        hx-post="/validation/email"
        name="c_email_address"
        value="{email}"
      >
    </div>
  """

proc sendPhone*(phone: string, input: Validity): string =
  result = fmt"""
    <div
      class="col-md-6"
      hx-target="this"
      hx-swap="outerHTML"
    >
      <label for="c_phone" class="text-black">Phone <span class="text-danger">*</span></label>
      <input type="text" class="form-control {input.mark}" id="c_phone"
        placeholder="{input.message}"
        hx-post="/validation/phone"
        name="c_phone"
        value="{phone}"
      >
    </div>
  """

proc sendCheckOut*(val: Table[string, Validity], total: string): string =
  result = fmt"""
    <div class="container" id="change">
      <div class="row mb-5">
        <div class="col-md-12">
          <div class="border p-4 rounded" role="alert">
            Returning customer? <a href="/login?prod={{productName}}&quantity={{quantity}}" onclick="login()">Click here</a> to login
          </div>
        </div>
      </div>
      <form
        hx-trigger="submit"
        hx-post="/checkout"
        hx-target="#change"
        class="row"
      >
        <div class="col-md-6 mb-5 mb-md-0">
          <h2 class="h3 mb-3 text-black">Billing Details</h2>
          <div class="p-3 p-lg-5 border">
            <div class="form-group">
              <label for="c_country" class="text-black">Country <span class="text-danger">*</span></label>
              <select id="c_country" class="form-control" name="c_country">
                <option value="1">Select a country</option>    
                <option value="2">bangladesh</option>    
                <option value="3">Algeria</option>    
                <option value="4">Afghanistan</option>    
                <option value="5">Ghana</option>    
                <option value="6">Albania</option>    
                <option value="7">Bahrain</option>    
                <option value="8">Colombia</option>    
                <option value="9">Dominican Republic</option>    
                <option value="10">India</option>
              </select>
            </div>
            <div class="form-group row">
              <div
                class="col-md-6"
                hx-target="this"
                hx-swap="outerHTML"
              >
                <label for="c_fname" class="text-black">First Name <span class="text-danger">*</span></label>
                <input type="text" class="form-control {val["c_fname"].mark}" id="c_fname"
                  placeholder="{val["c_fname"].message}"
                  hx-post="/validation/fname"
                  name="c_fname"
                  value="{val["c_fname"].name}"
                >
              </div>
              <div
                class="col-md-6"
                hx-target="this"
                hx-swap="outerHTML"
              >
                <label for="c_lname" class="text-black">Last Name <span class="text-danger">*</span></label>
                <input type="text" class="form-control {val["c_lname"].mark}" id="c_lname"
                  placeholder="{val["c_lname"].message}"
                  hx-post="/lname"
                  name="c_lname"
                  value="{val["c_lname"].name}"
                >
              </div>
            </div>

            <div class="form-group row">
              <div
                class="col-md-12"
                hx-target="this"
                hx-swap="outerHTML"
              >
                <label for="c_address" class="text-black">Address <span class="text-danger">*</span></label>
                <input type="text" class="form-control {val["c_address"].mark}" id="c_address" name="c_address"
                  placeholder="{val["c_address"].message}"
                  placeholder="Street address"
                  hx-post="/validation/address"
                  value="{val["c_address"].name}"
                >
              </div>
            </div>

            <div class="form-group">
              <input type="text" class="form-control" placeholder="Apartment, suite, unit etc. (optional)">
            </div>

            <div class="form-group row">
              <div
                class="col-md-6"
                hx-target="this"
                hx-swap="outerHTML"
              >
                <label for="c_state_country" class="text-black">State / Country <span class="text-danger">*</span></label>
                <input type="text" class="form-control {val["c_state_country"].mark}" id="c_state_country"
                  placeholder="{val["c_state_country"].message}"
                  hx-post="/validation/state"
                  name="c_state_country"
                  value="{val["c_state_country"].name}"
                >
              </div>

              <div
                class="col-md-6"
                hx-target="this"
                hx-swap="outerHTML"
              >
                <label for="c_postal_zip" class="text-black">Posta / Zip <span class="text-danger">*</span></label>
                <input type="text" class="form-control {val["c_postal_zip"].mark}" id="c_postal_zip"
                  placeholder="{val["c_postal_zip"].message}"
                  hx-post="/validation/zip"
                  name="c_postal_zip"
                  value="{val["c_postal_zip"].name}"
                >
              </div>
            </div>

            <div class="form-group row mb-5">
              <div
                class="col-md-6"
                hx-target="this"
                hx-swap="outerHTML"
              >
                <label for="c_email_address" class="text-black">Email Address <span class="text-danger">*</span></label>
                <input type="text" class="form-control {val["c_email_address"].mark}" id="c_email_address"
                  placeholder="{val["c_email_address"].message}"
                  hx-post="/validation/email"
                  name="c_email_address"
                  value="{val["c_email_address"].name}"
                >
              </div>
              <div
                class="col-md-6"
                hx-target="this"
                hx-swap="outerHTML"
              >
                <label for="c_phone" class="text-black">Phone <span class="text-danger">*</span></label>
                <input type="text" class="form-control {val["c_phone"].mark}" id="c_phone"
                  placeholder="{val["c_phone"].message}"
                  hx-post="/validation/phone"
                  name="c_phone"
                  value="{val["c_phone"].name}"
                >
              </div>
            </div>

            <div class="form-group">
              <label for="c_create_account" class="text-black" data-toggle="collapse" href="#create_an_account" role="button" aria-expanded="false" aria-controls="create_an_account"><input type="checkbox" value="1" id="c_create_account"> Create an account?</label>
              <div class="collapse" id="create_an_account">
                <div class="py-2">
                  <p class="mb-3">Create an account by entering the information below. If you are a returning customer please login at the top of the page.</p>
                  <div class="form-group">
                    <label for="c_account_password" class="text-black">Account Password</label>
                    <input type="email" class="form-control" id="c_account_password" name="c_account_password" placeholder="">
                  </div>
                </div>
              </div>
            </div>


            <div class="form-group">
              <label for="c_ship_different_address" class="text-black" data-toggle="collapse" href="#ship_different_address" role="button" aria-expanded="false" aria-controls="ship_different_address"><input type="checkbox" value="1" id="c_ship_different_address"> Ship To A Different Address?</label>
              <div class="collapse" id="ship_different_address">
                <div class="py-2">

                  <div class="form-group">
                    <label for="c_diff_country" class="text-black">Country <span class="text-danger">*</span></label>
                    <select id="c_diff_country" class="form-control">
                      <option value="1">Select a country</option>    
                      <option value="2">bangladesh</option>    
                      <option value="3">Algeria</option>    
                      <option value="4">Afghanistan</option>    
                      <option value="5">Ghana</option>    
                      <option value="6">Albania</option>    
                      <option value="7">Bahrain</option>    
                      <option value="8">Colombia</option>    
                      <option value="9">Dominican Republic</option>
                      <option value="10">India</option>    
                    </select>
                  </div>


                  <div class="form-group row">
                    <div class="col-md-6">
                      <label for="c_diff_fname" class="text-black">First Name <span class="text-danger">*</span></label>
                      <input type="text" class="form-control" id="c_diff_fname" name="c_diff_fname">
                    </div>
                    <div class="col-md-6">
                      <label for="c_diff_lname" class="text-black">Last Name <span class="text-danger">*</span></label>
                      <input type="text" class="form-control" id="c_diff_lname" name="c_diff_lname">
                    </div>
                  </div>

                  <div class="form-group row">
                    <div class="col-md-12">
                      <label for="c_diff_address" class="text-black">Address <span class="text-danger">*</span></label>
                      <input type="text" class="form-control" id="c_diff_address" name="c_diff_address" placeholder="Street address">
                    </div>
                  </div>

                  <div class="form-group">
                    <input type="text" class="form-control" placeholder="Apartment, suite, unit etc. (optional)">
                  </div>

                  <div class="form-group row">
                    <div class="col-md-6">
                      <label for="c_diff_state_country" class="text-black">State / Country <span class="text-danger">*</span></label>
                      <input type="text" class="form-control" id="c_diff_state_country" name="c_diff_state_country">
                    </div>
                    <div class="col-md-6">
                      <label for="c_diff_postal_zip" class="text-black">Posta / Zip <span class="text-danger">*</span></label>
                      <input type="text" class="form-control" id="c_diff_postal_zip" name="c_diff_postal_zip">
                    </div>
                  </div>

                  <div class="form-group row mb-5">
                    <div class="col-md-6">
                      <label for="c_diff_email_address" class="text-black">Email Address <span class="text-danger">*</span></label>
                      <input type="text" class="form-control" id="c_diff_email_address" name="c_diff_email_address">
                    </div>
                    <div class="col-md-6">
                      <label for="c_diff_phone" class="text-black">Phone <span class="text-danger">*</span></label>
                      <input type="text" class="form-control" id="c_diff_phone" name="c_diff_phone" placeholder="Phone Number">
                    </div>
                  </div>

                </div>

              </div>
            </div>

            <div class="form-group">
              <label for="c_order_notes" class="text-black">Order Notes</label>
              <textarea name="c_order_notes" id="c_order_notes" cols="30" rows="5" class="form-control" placeholder="Write your notes here..."></textarea>
            </div>

          </div>
        </div>
        <div class="col-md-6">

          <div class="row mb-5">
            <div class="col-md-12">
              <h2 class="h3 mb-3 text-black">Coupon Code</h2>
              <div class="p-3 p-lg-5 border">
                
                <label for="c_code" class="text-black mb-3">Enter your coupon code if you have one</label>
                <div class="input-group w-75">
                  <input type="text" class="form-control" id="c_code" placeholder="Coupon Code" aria-label="Coupon Code" aria-describedby="button-addon2">
                  <div class="input-group-append">
                    <button class="btn btn-primary btn-sm" type="button" id="button-addon2">Apply</button>
                  </div>
                </div>

              </div>
            </div>
          </div>
          
          <div class="row mb-5">
            <div class="col-md-12">
              <h2 class="h3 mb-3 text-black">Your Order</h2>
              <div class="p-3 p-lg-5 border">
                <table class="table site-block-order-table mb-5">
                  <thead>
                    <th>Product</th>
                    <th>Total</th>
                  </thead>
                  {total}
                </table>

                <div class="border p-3 mb-3">
                  <h3 class="h6 mb-0"><a class="d-block" data-toggle="collapse" href="#collapsebank" role="button" aria-expanded="false" aria-controls="collapsebank">Direct Bank Transfer</a></h3>

                  <div class="collapse" id="collapsebank">
                    <div class="py-2">
                      <p class="mb-0">Make your payment directly into our bank account. Please use your Order ID as the payment reference. Your order won’t be shipped until the funds have cleared in our account.</p>
                    </div>
                  </div>
                </div>

                <div class="border p-3 mb-3">
                  <h3 class="h6 mb-0"><a class="d-block" data-toggle="collapse" href="#collapsecheque" role="button" aria-expanded="false" aria-controls="collapsecheque">Cheque Payment</a></h3>

                  <div class="collapse" id="collapsecheque">
                    <div class="py-2">
                      <p class="mb-0">Make your payment directly into our bank account. Please use your Order ID as the payment reference. Your order won’t be shipped until the funds have cleared in our account.</p>
                    </div>
                  </div>
                </div>

                <div class="border p-3 mb-5">
                  <h3 class="h6 mb-0"><a class="d-block" data-toggle="collapse" href="#collapsepaypal" role="button" aria-expanded="false" aria-controls="collapsepaypal">Paypal</a></h3>

                  <div class="collapse" id="collapsepaypal">
                    <div class="py-2">
                      <p class="mb-0">Make your payment directly into our bank account. Please use your Order ID as the payment reference. Your order won’t be shipped until the funds have cleared in our account.</p>
                    </div>
                  </div>
                </div>

                <div class="form-group">
                  <button type="submit" class="btn btn-primary btn-lg py-3 btn-block">Place Order</button>
                </div>

              </div>
            </div>
          </div>

        </div>
      </form>
    </div>
  """

proc totalPriceHTML*(products: seq[Products], cart: seq[Cart]): string=
  var
    total: float = 0.0
    fru = ""

  for id, product in products:
    fru.add("""
      <tr>
        <td>$1 <strong class="mx-2">x</strong> $2</td>
        <td>₹$3</td>
      </tr>
    """ % [product.name, $toFloat(cart[id].quantity), $(toFloat(cart[id].quantity)*product.price)])

    total = total + toFloat(cart[id].quantity)*product.price

  result = fmt"""
    <tbody>
      {fru}

      <tr>
        <td class="text-black font-weight-bold"><strong>Cart Subtotal</strong></td>
        <td class="text-black">₹{total}</td>
      </tr>
      <tr>
        <td class="text-black font-weight-bold"><strong>Order Total</strong></td>
        <td class="text-black font-weight-bold"><strong>₹{total}</strong></td>
      </tr>
    </tbody>
  """

proc sendThankYou*(): string=
  result = """
    <div class="container">
      <div class="row">
        <div class="col-md-12 text-center">
          <span class="icon-check_circle display-3 text-success"></span>
          <h2 class="display-3 text-black">Thank you!</h2>
          <p class="lead mb-5">You order was successfuly completed.</p>
          <p><a href="/shop" class="btn btn-sm btn-primary">Back to shop</a></p>
        </div>
      </div>
    </div>
  """