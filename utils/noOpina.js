//  1: No opina
//  2: 10%
//  3: 20%
//  4: 30%
//  5: 40%
//  6: 50%
//  7: 60%
//  8: 70%
//  9: 80%
// 10: 90%
// 11: 100%
[...document.getElementsByClassName('form-group')]
  .flatMap(formGroup => [...formGroup.querySelectorAll('input[value="1"]')])
  .forEach(input => input.checked = true)
