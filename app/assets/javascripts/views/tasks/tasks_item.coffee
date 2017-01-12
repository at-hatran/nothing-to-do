class Railsbackbone.Views.TasksItem extends Backbone.View
  tagName: 'li'

  # template: JST['tasks/item.jst']
  template: _.template(
    "<div class='view'>
      <input class='toggle' type='checkbox' <%= completed ? 'checked' : '' %>>
      <label><%- title %></label>
      <button class='destroy'></button>
    </div>
    <input class='edit' value='<%- title %>'>"
  )

  events: {
    'click .toggle': 'toggleCompleted',
    'dblclick label': 'edit',
    'click .destroy': 'clear',
    'keypress .edit': 'updateOnEnter',
    'keydown .edit': 'revertOnEscape',
    'blur .edit': 'close'
  }

  initialize: ->
    this.listenTo(@model, 'change', this.render)
    this.listenTo(@model, 'destroy', this.remove)
    this.listenTo(@model, 'visible', this.toggleVisible)


  render: ->
    this.$el.html(this.template(@model.toJSON()))
    this.$el.toggleClass('completed', @model.get('completed'))
    this.toggleVisible()
    this.$input = this.$('.edit')
    this


  toggleVisible: ->
    this.$el.toggleClass('hidden', this.isHidden())


  isHidden: ->
    return @model.get('completed') ?
      Railsbackbone.TodoFilter == 'active' : \
      Railsbackbone.TodoFilter == 'completed'


  # Toggle the `"completed"` state of the model.
  toggleCompleted: ->
    @model.toggle()


  # Switch this view into `"editing"` mode, displaying the input field.
  edit: ->
    this.$el.addClass('editing')
    this.$input.focus()


  # Close the `"editing"` mode, saving changes to the todo.
  close: ->
    value = this.$input.val()
    trimmedValue = value.trim()

    # We don't want to handle blur events from an item that is no
    # longer being edited. Relying on the CSS class here has the
    # benefit of us not having to maintain state in the DOM and the
    # JavaScript logic.
    if !this.$el.hasClass('editing')
      return

    if trimmedValue
      @model.save({ title: trimmedValue })
    else
      this.clear()

    this.$el.removeClass('editing')


  # If you hit `enter`, we're through editing the item.
  updateOnEnter: (e) ->
    if e.which == ENTER_KEY
      this.close()


  # If you're pressing `escape` we revert your change by simply leaving
  # the `editing` state.
  revertOnEscape: (e) ->
    if e.which == ESC_KEY
      this.$el.removeClass('editing')
      # Also reset the hidden input back to the original value.
      this.$input.val(@model.get('title'))


  # Remove the item, destroy the model from *localStorage* and delete its view.
  clear: ->
    @model.destroy()
