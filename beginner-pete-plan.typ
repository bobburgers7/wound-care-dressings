#set page(margin: 0.5in)
#set text(font: "Arial", size: 10pt)
#set table(stroke: 0.5pt + black)

#align(center)[
  #text(size: 16pt, weight: "bold")[Pete Plan 24-Week Beginner Training (Half Volume)]
  
  #text(size: 9pt, fill: gray)[3 Core Workouts + 2 Optional Per Week | Focus: Technique, Consistency, Progressive Overload]
]

#v(0.3cm)

#rect(fill: rgb("#f5f5f5"), stroke: 0.5pt + black, width: 100%)[
  #pad(8pt)[
    *Workout Types:*
    
    #text(size: 8pt)[
      *Day 1 - Endurance:* Build aerobic base, focus on technique (aim for 24 spm or below) \
      *Day 2 - Speed:* High intensity intervals, develop race pace power \
      *Day 3 - Speed Endurance:* Bridge between distance and speed training \
      *Optional 4 & 5:* Additional training when time/motivation permits [shown in brackets]
    ]
  ]
]

#v(0.3cm)

#table(
  columns: (8%, 18%, 18%, 18%, 19%, 19%),
  align: center,
  fill: (col, row) => if row == 0 { rgb("#ddd") } else if col == 0 { rgb("#eee") } else { none },
  
  [*Week*], [*Day 1 (Endurance)*], [*Day 2 (Speed)*], [*Day 3 (Speed End.)*], [*Optional 4*], [*Optional 5*],
  
  [*1*], [2500m], [3 × 500m / 2min], [2500m], [_\[10min\]_], [_\[10min / 2min\]_],
  [*2*], [2750m], [2 × 750m / 2min], [2750m], [_\[10min\]_], [_\[2 × 4min / 2min\]_],
  [*3*], [3000m], [1 × 2000m], [3000m], [_\[2500m\]_], [_\[3 × 500m / 2min\]_],
  [*4*], [3250m], [2 × 1000m / 3min], [3250m], [_\[3000m\]_], [_\[2500m / 2min\]_],
  [*5*], [3500m], [2 × 800m / 2min], [3500m], [_\[10min\]_], [_\[10min / 2min\]_],
  [*6*], [3750m], [2 × 2000m / 4min], [3750m], [_\[2500m\]_], [_\[3 × 500m / 2min\]_],
  [*7*], [4000m], [4 × 500m / 2min], [4000m], [_\[3000m\]_], [_\[2 × 1500m / 3min\]_],
  [*8*], [4250m], [2 × 1500m / 3min], [4000m], [_\[12min\]_], [_\[2 × 1k / 3min\]_],
  [*9*], [4500m], [2 × 800m / 2min], [4000m], [_\[4000m\]_], [_\[10min / 2min\]_],
  [*10*], [4750m], [2 × 2000m / 4min], [4000m], [_\[4000m\]_], [_\[4 × 500m / 2min\]_],
  [*11*], [5000m], [4 × 500m / 2min], [4000m], [_\[12min\]_], [_\[2 × 1500m / 3min\]_],
  [*12*], [5000m], [2 × 1500m / 3min], [2 × 10min / 2min], [_\[4000m\]_], [_\[2 × 800m / 2min\]_],
  [*13*], [5000m], [2 × 1k / 3min], [15min / 2min], [_\[4000m\]_], [_\[2 × 2k / 4min\]_],
  [*14*], [5000m], [2 × 2k / 4min], [2 × 8min / 2min], [_\[15min\]_], [_\[4 × 500m / 2min\]_],
  [*15*], [5000m], [3 × 750m / 2min], [2 × 10min / 2min], [_\[4000m\]_], [_\[2 × 1500m / 3min\]_],
  [*16*], [5250m], [3 × 1500m / 3min], [15min], [_\[5000m\]_], [_\[2 × 1k / 3min\]_],
  [*17*], [5250m], [4 × 500m / 2min], [15min / 2min], [_\[15min\]_], [_\[2 × 8min / 2min\]_],
  [*18*], [5500m], [2 × 2k / 4min], [15min], [_\[5000m\]_], [_\[2 × 1k / 3min\]_],
  [*19*], [5000m], [3 × 800m / 2min], [2 × 10min / 2min], [_\[15min\]_], [_\[2 × 2k / 4min\]_],
  [*20*], [6000m], [3 × 1500m / 3min], [15min], [_\[5000m\]_], [_\[4 × 500m / 2min\]_],
  [*21*], [5000m], [2 × 1k / 3min], [2 × 8min / 2min], [_\[6000m\]_], [_\[3 × 1500m / 3min\]_],
  [*22*], [6000m], [2 × 2k / 4min], [15min], [_\[2 × 10min / 2min\]_], [_\[3 × 800m / 2min\]_],
  [*23*], [5000m], [4 × 500m / 2min], [15min / 2min], [_\[5000m\]_], [_\[2 × 2k / 4min\]_],
  [*24*], [6000m], [3 × 1500m / 3min], [15min], [_\[15min / 2min\]_], [_\[2 × 1k / 3min\]_],
)

#v(0.3cm)

#rect(fill: rgb("#f9f9f9"), stroke: 0.5pt + black, width: 100%)[
  #pad(8pt)[
    #text(size: 9pt, weight: "bold")[Training Notes:]
    
    #text(size: 8pt)[
      • *Pacing:* Use previous sessions to set targets. Start conservatively, build gradually \
      • *Technique:* Priority #1. Aim for smooth, efficient strokes at 24 spm or below on distance work \
      • *Rest:* Stick to prescribed rest times between intervals. Use for hydration and refocusing \
      • *Progression:* Complete core sessions consistently before adding optionals. Log every workout \
      • *Recovery:* Rest days essential. If fatigued, reduce intensity rather than skip sessions \
      • *Volume:* This is half the original Pete Plan volume - perfect for beginners or time-constrained athletes
    ]
  ]
]

#align(center)[
  #text(size: 7pt, fill: gray)[Source: thepeteplan.wordpress.com | Modified for half-volume progression]
]