{CompositeDisposable} = require 'atom'

module.exports =
  config:
    visible:
      type: 'boolean'
      default: false
    operators:
      type: 'object'
      default:
        '>>' :
          'name': 'projector'
          'replacement': '»'
        '=>' :
          'name': 'obj_arrow'
          'replacement': '⇒'
        '->' :
          'name': 'fun_arrow'
          'replacement': '→'
        '!=' :
          'name': 'not_equal'
          'replacement': '≠'
        '<=' :
          'name': 'lt_equal'
          'replacement': '≤'
        '>=' :
          'name': 'gt_equal'
          'replacement': '≥'
        '/'  :
          'name': 'divide'
          'replacement': '÷'
        '==' :
          'name': 'equal'
          'replacement': '≡'
        'all'  :
          'name': 'kw_all'
          'replacement': '∀'
        'where':
          'name': 'kw_where'
          'replacement': '∃'
        'in'   :
          'name': 'kw_in'
          'replacement': '∈'
        'true' :
          'name': 'kw_true'
          'replacement': '⊤'
        'false':
          'name': 'kw_false'
          'replacement': '⊥'

  activate: ->
    @subscriptions = new CompositeDisposable
    @subscriptions.add atom.commands.add 'atom-workspace',
      'london-fog:toggle': => @toggle()

  deactivate: ->
    @subscriptions.dispose()

  toggle: ->
    if atom.config.get 'london-fog.visible'
      console.log "The fog rolls out..."
      atom.config.set 'london-fog.visible', false
    else
      console.log "The fog rolls in..."
      atom.config.set 'london-fog.visible', true
    @conceal()

  conceal: ->
    operators  = atom.config.get 'london-fog.operators'
    atom.workspace.observeTextEditors (editor) ->
      editor.onDidStopChanging ->
        return unless atom.config.get 'london-fog.visible'
        view = atom.views.getView editor
        return unless view

        for element in view.querySelectorAll '::shadow .line span'
          continue unless element.childElementCount == 0
          operator = operators[element.textContent]
          continue unless operator

          element.classList.add 'fogged', operator.name
          element.dataset.fogContent = operator.replacement
