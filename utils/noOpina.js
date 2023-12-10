[...document.getElementsByClassName('form-group')]
  .flatMap(formGroup => [...formGroup.querySelectorAll('input[value="9"]')])
  .forEach(input => input.checked = true)
