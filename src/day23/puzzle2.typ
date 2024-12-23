#import "/src/utils.typ": *

#let bron-kerbosch(links, R, P, X) = {
  if P.len() == 0 and X.len() == 0 {
    return if R.len() > 2 {
      R.sorted()
    } else {
      none
    }
  }

  let longest-len = 0
  let longest = none
  let to-visit = P
  for v in to-visit {
    let neighbors = links.at(v)
    let clique = bron-kerbosch(
      links,
      R + (v,),
      P.filter(n => n in neighbors),
      X.filter(n => n in neighbors)
    )
    if clique != none {
      let l = clique.len()
      if longest == none or l > longest-len {
        longest = clique
        longest-len = l
      }
    }
    let _ = P.remove(0)
    X.push(v)
  }
  return longest
}

#let solve(input) = {
  let links = input.split("\n")

  let links-dict = (:)

  let to-test = ()
  for link in links {
    let (a, b) = link.split("-")
    if a not in links-dict {
      links-dict.insert(a, ())
    }
    if b not in links-dict {
      links-dict.insert(b, ())
    }
    links-dict.at(a).push(b)
    links-dict.at(b).push(a)
  }

  let clique = bron-kerbosch(links-dict, (), links-dict.keys(), ())

  return clique.join(",")
}

#show-puzzle(
  23, 2,
  solve,
  example: "co,de,ka,ta",
  only-example: true
)
#show-result("ab,al,cq,cr,da,db,dr,fw,ly,mn,od,py,uh")