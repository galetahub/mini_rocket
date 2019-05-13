class Global
  @initTurbolinks: ->
    content = $('#content')

    $(document).on 'turbolinks:load', () ->
      Global.init()

    $(document).on 'turbolinks:click', () ->
      content.addClass 'changing'

    $(document).on 'turbolinks:before-render', () ->
      content.removeClass 'changing'

  @initSelect: ->
    $('select.select').select2(
      allowClear: true
    )

  @initMaxLength: ->
    $("textarea[maxlength]").maxlength(
      alwaysShow: true
      threshold: 10
      placement: 'top'
    )

  @initAvatars = () ->
    $('.user-avatar').avatar()

  @initSidebarMenu: ->
    $('.left-menu .left-menu-list-submenu > a').on 'click', ->
      accessDenied = $('body').hasClass('menu-top') and $(window).width() > 768

      if !accessDenied
        that = $(this).parent()
        opened = $('.left-menu .left-menu-list-opened')
        if !that.hasClass('left-menu-list-opened') and !that.parent().closest('.left-menu-list-submenu').length
          opened.removeClass('left-menu-list-opened').find('> ul').slideUp 200
        that.toggleClass('left-menu-list-opened').find('> ul').slideToggle 200

      return

  @initReorderableTables: ->
    new ReorderableTable('table.js-reorder-table')

  @initReorderableItems: ->
    new ReorderableItems('#reorder')

  @initNestedForms: ->
    $("body").on("click", "a.nested_delete_handler", (e) ->
      parent = $(this).closest('.nested_item_field')
      field = parent.find('.nested_delete_field')

      if field.length
        field.val(1)
        parent.hide()
      else
        parent.remove()

      return false
    )

    $('[data-form-prepend]').click (e) ->
      obj = $( $(this).attr('data-form-prepend') )
      date = new Date().getTime()

      obj.find('input, select, textarea').each () ->
        name = $(this).attr('name').replace('new_record', date)
        $(this).attr('name', name)

      obj.insertBefore(this)

      return false

  @initDatePickers: ->
    $('input.datepicker').daterangepicker(
      singleDatePicker: true
      autoApply: true,
      locale: {
        format: 'YYYY/MM/DD'
      }
    )

  @initDateRangePickers: ->
    $('input.daterange').daterangepicker(
      autoApply: true
    )

  @initAnimations: ->
    if Cookies.get('sidebar_mode') == 'collapse'
      $('body').addClass('sidebar-collapse')

    $('.sidebar-toggle').click ->
      $('body').toggleClass('sidebar-collapse')
      mode = if $('body').hasClass('sidebar-collapse') then 'collapse' else 'open'
      Cookies.set('sidebar_mode', mode, { expires: 365 * 5 })

    $('.btn-filter').click ->
      $(this).parent().toggleClass('show')

    $('.treeview').click ->
      $(this).toggleClass('menu-open')

  @init: ->
    @initSelect()
    @initMaxLength()
    @initAvatars()
    @initSidebarMenu()
    @initReorderableTables()
    @initReorderableItems()
    @initNestedForms()
    @initDatePickers()
    @initDateRangePickers()
    @initAnimations()

window.Global = Global
