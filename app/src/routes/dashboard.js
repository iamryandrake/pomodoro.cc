var React = require('react')
  , PomodoroTimer = require('../components/PomodoroTimer')
  , TodoList = require('../components/TodoList')
  , LoginLogout = require('../components/LoginLogout')
  , SoundSettings = require('../components/SoundSettings')
  , PomodoroEventHandler = require('../modules/PomodoroEventHandler')
  , SettingsEventHandler = require('../modules/SettingsEventHandler')
  , Timer = require('../modules/Timer')
  , store = require('store')

module.exports = function(context){
  React.render(<Dashboard/>, document.querySelector('main'))
}


var Dashboard = React.createClass({
  render: function() {
    var remaining = Timer.getRemaining()
    var pomodoroData = store.get('pomodoroData')
    if( remaining <= 0 && pomodoroData ){
      PomodoroEventHandler('end', pomodoroData.minutes, pomodoroData.type)
    }
    var items = []
    try {
      var localStorageItems = localStorage.getItem('todoList')

      var parsedItems = JSON.parse(localStorageItems)
      if( parsedItems instanceof Array ){
        items = parsedItems
      }
    }catch(e){}
    return  <div>
              <header className="prominent-header">
              </header>
              <div className="content limit extended small breath">
                <div className="limit">
                  <TodoList items={items} onAdd={this._todoListOnAdd} onChange={this._todoListOnChange}/>
                  <PomodoroTimer data={pomodoroData} notify={PomodoroEventHandler}/>
                  <SoundSettings/>
                  <div className="limit breath">
                    <LoginLogout onlyLogin={true} text="Keep track of your work, login with" className="big center"/>
                  </div>
                </div>
              </div>
            </div>
  },
  _todoListOnAdd: function(){
    // debugger
  },
  _todoListOnChange: function(){
    // debugger
  }
})
