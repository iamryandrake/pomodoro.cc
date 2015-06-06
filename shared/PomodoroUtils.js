 module.exports = {
  getDuration: getDuration,
  getDurationInMinutes: getDurationInMinutes,
  getDurationInHours: getDurationInHours
}

function getDuration(pomodoro){
  if( !pomodoro || pomodoro.startedAt === undefined || pomodoro.minutes === undefined ) {
    return 0
  }
  if( !pomodoro.cancelledAt ){
    return pomodoro.minutes * 60
  }
  if( pomodoro.cancelledAt ) {
    return parseInt((pomodoro.cancelledAt - pomodoro.startedAt)/1000, 10)
  }
  return 0
}


function getDurationInMinutes(pomodoro){
  return parseInt(getDuration(pomodoro)/60, 10)
}
function getDurationInHours(pomodoro){
  return trimDecimals(getDurationInMinutes(pomodoro)/60, 1)
}


function trimDecimals(number,numberOfDecimals){
  var decimals = Math.pow(10,numberOfDecimals)
  return parseInt(number*decimals,10)/decimals
}
