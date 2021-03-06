
update_run_sh <- function() {
rl <- readLines(file.path(here::here(),"countries"))

currently <- seq_along(rl)[-grep("#", rl)]
currently_iso <- rl[currently]
not <- tail(currently,1) + grep("#", rl[tail(currently,1):length(rl)])
not <- head(not, -1)
not_iso <- gsub("# ", "", rl[not])

ecdc <- readRDS(file.path(here::here(),"archive","ecdc",tail(list.files(file.path(here::here(),"archive/ecdc/")),1),"ecdc_all.rds"))
with_deaths <- ecdc$countryterritoryCode[ecdc$deaths>0] %>% unique()

# any to change
to_uncomment <- which(not_iso %in% with_deaths)
to_comment <- which(!currently_iso %in% with_deaths)

# change them 
if(length(to_uncomment) > 0) {
rl[not[to_uncomment]] <- not_iso[to_uncomment]
}

if(length(to_comment) > 0) {
rl[currently[to_comment]] <- paste0("# ", currently_iso[to_comment])
}

writeLines(rl, file.path(here::here(),"countries"))

}

if(!interactive()) {
  update_run_sh()
}
