$ ->

  # THE KEYWORK
  # ==========

  # Define Variables
  # ----------

  # Find the `canvas` element
  $keywork = $("canvas")

  # Store, size, and positon the Keywork
  KEY_SIZE  = $keywork.width()
  CENTER    = LEFT = KEY_SIZE / 2
  TOP       = KEY_SIZE / 2 + 5

  $keywork.attr height: KEY_SIZE, width: KEY_SIZE
  $keywork.css margin: "-#{ CENTER }px 0 0 -#{ CENTER }px"

  # Planet sizes and distance
  BG_PLANET   = KEY_SIZE / 5
  SM_PLANET   = KEY_SIZE / 10
  DISTANCE    = CENTER - BG_PLANET
  LINE_WIDTH  = KEY_SIZE / 80

  # Back and foreground colors
  BACK_COLOR  = "rgba(149,149,149,0.5)"
  FRONT_COLOR = "white"

  # Get the `canvas` context and setup any defaults
  keywork = $keywork[0].getContext("2d")
  keywork.lineWidth = LINE_WIDTH

  # Functions
  # ----------

  getPosition = (degrees) ->
    RADIANS = Math.PI / 180 * degrees
    x = LEFT + Math.sin(RADIANS) * DISTANCE
    y = TOP  + Math.cos(RADIANS) * DISTANCE
    x: x, y: y

  getTime = (position) ->
    Math.PI / 180 * 360 * position

  createPlanet = (x, y, size, start, end, timer) ->
    keywork.strokeStyle = if timer then FRONT_COLOR else BACK_COLOR
    keywork.beginPath()
    keywork.arc(x, y, size, start, end, false)
    keywork.stroke()

    if timer  
      keywork.strokeStyle = BACK_COLOR
      keywork.beginPath()
      keywork.arc(x, y, size, end, 2 * Math.PI, false)
      keywork.stroke()

  # Countdown
  # ----------

  SECONDS = MINUTES = HOURS = DAYS = 0
  TICK    = 0 

  # Date

  DATE = new Date()
  DATE.setDate(DATE.getDate() + 1)

  $("#keywork").countdown DATE, (e) ->

    # UPDATE TIMERS
    switch e.type
      when "seconds" then SECONDS = e.value / 60
      when "minutes" then MINUTES = e.value / 60
      when "hours"   then HOURS   = e.value / 24
      when "days"    then DAYS    = e.value / 4

    if e.type is "minutes"
      if TICK
        $("body").css background: "white"
        FRONT_COLOR = "black"
        TICK = 0
      else
        $("body").css background: "black"
        FRONT_COLOR = "white"
        TICK = 1

    # Clear the `canvas`
    keywork.clearRect(0, 0, KEY_SIZE, KEY_SIZE)

    # Draw the three static surrounding planets
    for ANGLE in [0..240] by 120
      POS = getPosition(ANGLE)
      createPlanet(POS.x, POS.y, SM_PLANET, 0, 2 * Math.PI, false)

    # Draw the three timed surrounding planets
    for ANGLE in [60..300] by 120
      POS = getPosition(ANGLE)
      TIME = getTime switch ANGLE
        when 60  then SECONDS
        when 180 then MINUTES
        when 300 then HOURS
      createPlanet(POS.x, POS.y, BG_PLANET, 0, TIME, true)

    # Draw center planet and hour planet
    TIME = getTime(DAYS)
    createPlanet(LEFT, TOP, SM_PLANET, 0, TIME, true)

    # Draw triangle
    keywork.strokeStyle = BACK_COLOR
    keywork.beginPath()
    for ANGLE in [60..300] by 120
      POS = getPosition(ANGLE)
      keywork.lineTo(POS.x, POS.y)
    keywork.closePath()
    keywork.stroke()
