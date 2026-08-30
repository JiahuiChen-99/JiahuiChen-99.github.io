# Profile Icons, Education, and Honors Design

## Portrait metadata layout

- Keep the identity and contact information directly below the portrait.
- Widen the portrait panel and the homepage biography’s reserved right column so `Beijing Institute of Technology` remains on one line at desktop and standard mobile widths.
- Replace the current Unicode building, envelope, and plain-text `in` markers with inline SVG icons modeled on the supplied reference.
- Use a dark academic-building icon, dark envelope icon, and blue square LinkedIn icon with its white `in` mark contained inside the icon. Do not render a separate text `in` before the LinkedIn label.
- Preserve name, pronouns, email, LinkedIn destination, bilingual behavior, and the site’s restrained white-background academic style.

## Duke Education entry

Render the English entry as:

> Visiting PhD student in Energy and Environmental Economics, Sanford School of Public Policy. Supervisor: Professor Alex Pfaff.

Link `Professor Alex Pfaff` to `https://sanford.duke.edu/profile/alexander-pfaff/`. The Chinese entry will read `Sanford 公共政策学院能源与环境经济方向访问博士生。导师：Alex Pfaff 教授。`, with `Alex Pfaff 教授` linked to the same page.

## Selected honors

- Change the CSC entry to `China Scholarship Council (CSC) Scholarship`; Chinese remains `国家留学基金委公派奖学金`.
- Change the BIT CEEP Young Scholars Seminar award years from `2022, 2026` to `2023, 2026`.
- Add a 2020 entry: `National Scholarship, Ministry of Education of China` / `国家奖学金，教育部`.
- Keep the honors list in descending chronological order, placing the new 2020 entry last.

## Verification

Add regression checks for the SVG icons, no standalone LinkedIn `in` marker, unwrapped institution label, Alex Pfaff link, CSC wording, 2020 national scholarship, and corrected award years. Verify desktop and mobile English/Chinese rendering, no overlap or horizontal overflow, then push and verify GitHub Pages.
