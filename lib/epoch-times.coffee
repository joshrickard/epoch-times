EpochTimesView = require './epoch-times-view'
{CompositeDisposable} = require 'atom'

moment = require 'moment'

module.exports = EpochTimes =
  config:
    copyToClipboard:
      title: 'Copy to Clipboard'
      description: 'Copies the translated time value to the clipboard.'
      type: 'boolean'
      default: true
    defaultEpochFormat:
      title: 'Epoch Format'
      description: 'Display/parse epoch times in seconds or milliseconds'
      type: 'string'
      default: 'seconds'
      enum: ['seconds', 'milliseconds']
    defaultTimeFormat:
      title: 'Time Format'
      description: 'Display times in this format (see moment formatting to customize: http://momentjs.com/docs/#/displaying/)'
      type: 'string'
      default: moment.defaultFormat
    showNotifications:
      title: 'Notifications'
      description: 'Displays parsed time values as a notification'
      type: 'boolean'
      default: true
    notificationDuration:
      title: 'Notification Duration'
      description: 'Automatically hide notifications after this many seconds (0 for manual dismissal).  Only valid if notifications are enabled.'
      type: 'integer'
      default: 3
      minimum: 0

  epochTimesView: null
  modalPanel: null
  subscriptions: null

  activate: (state) ->
    @epochTimesView = new EpochTimesView(state.epochTimesViewState)
    @modalPanel = atom.workspace.addModalPanel(item: @epochTimesView.getElement(), visible: false)

    @subscriptions = new CompositeDisposable

    @subscriptions.add atom.commands.add 'atom-workspace', 'epoch-times:translate': => @toggle()

  deactivate: ->
    @modalPanel.destroy()
    @subscriptions.dispose()
    @epochTimesView.destroy()

  serialize: ->
    epochTimesViewState: @epochTimesView.serialize()

  toggle: ->
    editor = atom.workspace.getActiveTextEditor()
    @epochTimesView.setEpochTime(editor)
