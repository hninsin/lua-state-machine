require("busted")

local machine = require("fsm")

local stoplight =  {
  { name = 'warn',  from = 'green',  to = 'yellow' },
  { name = 'panic', from = 'yellow', to = 'red'    },
  { name = 'calm',  from = 'red',    to = 'yellow' },
  { name = 'clear', from = 'yellow', to = 'green'  }
}

describe("Lua state machine framework", function()
  describe("A stop light", function()
    it("should start as green", function()
      local fsm = machine.create({ initial = 'green', events = stoplight })
      assert.are.equal(fsm.current, 'green')
    end)

    it("should not let you get to the wrong state", function()
      local fsm = machine.create({ initial = 'green', events = stoplight })
      assert.is_false(fsm:panic())
      assert.is_false(fsm:calm())
      assert.is_false(fsm:clear())
    end)

    it("should let you go to yellow", function()
      local fsm = machine.create({ initial = 'green', events = stoplight })
      assert.is_true(fsm:warn())
      assert.are.equal(fsm.current, 'yellow')
    end)

    it("should tell you what it can do", function()
      local fsm = machine.create({ initial = 'green', events = stoplight })
      assert.is_true(fsm:can('warn'))
      assert.is_false(fsm:can('panic'))
      assert.is_false(fsm:can('calm'))
      assert.is_false(fsm:can('clear'))
    end)

    it("should tell you what it can't do", function()
      local fsm = machine.create({ initial = 'green', events = stoplight })
      assert.is_false(fsm:cannot('warn'))
      assert.is_true(fsm:cannot('panic'))
      assert.is_true(fsm:cannot('calm'))
      assert.is_true(fsm:cannot('clear'))
    end)

    it("should support checking states", function()
      local fsm = machine.create({ initial = 'green', events = stoplight })
      assert.is_true(fsm:is('green'))
      assert.is_false(fsm:is('red'))
      assert.is_false(fsm:is('yellow'))
    end)

    it("should fire the onwarn handler", function()
      local fsm = machine.create({ initial = 'green', events = stoplight })
      fsm.onwarn = function(self, name, from, to) 
        self.called = true
      end

      fsm:warn()

      assert.is_true(fsm.called)
    end)

  end)
end)
