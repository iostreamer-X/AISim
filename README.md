# AISim
Simulates routine of a person and outputs that person's location tagged with time.

#Install

do a `git clone`

#Usage

`cd AISim`

`node --expose-gc index.js 20 30 57 300 metro 10`

20,30 are x,y coordinates of user's home on a grid of 1000x1000.

57,300 are x,y coordinates of user's work.
metro is user's mode of transportation. Possible values:metro,bus,car.

10 is the traffic level. The more it is, the more traffic user will face. Range:0-10.

#Output

`node --expose-gc index.js 20 30 57 300 metro 10 > op.txt`
