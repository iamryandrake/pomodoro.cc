var React = require('react')
require('react/addons')
var TestUtils = React.addons.TestUtils

var TodoList = require('./TodoList.js')
describe('TodoList', function () {
  it('renders items', function () {
    var items = [{
      done: false,
      text: ''
    }]
    var todoList = TestUtils.renderIntoDocument( <TodoList items={items}/>)
    var elem = TestUtils.scryRenderedDOMComponentsWithTag(todoList, 'li')
    expect( elem.length ).to.eql( 1 )
  })

  xit('is collapsed by default', function () {
    var node = TestUtils.renderIntoDocument( <TodoList/>)
    var elem = TestUtils.findRenderedDOMComponentWithTag(node, 'ul').getDOMNode()
    expect( elem.getAttribute('class') ).to.match(/collapsed/)
  })
  xit('renders children', function () {
    var accordion = <TodoList>
                      <div className="title">child node</div>
                    </TodoList>
    var node = TestUtils.renderIntoDocument( accordion )
    var elems = TestUtils.scryRenderedDOMComponentsWithClass(node, 'title')
    expect( elems.length ).to.eql( 1 )
  })
  xit('recursively renders TodoLists', function () {
    var accordion = <TodoList>
                      <div className="title">child node 1</div>
                      <div className="content">
                        <TodoList>
                          <div className="title">child node 2</div>
                        </TodoList>
                      </div>
                    </TodoList>
    var node = TestUtils.renderIntoDocument( accordion )
    var nodesElems = TestUtils.scryRenderedComponentsWithType(node, TodoList)

    expect( nodesElems.length ).to.eql( 2 )

    var childElems = TestUtils.scryRenderedDOMComponentsWithClass(node, 'content')
    expect( childElems.length ).to.eql( 1 )
  })

  xdescribe('on click', function () {
    it('expands only parent node / does not propagate event down to children', function () {
      var accordion = <TodoList>
                        <div className="title">title</div>
                        <div className="content">
                          <TodoList>
                            <div className="title">child title</div>
                          </TodoList>
                        </div>
                      </TodoList>
      var element = TestUtils.renderIntoDocument( accordion )
      var accordionParentNode = element.getDOMNode()
      TestUtils.Simulate.click( accordionParentNode )
      expect( accordionParentNode.getAttribute('class') ).to.match(/expanded/)
      var accordionChildNode = accordionParentNode.querySelector('ul')
      expect( accordionChildNode.getAttribute('class') ).to.match(/collapsed/)
    })
  })
})

