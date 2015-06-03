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
  if( !pomodoro || Object.keys(pomodoro).length === 0 ){
    errors.minutes = 'required'
    errors.type = 'required'
    errors.startedAt = 'required'
    return errors
  }
  if( !isValidType(pomodoro) ){
    errors.type = '"'+ pomodoro.type +'" is not valid'
  }
  return errors
}

function isValidType(pomodoro){
  return /(pomodoro|break)/.test(pomodoro.type)
}
