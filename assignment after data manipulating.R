getwd()
pups_df = read_csv("./data/FAS_pups.csv", na = c("NA","."))
pups_df = janitor::clean_names(pups_df)
select(pups_df,litter_number,sex,pd_ears)
filter(pups_df,sex == 1)
filter(pups_df,pd_walk <11 & sex == 2)
dd11 = mutate(pups_df,pd_7 = pd_pivot - 7)

pups_df2 = read_csv("./data/FAS_pups.csv", na = c("NA",".")) |>
  janitor::clean_names() |>
  filter(sex == 1) |>
  select(-pd_ears) |>
  mutate(pd_whe = pd_pivot >=7 )