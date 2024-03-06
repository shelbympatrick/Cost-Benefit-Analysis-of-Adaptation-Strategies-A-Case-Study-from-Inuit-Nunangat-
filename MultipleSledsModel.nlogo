;; 35 ticks = 70km = 1 day

globals
  [resources
  maximum-resources
  hunt-done?
]

to setup
  clear-all
  setup-turtles
  setup-patches
  create-route
  create-hazards
  create-hunting-opportunities
  reset-ticks
end


to go
  move-to-destination
  encounter-hazards
  hunt-on-journey-seals
  hunt-on-journey-caribou
  eat-on-journey
  prevent-death-seals
  prevent-death-caribou
  final-hunt
  tick
end


;; turtle procedures

to setup-turtles ;;creating the trading party agnet
  create-turtles 1
  ask turtles [
  set shape "person"
  setxy 0 0
  set size 5
  set resources 191.1 ;;amount of food resources brought for the initial part of the trip
  set maximum-resources 543.1 ;;total amount of resources all sleds can handle in terms of weight minus the weight of any initial supplies
  set hunt-done? false
  ]
end

;; turtle procedures

to move-to-destination ;;to move towards the destination (violet patch)
  ask turtles [
   ifelse hunt-done? = true [
   set heading 270
   forward 2
  ][
    set heading 90
   forward 2
    ]
]
end

to hunt-on-journey-seals ;;determines if the agent will hunt seals based on the current location, if they will be successful, and how many kilograms of resources they will acquire
  ask turtles [
    if pcolor = green AND resources < maximum-resources AND pxcor < 150 [
    if random 100 <= hunting-on-journey-success [
      set resources (resources + (13 + random 8))
    ]
  ]
]
end

to  hunt-on-journey-caribou ;;determines if the agent will hunt caribou based on the current location, if they will be successful, and how many kilograms of resources they will acquire
  ask turtles [
    if pcolor = green AND resources < maximum-resources AND pxcor > 150 [
    if random 100 <= hunting-on-journey-success [
      set resources (resources + (43 + random 5))
    ]
  ]
]
end

to prevent-death-seals ;;if resources reach zero and they are within the seal hunting zone this gives the agent an immediate, successful hunting opportunity
  ask turtles [
    if resources <= 0 AND pxcor < 150 [
      set resources (resources + (13 + random 8))
    ]
  ]
end

to prevent-death-caribou ;;if resources reach zero and they are within the caribou hunting zone this gives the agent an immediate, successful hunting opportunity
  ask turtles [
    if resources <= 0 AND pxcor > 150 [
      set resources (resources + (43 + random 5))
    ]
  ]
end

to final-hunt ;;once they reach the destination they receive the maximum amount of resources
  ask patch 327 0 [
    set pcolor violet ]
 ask turtles [
    if pcolor = violet [
      set resources maximum-resources
   set hunt-done? true ]
  ]
end


to encounter-hazards ;;determines if the agent will be susceptible to a hazard and if they are how many resources will be subtracted
  ask turtles [
    if pcolor = red [
      if random 100 <= hazard-susceptibility [
      set resources (resources - (31.85 + random 31.85) ) ;; assuming the hazards take between half a day and a full day to navigate around
      ]
    ]
  ]
end

to eat-on-journey  ;;subtracts the necessary amount of resources consumed for all humans and dogs on each day of travel
  ask turtles [
    if ticks = 35 [
      set resources resources - 63.7 ]
    if ticks = 70 [
      set resources resources - 63.7 ]
    if ticks = 105 [
      set resources resources - 63.7 ]
    if ticks = 140 [
      set resources resources - 63.7 ]
    if ticks = 175 [
      set resources resources - 63.7 ]
    if ticks = 210 [
      set resources resources - 63.7 ]
    if ticks = 245 [
      set resources resources - 63.7 ]
    if ticks = 280 [
      set resources resources - 63.7 ]
    if ticks = 315 [
      set resources resources - 63.7 ]
  ]
end

;; patch procedures


to setup-patches
  ask patches [
    set pcolor grey
  ]
end


to create-route ;;creates the straight line route
  ask patches with [ pxcor = 1 AND pycor = 0 ] [
  set pcolor blue ]
  ask patches with [ pxcor > 0 AND pycor = 0 ] [
    set pcolor blue ]
end

to create-hazards ;;determines how many patches will be hazards
  ask patches with [pcolor = blue] [
    ifelse random 100 <= hazard-probability [
      set pcolor red
  ][
    set pcolor blue
  ]
]
end

to create-hunting-opportunities ;;determines how many patches will be hunting opportunities
  ask patches with [pcolor = blue] [
    ifelse random 100 < 6 [
      set pcolor green
    ][
      set pcolor blue
    ]
  ]
end

;; reporter procedures

to-report turtle-final-resources
  report sum [ resources ] of turtles
end
@#$#@#$#@
GRAPHICS-WINDOW
210
11
1370
164
-1
-1
3.5122
1
10
1
1
1
0
0
0
1
0
327
-20
20
1
1
1
ticks
30.0

BUTTON
18
22
84
55
NIL
setup\n
NIL
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

BUTTON
121
25
184
58
NIL
go
T
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

MONITOR
31
70
180
115
NIL
turtle-final-resources
17
1
11

SLIDER
24
184
270
217
hazard-probability
hazard-probability
0
100
20.0
1
1
%
HORIZONTAL

SLIDER
25
240
272
273
hazard-susceptibility
hazard-susceptibility
0
100
20.0
1
1
%
HORIZONTAL

SLIDER
22
298
269
331
hunting-on-journey-success
hunting-on-journey-success
0
100
10.0
1
1
%
HORIZONTAL

@#$#@#$#@
## WHAT IS IT?
This long-distance journey model aims to determine how many dog sled teams would be needed on a 1260-kilometre journey to transport enough perishable goods to outperform the local hunting model. The number of sleds begins at four and increases by one until the kilograms of perishable resources returned is equal to or greater than 146 kilograms, the result of a 10% hunting success rate in the local hunting model. There are four types of entities in this model: an agent representing the trading party (shown as a person icon), square patches representing hazards, square patches representing hunting opportunities, and square patches representing normal land. The patches in this model represent a landscape of 328 x 41 patches. As environmental and geographic conditions such as ice conditions or elevation are not taken into account in this model, the 630-kilometre journey is represented by a straight line that the trading party agent travels across. Each model run represents a 630-kilometre round trip journey, approximately a 30-day time step. Every 35 ticks of the model represent one day of travel.  
## HOW IT WORKS

On the model setup, the number of hazards and hunting opportunity patches are randomly distributed on the straight line of the journey. On each movement of the model, the trading party agent sets their heading to 270° and moves forward two steps. As the trading party agent moves toward the violet patch (327, 0), there is a user-set probability that the hunter will encounter a hazard, such as injury to a human or dog or unforeseen adverse weather conditions. If they encounter a hazard, there is also a user-set probability that the hunter will be susceptible to that hazard, resulting in a loss of between half a day and a full day’s worth of travel time and resources. As the trading party agent moves forward, they may encounter green patches representing hunting opportunities. On a green patch, there is a user-set probability that they will successfully catch an animal. If successful and on a green patch with location coordinates between 0,0 and 150,0, the trading party agent is considered to be travelling across the ice or along the coast, and opportunity represents breathing hole sealing. If successful, the trading party agent will acquire a random amount of resources between 13 and 21 kilograms (Ashley 2002). If successful and the patch coordinates are between 150,0 and 327, 0 (when the trading party agent is now assumed to be inland), the hunting opportunity represents caribou hunting, and the trading party agent acquires between 43 and 48 kilograms, the average range of edible weight for barren-ground caribou (Ashley 2002). During the journey, every 35 ticks, the trading party agent’s resources decrease by 29.3 kilograms, representing a day’s worth of food for all party members. When the trading party agent reaches the violet patch (327, 0), the agent acquires the maximum resources their sleds can hold. The agent’s heading is then set to 90°, and they return to the 0,0 starting location. On the journey back, they have the same opportunities to encounter hazards and hunting opportunities. 

## HOW TO USE IT

There are eight submodels. The first submodel details how the trading party agent moves. They initially set a heading of 270 and move forward two steps with each tick. They continue this until they reach the violet patch, at which point the agent’s heading is set to 90, and they move forward two steps each tick until they reach the patch at 0,0. The second submodel determines if a hunter will be susceptible to a hazard. In terms of hunters’ susceptibility to hazards they encountered, this parameter followed Brinton (2018) as well and was set at 20%. In addition to search and rescue data utilized by Brinton (2018), dogsled teams have been reported to impact hazard avoidance as the slower pace of dog teams forces one to be more aware of the environment (Aporta 2004). Dogs also have a keen sense of where ice is thin, can use their sense of smell to follow paths in blizzard conditions, can scent hazards such as polar bears, and can detect seal lairs (Krupnik et al. 2010; Qikiqtani Inuit Association 2014). In this submodel, the trading party agent draws a random number, and if it is between 1 and 20, they are affected by the hazard between a half-day and full-day worth of resources are subtracted from the total resources. They continue the journey if the random draw is between 21 and 100. The trading party agent may encounter multiple hazards in one run of the model, and this encounter-hazard submodel repeats each time. 
The third and fourth submodels detail what occurs if the trading party agent is on a green “hunting opportunity” patch.  In both submodels, on a green patch, the agent draws a random number to determine if they will successfully hunt a seal or caribou. The agent's location variable determines whether the seal or caribou submodel runs (between 0,0 and 150,0, it is a seal, and between 150,0 and 327,0, it is a caribou). These submodels are a user-set probability, and the parameter determining hunting success began at 10% based on modern and ethnographic estimates of how successful breathing hole sealing attempts were (e.g., Balikci 1970 and Furgal et al. 2002). Success rate estimates were unavailable for caribou; thus, the 10% success rate remained the same despite the hunters having opportunities for both ringed seals and caribou. If a hunter successfully obtains a seal, their resources increase by a random value between 13 and 21 kilograms to simulate the natural variation in ringed seals’ weights (Ashley 2002), which is decided by adding 13 kilograms and then a random number of kilograms between one and seven to the hunter’s resources. If the agent obtains a caribou, its resources increase by a random value between 43 and 48 kilograms to simulate the range of edible weights of barren-ground caribou (Ashley 2002). 
The fifth submodel simulates the need for the sled teams to eat while on the journey. Every 35 ticks, which is equivalent to 70km or one day of travel, the total amount of resources decreases by 4.9 (what each sled team of one human and two dogs consumes in a day) multiplied by the number of sleds being simulated.
The sixth and seventh submodels are designed to prevent the trading party agent from depleting their resources, preventing simulated starvation. In these models, if the agent’s resources reach zero, they are automatically given the same random number of resources they would obtain if they successfully hunted a seal or a caribou. 
The eighth submodel simulates the trading party reaching the destination. In this model, when the trading party agent reaches the violet patch (327,0), they are automatically given the maximum amount of resources based on how many sleds are simulated. For example, if four sleds are simulated when the agent reaches the violet patch, it receives 166.8 kilograms of resources. 


## THINGS TO TRY
Try adjusting the probabilities of encountering a hazard, how susceptible the trading party agent is to hazards, and how successful they are at hunting.

## EXTENDING THE MODEL

Try adding environmental data or a GIS background to take geographic information, like elevation or ice coverage, into consideration.
@#$#@#$#@
default
true
0
Polygon -7500403 true true 150 5 40 250 150 205 260 250

airplane
true
0
Polygon -7500403 true true 150 0 135 15 120 60 120 105 15 165 15 195 120 180 135 240 105 270 120 285 150 270 180 285 210 270 165 240 180 180 285 195 285 165 180 105 180 60 165 15

arrow
true
0
Polygon -7500403 true true 150 0 0 150 105 150 105 293 195 293 195 150 300 150

box
false
0
Polygon -7500403 true true 150 285 285 225 285 75 150 135
Polygon -7500403 true true 150 135 15 75 150 15 285 75
Polygon -7500403 true true 15 75 15 225 150 285 150 135
Line -16777216 false 150 285 150 135
Line -16777216 false 150 135 15 75
Line -16777216 false 150 135 285 75

bug
true
0
Circle -7500403 true true 96 182 108
Circle -7500403 true true 110 127 80
Circle -7500403 true true 110 75 80
Line -7500403 true 150 100 80 30
Line -7500403 true 150 100 220 30

butterfly
true
0
Polygon -7500403 true true 150 165 209 199 225 225 225 255 195 270 165 255 150 240
Polygon -7500403 true true 150 165 89 198 75 225 75 255 105 270 135 255 150 240
Polygon -7500403 true true 139 148 100 105 55 90 25 90 10 105 10 135 25 180 40 195 85 194 139 163
Polygon -7500403 true true 162 150 200 105 245 90 275 90 290 105 290 135 275 180 260 195 215 195 162 165
Polygon -16777216 true false 150 255 135 225 120 150 135 120 150 105 165 120 180 150 165 225
Circle -16777216 true false 135 90 30
Line -16777216 false 150 105 195 60
Line -16777216 false 150 105 105 60

car
false
0
Polygon -7500403 true true 300 180 279 164 261 144 240 135 226 132 213 106 203 84 185 63 159 50 135 50 75 60 0 150 0 165 0 225 300 225 300 180
Circle -16777216 true false 180 180 90
Circle -16777216 true false 30 180 90
Polygon -16777216 true false 162 80 132 78 134 135 209 135 194 105 189 96 180 89
Circle -7500403 true true 47 195 58
Circle -7500403 true true 195 195 58

circle
false
0
Circle -7500403 true true 0 0 300

circle 2
false
0
Circle -7500403 true true 0 0 300
Circle -16777216 true false 30 30 240

cow
false
0
Polygon -7500403 true true 200 193 197 249 179 249 177 196 166 187 140 189 93 191 78 179 72 211 49 209 48 181 37 149 25 120 25 89 45 72 103 84 179 75 198 76 252 64 272 81 293 103 285 121 255 121 242 118 224 167
Polygon -7500403 true true 73 210 86 251 62 249 48 208
Polygon -7500403 true true 25 114 16 195 9 204 23 213 25 200 39 123

cylinder
false
0
Circle -7500403 true true 0 0 300

dot
false
0
Circle -7500403 true true 90 90 120

face happy
false
0
Circle -7500403 true true 8 8 285
Circle -16777216 true false 60 75 60
Circle -16777216 true false 180 75 60
Polygon -16777216 true false 150 255 90 239 62 213 47 191 67 179 90 203 109 218 150 225 192 218 210 203 227 181 251 194 236 217 212 240

face neutral
false
0
Circle -7500403 true true 8 7 285
Circle -16777216 true false 60 75 60
Circle -16777216 true false 180 75 60
Rectangle -16777216 true false 60 195 240 225

face sad
false
0
Circle -7500403 true true 8 8 285
Circle -16777216 true false 60 75 60
Circle -16777216 true false 180 75 60
Polygon -16777216 true false 150 168 90 184 62 210 47 232 67 244 90 220 109 205 150 198 192 205 210 220 227 242 251 229 236 206 212 183

fish
false
0
Polygon -1 true false 44 131 21 87 15 86 0 120 15 150 0 180 13 214 20 212 45 166
Polygon -1 true false 135 195 119 235 95 218 76 210 46 204 60 165
Polygon -1 true false 75 45 83 77 71 103 86 114 166 78 135 60
Polygon -7500403 true true 30 136 151 77 226 81 280 119 292 146 292 160 287 170 270 195 195 210 151 212 30 166
Circle -16777216 true false 215 106 30

flag
false
0
Rectangle -7500403 true true 60 15 75 300
Polygon -7500403 true true 90 150 270 90 90 30
Line -7500403 true 75 135 90 135
Line -7500403 true 75 45 90 45

flower
false
0
Polygon -10899396 true false 135 120 165 165 180 210 180 240 150 300 165 300 195 240 195 195 165 135
Circle -7500403 true true 85 132 38
Circle -7500403 true true 130 147 38
Circle -7500403 true true 192 85 38
Circle -7500403 true true 85 40 38
Circle -7500403 true true 177 40 38
Circle -7500403 true true 177 132 38
Circle -7500403 true true 70 85 38
Circle -7500403 true true 130 25 38
Circle -7500403 true true 96 51 108
Circle -16777216 true false 113 68 74
Polygon -10899396 true false 189 233 219 188 249 173 279 188 234 218
Polygon -10899396 true false 180 255 150 210 105 210 75 240 135 240

house
false
0
Rectangle -7500403 true true 45 120 255 285
Rectangle -16777216 true false 120 210 180 285
Polygon -7500403 true true 15 120 150 15 285 120
Line -16777216 false 30 120 270 120

leaf
false
0
Polygon -7500403 true true 150 210 135 195 120 210 60 210 30 195 60 180 60 165 15 135 30 120 15 105 40 104 45 90 60 90 90 105 105 120 120 120 105 60 120 60 135 30 150 15 165 30 180 60 195 60 180 120 195 120 210 105 240 90 255 90 263 104 285 105 270 120 285 135 240 165 240 180 270 195 240 210 180 210 165 195
Polygon -7500403 true true 135 195 135 240 120 255 105 255 105 285 135 285 165 240 165 195

line
true
0
Line -7500403 true 150 0 150 300

line half
true
0
Line -7500403 true 150 0 150 150

pentagon
false
0
Polygon -7500403 true true 150 15 15 120 60 285 240 285 285 120

person
false
0
Circle -7500403 true true 110 5 80
Polygon -7500403 true true 105 90 120 195 90 285 105 300 135 300 150 225 165 300 195 300 210 285 180 195 195 90
Rectangle -7500403 true true 127 79 172 94
Polygon -7500403 true true 195 90 240 150 225 180 165 105
Polygon -7500403 true true 105 90 60 150 75 180 135 105

plant
false
0
Rectangle -7500403 true true 135 90 165 300
Polygon -7500403 true true 135 255 90 210 45 195 75 255 135 285
Polygon -7500403 true true 165 255 210 210 255 195 225 255 165 285
Polygon -7500403 true true 135 180 90 135 45 120 75 180 135 210
Polygon -7500403 true true 165 180 165 210 225 180 255 120 210 135
Polygon -7500403 true true 135 105 90 60 45 45 75 105 135 135
Polygon -7500403 true true 165 105 165 135 225 105 255 45 210 60
Polygon -7500403 true true 135 90 120 45 150 15 180 45 165 90

sheep
false
15
Circle -1 true true 203 65 88
Circle -1 true true 70 65 162
Circle -1 true true 150 105 120
Polygon -7500403 true false 218 120 240 165 255 165 278 120
Circle -7500403 true false 214 72 67
Rectangle -1 true true 164 223 179 298
Polygon -1 true true 45 285 30 285 30 240 15 195 45 210
Circle -1 true true 3 83 150
Rectangle -1 true true 65 221 80 296
Polygon -1 true true 195 285 210 285 210 240 240 210 195 210
Polygon -7500403 true false 276 85 285 105 302 99 294 83
Polygon -7500403 true false 219 85 210 105 193 99 201 83

square
false
0
Rectangle -7500403 true true 30 30 270 270

square 2
false
0
Rectangle -7500403 true true 30 30 270 270
Rectangle -16777216 true false 60 60 240 240

star
false
0
Polygon -7500403 true true 151 1 185 108 298 108 207 175 242 282 151 216 59 282 94 175 3 108 116 108

target
false
0
Circle -7500403 true true 0 0 300
Circle -16777216 true false 30 30 240
Circle -7500403 true true 60 60 180
Circle -16777216 true false 90 90 120
Circle -7500403 true true 120 120 60

tree
false
0
Circle -7500403 true true 118 3 94
Rectangle -6459832 true false 120 195 180 300
Circle -7500403 true true 65 21 108
Circle -7500403 true true 116 41 127
Circle -7500403 true true 45 90 120
Circle -7500403 true true 104 74 152

triangle
false
0
Polygon -7500403 true true 150 30 15 255 285 255

triangle 2
false
0
Polygon -7500403 true true 150 30 15 255 285 255
Polygon -16777216 true false 151 99 225 223 75 224

truck
false
0
Rectangle -7500403 true true 4 45 195 187
Polygon -7500403 true true 296 193 296 150 259 134 244 104 208 104 207 194
Rectangle -1 true false 195 60 195 105
Polygon -16777216 true false 238 112 252 141 219 141 218 112
Circle -16777216 true false 234 174 42
Rectangle -7500403 true true 181 185 214 194
Circle -16777216 true false 144 174 42
Circle -16777216 true false 24 174 42
Circle -7500403 false true 24 174 42
Circle -7500403 false true 144 174 42
Circle -7500403 false true 234 174 42

turtle
true
0
Polygon -10899396 true false 215 204 240 233 246 254 228 266 215 252 193 210
Polygon -10899396 true false 195 90 225 75 245 75 260 89 269 108 261 124 240 105 225 105 210 105
Polygon -10899396 true false 105 90 75 75 55 75 40 89 31 108 39 124 60 105 75 105 90 105
Polygon -10899396 true false 132 85 134 64 107 51 108 17 150 2 192 18 192 52 169 65 172 87
Polygon -10899396 true false 85 204 60 233 54 254 72 266 85 252 107 210
Polygon -7500403 true true 119 75 179 75 209 101 224 135 220 225 175 261 128 261 81 224 74 135 88 99

wheel
false
0
Circle -7500403 true true 3 3 294
Circle -16777216 true false 30 30 240
Line -7500403 true 150 285 150 15
Line -7500403 true 15 150 285 150
Circle -7500403 true true 120 120 60
Line -7500403 true 216 40 79 269
Line -7500403 true 40 84 269 221
Line -7500403 true 40 216 269 79
Line -7500403 true 84 40 221 269

wolf
false
0
Polygon -16777216 true false 253 133 245 131 245 133
Polygon -7500403 true true 2 194 13 197 30 191 38 193 38 205 20 226 20 257 27 265 38 266 40 260 31 253 31 230 60 206 68 198 75 209 66 228 65 243 82 261 84 268 100 267 103 261 77 239 79 231 100 207 98 196 119 201 143 202 160 195 166 210 172 213 173 238 167 251 160 248 154 265 169 264 178 247 186 240 198 260 200 271 217 271 219 262 207 258 195 230 192 198 210 184 227 164 242 144 259 145 284 151 277 141 293 140 299 134 297 127 273 119 270 105
Polygon -7500403 true true -1 195 14 180 36 166 40 153 53 140 82 131 134 133 159 126 188 115 227 108 236 102 238 98 268 86 269 92 281 87 269 103 269 113

x
false
0
Polygon -7500403 true true 270 75 225 30 30 225 75 270
Polygon -7500403 true true 30 75 75 30 270 225 225 270
@#$#@#$#@
NetLogo 6.2.2
@#$#@#$#@
@#$#@#$#@
@#$#@#$#@
<experiments>
  <experiment name="5sleds" repetitions="100" runMetricsEveryStep="false">
    <setup>setup</setup>
    <go>go</go>
    <timeLimit steps="350"/>
    <metric>turtle-final-resources</metric>
    <enumeratedValueSet variable="hazard-probability">
      <value value="5"/>
      <value value="10"/>
      <value value="20"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="hazard-susceptibility">
      <value value="20"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="hunting-on-journey-success">
      <value value="10"/>
    </enumeratedValueSet>
  </experiment>
  <experiment name="6sleds" repetitions="100" runMetricsEveryStep="false">
    <setup>setup</setup>
    <go>go</go>
    <timeLimit steps="350"/>
    <metric>turtle-final-resources</metric>
    <enumeratedValueSet variable="hazard-probability">
      <value value="5"/>
      <value value="10"/>
      <value value="20"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="hazard-susceptibility">
      <value value="20"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="hunting-on-journey-success">
      <value value="10"/>
    </enumeratedValueSet>
  </experiment>
  <experiment name="4sleds" repetitions="100" runMetricsEveryStep="false">
    <setup>setup</setup>
    <go>go</go>
    <timeLimit steps="350"/>
    <metric>turtle-final-resources</metric>
    <enumeratedValueSet variable="hazard-probability">
      <value value="5"/>
      <value value="10"/>
      <value value="20"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="hazard-susceptibility">
      <value value="20"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="hunting-on-journey-success">
      <value value="10"/>
    </enumeratedValueSet>
  </experiment>
  <experiment name="7sleds" repetitions="100" runMetricsEveryStep="false">
    <setup>setup</setup>
    <go>go</go>
    <timeLimit steps="350"/>
    <metric>turtle-final-resources</metric>
    <enumeratedValueSet variable="hazard-probability">
      <value value="5"/>
      <value value="10"/>
      <value value="20"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="hazard-susceptibility">
      <value value="20"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="hunting-on-journey-success">
      <value value="10"/>
    </enumeratedValueSet>
  </experiment>
  <experiment name="8sleds" repetitions="100" runMetricsEveryStep="false">
    <setup>setup</setup>
    <go>go</go>
    <timeLimit steps="350"/>
    <metric>turtle-final-resources</metric>
    <enumeratedValueSet variable="hazard-probability">
      <value value="5"/>
      <value value="10"/>
      <value value="20"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="hazard-susceptibility">
      <value value="20"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="hunting-on-journey-success">
      <value value="10"/>
    </enumeratedValueSet>
  </experiment>
  <experiment name="9sleds" repetitions="100" runMetricsEveryStep="false">
    <setup>setup</setup>
    <go>go</go>
    <timeLimit steps="350"/>
    <metric>turtle-final-resources</metric>
    <enumeratedValueSet variable="hazard-probability">
      <value value="5"/>
      <value value="10"/>
      <value value="20"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="hazard-susceptibility">
      <value value="20"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="hunting-on-journey-success">
      <value value="10"/>
    </enumeratedValueSet>
  </experiment>
  <experiment name="10sleds" repetitions="100" runMetricsEveryStep="false">
    <setup>setup</setup>
    <go>go</go>
    <timeLimit steps="350"/>
    <metric>turtle-final-resources</metric>
    <enumeratedValueSet variable="hazard-probability">
      <value value="5"/>
      <value value="10"/>
      <value value="20"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="hazard-susceptibility">
      <value value="20"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="hunting-on-journey-success">
      <value value="10"/>
    </enumeratedValueSet>
  </experiment>
  <experiment name="5sleds_sensitivity_hazardprob" repetitions="100" runMetricsEveryStep="false">
    <setup>setup</setup>
    <go>go</go>
    <timeLimit steps="350"/>
    <metric>turtle-final-resources</metric>
    <enumeratedValueSet variable="hazard-probability">
      <value value="0"/>
      <value value="5"/>
      <value value="10"/>
      <value value="15"/>
      <value value="20"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="hazard-susceptibility">
      <value value="20"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="hunting-on-journey-success">
      <value value="10"/>
    </enumeratedValueSet>
  </experiment>
  <experiment name="5sleds_sensitivity_hazardsusc" repetitions="100" runMetricsEveryStep="false">
    <setup>setup</setup>
    <go>go</go>
    <timeLimit steps="350"/>
    <metric>turtle-final-resources</metric>
    <enumeratedValueSet variable="hazard-probability">
      <value value="10"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="hazard-susceptibility">
      <value value="0"/>
      <value value="5"/>
      <value value="10"/>
      <value value="15"/>
      <value value="20"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="hunting-on-journey-success">
      <value value="10"/>
    </enumeratedValueSet>
  </experiment>
  <experiment name="5sleds_sensitivity_huntingsuccess" repetitions="100" runMetricsEveryStep="false">
    <setup>setup</setup>
    <go>go</go>
    <timeLimit steps="350"/>
    <metric>turtle-final-resources</metric>
    <enumeratedValueSet variable="hazard-probability">
      <value value="10"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="hazard-susceptibility">
      <value value="20"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="hunting-on-journey-success">
      <value value="0"/>
      <value value="10"/>
      <value value="20"/>
      <value value="30"/>
      <value value="40"/>
      <value value="50"/>
    </enumeratedValueSet>
  </experiment>
  <experiment name="4sleds_sensitivity_hazardprob" repetitions="100" runMetricsEveryStep="false">
    <setup>setup</setup>
    <go>go</go>
    <timeLimit steps="350"/>
    <metric>turtle-final-resources</metric>
    <enumeratedValueSet variable="hazard-probability">
      <value value="0"/>
      <value value="5"/>
      <value value="10"/>
      <value value="15"/>
      <value value="20"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="hazard-susceptibility">
      <value value="20"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="hunting-on-journey-success">
      <value value="10"/>
    </enumeratedValueSet>
  </experiment>
  <experiment name="4sleds_sensitivity_hazardsusc" repetitions="100" runMetricsEveryStep="false">
    <setup>setup</setup>
    <go>go</go>
    <timeLimit steps="350"/>
    <metric>turtle-final-resources</metric>
    <enumeratedValueSet variable="hazard-probability">
      <value value="10"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="hazard-susceptibility">
      <value value="0"/>
      <value value="5"/>
      <value value="10"/>
      <value value="15"/>
      <value value="20"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="hunting-on-journey-success">
      <value value="10"/>
    </enumeratedValueSet>
  </experiment>
  <experiment name="4sleds_sensitivity_huntingsuccess" repetitions="100" runMetricsEveryStep="false">
    <setup>setup</setup>
    <go>go</go>
    <timeLimit steps="350"/>
    <metric>turtle-final-resources</metric>
    <enumeratedValueSet variable="hazard-probability">
      <value value="10"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="hazard-susceptibility">
      <value value="20"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="hunting-on-journey-success">
      <value value="0"/>
      <value value="10"/>
      <value value="20"/>
      <value value="30"/>
      <value value="40"/>
      <value value="50"/>
    </enumeratedValueSet>
  </experiment>
  <experiment name="6sleds_sensitivity_hazardprob" repetitions="100" runMetricsEveryStep="false">
    <setup>setup</setup>
    <go>go</go>
    <timeLimit steps="350"/>
    <metric>turtle-final-resources</metric>
    <enumeratedValueSet variable="hazard-probability">
      <value value="0"/>
      <value value="5"/>
      <value value="10"/>
      <value value="15"/>
      <value value="20"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="hazard-susceptibility">
      <value value="20"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="hunting-on-journey-success">
      <value value="10"/>
    </enumeratedValueSet>
  </experiment>
  <experiment name="6sleds_sensitivity_hazardsusc" repetitions="100" runMetricsEveryStep="false">
    <setup>setup</setup>
    <go>go</go>
    <timeLimit steps="350"/>
    <metric>turtle-final-resources</metric>
    <enumeratedValueSet variable="hazard-probability">
      <value value="10"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="hazard-susceptibility">
      <value value="0"/>
      <value value="5"/>
      <value value="10"/>
      <value value="15"/>
      <value value="20"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="hunting-on-journey-success">
      <value value="10"/>
    </enumeratedValueSet>
  </experiment>
  <experiment name="6sleds_sensitivity_huntingsuccess" repetitions="100" runMetricsEveryStep="false">
    <setup>setup</setup>
    <go>go</go>
    <timeLimit steps="350"/>
    <metric>turtle-final-resources</metric>
    <enumeratedValueSet variable="hazard-probability">
      <value value="10"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="hazard-susceptibility">
      <value value="20"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="hunting-on-journey-success">
      <value value="0"/>
      <value value="10"/>
      <value value="20"/>
      <value value="30"/>
      <value value="40"/>
      <value value="50"/>
    </enumeratedValueSet>
  </experiment>
  <experiment name="7sleds_sensitivity_hazardprob" repetitions="100" runMetricsEveryStep="false">
    <setup>setup</setup>
    <go>go</go>
    <timeLimit steps="350"/>
    <metric>turtle-final-resources</metric>
    <enumeratedValueSet variable="hazard-probability">
      <value value="0"/>
      <value value="5"/>
      <value value="10"/>
      <value value="15"/>
      <value value="20"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="hazard-susceptibility">
      <value value="20"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="hunting-on-journey-success">
      <value value="10"/>
    </enumeratedValueSet>
  </experiment>
  <experiment name="7sleds_sensitivity_hazardsusc" repetitions="100" runMetricsEveryStep="false">
    <setup>setup</setup>
    <go>go</go>
    <timeLimit steps="350"/>
    <metric>turtle-final-resources</metric>
    <enumeratedValueSet variable="hazard-probability">
      <value value="10"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="hazard-susceptibility">
      <value value="0"/>
      <value value="5"/>
      <value value="10"/>
      <value value="15"/>
      <value value="20"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="hunting-on-journey-success">
      <value value="10"/>
    </enumeratedValueSet>
  </experiment>
  <experiment name="7sleds_sensitivity_huntingsuccess" repetitions="100" runMetricsEveryStep="false">
    <setup>setup</setup>
    <go>go</go>
    <timeLimit steps="350"/>
    <metric>turtle-final-resources</metric>
    <enumeratedValueSet variable="hazard-probability">
      <value value="10"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="hazard-susceptibility">
      <value value="20"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="hunting-on-journey-success">
      <value value="0"/>
      <value value="10"/>
      <value value="20"/>
      <value value="30"/>
      <value value="40"/>
      <value value="50"/>
    </enumeratedValueSet>
  </experiment>
  <experiment name="8sleds_sensitivity_hazardprob" repetitions="100" runMetricsEveryStep="false">
    <setup>setup</setup>
    <go>go</go>
    <timeLimit steps="350"/>
    <metric>turtle-final-resources</metric>
    <enumeratedValueSet variable="hazard-probability">
      <value value="0"/>
      <value value="5"/>
      <value value="10"/>
      <value value="15"/>
      <value value="20"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="hazard-susceptibility">
      <value value="20"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="hunting-on-journey-success">
      <value value="10"/>
    </enumeratedValueSet>
  </experiment>
  <experiment name="8sleds_sensitivity_hazardsusc" repetitions="100" runMetricsEveryStep="false">
    <setup>setup</setup>
    <go>go</go>
    <timeLimit steps="350"/>
    <metric>turtle-final-resources</metric>
    <enumeratedValueSet variable="hazard-probability">
      <value value="10"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="hazard-susceptibility">
      <value value="0"/>
      <value value="5"/>
      <value value="10"/>
      <value value="15"/>
      <value value="20"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="hunting-on-journey-success">
      <value value="10"/>
    </enumeratedValueSet>
  </experiment>
  <experiment name="8sleds_sensitivity_huntingsuccess" repetitions="100" runMetricsEveryStep="false">
    <setup>setup</setup>
    <go>go</go>
    <timeLimit steps="350"/>
    <metric>turtle-final-resources</metric>
    <enumeratedValueSet variable="hazard-probability">
      <value value="10"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="hazard-susceptibility">
      <value value="20"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="hunting-on-journey-success">
      <value value="0"/>
      <value value="10"/>
      <value value="20"/>
      <value value="30"/>
      <value value="40"/>
      <value value="50"/>
    </enumeratedValueSet>
  </experiment>
  <experiment name="9sleds_sensitivity_hazardprob" repetitions="100" runMetricsEveryStep="false">
    <setup>setup</setup>
    <go>go</go>
    <timeLimit steps="350"/>
    <metric>turtle-final-resources</metric>
    <enumeratedValueSet variable="hazard-probability">
      <value value="0"/>
      <value value="5"/>
      <value value="10"/>
      <value value="15"/>
      <value value="20"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="hazard-susceptibility">
      <value value="20"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="hunting-on-journey-success">
      <value value="10"/>
    </enumeratedValueSet>
  </experiment>
  <experiment name="9sleds_sensitivity_hazardsusc" repetitions="100" runMetricsEveryStep="false">
    <setup>setup</setup>
    <go>go</go>
    <timeLimit steps="350"/>
    <metric>turtle-final-resources</metric>
    <enumeratedValueSet variable="hazard-probability">
      <value value="10"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="hazard-susceptibility">
      <value value="0"/>
      <value value="5"/>
      <value value="10"/>
      <value value="15"/>
      <value value="20"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="hunting-on-journey-success">
      <value value="10"/>
    </enumeratedValueSet>
  </experiment>
  <experiment name="9sleds_sensitivity_huntingsuccess" repetitions="100" runMetricsEveryStep="false">
    <setup>setup</setup>
    <go>go</go>
    <timeLimit steps="350"/>
    <metric>turtle-final-resources</metric>
    <enumeratedValueSet variable="hazard-probability">
      <value value="10"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="hazard-susceptibility">
      <value value="20"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="hunting-on-journey-success">
      <value value="0"/>
      <value value="10"/>
      <value value="20"/>
      <value value="30"/>
      <value value="40"/>
      <value value="50"/>
    </enumeratedValueSet>
  </experiment>
  <experiment name="10sleds_sensitivity_hazardprob" repetitions="100" runMetricsEveryStep="false">
    <setup>setup</setup>
    <go>go</go>
    <timeLimit steps="350"/>
    <metric>turtle-final-resources</metric>
    <enumeratedValueSet variable="hazard-probability">
      <value value="0"/>
      <value value="5"/>
      <value value="10"/>
      <value value="15"/>
      <value value="20"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="hazard-susceptibility">
      <value value="20"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="hunting-on-journey-success">
      <value value="10"/>
    </enumeratedValueSet>
  </experiment>
  <experiment name="10sleds_sensitivity_hazardsusc" repetitions="100" runMetricsEveryStep="false">
    <setup>setup</setup>
    <go>go</go>
    <timeLimit steps="350"/>
    <metric>turtle-final-resources</metric>
    <enumeratedValueSet variable="hazard-probability">
      <value value="10"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="hazard-susceptibility">
      <value value="0"/>
      <value value="5"/>
      <value value="10"/>
      <value value="15"/>
      <value value="20"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="hunting-on-journey-success">
      <value value="10"/>
    </enumeratedValueSet>
  </experiment>
  <experiment name="10sleds_sensitivity_huntingsuccess" repetitions="100" runMetricsEveryStep="false">
    <setup>setup</setup>
    <go>go</go>
    <timeLimit steps="350"/>
    <metric>turtle-final-resources</metric>
    <enumeratedValueSet variable="hazard-probability">
      <value value="10"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="hazard-susceptibility">
      <value value="20"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="hunting-on-journey-success">
      <value value="0"/>
      <value value="10"/>
      <value value="20"/>
      <value value="30"/>
      <value value="40"/>
      <value value="50"/>
    </enumeratedValueSet>
  </experiment>
  <experiment name="11sleds" repetitions="100" runMetricsEveryStep="false">
    <setup>setup</setup>
    <go>go</go>
    <timeLimit steps="350"/>
    <metric>turtle-final-resources</metric>
    <enumeratedValueSet variable="hazard-probability">
      <value value="5"/>
      <value value="10"/>
      <value value="20"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="hazard-susceptibility">
      <value value="20"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="hunting-on-journey-success">
      <value value="10"/>
    </enumeratedValueSet>
  </experiment>
  <experiment name="11sleds_sensitivity_hazardprob" repetitions="100" runMetricsEveryStep="false">
    <setup>setup</setup>
    <go>go</go>
    <timeLimit steps="350"/>
    <metric>turtle-final-resources</metric>
    <enumeratedValueSet variable="hazard-probability">
      <value value="0"/>
      <value value="5"/>
      <value value="10"/>
      <value value="15"/>
      <value value="20"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="hazard-susceptibility">
      <value value="20"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="hunting-on-journey-success">
      <value value="10"/>
    </enumeratedValueSet>
  </experiment>
  <experiment name="11sleds_sensitivity_hazardsusc" repetitions="100" runMetricsEveryStep="false">
    <setup>setup</setup>
    <go>go</go>
    <timeLimit steps="350"/>
    <metric>turtle-final-resources</metric>
    <enumeratedValueSet variable="hazard-probability">
      <value value="10"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="hazard-susceptibility">
      <value value="0"/>
      <value value="5"/>
      <value value="10"/>
      <value value="15"/>
      <value value="20"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="hunting-on-journey-success">
      <value value="10"/>
    </enumeratedValueSet>
  </experiment>
  <experiment name="11sleds_sensitivity_huntingsuccess" repetitions="100" runMetricsEveryStep="false">
    <setup>setup</setup>
    <go>go</go>
    <timeLimit steps="350"/>
    <metric>turtle-final-resources</metric>
    <enumeratedValueSet variable="hazard-probability">
      <value value="10"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="hazard-susceptibility">
      <value value="20"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="hunting-on-journey-success">
      <value value="0"/>
      <value value="10"/>
      <value value="20"/>
      <value value="30"/>
      <value value="40"/>
      <value value="50"/>
    </enumeratedValueSet>
  </experiment>
  <experiment name="12sleds" repetitions="100" runMetricsEveryStep="false">
    <setup>setup</setup>
    <go>go</go>
    <timeLimit steps="350"/>
    <metric>turtle-final-resources</metric>
    <enumeratedValueSet variable="hazard-probability">
      <value value="5"/>
      <value value="10"/>
      <value value="20"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="hazard-susceptibility">
      <value value="20"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="hunting-on-journey-success">
      <value value="10"/>
    </enumeratedValueSet>
  </experiment>
  <experiment name="12sleds_sensitivity_hazardprob" repetitions="100" runMetricsEveryStep="false">
    <setup>setup</setup>
    <go>go</go>
    <timeLimit steps="350"/>
    <metric>turtle-final-resources</metric>
    <enumeratedValueSet variable="hazard-probability">
      <value value="0"/>
      <value value="5"/>
      <value value="10"/>
      <value value="15"/>
      <value value="20"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="hazard-susceptibility">
      <value value="20"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="hunting-on-journey-success">
      <value value="10"/>
    </enumeratedValueSet>
  </experiment>
  <experiment name="12sleds_sensitivity_hazardsusc" repetitions="100" runMetricsEveryStep="false">
    <setup>setup</setup>
    <go>go</go>
    <timeLimit steps="350"/>
    <metric>turtle-final-resources</metric>
    <enumeratedValueSet variable="hazard-probability">
      <value value="10"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="hazard-susceptibility">
      <value value="0"/>
      <value value="5"/>
      <value value="10"/>
      <value value="15"/>
      <value value="20"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="hunting-on-journey-success">
      <value value="10"/>
    </enumeratedValueSet>
  </experiment>
  <experiment name="12sleds_sensitivity_huntingsuccess" repetitions="100" runMetricsEveryStep="false">
    <setup>setup</setup>
    <go>go</go>
    <timeLimit steps="350"/>
    <metric>turtle-final-resources</metric>
    <enumeratedValueSet variable="hazard-probability">
      <value value="10"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="hazard-susceptibility">
      <value value="20"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="hunting-on-journey-success">
      <value value="0"/>
      <value value="10"/>
      <value value="20"/>
      <value value="30"/>
      <value value="40"/>
      <value value="50"/>
    </enumeratedValueSet>
  </experiment>
  <experiment name="13sleds" repetitions="100" runMetricsEveryStep="false">
    <setup>setup</setup>
    <go>go</go>
    <timeLimit steps="350"/>
    <metric>turtle-final-resources</metric>
    <enumeratedValueSet variable="hazard-probability">
      <value value="5"/>
      <value value="10"/>
      <value value="20"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="hazard-susceptibility">
      <value value="20"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="hunting-on-journey-success">
      <value value="10"/>
    </enumeratedValueSet>
  </experiment>
  <experiment name="13sleds_sensitivity_hazardprob" repetitions="100" runMetricsEveryStep="false">
    <setup>setup</setup>
    <go>go</go>
    <timeLimit steps="350"/>
    <metric>turtle-final-resources</metric>
    <enumeratedValueSet variable="hazard-probability">
      <value value="0"/>
      <value value="5"/>
      <value value="10"/>
      <value value="15"/>
      <value value="20"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="hazard-susceptibility">
      <value value="20"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="hunting-on-journey-success">
      <value value="10"/>
    </enumeratedValueSet>
  </experiment>
  <experiment name="13sleds_sensitivity_hazardsusc" repetitions="100" runMetricsEveryStep="false">
    <setup>setup</setup>
    <go>go</go>
    <timeLimit steps="350"/>
    <metric>turtle-final-resources</metric>
    <enumeratedValueSet variable="hazard-probability">
      <value value="10"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="hazard-susceptibility">
      <value value="0"/>
      <value value="5"/>
      <value value="10"/>
      <value value="15"/>
      <value value="20"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="hunting-on-journey-success">
      <value value="10"/>
    </enumeratedValueSet>
  </experiment>
  <experiment name="13sleds_sensitivity_huntingsuccess" repetitions="100" runMetricsEveryStep="false">
    <setup>setup</setup>
    <go>go</go>
    <timeLimit steps="350"/>
    <metric>turtle-final-resources</metric>
    <enumeratedValueSet variable="hazard-probability">
      <value value="10"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="hazard-susceptibility">
      <value value="20"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="hunting-on-journey-success">
      <value value="0"/>
      <value value="10"/>
      <value value="20"/>
      <value value="30"/>
      <value value="40"/>
      <value value="50"/>
    </enumeratedValueSet>
  </experiment>
</experiments>
@#$#@#$#@
@#$#@#$#@
default
0.0
-0.2 0 0.0 1.0
0.0 1 1.0 0.0
0.2 0 0.0 1.0
link direction
true
0
Line -7500403 true 150 150 90 180
Line -7500403 true 150 150 210 180
@#$#@#$#@
0
@#$#@#$#@
