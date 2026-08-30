# Profile Details and Publication Metadata Design

## Scope

Update the homepage profile introduction, portrait metadata, Education entry, Academic service list, homepage footer date, and three publication records on `research.html`. Preserve the existing two-page architecture, bilingual behavior, overall minimalist academic style, remaining publications, and all unrelated content.

## Profile introduction

- Change “I have been a PhD candidate” to “I am a PhD candidate”.
- Use “Beijing Institute of Technology (BIT) since 2021,” without a comma before “since”.
- Link “Professor Hua Liao” to `https://scholar.google.com/citations?user=-TFrj1UAAAAJ&hl=en&oi=ao` and preserve the bilingual sentence structure.
- Remove “household” from the research-focus sentence.
- Bold the complete phrase “energy transitions and climate change”; in Chinese, bold “能源转型与气候变化”.

## Portrait metadata

Add a compact identity block directly below the portrait with:

- Jiahui Chen
- She/Her
- Beijing Institute of Technology
- `chenjh99@bit.edu.cn`, linked with `mailto:`
- LinkedIn, linked to `https://www.linkedin.com/in/jiahui-chen-193418387/`

Use small inline icons and restrained typography without copying the reference image’s gray card background. On desktop, the portrait and identity block remain in the right column; on mobile, the block appears directly below the portrait before the biography.

## Education and academic service

- Replace “Joint doctoral training” with “Visiting PhD student”.
- Replace the corresponding Chinese wording with “访问博士生”.
- The Academic service journal list will contain: AERE Summer Conference (2025); Energy Policy; Humanities and Social Sciences Communications; Environmental Science and Pollution Research; Sustainable Development; Energy, Sustainability and Society; Clean Energy Science and Technology.
- Remove Energy Economics, Energy, and World Development from that list.

## Publication metadata

Update only these three records while preserving author emphasis and the first paper’s DOI link:

1. Chen, J., Zhang, T., & Liao, H.* (2026). Solar photovoltaic adoption and poverty alleviation: Experience from rural China. *Environment and Development Economics*, 2026, 1–23.
2. Liao, H.*, Chen, J., Tang, X., Zhu, L., & Ma, C. (2026). Children’s Extracurricular Participation under Household Energy Transition: Evidence from China. *International Journal of Educational Development*, 120, 103486.
3. Li, W., Chen, J., Zheng, G., & Li, H.* (2025). Weather, Travel Modes, and the Effectiveness of Driving Restriction Policies: A Case of China. *Transportation*, 1–26.

The page’s existing year column remains, and citation punctuation follows the current site style.

## Footer and verification

- Add bilingual homepage footer text: “Site last updated 2026-8-28” / “网站最后更新于 2026-8-28”.
- Keep all site email links as `chenjh99@bit.edu.cn`.
- Add regression checks for the new profile wording, links, service list, footer date, and publication metadata.
- Verify English and Chinese desktop/mobile rendering, external links, no overflow, automated tests, GitHub push, and deployed HTML.
