import
  strformat

type
  Validity* = object
    message*: string
    class*: string

proc sendLastName*(lastName: string, input: Validity): string =
  result = fmt"""
    <div
      class="col-md-6"
      hx-target="this"
      hx-swap="outerHTML"
    >
      <label for="c_lname" class="text-black">Last Name <span class="text-danger">*</span></label>
      <label class="{input.class}">{input.message}</label>
      <input type="text" class="form-control" id="c_lname"
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
      <label class="{input.class}">{input.message}</label>
      <input type="text" class="form-control" id="c_fname"
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
      <label class="{input.class}">{input.message}</label>
      <input type="text" class="form-control" id="c_address"
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
      <label class="{input.class}">{input.message}</label>
      <input type="text" class="form-control" id="c_state_country"
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
      <label class="{input.class}">{input.message}</label>
      <input type="text" class="form-control" id="c_postal_zip"
        hx-post="/validation/zip"
        name="c_postal_zip"
        value="{zip}"
      >
    </div>
  """