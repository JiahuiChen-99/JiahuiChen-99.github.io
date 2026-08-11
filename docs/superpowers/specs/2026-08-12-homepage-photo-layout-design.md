# Homepage Photo and Content Refresh Design

## Goal

Keep the homepage focused on Jiahui Chen's personal and academic identity, while displaying the portrait at its natural aspect ratio without stretching or aggressive cropping.

## Scope

- Retain the bilingual hero, education and joint-training information, email, CV, Google Scholar, and ORCID links.
- Remove the homepage research-focus cards and recent-publications section. Research content remains on `research.html`.
- Replace the organic clipped portrait treatment with a restrained rounded-rectangle frame.
- Preserve the portrait's intrinsic 1122:1402 ratio by using `height: auto` and no forced `aspect-ratio` or `object-fit` crop.
- Keep a two-column desktop hero and a centered, stacked mobile hero.

## Verification

The static contract will assert that the homepage contains no research overview sections and that the portrait CSS does not force a crop. Existing bilingual, link, publication, and identity checks remain active.
