
extensions [
  csv
  palette
]


globals
[
  QQ
  QQL
  qmec
  deathcounter
  deathlog
  strandmortstep

]

patches-own [
  pref_015
  pref_020
  pref_025
  pref_030
  pref_035
  pref_040
  pref_045
  pref_050
  pref_055
  pref_060
  pref_065
  pref_070
  pref_075
  pref_080
  pref_085
  pref_100
  pref_115
  pref_135
  pref
  dist_bank
]

turtles-own [
  flockmates
  turtlesinfront
  nearest-neighbor
  closest-classmate
  ori-xcor
  ori-ycor
  min-distance
  average-distance
  distance-traveled
  max-distance-traveled
  distance-bank
  meanx
  meany
]

to setup
  clear-all
  resize-world 0 298 0 498

  file-open "C:/Users/richard.hedger/OneDrive - NINA/SalStrand-IBM/Input data/MultiPref.txt"
  while [not file-at-end?] [
    let next-X file-read
    let next-Y file-read
    let next-pref_015 file-read
    let next-pref_020 file-read
    let next-pref_025 file-read
    let next-pref_030 file-read
    let next-pref_035 file-read
    let next-pref_040 file-read
    let next-pref_045 file-read
    let next-pref_050 file-read
    let next-pref_055 file-read
    let next-pref_060 file-read
    let next-pref_065 file-read
    let next-pref_070 file-read
    let next-pref_075 file-read
    let next-pref_080 file-read
    let next-pref_085 file-read
    let next-pref_100 file-read
    let next-pref_115 file-read
    let next-pref_135 file-read
    ask patch next-X next-Y [set pref_015 next-pref_015]
    ask patch next-X next-Y [set pref_020 next-pref_020]
    ask patch next-X next-Y [set pref_025 next-pref_025]
    ask patch next-X next-Y [set pref_030 next-pref_030]
    ask patch next-X next-Y [set pref_035 next-pref_035]
    ask patch next-X next-Y [set pref_040 next-pref_040]
    ask patch next-X next-Y [set pref_045 next-pref_045]
    ask patch next-X next-Y [set pref_050 next-pref_050]
    ask patch next-X next-Y [set pref_055 next-pref_055]
    ask patch next-X next-Y [set pref_060 next-pref_060]
    ask patch next-X next-Y [set pref_065 next-pref_065]
    ask patch next-X next-Y [set pref_070 next-pref_070]
    ask patch next-X next-Y [set pref_075 next-pref_075]
    ask patch next-X next-Y [set pref_080 next-pref_080]
    ask patch next-X next-Y [set pref_085 next-pref_085]
    ask patch next-X next-Y [set pref_100 next-pref_100]
    ask patch next-X next-Y [set pref_115 next-pref_115]
    ask patch next-X next-Y [set pref_135 next-pref_135]
  ]
  file-close

  file-open "C:/Users/richard.hedger/OneDrive - NINA/SalStrand-IBM/Input data/BankDist.Dep-Q135.txt"
  while [not file-at-end?] [
    let next-X file-read
    let next-Y file-read
    let next-dist-bank file-read
    ask patch next-X next-Y [set dist_bank next-dist-bank]
  ]
  file-close

  set QQ csv:from-file word "C:/Users/richard.hedger/OneDrive - NINA/SalStrand-IBM/Input data/Qmec.step.sim" word sim ".csv"
  set QQ reduce sentence QQ
  set QQL length QQ

  ask patches [
    set pref pref_135
   colorriv
  ]

  clear-turtles
  create-turtles 3000 [
    set size 2
    set color white
    random-seed 0
    setxy random-pxcor random-pycor
  ]

  ask turtles  [
    move-to one-of patches with [pref > 0.9]
    set distance-bank dist_bank
  ]

  set strandmortstep 1 - ( (1 - strandmort)^(1 / 24) )


  reset-ticks
end


to go
  tick
  set Qmec item (ticks - 1) QQ
  changepatchpref
  ask turtles  [
     pref_move
     avoid_others
     stranding

     if ticks = 144 [
        set ori-xcor xcor
        set ori-ycor ycor
     ]

     if ticks > 144  [
        set distance-traveled distancexy ori-xcor ori-ycor
           if distance-traveled > max-distance-traveled [
           set max-distance-traveled distance-traveled
        ]
     ]
     set distance-bank dist_bank
  ]

  if ticks >= 144  [
  write_png
  ]

  if ticks >= 144 * 2  [
;    write_data
    stop
  ]
end


to changepatchpref
 ask patches
  [
    if Qmec > 125 [set pref pref_135]
    if Qmec > 107.5 and Qmec <= 125 [set pref pref_115]
    if Qmec > 92.5 and Qmec <= 107.5 [set pref pref_100]
    if Qmec > 82.5 and Qmec <= 92.5 [set pref pref_085]
    if Qmec > 77.5 and Qmec <= 82.5 [set pref pref_080]
    if Qmec > 72.5 and Qmec <= 77.5 [set pref pref_075]
    if Qmec > 67.5 and Qmec <= 72.5 [set pref pref_070]
    if Qmec > 62.5 and Qmec <= 67.5 [set pref pref_065]
    if Qmec > 57.5 and Qmec <= 62.5 [set pref pref_060]
    if Qmec > 52.5 and Qmec <= 57.5 [set pref pref_055]
    if Qmec > 47.5 and Qmec <= 52.5 [set pref pref_050]
    if Qmec > 42.5 and Qmec <= 47.5 [set pref pref_045]
    if Qmec > 37.5 and Qmec <= 42.5 [set pref pref_040]
    if Qmec > 32.5 and Qmec <= 37.5 [set pref pref_035]
    if Qmec > 27.5 and Qmec <= 32.5 [set pref pref_030]
    if Qmec > 22.5 and Qmec <= 27.5 [set pref pref_025]
    if Qmec > 17.5 and Qmec <= 22.5 [set pref pref_020]
    if Qmec <= 17.5 [set pref pref_015]
    colorriv
  ]
end


to avoid_others
  set flockmates other turtles in-radius territory
  ifelse any? flockmates
    [
      set meanx mean [xcor] of flockmates
      set meany mean [ycor] of flockmates
      facexy meanx meany
      rt 180
      if [pref] of patch-ahead territory >= 0 [ forward territory ]
      set min-distance min [distance myself] of flockmates
      set average-distance mean [distance myself] of flockmates
    ]
    [
      set min-distance "#NA"
      set average-distance "#NA"
    ]
end

to pref_move
     let p max-one-of patches in-radius 5 [pref]
     if [pref] of p > pref
     [
       face p
       if [pref] of patch-ahead locusvel > -999
        [
        set turtlesinfront other turtles in-cone ( territory / 2 ) 90
         if not any? turtlesinfront
        [
           forward locusvel
           set distance-traveled distance-traveled + locusvel ]
        ]
     ]
end

to write_png
  set-current-directory "C:/Users/richard.hedger/OneDrive - NINA/SalStrand-IBM/Output data/"
  let val ticks + 100
  let outname (word "out." val ".png")
  export-view outname
  let outname2 (word "out." val ".csv")
  csv:to-file outname2 [ (list (xcor + 569350) (ycor + 7029800)) ] of turtles
end

to stranding
  if pref = -999 and random-float 1 <= strandmortstep
    [
      die
    ]
end


to colorriv

  set pcolor ( ifelse-value
      pref >= 0 and pref < 0.05 [black]
      pref >= 0.05 and pref < 0.1 [122]
      pref >= 0.1  and pref < 0.15 [102]
      pref >= 0.15  and pref < 0.2 [107]
      pref >= 0.2  and pref < 0.3 [sky]
      pref >= 0.3  and pref < 0.4 [cyan]
      pref >= 0.4  and pref < 0.5 [turquoise]
      pref >= 0.5  and pref < 0.6 [lime]
      pref >= 0.6  and pref < 0.7 [green]
      pref >= 0.7 and pref < 0.8 [yellow]
      pref >= 0.8 and pref < 0.9 [brown]
      pref >= 0.9 and pref < 0.95 [orange]
      pref >= 0.95 [red]
    [gray])

end


to write_data
     set-current-directory "C:/Users/richard.hedger/OneDrive - NINA/SalStrand-IBM/Output data/"
     csv:to-file "turtles.csv" [ (list ori-xcor ori-ycor xcor ycor min-distance average-distance) ] of turtles
end
@#$#@#$#@
GRAPHICS-WINDOW
178
10
477
518
-1
-1
0.97324415
1
20
1
1
1
0
1
1
1
0
298
0
498
0
0
1
ticks
30.0

BUTTON
10
38
81
80
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
12
108
83
150
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

PLOT
587
10
787
160
Abundance
NIL
NIL
0.0
10.0
0.0
10.0
true
false
"" ""
PENS
"default" 1.0 0 -16777216 true "" "plot count turtles"

SLIDER
490
250
662
283
locusvel
locusvel
0
5
1.0
1
1
NIL
HORIZONTAL

SLIDER
491
290
663
323
territory
territory
0
10
1.0
0.1
1
NIL
HORIZONTAL

SLIDER
493
330
665
363
strandmort
strandmort
0
1
0.5
0.05
1
NIL
HORIZONTAL

SLIDER
489
208
661
241
sim
sim
1
122
122.0
1
1
NIL
HORIZONTAL

PLOT
795
10
995
160
Distance traveled
NIL
NIL
0.0
10.0
0.0
10.0
true
false
"" ""
PENS
"default" 1.0 0 -16777216 true "" "plot max [max-distance-traveled] of turtles"
"pen-1" 1.0 0 -7500403 true "" "plot mean [max-distance-traveled] of turtles"

PLOT
1000
171
1200
321
Distance to bank
NIL
NIL
0.0
10.0
0.0
10.0
true
false
"" ""
PENS
"default" 1.0 0 -16777216 true "" "plot mean [distance-bank] of turtles"

@#$#@#$#@
## WHAT IS IT?

This model demonstrates one way to locate a continental divide.  A continental divide separates a continent into two regions based on two bodies of water.  Rain in one region flows into one body of water and rain in the other region flows into the other.

In the example data, the continent is North America and the two bodies of water used to calculate the divide are the Pacific and Atlantic oceans.

## HOW IT WORKS

The model is initialized with an elevation map.  Then both oceans systematically rise, bit by bit.  The two floods run towards each other over the continent and eventually crash.  The continental divide is precisely where the two floods collide.

## HOW TO USE IT

SETUP initializes the model.  Elevations are stored in the patches and they are colored appropriately. Also, the two floods are started off on the coasts.

GO runs the model.  When the floods cannot advance any more with the given height of the water, the water level is raised a little bit.  Eventually, when the whole continent has been flooded and the continental divide has been found, the model stops automatically.

## THINGS TO NOTICE

The two floods move at different rates.

The first 100 meters of flood covers more land than the last 100 meters.  What about in between?

Land that's flooded later isn't necessarily higher elevation. (Why?)

## THINGS TO TRY

Use the speed slider to slow the model down and watch what happens in more detail.

Increase the patch-size to get a better view of the action.  (Because the elevation data assumes specific dimensions, you can't change the number of patches in the model.)

## EXTENDING THE MODEL

Make a slider to control how much water-height changes when the flooding at a given water-height has stopped.

Make a slider for controlling how many colors from FLOODED-GROUND-COLOR-LIST get used.  With a smaller number, the flooded land's elevation is easier to see.  With a larger number, the progression of flooding is easier to see.

Is there a difference if `neighbors` is used instead of `neighbors4`? Make a switch to toggle between the two options and compare them.

Try the model with a more detailed dataset.

Allow the user of the model to specify different bodies of water than the Atlantic and Pacific oceans.  For example, it'd be interesting to see which water flows into the Gulf of Mexico and which flows into the Atlantic.

Allow the user to import maps of other parts of the world.

## NETLOGO FEATURES

Note the use of turtles to represent the edges of the flood.  Instead of asking all the patches to find the ones on each edge, we only need to ask the turtles to act.  Since at any given moment only a few patches are at a flood edge, this is much faster.

Note the used of `foreach` on multiple lists to initialize the elevation data in the patches.

## RELATED MODELS

Grand Canyon

## CREDITS AND REFERENCES

This model was inspired by Brian Hayes' article "Dividing the Continent" in American Scientist, Volume 88, Number 6, page 481.  An online version can be found here: https://www.jstor.org/stable/27858114

Thanks to Josh Unterman for his work on this model.

## HOW TO CITE

If you mention this model or the NetLogo software in a publication, we ask that you include the citations below.

For the model itself:

* Wilensky, U. (2007).  NetLogo Continental Divide model.  http://ccl.northwestern.edu/netlogo/models/ContinentalDivide.  Center for Connected Learning and Computer-Based Modeling, Northwestern University, Evanston, IL.

Please cite the NetLogo software as:

* Wilensky, U. (1999). NetLogo. http://ccl.northwestern.edu/netlogo/. Center for Connected Learning and Computer-Based Modeling, Northwestern University, Evanston, IL.

## COPYRIGHT AND LICENSE

Copyright 2007 Uri Wilensky.

![CC BY-NC-SA 3.0](http://ccl.northwestern.edu/images/creativecommons/byncsa.png)

This work is licensed under the Creative Commons Attribution-NonCommercial-ShareAlike 3.0 License.  To view a copy of this license, visit https://creativecommons.org/licenses/by-nc-sa/3.0/ or send a letter to Creative Commons, 559 Nathan Abbott Way, Stanford, California 94305, USA.

Commercial licenses are also available. To inquire about commercial licenses, please contact Uri Wilensky at uri@northwestern.edu.

<!-- 2007 -->
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

x
false
0
Polygon -7500403 true true 270 75 225 30 30 225 75 270
Polygon -7500403 true true 30 75 75 30 270 225 225 270
@#$#@#$#@
NetLogo 6.1.1
@#$#@#$#@
@#$#@#$#@
@#$#@#$#@
<experiments>
  <experiment name="" repetitions="3" runMetricsEveryStep="true">
    <setup>setup1
setup2</setup>
    <go>go</go>
    <metric>count turtles</metric>
    <metric>max [max-distance-traveled] of turtles</metric>
    <metric>mean [max-distance-traveled] of turtles</metric>
    <metric>mean [distance-bank] of turtles with [pref &gt; 0]</metric>
    <enumeratedValueSet variable="sim">
      <value value="122"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="locusvel">
      <value value="1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="territory">
      <value value="1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="strandmort">
      <value value="0.5"/>
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
