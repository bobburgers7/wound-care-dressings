#import "@preview/codetastic:0.2.2": qrcode

#let load-product-image(image-path, product-name: "") = {
  // Only show the actual image, no placeholder
  box(width: 60pt, height: 40pt, stroke: 0.5pt)[
    #image(image-path, width: 60pt, height: 40pt, fit: "cover")
  ]
}

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

#let create-section-table(
  section-config, 
  products-data, 
  show-frequency: false
) = {
  let table-rows = ()
  
  // Section Header
  table-rows.push((
    table.cell(colspan: 4, fill: rgb(section-config.at("header-color", default: "#FFFFFF")), stroke: 1pt)[
      #text(weight: "bold", size: 12pt)[#section-config.title]
    ]
  ))
  
  // Table headers
  table-rows.push((
    [*Image*], [*Name & Type*], [*Description & Instructions*], [*Frequency*]
  ))
  
  // Add products
  for product-id in section-config.products {
    if product-id in products-data {
      let info = products-data.at(product-id)
      table-rows.push((
        // Load actual image from file - only show image if available
        if "image" in info.keys() {
          load-product-image(info.image, product-name: info.name)
        } else {
          box(width: 60pt, height: 40pt, fill: rgb("#f8f8f8"), stroke: 0.5pt)[
            #align(center + horizon)[
              #text(size: 8pt, fill: gray)[No Image]
            ]
          ]
        },
        [#text(weight: "bold")[#info.name] \ #text(size: 9pt, style: "italic")[#info.indication]], 
        [#info.description], 
        if show-frequency [Change: #info.frequency] else [#info.frequency]
      ))
    }
  }
  
  // Add section note if present
  if "note" in section-config.keys() {
    let note-color = if "note-color" in section-config.keys() { 
      rgb(section-config.at("note-color")) 
    } else { 
      rgb("#FFFACD") 
    }
    table-rows.push((
      table.cell(colspan: 4, fill: note-color, stroke: 0.5pt)[
        #text(size: 9pt, style: "italic")[#section-config.note]
      ]
    ))
  }
  
  return table-rows
}

#let create-catalog-review-section(
  catalog-config,
  products-data,
  show-frequency: false
) = {
  if not catalog-config.enabled {
    return []
  }
  
  let all-rows = ()
  
  // Main catalog header
  all-rows.push((
    table.cell(colspan: 4, fill: rgb(catalog-config.at("header-color", default: "#FFFFFF")), stroke: 1pt)[
      #text(weight: "bold", size: 12pt)[#catalog-config.title]
    ]
  ))
  
  // Add each category
  for (category-key, category-config) in catalog-config.at("categories", default: (:)) {
    // Category subheader
    all-rows.push((
      table.cell(colspan: 4, fill: rgb("#F8F8F8"), stroke: 0.5pt)[
        #text(weight: "bold", size: 11pt)[#category-config.title]
      ]
    ))
    
    // Category products
    for product-id in category-config.products {
      if product-id in products-data {
        let info = products-data.at(product-id)
        all-rows.push((
          // Image
          if "image" in info.keys() {
            load-product-image(info.image, product-name: info.name)
          } else {
            box(width: 60pt, height: 40pt, fill: rgb("#f8f8f8"), stroke: 0.5pt)[
              #align(center + horizon)[
                #text(size: 8pt, fill: gray)[No Image]
              ]
            ]
          },
          [#text(weight: "bold")[#info.name] \ #text(size: 9pt, style: "italic")[#info.indication]], 
          [#info.description], 
          if show-frequency [Change: #info.frequency] else [#info.frequency]
        ))
      }
    }
  }
  
  return all-rows
}

#let wound-care-guide(
  config-file: "wound-care-config.yaml",
  data-file: "wound-care-data.json"
) = {
  // Load configuration and data
  let config = yaml(config-file)
  let products-data = json(data-file)
  
  // Set the document's basic properties
  set document(
    title: config.document.title, 
    author: config.document.author
  )
  
  set page(
    "a4", 
    flipped: true, 
    margin: (left:1.5cm, rest:1cm, bottom: 2cm),
    footer: context [
      #line(length: 100%, stroke: 0.5pt + gray)
      #v(3pt)
      #text(font: ("Source Sans Pro", "Arial", "Helvetica", "sans-serif"), size: 8pt, fill: gray)[
        #if config.footer.show_date [
          Last revised: #datetime(
            year: config.document.date.year, 
            month: config.document.date.month, 
            day: config.document.date.day
          ).display("[year]-[month repr:numerical padding:zero]-[day padding:zero]")
        ]
        #if config.footer.show_version [ | Document version #config.footer.version]
        #h(1fr) Page #counter(page).display()
      ]
    ]
  )
  
  set text(font: ("Source Sans Pro", "Arial", "Helvetica", "sans-serif"), size:16pt, number-type: "lining")
  
  // Document header
  intro(
    title: smallcaps[#config.document.title], 
    tagline: config.document.tagline, 
    url: config.document.at("reference-url", default: "")
  )
  v(5pt, weak: true)
  
  show grid.cell: set text(font: ("Source Sans Pro", "Arial", "Helvetica", "sans-serif"), size:11pt)
  show grid.cell: set rect(fill:none, stroke:none, inset:8pt)
  show table.cell: set text(font: ("Source Sans Pro", "Arial", "Helvetica", "sans-serif"), size: 10pt)
  
  // Create main sections
  let all-table-rows = ()
  
  for (section-key, section-config) in config.sections {
    let section-rows = create-section-table(
      section-config, 
      products-data, 
      show-frequency: config.document.at("show-frequency", default: false)
    )
    all-table-rows = all-table-rows + section-rows
  }
  
  // Add catalog review section if enabled
  if config.at("catalog-review", default: (enabled: false)).enabled {
    let catalog-rows = create-catalog-review-section(
      config.at("catalog-review", default: (enabled: false)),
      products-data,
      show-frequency: config.document.at("show-frequency", default: false)
    )
    all-table-rows = all-table-rows + catalog-rows
  }
  
  // Create the main table
  table(
    columns: (auto, 1fr, 1fr, auto),
    align: (center, left, left, center),
    stroke: 0.5pt,
    ..all-table-rows.flatten()
  )
  
  v(10pt)
  text(font: ("Source Sans Pro", "Arial", "Helvetica", "sans-serif"), size:9pt, number-type: "lining")[
    *Important:* Always assess wound bed, surrounding skin, and patient factors before selecting dressing. 
    For detailed protocols visit: #config.document.at("reference-url", default: "")
  ]
}

// Example usage with the new split file system
#wound-care-guide(
  config-file: "wound-care-config.yaml",
  data-file: "wound-care-data.json"
)