$ = jQuery

$.fn.avatar = (options = {}) ->
  @each ->
    $this = $(this)
    data = $this.data("avatar")
    if (!data)
      $this.data("avatar", new Avatar(this, options))
    if (typeof options is 'string')
      data[options]()

class Avatar
  constructor: (@dom_id, options = {}) ->
    defaults =
      colours: ["#1abc9c", "#2ecc71", "#3498db", "#9b59b6", "#34495e", "#16a085", "#27ae60", "#2980b9",
                "#8e44ad", "#2c3e50", "#f1c40f", "#e67e22", "#e74c3c", "#95a5a6", "#f39c12", "#d35400",
                "#c0392b", "#bdc3c7", "#7f8c8d"]
      font: '12px Arial'
      textAlign: 'center'
      textBaseline: 'middle'
      fillStyle: '#FFF'

    @options = $.extend defaults, options

    this._setup()

  _setup: ->
    @element = $(@dom_id)
    @name = @element.data('name')
    @initials = this._extractInitials(@name)

    @colourIndex = this._extractColorIndex(@initials)

    @canvas = @element.get(0)
    @context = @canvas.getContext('2d')

    @canvasWidth = @element.attr("width")
    @canvasHeight = @element.attr("height")
    @canvasCssWidth = @canvasWidth
    @canvasCssHeight = @canvasHeight

    this._scaleWindow()
    this.draw()

  draw: ->
    @context.fillStyle = @options.colours[@colourIndex];
    @context.fillRect(0, 0, @canvas.width, @canvas.height);

    @context.font = @options.font;
    @context.textAlign = @options.textAlign;
    @context.textBaseline = @options.textBaseline;
    @context.fillStyle = @options.fillStyle;

    @context.fillText(@initials, @canvasCssWidth / 2, @canvasCssHeight / 2)

  _scaleWindow: ->
    return unless window.devicePixelRatio

    @element.attr("width", @canvasWidth * window.devicePixelRatio)
    @element.attr("height", @canvasHeight * window.devicePixelRatio)
    @element.css("width", @canvasCssWidth)
    @element.css("height", @canvasCssHeight)

    @context.scale(window.devicePixelRatio, window.devicePixelRatio)

  _extractInitials: (name) ->
    nameSplit = name.split(" ")

    if nameSplit.length == 1
      nameSplit[0].charAt(0).toUpperCase() + nameSplit[0].charAt(1).toUpperCase()
    else
      nameSplit[0].charAt(0).toUpperCase() + nameSplit[1].charAt(0).toUpperCase()

  _extractColorIndex: (name) ->
    charIndex = name.charCodeAt(0) - 65
    charIndex % 19

