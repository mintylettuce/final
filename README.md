# South Florida Insurance Market Analysis

A Quarto website exploring demographic and economic characteristics of Census block groups in Miami-Dade, Broward, and Palm Beach counties. It uses 2024 ACS 5-year estimates (covering 2020–2024) to compare income, age, population, household counts, renter-occupied housing, and home values.

The current download has 3,589 block groups. Rows missing median household income or median age are excluded; other estimates may be missing. Each row represents an area, not an individual or household, and these data do not measure insurance coverage or buying behavior.

## Set up and render

Run R commands in the R console and shell commands in the VS Code Terminal.

1. Install the R packages:

   ```r
   install.packages(c("tidycensus", "tidyverse", "ggplot2", "plotly"))
   ```

   Quarto is a separate command-line application, not an R package. Check that it is installed with `quarto --version`.

2. Get a Census API key from the [Census Bureau](https://api.census.gov/data/key_signup.html). In the R console, store it in your user-level `.Renviron` file:

   ```r
   invisible(tidycensus::census_api_key("YOUR_CENSUS_KEY", install = TRUE, overwrite = TRUE))
   ```

   Replace the placeholder locally; never put the actual key in a project file or commit it. Restart R after setting the key.

3. From the project root, download the data:

   ```sh
   Rscript download.R
   ```

   The cleaned CSV is saved to `data/south-florida-block-groups.csv`.

4. Render the website:

   ```sh
   quarto render
   ```

   Preview `_site/index.html` in a browser.

## Commit and publish

Create a **public** GitHub repository named `south-florida-insurance`. Before pushing, check `git remote -v` and make sure `origin` points to that repository. This working checkout currently points to `mintylettuce/final`, so do not push until the remote targets your intended project repository. If needed, update it with:

```sh
git remote set-url origin https://github.com/YOUR_USERNAME/south-florida-insurance.git
```

Then stage, commit, and push the source and downloaded data:

```sh
git add .gitignore README.md _quarto.yml download.R index.qmd explore.qmd story.qmd data/south-florida-block-groups.csv
git commit -m "Build South Florida insurance market analysis website"
git push -u origin HEAD
```

From the project root, publish to GitHub Pages:

```sh
quarto publish gh-pages
```

After GitHub Pages finishes deploying, the site URL will be `https://YOUR_USERNAME.github.io/south-florida-insurance/`.
