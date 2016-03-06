moment = require 'moment'

module.exports =
class EpochTimesView
  constructor: (serializedState) ->
    @element = document.createElement('div')

  serialize: ->

  destroy: ->
    @element.remove()

  getElement: ->
    @element

  setEpochTime: (editor) ->
    selectedText = editor.getSelectedText()
    if !isNaN(parseFloat(selectedText)) && isFinite(selectedText)
      unixTime = parseInt(selectedText)
      if atom.config.get('epoch-times.defaultEpochFormat') == 'seconds'
        d = moment(unixTime * 1000)
      else
        d = moment(unixTime)
      displayValue = d.format(atom.config.get('epoch-times.defaultTimeFormat')) if d.isValid()
    else
      d = moment(selectedText)
      if d.isValid()
        if atom.config.get('epoch-times.defaultEpochFormat') == 'seconds'
          displayValue = d.format("X")
        else
          displayValue = d.format("x")

    @showValue(displayValue)

  # 1234567890
  # 1234567890000
  # 2009-02-13T17:31:30-06:00
  # Fri Feb 13 2009 17:31:30 GMT-0600 (CST)
  showValue: (displayValue) ->
    if displayValue
      if atom.config.get('epoch-times.showNotifications')
        notification = atom.notifications.addInfo(displayValue, { dismissable: true })
        if atom.config.get('epoch-times.notificationDuration') > 0
          setTimeout(->
            notification.dismiss()
          , atom.config.get('epoch-times.notificationDuration') * 1000)
      if atom.config.get('epoch-times.copyToClipboard')
        atom.clipboard.write(displayValue)
