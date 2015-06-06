{CompositeDisposable} = require 'atom'

module.exports =
  config:
    visible:
      type: 'boolean'
      default: false

  operators: null

  activate: ->
    @subscriptions = new CompositeDisposable

    @subscriptions.add atom.commands.add 'atom-workspace',
      'london-fog:toggle': => @toggle()

    @loadOperators()

    @conceal @operators

  deactivate: ->
    atom.config.transact => @subscriptions.dispose()

  loadOperators: ->
    @operators = require './operators'

  toggle: ->
    if atom.config.get 'london-fog.visible'
      console.log "The fog rolls out..."
      atom.config.set 'london-fog.visible', false
    else
      console.log "The fog rolls in..."
      atom.config.set 'london-fog.visible', true
    @conceal @operators

  conceal: (operators) ->
    atom.workspace.observeTextEditors (editor) ->
      innerConceal = (operators) -> ->
        return unless atom.config.get 'london-fog.visible'
        view = atom.views.getView editor
        return unless view

        for element in view.querySelectorAll '::shadow .line span'
          continue unless element.childElementCount == 0
          operator = operators[element.textContent]
          continue unless operator

          element.classList.add 'fogged', operator.name
          element.dataset.fogContent = operator.replacement

      editor.onDidStopChanging innerConceal(operators)
      editor.onDidChangeCursorPosition innerConceal(operators)
