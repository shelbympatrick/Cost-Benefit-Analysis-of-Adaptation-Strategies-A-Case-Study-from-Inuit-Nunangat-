breed [people person]
breed [seals seal]

people-own [
  resources
  hunt-done?
  target

]

to setup
  clear-all
  setup-seals
  setup-people
  setup-patches
  create-hazards
  reset-ticks
end


to go
  go-to-target
  encounter-hazards
  hunt
  return-home
  tick
end


;; turtle procedures

to setup-people ;;determining how many hunters there are and setting their target to one of the seal
  create-people 4
  ask people [
    set shape "person"
    set size 5
    setxy 0 0
    set color blue
    set resources 0
    set hunt-done? false
    set target one-of seals
  ]
end

to setup-seals ;;determining how many seals are available on the landscape and randomly distributing them
  create-seals 10
  ask seals [
    set shape "fish"
    set size 5
    setxy random-xcor random-ycor
  ]
end


to go-to-target  ;;to have each hunter target a seal
  ask people [
    ifelse distance target > 1 [
      face target
      forward 1
    ][
      move-to target ]
  ]
end

to hunt ;;when the hunter reaches the seal, this determines how many resources they gain
  ask people
  [ if [patch-here] of target = patch-here [
    ifelse random 100 <= hunting-success [
          set resources (resources + (13 + random 7) )
          set hunt-done? true
    ][
      set resources resources + 0
      set hunt-done? true
    ]
  ]
  ]
end


to encounter-hazards ;;this determines how many patches will be hazards in the model and if the hunter encounter one instructs them to return home (to patch 0,0)
  ask people
  [ if pcolor = red [
    ifelse random 100 <= hazard-susceptibility [
      move-to patch 0 0
      set hunt-done? true
    ][
      hunt
    ]
   ]
  ]
end

to return-home ;;once the hunter has reached the seal and either successfully caught a seal or not, this directs them to return home (to patch 0,0)
  ask people [
  if hunt-done? = true [
     move-to patch 0 0
    ]
  ]

end

;; patch procedures

to setup-patches
  ask patches [
    set pcolor gray
  ]
end

to create-hazards
  ask patches [
    ifelse random 100 <= hazard-probability [
      set pcolor red
    ][
      set pcolor gray
    ]
  ]
end

;; reporter procedures

to-report people-final-resources
  report sum [resources] of people
end
@#$#@#$#@
GRAPHICS-WINDOW
394
10
1078
695
-1
-1
4.8
1
10
1
1
1
0
0
0
1
-70
70
-70
70
0
0
1
ticks
30.0

BUTTON
205
104
271
137
NIL
setup
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
207
159
270
192
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
163
242
320
287
NIL
people-final-resources
17
1
11

SLIDER
129
322
336
355
hunting-success
hunting-success
0
100
50.0
1
1
%
HORIZONTAL

SLIDER
127
370
334
403
hazard-probability
hazard-probability
0
100
5.0
1
1
%
HORIZONTAL

SLIDER
124
423
334
456
hazard-susceptibility
hazard-susceptibility
0
100
20.0
1
1
%
HORIZONTAL

@#$#@#$#@
## WHAT IS IT?

 The purpose of this local hunting model is to explore the average amount of resources, in the form of ringed seal meat, a group of a group of four hunters in a Central Arctic Archipelago community could acquire over a 30-day period of hunting with hunting attempts being made each day. In this case, hunting ringed seals represents the adaptive strategy of pursuing local, lower-ranked resources. In order to more closely simulate a real-life hunting scenario, the probability of success in each hunting attempt, the probability of encountering a hazard, and the probability of coping with an encountered hazard to a degree that hunting is able to continue are all considered. By predicting the average amount of resources a group can acquire over a 30-day period, this will enable a comparison in the overall productivity of this adaptive strategy to an alternative one: engaging in long-distance journeys for the purpose of acquiring perishable food goods via trade. As this model does represent a real Thule community in the Central Arctic Archipelago and is meant to simulate the average resources acquired when affected by hunting success probabilities and hazards, the pattern that determines its usefulness is whether or not the amount of total resources acquired varies between runs.
## HOW IT WORKS

There are four different submodels within the local hunting model. The first submodel is how the hunters move towards their target seal. After randomly choosing a target seal during the initialization of the model, the hunter then moves forward one patch on each tick. As they move forward toward the target, they may or may not encounter a hazard, as determined by the random number drawn in the model initialization. If a hunter encounters a hazard when executing the move-toward-target procedure/submodel, there is another random number drawn to determine if they are affected by the hazard or not. In terms of hunters’ susceptibility to hazards they encountered, this parameter followed Brinton (2018) as well and was set at 20%. In addition to search and rescue data utilized by Brinton (2018), dogsled teams have been reported to impact hazard avoidance as the slower pace of dog teams forces one to be more aware of the environment (Aporta 2004). Dogs also have a keen sense of where ice is thin, can use their sense of smell to follow paths in blizzard conditions, can scent hazards such as polar bears, and can detect seal lairs (Krupnik et al. 2010; Qikiqtani Inuit Association 2014). In this submodel, each hunter draws a random number, and if it is between 1 and 20, they are affected by the hazard, which means they return to the 0,0 coordinate without completing a hunting trip. If the random draw is between 21 and 100, they continue to their target seal. Hunters may encounter multiple hazards in one run of the model, and this encounter-hazard submodel repeats each time. Once a hunter reaches their target seal, they draw a random number to determine if they successfully catch a seal. This is a user-set probability, and the parameter determining hunting success began at 10% based on modern and ethnographic estimates of how successful breathing hole sealing attempts were (e.g., Balikci 1970 and Furgal et al. 2002). If a hunter successfully obtains a seal, their resources increase by a random value between 13 and 21 kilograms to simulate the natural variation in ringed seals’ weights (Ashley 2002), which is decided by adding 13 kilograms and then a random number of kilograms between one and seven to the hunter’s resources. Following a successful or unsuccessful hunt, the hunter returns to the 0,0 coordinate. 

## HOW TO USE IT

There are four types of entities in this model: agents representing hunters, agents representing seal breathing holes (shown as fish icons), square patches representing hazards, and square patches of normal land. The patches in this model represent a landscape of 141 x 141 patches. This is not meant to replicate an actual segment of the real-world environment but is meant to represent approximately 5km2, a feasible walking distance in one day for an able-bodied individual. When communities were pursuing ringed seals locally, ethnographic evidence details how the locations would be within walking distance (Balicki 1970). Each model run is a one-day time step. Square patches have two state variables: color and location. The color state variable indicates whether the patch is a hazard or not. In this model, grey patches represent an area with no hazard and red patches represent an area where a hazard is present. The location variable are the x- and y- coordinates of each patch. The four hunter agents have state variables in their location (x- and y- coordinates) and the amount of resources they have at any time. The ten seal agents have a state variable in their location (x- and y- coordinates), a random and the amount of resources they provide to the hunter if successfully caught. 

On model set up, the seal agents are randomly distributed throughout the landscape and each hunter sets one of the seals as their target. On each movement of the model, known as a “tick,” the hunter moves one patch towards their target until they have reached it. Along the way to the target seal, there is a user-set probability that the hunter will encounter a hazard. If they encounter a hazard, there is also a user-set probability that the hunter will need to abandon the hunt and return to the community. While the type of hazard is not specified in this model, some examples would be that a hunter becomes injured or unforeseen adverse weather conditions. If the hunter does not encounter a hazard or encounters a hazard but is able to continue, once they reach the seal’s location there is a user-set probability that they will successfully catch the seal. If successful, the hunter acquires the amount of resources assigned to that seal. After they reach the hunting location and either do or do not catch a seal, they return to the community.


## THINGS TO TRY

Try using different start values for the number of hazards and how susceptible the hunters are to the hazards.

## EXTENDING THE MODEL

Try adding environmental data or varying the number of hunters the model begins with.


## CREDITS AND REFERENCES

(a reference to the model's URL on the web if it has one, as well as any other necessary credits, citations, and links)
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
  <experiment name="test" repetitions="140" runMetricsEveryStep="false">
    <setup>setup</setup>
    <go>go</go>
    <timeLimit steps="100"/>
    <metric>people-final-resources</metric>
  </experiment>
  <experiment name="Combo 1" repetitions="3000" runMetricsEveryStep="false">
    <setup>setup</setup>
    <go>go</go>
    <timeLimit steps="100"/>
    <metric>people-final-resources</metric>
    <enumeratedValueSet variable="hazard-probability">
      <value value="5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="hunting-success">
      <value value="10"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="hazard-susceptibility">
      <value value="20"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="number-of-seals-caught">
      <value value="1"/>
    </enumeratedValueSet>
  </experiment>
  <experiment name="Combo 2" repetitions="3000" runMetricsEveryStep="false">
    <setup>setup</setup>
    <go>go</go>
    <timeLimit steps="100"/>
    <metric>people-final-resources</metric>
    <enumeratedValueSet variable="hazard-probability">
      <value value="5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="hunting-success">
      <value value="20"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="hazard-susceptibility">
      <value value="20"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="number-of-seals-caught">
      <value value="1"/>
    </enumeratedValueSet>
  </experiment>
  <experiment name="Combo 3" repetitions="3000" runMetricsEveryStep="false">
    <setup>setup</setup>
    <go>go</go>
    <timeLimit steps="1000"/>
    <metric>people-final-resources</metric>
    <enumeratedValueSet variable="hazard-probability">
      <value value="5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="hunting-success">
      <value value="30"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="hazard-susceptibility">
      <value value="20"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="number-of-seals-caught">
      <value value="1"/>
    </enumeratedValueSet>
  </experiment>
  <experiment name="Combo 4" repetitions="3000" runMetricsEveryStep="false">
    <setup>setup</setup>
    <go>go</go>
    <timeLimit steps="1000"/>
    <metric>people-final-resources</metric>
    <enumeratedValueSet variable="hazard-probability">
      <value value="5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="hunting-success">
      <value value="40"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="hazard-susceptibility">
      <value value="20"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="number-of-seals-caught">
      <value value="1"/>
    </enumeratedValueSet>
  </experiment>
  <experiment name="Combo 5" repetitions="3000" runMetricsEveryStep="false">
    <setup>setup</setup>
    <go>go</go>
    <timeLimit steps="100"/>
    <metric>people-final-resources</metric>
    <enumeratedValueSet variable="hazard-probability">
      <value value="5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="hunting-success">
      <value value="50"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="hazard-susceptibility">
      <value value="20"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="number-of-seals-caught">
      <value value="1"/>
    </enumeratedValueSet>
  </experiment>
  <experiment name="Combo 6" repetitions="3000" runMetricsEveryStep="false">
    <setup>setup</setup>
    <go>go</go>
    <timeLimit steps="100"/>
    <metric>people-final-resources</metric>
    <enumeratedValueSet variable="hazard-probability">
      <value value="5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="hunting-success">
      <value value="60"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="hazard-susceptibility">
      <value value="20"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="number-of-seals-caught">
      <value value="1"/>
    </enumeratedValueSet>
  </experiment>
  <experiment name="Combo 7" repetitions="3000" runMetricsEveryStep="false">
    <setup>setup</setup>
    <go>go</go>
    <timeLimit steps="100"/>
    <metric>people-final-resources</metric>
    <enumeratedValueSet variable="hazard-probability">
      <value value="5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="hunting-success">
      <value value="70"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="hazard-susceptibility">
      <value value="20"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="number-of-seals-caught">
      <value value="1"/>
    </enumeratedValueSet>
  </experiment>
  <experiment name="Combo 8" repetitions="3000" runMetricsEveryStep="false">
    <setup>setup</setup>
    <go>go</go>
    <timeLimit steps="100"/>
    <metric>people-final-resources</metric>
    <enumeratedValueSet variable="hazard-probability">
      <value value="5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="hunting-success">
      <value value="80"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="hazard-susceptibility">
      <value value="20"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="number-of-seals-caught">
      <value value="1"/>
    </enumeratedValueSet>
  </experiment>
  <experiment name="SensitivityAnalysisHazardProbability" repetitions="100" runMetricsEveryStep="false">
    <setup>setup</setup>
    <go>go</go>
    <timeLimit steps="300"/>
    <metric>people-final-resources</metric>
    <enumeratedValueSet variable="hazard-probability">
      <value value="0"/>
      <value value="5"/>
      <value value="10"/>
      <value value="15"/>
      <value value="20"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="hunting-success">
      <value value="10"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="hazard-susceptibility">
      <value value="20"/>
    </enumeratedValueSet>
  </experiment>
  <experiment name="SensitivityAnalysisHazardSusceptibility" repetitions="100" runMetricsEveryStep="false">
    <setup>setup</setup>
    <go>go</go>
    <timeLimit steps="300"/>
    <metric>people-final-resources</metric>
    <enumeratedValueSet variable="hazard-probability">
      <value value="5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="hunting-success">
      <value value="10"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="hazard-susceptibility">
      <value value="0"/>
      <value value="5"/>
      <value value="10"/>
      <value value="15"/>
      <value value="20"/>
    </enumeratedValueSet>
  </experiment>
  <experiment name="SensitivityAnalysisHuntingSuccess" repetitions="100" runMetricsEveryStep="false">
    <setup>setup</setup>
    <go>go</go>
    <timeLimit steps="300"/>
    <metric>people-final-resources</metric>
    <enumeratedValueSet variable="hazard-probability">
      <value value="5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="hunting-success">
      <value value="10"/>
      <value value="20"/>
      <value value="30"/>
      <value value="40"/>
      <value value="50"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="hazard-susceptibility">
      <value value="20"/>
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
