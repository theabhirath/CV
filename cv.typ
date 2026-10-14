// CV built on a vendored fork of the
// modern-cv Typst package (see modern-cv/README.md)
#import "modern-cv/lib.typ": *

#show: resume.with(
  author: (
    firstname: "Abhirath",
    lastname: "Anand",
    contacts: (
      (text: "abhirath@umich.edu", icon: "envelope", link: "mailto:abhirath@umich.edu"),
      (text: "theabhirath.com", icon: "globe", link: "https://theabhirath.com"),
      (text: "theabhirath", icon: "github", link: "https://github.com/theabhirath"),
      (text: "theabhirath", icon: "linkedin", link: "https://www.linkedin.com/in/theabhirath"),
      (text: "Abhirath Anand", icon: "google-scholar", link: "https://scholar.google.com/citations?user=312gafgAAAAJ"),
    ),
  ),
  paper-size: "a4",
)

#include "sections/education.typ"
#include "sections/experience.typ"
#include "sections/publications.typ"
#include "sections/talks.typ"
#include "sections/posters.typ"
#include "sections/workshops.typ"
#include "sections/projects.typ"
#include "sections/extracurricular.typ"
#include "sections/honors.typ"
#include "sections/skills.typ"
