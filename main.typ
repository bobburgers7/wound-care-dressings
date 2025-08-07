#import "@preview/codetastic:0.2.2": qrcode

#let smcps = (x) => text(tracking: 0.8pt)[#smallcaps[#lower(x)]]

#let sentence-case(x) = text[#upper(x.at(0))#x.slice(1)]
#let darkgrey = rgb(29, 27, 28)
#let medical-red = rgb("#8B0000") 
#let medical-blue = rgb("#4682B4")
#let light-blue = rgb("#E6F3FF")
#let medical-green = rgb("#228B22")
#let light-green = rgb("#F0FFF0")

#let intro(title: none, tagline: none, url: none) = {
  grid(columns: (0.8cm,1fr, 2cm),
    [],
    grid.cell(
      rowspan: 1,
      inset: (bottom:12pt),
      smallcaps[#text(size:28pt)[#title]],
    ),
    grid.cell(
      rowspan: 2,
      inset: (bottom:0pt),
      qrcode(url, width: 2cm, quiet-zone:0,min-version:1, colors: (white,black)),
    ),
    [],
    text[#tagline]
  )
}

#let wound-type(body) = {
  box[
    #set text(font: "Source Sans Pro", size:12pt)
    #rect(fill:rgb("#DDDD").transparentize(60%),width:100%, height: 2cm)[#body]
  ]
}

#let dressing(
  category: "primary", 
  name: "hydrocolloid", 
  indication: "moderate exudate",
  fill: rgb("#E6F3FF"),
  description: text[absorptive, waterproof backing]
) = box[
  #set text(font: "Source Sans Pro", size:12pt)
  #rect(fill:fill,width:5.5cm, height: 2cm)[
    #smallcaps[#text(size:14pt)[#category]] | #text[#name]\ 
    #text(size:10pt, style: "italic")[#indication]\ 
    #description
  ]
]

#show grid.cell: set text(font: "Source Sans Pro", size:11pt)
#show grid.cell: set rect(fill:none,stroke:none, inset:8pt)

#let dressing-details(dressing-id, dressings: none, primary: true, footnote: none,
show-frequency: false) = {
  let info = dressings.at(dressing-id)
  let category = info.category
  let name = info.name
  let indication = info.indication
  let description = info.description
  let frequency = info.frequency
  let contraindications = if "contraindications" in info.keys() { info.contraindications } else { none }
  
  let fill = if primary {(
    "primary": rgb(176, 224, 230),      // Light blue
    "secondary": rgb(152, 251, 152),    // Light green  
    "antimicrobial": rgb(255, 182, 193), // Light pink
    "specialty": rgb(255, 218, 185),    // Light orange
  ).at(category)} else {rgb("#AAAA")}

  let stroke = if primary { 1pt + fill} else {1pt + color.mix((rgb("#AAAA"), 15%), (white, 85%)) }
  
  box[
    #set text(font: "Source Sans Pro", size:12pt)
    #rect(fill:color.mix((fill, 15%), (white, 85%)), stroke: stroke,
    width:100%, height: 2cm)[
      #smallcaps[#text(size:14pt)[#category#h(1pt)*#name*]] 
      #if show-frequency [#h(1fr) #text[Change: #frequency]] else {}  
      #h(1fr)| #text[#indication]\ 
      #description 
      #if footnote != none {text(size:9pt)[#eval(footnote, mode: "markup")]} else {}
    ]
  ]
}

#let wound-care-guide(
  title: "wound dressing selection guide",
  author: "Medical Team",
  tagline: text[Quick reference for wound assessment and dressing selection],
  reference-url: "", 
  dressing-info: none,
  dressing-ids: none,
  show-frequency: true,
  date: datetime(year: 2024, month: 12, day: 1),
) = {
  // Set the document's basic properties
  set document(title: title, author: author)
  set page("a4", flipped: true, margin: (left:1.5cm, rest:1cm))
  set text(font: "Source Sans Pro", size:16pt, number-type: "lining")
  
  intro(title: smallcaps[#title], tagline: tagline, url: reference-url)
  v(5pt, weak: true)
  
  show grid.cell: set text(font: "Source Sans Pro", size:11pt)
  show grid.cell: set rect(fill:none, stroke:none, inset:8pt)

  // Create table with dressing information
  show table.cell: set text(font: "Source Sans Pro", size: 10pt)
  
  let table-rows = ()
  
  // Primary Dressings Header
  table-rows.push((
    table.cell(colspan: 4, fill: rgb("#E6F3FF"), stroke: 1pt)[
      #text(weight: "bold", size: 12pt)[COMMONLY ORDERED OINTMENTS AND GELS]
    ]
  ))
  
  // Table headers
  table-rows.push((
    [*Image*], [*Name & Type*], [*Description & Instructions*], [*Frequency*]
  ))
  
  // Ointments and Gels
  for item in dressing-ids.ointments.topical {
    let info = dressing-info.at(item.id)
    table-rows.push((
      // Image placeholder - replace with actual image path
      if "image" in info.keys() {
        box(width: 60pt, height: 40pt, fill: rgb("#f8f8f8"), stroke: 0.5pt)[
          #align(center + horizon)[
            #text(size: 8pt, fill: gray)[#info.image]
          ]
        ]
      } else {
        box(width: 60pt, height: 40pt, fill: rgb("#f8f8f8"), stroke: 0.5pt)[
          #align(center + horizon)[
            #text(size: 8pt, fill: gray)[No Image]
          ]
        ]
      },
      [#text(weight: "bold")[#info.name] \ #text(size: 9pt, style: "italic")[#info.indication]], 
      [#info.description], 
      [#info.frequency]
    ))
  }
  
  // Note about oil emulsion gauze
  table-rows.push((
    table.cell(colspan: 4, fill: rgb("#FFFACD"), stroke: 0.5pt)[
      #text(size: 9pt, style: "italic")[Each of these can be spread over a piece of oil emulsion gauze first, then applied to the wound, to ensure coverage of the wound bed.]
    ]
  ))
  
  // Wound Fillers Header
  table-rows.push((
    table.cell(colspan: 4, fill: rgb("#E6FFE6"), stroke: 1pt)[
      #text(weight: "bold", size: 12pt)[COMMONLY ORDERED WOUND FILLERS AND MEDICATED DRESSINGS]
    ]
  ))
  
  // Fillers and Medicated Dressings
  for item in dressing-ids.fillers.medicated {
    let info = dressing-info.at(item.id)
    table-rows.push((
      [#text(weight: "bold")[#info.name]], 
      [#info.indication], 
      [#info.description], 
      [Change: #info.frequency]
    ))
  }
  
  // Cover Dressings Header
  table-rows.push((
    table.cell(colspan: 4, fill: rgb("#FFE6E6"), stroke: 1pt)[
      #text(weight: "bold", size: 12pt)[COMMONLY ORDERED COVER DRESSINGS]
    ]
  ))
  
  // Cover Dressings
  for item in dressing-ids.covers.secondary {
    let info = dressing-info.at(item.id)
    table-rows.push((
      [#text(weight: "bold")[#info.name]], 
      [#info.indication], 
      [#info.description], 
      [Change: #info.frequency]
    ))
  }
  
  // Create the table
  table(
    columns: (auto, 1fr, 1fr, auto),
    align: (left, left, left, center),
    stroke: 0.5pt,
    ..table-rows.flatten()
  )
  
  v(10pt)
  text(font: "Source Sans Pro", size:9pt, number-type: "lining")[
    *Important:* Always assess wound bed, surrounding skin, and patient factors before selecting dressing. 
    For detailed protocols visit: #reference-url
  ]
}

// Example usage with comprehensive wound care data:
#let comprehensive-dressing-info = (
  // Ointments and Gels
  "medihoney-gel": (
    category: "Ointment/Gel",
    name: "Medihoney Gel",
    indication: "Medical-grade honey gel",
    description: "Promotes debridement and reduction of bioburden. Available on unit carts.",
    frequency: "Daily",
    contraindications: "Honey allergies",
    image: "medihoney-gel.jpg"
  ),
  "hydrogel": (
    category: "Ointment/Gel", 
    name: "Hydrogel",
    indication: "Dry wounds",
    description: "Adds moisture to dry wounds. Available on unit carts.",
    frequency: "Daily",
    contraindications: "Heavy exudate",
    image: "hydrogel.jpg"
  ),
  "iodosorb": (
    category: "Ointment/Gel",
    name: "Iodosorb",
    indication: "Cadexomer iodine gel",
    description: "Absorbs drainage and promotes debridement. Comes from pharmacy.",
    frequency: "2-3 times weekly",
    contraindications: "Iodine allergy, thyroid disorders",
    image: "iodosorb.jpg"
  ),
  "santyl": (
    category: "Ointment/Gel",
    name: "Santyl",
    indication: "Enzymatic debriding ointment",
    description: "Enzymatic debridement. Apply in nickel-thick layer. Comes from pharmacy.",
    frequency: "Daily",
    contraindications: "Silver-containing products",
    image: "santyl.jpg"
  ),
  
  // Wound Fillers and Medicated Dressings
  "medihoney-alginate": (
    category: "Filler/Medicated",
    name: "Medihoney Alginate",
    indication: "Medical-grade honey alginate",
    description: "Absorbs drainage and dissolves. Can fill tunnels. Rip or cut to fit. Storeroom (#103872 small, #103873 large).",
    frequency: "1-3 days",
    contraindications: "Honey allergies, dry wounds",
    image: "medihoney-alginate.jpg"
  ),
  "gelling-fiber": (
    category: "Filler/Medicated",
    name: "Gelling Fiber",
    indication: "Exufiber/Aquacel - Alginate with silver/rope",
    description: "Absorbs drainage and becomes gel. Ribbon for deep tunnels. Storeroom (Aquacel #112580, Exufiber #201580).",
    frequency: "1-3 days", 
    contraindications: "Dry wounds",
    image: "gelling-fiber.jpg"
  ),
  "hydrofera-blue": (
    category: "Filler/Medicated",
    name: "Hydrofera Blue",
    indication: "Methylene Blue/Gentian Violet Foam",
    description: "Blue foam, absorbs drainage. Plain blue side touches wound. Obtain extra from SWAT.",
    frequency: "1-3 days",
    contraindications: "Dry wounds",
    image: "hydrofera-blue.jpg"
  ),
  "xeroform": (
    category: "Filler/Medicated",
    name: "Xeroform",
    indication: "Petroleum gauze with Bismuth",
    description: "Non-adherent, antimicrobial sheets. Useful for skin tears, burns, painful wounds. On unit carts.",
    frequency: "Daily",
    contraindications: "Bismuth sensitivity",
    image: "xeroform.jpg"
  ),
  "prisma-promogran": (
    category: "Filler/Medicated",
    name: "Prisma Promogran",
    indication: "Collagen with Silver",
    description: "Dissolvable collagen matrix. Rip or cut to fit, premoisten before applying. Storeroom #135917.",
    frequency: "Weekly",
    contraindications: "Silver allergies",
    image: "prisma-promogran.jpg"
  ),
  
  // Cover Dressings
  "mepilex": (
    category: "Cover",
    name: "Mepilex",
    indication: "Foam-Bordered or Foam-Borderless",
    description: "Absorbent cover dressing. Variety of sizes. Aggressive adhesive—use caution when removing. Available on unit carts.",
    frequency: "2-3 days",
    contraindications: "Fragile skin",
    image: "mepilex.jpg"
  ),
  "tegaderm-absorbent": (
    category: "Cover",
    name: "Tegaderm Absorbent",
    indication: "Transparent Film-Absorbent",
    description: "For shallow wounds—first-line treatment for skin tears. Can be left in place for 1 week. Gentle adhesive. Available on unit carts/Pyxis.",
    frequency: "Weekly",
    contraindications: "Heavy exudate",
    image: "tegaderm.jpg"
  ),
  "duoderm": (
    category: "Cover",
    name: "DuoDerm",
    indication: "Hydrocolloid",
    description: "For shallow wounds with minimal exudate. Also comes in Medihoney version (Medihoney HCS storeroom #147573).",
    frequency: "3-7 days",
    contraindications: "Heavy exudate, infection",
    image: "duoderm.jpg"
  ),
  "abd-gauze": (
    category: "Cover",
    name: "ABD & Rolled Gauze",
    indication: "Non-adherent gauze",
    description: "Best for large areas, limbs, or dressings that require frequent changing. Available on unit carts.",
    frequency: "Daily",
    contraindications: "None significant",
    image: "abd-gauze.jpg"
  )
)

#let comprehensive-dressing-ids = (
  ointments: (
    topical: (
      (id: "medihoney-gel", primary: true),
      (id: "hydrogel", primary: true),
      (id: "iodosorb", primary: true),
      (id: "santyl", primary: true),
    )
  ),
  fillers: (
    medicated: (
      (id: "medihoney-alginate", primary: true),
      (id: "gelling-fiber", primary: true),
      (id: "hydrofera-blue", primary: true),
      (id: "xeroform", primary: true),
      (id: "prisma-promogran", primary: true),
    )
  ),
  covers: (
    secondary: (
      (id: "mepilex", primary: false),
      (id: "tegaderm-absorbent", primary: false),
      (id: "duoderm", primary: false),
      (id: "abd-gauze", primary: false),
    )
  )
)

// Uncomment to test with comprehensive data:
#wound-care-guide(
  title: "wound care dressing guide",
  tagline: text[Quick reference for commonly ordered wound care products],
  dressing-info: comprehensive-dressing-info,
  dressing-ids: comprehensive-dressing-ids,
  reference-url: "https://example.com/wound-care-protocols"
)