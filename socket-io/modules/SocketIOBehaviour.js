module.exports = function SocketIOBehaviour(rooms){
  return function(socket){


    var room = ''
    socket.on('room', function(_room){
      if( !_room )return
      console.log('-- entering room: ', _room)
      room = _room
      rooms.addTo(room)
      socket.join(room)
      socket.to(room)

      var clientsCount = rooms.countFor(room)
      socket.broadcast.to(room).emit('clientsCount', clientsCount)
      socket.broadcast.to(room).emit('pomodoroSyncRequest')
      socket.emit('clientsCount', clientsCount)
    })
    socket.on('pomodoroSyncResponse', function(remainingTime){
      console.log('-- pomodoroSyncResponse: ', remainingTime)
      socket.broadcast.to(room).emit('pomodoroSyncResponse', remainingTime)
    })
    socket.on('start', function(minutes,type){
      console.log('-- start: ', minutes, type)
      socket.broadcast.to(room).emit('start',minutes,type)
    })
    socket.on('stop', function(minutes,type){
      console.log('-- stop: ', minutes, type)
      socket.broadcast.to(room).emit('stop',minutes,type)
    })
    socket.on('event', function(obj){
      console.log('-- event: ', obj)
      socket.broadcast.to(room).emit('event',obj)
    })
    socket.on('disconnect', function(){
      console.log('-- disconnect')
      rooms.removeFrom(room)
      var clientsCount = rooms.countFor(room)
      socket.broadcast.to(room).emit('clientsCount', clientsCount)
      socket.emit('clientsCount', clientsCount)
    })
  }
}
