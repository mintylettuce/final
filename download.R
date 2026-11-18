library(tidycensus)
library(tidyverse)

if (!nzchar(Sys.getenv("CENSUS_API_KEY"))) {
  stop("CENSUS_API_KEY is not set. Add your key to your user-level .Renviron file.")
}

acs_variables <- c(
  median_household_income = "B19013_001",
  median_age = "B01002_001",
  total_population = "B01003_001",
  households = "B11001_001",
  renter_occupied_units = "B25003_003",
  median_home_value = "B25077_001"
)

block_groups <- get_acs(
  geography = "block group",
  state = "FL",
  county = c("Miami-Dade", "Broward", "Palm Beach"),
  variables = acs_variables,
  year = 2024,
  survey = "acs5",
  output = "wide"
) |>
  mutate(
    county = case_when(
      str_detect(NAME, "Miami-Dade County") ~ "Miami-Dade",
      str_detect(NAME, "Broward County") ~ "Broward",
      str_detect(NAME, "Palm Beach County") ~ "Palm Beach",
      TRUE ~ NA_character_
    )
  ) |>
  transmute(
    geoid = GEOID,
    block_group = NAME,
    county,
    median_household_income = median_household_incomeE,
    median_age = median_ageE,
    total_population = total_populationE,
    households = householdsE,
    renter_occupied_units = renter_occupied_unitsE,
    median_home_value = median_home_valueE
  )

rows_before_filter <- nrow(block_groups)
block_groups <- block_groups |>
  filter(!is.na(median_household_income), !is.na(median_age))

dir.create("data", showWarnings = FALSE)
write_csv(block_groups, "data/south-florida-block-groups.csv")

message("Saved ", nrow(block_groups), " block groups to data/south-florida-block-groups.csv.")
message(
  "Removed ", rows_before_filter - nrow(block_groups),
  " block groups missing median income or median age."
)
