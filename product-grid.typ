#import "@preview/codetastic:0.2.2": qrcode

#let load-product-image(image-path, product-name: "") = {
  // Only show the actual image, no placeholder
  box(width: 70pt, height: 50pt, stroke: 0.5pt)[
    #image(image-path, width: 70pt, height: 50pt, fit: "cover")
  ]
}

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

#let product-card(name: "", image-path: none) = {
  let card-width = 100pt
  let card-height = 80pt
  
  box(width: card-width, height: card-height)[
    #set align(center)
    #if image-path != none {
      load-product-image(image-path, product-name: name)
    } else {
      box(width: 70pt, height: 50pt, fill: rgb("#f8f8f8"), stroke: 0.5pt)[
        #align(center + horizon)[
          #text(size: 7pt, fill: gray)[No Image]
        ]
      ]
    }
    #v(1pt)
    #text(font: "Source Sans Pro", size: 8pt, weight: "bold")[#name]
  ]
}

#let product-grid-guide(
  title: "wound care products",
  author: "Medical Team",
  tagline: text[Visual reference for wound care products],
  reference-url: "", 
  data-file: "wound-care-data.json",
  date: datetime(year: 2024, month: 12, day: 1),
) = {
  // Load data from JSON file
  let wound-data = json(data-file)
  let dressing-info = wound-data.dressing-info
  let dressing-ids = wound-data.dressing-ids
  
  // Set the document's basic properties
  set document(title: title, author: author)
  set page(
    "a4", 
    flipped: true, 
    margin: (left:1.5cm, rest:1cm, bottom: 2cm),
    footer: context [
      #line(length: 100%, stroke: 0.5pt + gray)
      #v(3pt)
      #text(font: "Source Sans Pro", size: 8pt, fill: gray)[
        Last revised: #date.display("[year]-[month repr:numerical padding:zero]-[day padding:zero]") | Document version 1.0
        #h(1fr) Page #counter(page).display()
      ]
    ]
  )
  set text(font: "Source Sans Pro", size:16pt, number-type: "lining")
  
  intro(title: smallcaps[#title], tagline: tagline, url: reference-url)
  v(5pt, weak: true)
  
  // Collect all products
  let all-products = ()
  
  // Add ointments and gels
  for item in dressing-ids.ointments.topical {
    let info = dressing-info.at(item.id)
    let image-path = if "image" in info.keys() { info.image } else { none }
    all-products.push((name: info.name, image: image-path, category: "Ointments & Gels"))
  }
  
  // Add fillers and medicated dressings
  for item in dressing-ids.fillers.medicated {
    let info = dressing-info.at(item.id)
    let image-path = if "image" in info.keys() { info.image } else { none }
    all-products.push((name: info.name, image: image-path, category: "Fillers & Medicated"))
  }
  
  // Add cover dressings
  for item in dressing-ids.covers.secondary {
    let info = dressing-info.at(item.id)
    let image-path = if "image" in info.keys() { info.image } else { none }
    all-products.push((name: info.name, image: image-path, category: "Cover Dressings"))
  }
  
  // Group products by category
  let categories = (
    "Ointments & Gels": all-products.filter(p => p.category == "Ointments & Gels"),
    "Fillers & Medicated": all-products.filter(p => p.category == "Fillers & Medicated"),
    "Cover Dressings": all-products.filter(p => p.category == "Cover Dressings"),
  )
  
  // Display each category
  for (category-name, products) in categories {
    if products.len() > 0 {
      // Category header
      rect(fill: rgb("#E6F3FF"), width: 100%, inset: 6pt)[
        #text(weight: "bold", size: 12pt)[#upper(category-name)]
      ]
      
      v(5pt)
      
      // Create grid of products (6 columns to fit more on landscape page)
      let columns = 6
      let rows = calc.ceil(products.len() / columns)
      
      grid(
        columns: (1fr,) * columns,
        column-gutter: 1pt,
        row-gutter: 1pt,
        ..products.map(product => 
          product-card(
            name: product.name, 
            image-path: product.image
          )
        )
      )
      
      v(10pt)
    }
  }
  
  v(10pt)
  text(font: "Source Sans Pro", size:9pt, number-type: "lining")[
    *Visual Reference Only* - For detailed usage instructions, refer to the complete wound care guide at: #reference-url
  ]
}

// Example usage
#product-grid-guide(
  title: "wound care products",
  tagline: text[Visual reference guide - names and images],
  data-file: "wound-care-data.json",
  reference-url: "https://example.com/wound-care-protocols"
)