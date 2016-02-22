##################################################
class User
  #work_reach:0
  #home_reach:0
  work_leave:0
  home_leave:0
  work_stop:0
  home_stop:0
  work_stop_leave:0
  home_stop_leave:0
  traffic_points:[]
  route:[]
  speed:0
  current:0
  current_speed:0
  calcStraightLine = (startCoordinates, endCoordinates) ->
    coordinatesArray = new Array
    # Translate coordinates
    x1 = startCoordinates.x
    y1 = startCoordinates.y
    x2 = endCoordinates.x
    y2 = endCoordinates.y
    # Define differences and error check
    dx = Math.abs(x2 - x1)
    dy = Math.abs(y2 - y1)
    sx = if x1 < x2 then 1 else -1
    sy = if y1 < y2 then 1 else -1
    err = dx - dy
    # Set first coordinates
    coordinatesArray.push {x:x1,y:y1}
    # Main loop
    while !(x1 == x2 and y1 == y2)
      e2 = err << 1
      if e2 > -dy
        err -= dy
        x1 += sx
      if e2 < dx
        err += dx
        y1 += sy
      # Set coordinates
      coordinatesArray.push {x:x1,y:y1}
    # Return the result
    coordinatesArray

  spend_day:(t)->
    gc()
    if t >= @home_leave and t < @work_leave and @current!=@route.length - 1
      if @mode_of_trans isnt 'metro'
        route=@route
        current=@current
        @current_speed =
        if (@traffic_points.find (i)->JSON.stringify(i)==JSON.stringify(route[current]))
          @speed-2
        else
          @speed
      else
        @current_speed=
        if t%2
          0
        else
          @speed
      @current+=@current_speed
      if @current>@route.length-1
        @current=@route.length - 1

    else if t>=@work_leave and @current!=0
      if @mode_of_trans isnt 'metro'
        r=@route
        c=@current
        @current_speed=
        if (@traffic_points.find (i)->JSON.stringify(i)==JSON.stringify(r[c]))
          @speed-2
        else
          @speed
      else
        @current_speed=
        if t%2
          0
        else
          @speed
      @current-=@current_speed
      if @current<0
        @current=0

  constructor:(@home, @work, @mode_of_trans, @traffic)->
    @route=calcStraightLine @home, @work
    tp=@traffic/3
    length=@route.length
    @traffic_points=((@route[i] for i in [(n + 10)-4..(n + 10)+4]) for n in [1..tp].map (j)->Math.round Math.random()*length)
    @traffic_points=[].concat.apply [],@traffic_points
    @traffic_points=@traffic_points.filter (i)->i?
    @work_leave=Math.round  Math.random()*180 + 1020
    @home_leave=Math.round  Math.random()*180 + 420
    @speed=
    switch @mode_of_trans
      when 'bus' then 3
      when 'car' then 5
      when 'metro' then 7
    @current_speed=@speed


##################################################
args=process.argv.slice 2
lx=Number args[0]
ly=Number args[1]
wx=Number args[2]
wy=Number args[3]
m=args[4]
t=Number args[5]
if(!t or !m or !wx or !wy or !lx or !ly )
  console.log 'Arguments missing. Example usage: node --expose-gc index.js 20 30 57 300 metro 10'
  console.log '20,30 are x,y coordinates of user\'s home on a grid of 1000x1000.'
  console.log '57,300 are x,y coordinates of user\'s work.'
  console.log '\'metro\' is user\'s mode of transportation. Possible values:metro,bus,car.'
  console.log '10 is the traffic level. The more it is, the more traffic user will face. Range:0-10.'
  process.exit -1
user = new User {x:lx,y:ly},{x:wx,y:wy},m,t
console.log user
while true
  for i in [1..1440]
    user.spend_day i
    console.log {loc:user.route[user.current],t:i}
