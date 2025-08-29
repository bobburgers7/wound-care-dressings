#import "@preview/codetastic:0.2.2": qrcode

#let load-product-image(image-path, product-name: "", prefer-optimized: true) = {
  let final-path = if prefer-optimized and image-path.starts-with("images/") {
    image-path.replace("images/", "images-optimized/")
  } else {
    image-path
  }
  
  // Only show the actual image, no placeholder
  box(width: 70pt, height: 50pt, stroke: 0.5pt)[
    #image(final-path, width: 70pt, height: 50pt, fit: "cover")
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
  let card-width = 80pt
  let card-height = 80pt
  
  box(width: card-width, height: card-height)[
    #grid(
      rows: (20pt, 1fr),
      gutter: 2pt,
      align: center,
      // Text area with fixed height
      grid.cell(
        inset: (top: 2pt),
        align: center + horizon,
        text(font: "Source Sans Pro", size: 8pt, weight: "bold")[#name]
      ),
      // Image area
      grid.cell(
        align: center + horizon,
        if image-path != none {
          load-product-image(image-path, product-name: name)
        } else {
          box(width: 70pt, height: 50pt, fill: rgb("#f8f8f8"), stroke: 0.5pt)[
            #align(center + horizon)[
              #text(size: 7pt, fill: gray)[No Image]
            ]
          ]
        }
      )
    )
  ]
}

#let format-changelog(changelog-content) = {
  // Split content by lines and process
  let lines = changelog-content.split("\n")
  let formatted = ()
  
  for line in lines {
    if line.starts-with("## Version") {
      // Version headers
      formatted.push([#text(size: 11pt, weight: "bold")[#line]])
      formatted.push([])
    } else if line.starts-with("- ") {
      // Bullet points
      formatted.push([#text(size: 9pt)[#line]])
    } else if line.starts-with("  - ") {
      // Sub-bullet points
      formatted.push([#text(size: 8pt)[#line]])
    } else if line.trim().len() > 0 and not line.starts-with("#") {
      // Other content
      formatted.push([#text(size: 9pt)[#line]])
    }
    // Skip empty lines and # headers
  }
  
  return formatted
}

#let product-grid-guide(
  data-file: "wound-care-data.json",
  config-file: "wound-care-config.yaml"
) = {
  // Load data from JSON file and config
  let wound-data = json(data-file)
  let config = yaml(config-file)
  
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
  set text(font: "Source Sans Pro", size:16pt, number-type: "lining")
  
  intro(
    title: smallcaps[#config.document.title], 
    tagline: config.document.tagline, 
    url: config.document.at("reference-url", default: "")
  )
  v(5pt, weak: true)
  
  // Collect all products by category
  let all-products = ()
  
  // Iterate through all products and categorize them
  for (id, info) in wound-data {
    let image-path = if "image" in info.keys() { info.image } else { none }
    let category = info.category
    all-products.push((id: id, name: info.name, image: image-path, category: category))
  }
  
  // Group products by category - main sections
  let main-categories = (
    "Ointment/Gel": all-products.filter(p => p.category == "Ointment/Gel"),
    "Filler/Medicated": all-products.filter(p => p.category == "Filler/Medicated"), 
    "Cover": all-products.filter(p => p.category == "Cover"),
    "Multi-Layer Compression Wrap": all-products.filter(p => p.category == "Multi-Layer Compression Wrap"),
  )
  
  // Catalog review products organized by subcategories
  let catalog-products = all-products.filter(p => p.category == "Catalog-Review")
  
  // Display main sections
  for (section-key, section-config) in config.sections {
    let section-products = all-products.filter(product => {
      product.id in section-config.products
    })
    
    if section-products.len() > 0 {
      // Category header
      rect(fill: rgb(section-config.at("header-color", default: "#E6F3FF")), width: 100%, inset: 6pt)[
        #text(weight: "bold", size: 12pt)[#upper(section-config.title)]
      ]
      
      v(5pt)
      
      // Create grid of products (8 columns to fit more on landscape page)
      let columns = 8
      let rows = calc.ceil(section-products.len() / columns)
      
      grid(
        columns: (1fr,) * columns,
        column-gutter: 1pt,
        row-gutter: 12pt,
        ..section-products.map(product => 
          product-card(
            name: product.name, 
            image-path: product.image
          )
        )
      )
      
      v(15pt)
    }
  }
  
  // Display catalog review section if enabled
  if config.at("catalog-review", default: (enabled: false)).enabled {
    let catalog-config = config.at("catalog-review")
    
    // Main catalog header
    rect(fill: rgb(catalog-config.at("header-color", default: "#F0F0F0")), width: 100%, inset: 6pt)[
      #text(weight: "bold", size: 12pt)[#upper(catalog-config.title)]
    ]
    
    v(5pt)
    
    // Display each catalog subcategory
    for (category-key, category-config) in catalog-config.at("categories", default: (:)) {
      let category-products = all-products.filter(product => {
        product.id in category-config.products
      })
      
      if category-products.len() > 0 {
        // Subcategory header
        rect(fill: rgb("#F8F8F8"), width: 100%, inset: 4pt)[
          #text(weight: "bold", size: 11pt)[#category-config.title]
        ]
        
        v(3pt)
        
        // Create grid of products
        let columns = 8
        grid(
          columns: (1fr,) * columns,
          column-gutter: 1pt,
          row-gutter: 12pt,
          ..category-products.map(product => 
            product-card(
              name: product.name, 
              image-path: product.image
            )
          )
        )
        
        v(10pt)
      }
    }
  }
  
  v(10pt)
  text(font: "Source Sans Pro", size:9pt, number-type: "lining")[
    *Visual Reference Only* - For detailed usage instructions, refer to the complete wound care guide at: #config.document.at("reference-url", default: "")
  ]
  
  // Add changelog section
  pagebreak()
  
  text(size: 14pt, weight: "bold")[Change Log]
  v(8pt)
  
  // Load and format changelog
  let changelog-content = read("CHANGELOG.md")
  let changelog-items = format-changelog(changelog-content)
  
  for item in changelog-items {
    item
    v(3pt)
  }
}

// Example usage
#product-grid-guide(
  data-file: "wound-care-data.json",
  config-file: "wound-care-config.yaml"
)