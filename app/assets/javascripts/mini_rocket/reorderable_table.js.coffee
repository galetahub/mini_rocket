class ReorderableTable
  constructor: (selector) ->
    @element = $(selector)

    this._buildSortable()

    @setUrl(@element.data('url'))

  _buildSortable: ->
    @elements = @element.find('tbody')

    @elements.sortable
      items:  "tr"
      handle: ".js-reorder-handle"
      axis: "y"
      update: @_sendPositions
      placeholder: 'ui-sortable-placeholder'

    @elements.disableSelection()

  setUrl: (base_url) ->
    base_url ?= this._defaultUrl()
    @url = base_url

  _defaultUrl: ->
    url = window.location.pathname

    items = url.split('?')
    @url = items[0] + '/reorder' + '?' + items[1]

  _calculatePositions: (sortable) ->
    # Sortable uses ids by default for serialisation
    for itemId, index in $(sortable).sortable("toArray")
      # ActiveAdmin sets the id to the form "underscored_classname_id"
      id:    itemId.split("_").pop()
      sort_order: index + 1

  _sendPositions: (event) =>
    positions = items: @_calculatePositions(event.target)

    $.ajax
      url:         @url
      method:      "POST"
      dataType:    "json"
      contentType: "application/json"
      data:        JSON.stringify(positions)

window.ReorderableTable = ReorderableTable
