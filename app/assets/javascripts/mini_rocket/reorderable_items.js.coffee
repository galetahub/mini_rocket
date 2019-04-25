class ReorderableItems extends ReorderableTable
  _buildSortable: ->
    @element.sortable
      items:  ".sort-item"
      update: @_sendPositions
      cursor: 'crosshair'
      opacity: 0.6

    @element.disableSelection()

    @save_button = $('#reorder-save')
    @save_button.attr 'disabled', true
    @save_button.off('click.cleancms').on('click.cleancms', (e) =>
      this.save()
      return false
    )

  _sendPositions: (event, ui) =>
    @positions = items: @_calculatePositions(event.target)

    @save_button.attr 'disabled', false

    this.refresh_counters()

  save: =>
    $.ajax
      url:         @url
      method:      "POST"
      dataType:    "json"
      contentType: "application/json"
      data:        JSON.stringify(@positions)
      success: (data) ->
        Turbolinks.visit $('#reorder-cancel').attr('href')
      error: ->
        $.notify({message: "Some errors occurred when updating sorting", icon: 'fa fa-paw'}, {type: "warning"})

  refresh_counters: ->
    @element.find('.sort-item .numb').each (index) ->
      $(this).text index + 1

window.ReorderableItems = ReorderableItems
