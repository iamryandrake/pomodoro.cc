var React = require('react')

var ENTER_KEY = 13

module.exports = React.createClass({
  propTypes : {
    onAdd: React.PropTypes.func.isRequired,
    onUpdate: React.PropTypes.func.isRequired,
    items: React.PropTypes.array.isRequired,
  },
  render: function(){
    console.log( '-- items', this.props.items )
    return  <div>
              <ul>
                <li>
                  <input type="text" placeholder="Add a new task" onKeyUp={this._addItem}/>
                </li>
                {this.props.items.map(function(item){
                  return <TodoListItem done={item.done} text={item.text} reference={item.reference} onUpdate={this._onUpdate}/>
                }.bind(this))}
              </ul>
            </div>
    return null
  },
  _addItem: function(event){
    var itemText = event.target.value
    if( ENTER_KEY === event.which && itemText ){
      return this.props.onAdd(itemText)
    }
  },
  _onUpdate: function(reference, item){
    this.props.items = this.props.ditems.map(function(_item){
      if( _item.reference === reference ){
        _item = item
      }
      return item
    })
    this.props.onUpdate(this.props.items)
  }
})

var TodoListItem = React.createClass({
  propTypes : {
    onUpdate: React.PropTypes.func.isRequired,
    reference: React.PropTypes.number.isRequired,
    done: React.PropTypes.bool.isRequired,
    text: React.PropTypes.string.isRequired,
  },
  getInitialState: function(){
    return {
      done: this.props.done,
      text: this.props.text,
    }
  },
  render: function(){
    return  <li>
              <input type="checkbox" value={this.state.done} onChange={this._onChange('checkbox')}/>
              <input type="text" value={this.state.text} onChange={this._onChange('textfield')}/>
            </li>
  },
  _onChange: function(type){
    if( 'textfield' === type ){
      return this._textfieldOnChangeHandler
    }
    return this._checkboxOnChangeHandler
  },
  _checkboxOnChangeHandler: function(event){
    var done = /true/.test(event.target.value)
    this.setState({
      done: done
    }, function(){
      this.props.onUpdate(this.props.reference, this.state)
    }.bind(this))
  },
  _textfieldOnChangeHandler: function(){
    var text = event.target.value
    this.setState({
      text: text
    }, function(){
      this.props.onUpdate(this.props.reference, this.state)
    }.bind(this))
  },
})