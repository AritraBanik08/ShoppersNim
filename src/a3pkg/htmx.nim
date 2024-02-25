import
  strformat

type
  Validity* = object
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
      class="col-md-12"
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
      class="col-md-12"
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