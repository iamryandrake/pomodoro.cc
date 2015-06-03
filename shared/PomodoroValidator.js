module.exports = {
  isValid: isValid,
  validate: validate
}

function isValid(pomodoro){
  var errors = validate(pomodoro)
  if( Object.keys(errors).length > 0 )
    return false
  return true
}

function validate(pomodoro){
  var errors = {}
  if( Object.keys(pomodoro).length === 0 ){
    errors.minutes = 'required'
    errors.type = 'required'
    errors.startedAt = 'required'
  }
  return errors
}
