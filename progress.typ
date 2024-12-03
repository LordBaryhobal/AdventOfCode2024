#import "/src/utils.typ": make-progress, template, star-state

#show: template
#set page(height: auto, margin: 1cm)
#let progress = yaml("/progress.yaml")
#star-state.update(s => {
  let p = progress
  for (k, v) in p.pairs() {
    p.at(k) = v.stars
  }
  return p
})
#make-progress(
  links: false,
  badge: (
    name: "LordBaryhobal",
    img: image("res/me.jpg", width: 3em)
  )
)