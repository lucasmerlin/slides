---
theme: apple-basic
layout: intro-image
# some information about your slides (markdown enabled)
title: Kittest presentation
transition: slide-left
# enable MDC Syntax: https://sli.dev/features/mdc
mdc: true
# take snapshot for each slide in the overview
overviewSnapshots: true

---




<div class="absolute top-10">
  <span class="font-700">
    by Lucas Meurer
  </span>
</div>

<div class="absolute bottom-10">
  <h1>egui_flex 💪</h1>
  <p>Flex layout for egui</p>
</div>

---
layout: statement
---

# I wondered...

How much of flexbox could I implement in a single pass layout by just remembering the sizes from the last frame?

--- 

# A demo

https://app.hellopaint.io

https://lucasmerlin.github.io/hello_egui/#/example/flex

flex widgets

--- 

# How does it work?
- for a refresher on flex check out the flexbox guide: https://css-tricks.com/snippets/css/a-guide-to-flexbox/
- each item has an "intrinsic size", e.g. the width of a label when it is not truncated, wrapped or justified
- three methods of getting the intrinsic size
- each frame we remember the item sizes
- calculate the layout with the configured container width/height
  - based on the intrinsic sizes, items are grown / shrunk / justified, depending on the configuration

---

# add_ui

- Available size is set to the max width of the parent (`max_item_size`)
- The actual used sized is remembered (the intrinsic size) 
- On the next frame, the content is positioned based on the remembered size
---

# add_widget (for `egui::Widget`s)

- currently a mess
- Widgets are added in a centered_and_justified layout
- intrinsic size is based on `Response::intrinsic_size`
- detect if the height changes (due to wrapping) to detect if the size of the content changes (e.g. text was added)
- trigger a "remeasure", discarding two frames
- draw the widget with `max_item_size` to grab the actual intrinsic size

All this is only really necessary for widgets with a frame, so buttons and textedits, most widgets would be fine with 
the add_ui method, but there is no way to really figure out what we have from the trait.

---

# add_flex
- We render the child flex, passing in the max item and the target size (- margins)
- Intrinsic size all the intrinsic sizes of the child combined + the gaps
  - Means wrapping children aren’t handled correctly right now
  - I think this should be possible though

---

# Can we improve egui's default layout with these ideas?

- better `Ui::horizontal_centered`
- allow centering multiple widgets in a row/column

---

# Can flex be part of egui?

- would allow for much better performance (currently egui_flex creates a lot of child uis)
- could be on a similar level as `Grid`
- we need to remember widget sizes from the last frame
  - could use the `WidgetRect`s for that

---

# flex in egui questions

- how to handle `FlexItem`?
- how to handle `Frame`?
- how to make `Ui` extensible without cluttering the other layouts?
    - we might want a `Ui::add_item` that only exists on e.g. `Ui<Flex>`
- better support for egui widgets
    - ideally widgets should report their intrinsic size independently of the way they are currently displayed (truncated, wrapped, etc.)
