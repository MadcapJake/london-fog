{CompositeDisposable} = require 'atom'

module.exports =
  config:
    replacements:
      type: 'object'
      default:
        '>>' : '»'
        '=>' : '⇒'
        '->' : '→'
        '!=' : '≠'
        '<=' : '≤'
        '>=' : '≥'
        '/'  : '÷'
        '==' : '≡'
        'all'  : '∀'
        'where': '∃'
        'in'   : '∈'
        'true' : '⊤'
        'false': '⊥'


  activate: ->
    @subscriptions = new CompositeDisposable
    @subscriptions.add @toggle()

  deactivate: ->
    @subscriptions.dispose()

  toggle: ->
    replacements  = atom.config.get 'london-fog.replacements'
    atom.workspace.observeTextEditors (editor) ->
      editor.onDidStopChanging ->

        view = atom.views.getView editor
        return unless view

        for element in view.querySelectorAll '::shadow .line span'
          continue unless element.childElementCount == 0
          replacement = replacements[element.textContent]
          continue unless replacement

          element.classList.add 'fogged'
          element.dataset.fogContent = replacement
          uglySpaces = (element.textContent.length - 1).toString()
          element.dataset.fogLength =
            if uglySpaces == 0
              '1em'
            else
              "-#{uglySpaces}em"
          console.log "margin-right: #{ element.dataset.fogLength }"
          console.log "content: #{ element.dataset.fogContent }"
