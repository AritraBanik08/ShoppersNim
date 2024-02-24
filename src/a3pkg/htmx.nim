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
