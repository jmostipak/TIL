#' in reviewing code for a colleague they had used group_by() followed by mutate(), and were 
#' encountering errors in their code. I chimed in with "use summarise() after group_by()" and was
#' pretty thoroughly contradicted by the group, which pushed me to re-examine where I had picked
#' up that knowledge and whether or not it were true (it's not).
#' 
#' From Jenny: 
#' `group_by()` then `mutate()` is absolutely a "designed for" workflow, but the mutate 
#' operations are then done _within groups_ which is possibly where some people have internalized 
#' that it's a no-no or confusing?
#' 
#' Sharla shared the following explanation and example code:
#' here's one from gapminder where, say i want to know the % of years that each country has a 
#' life expectancy of 50+ -- first, i use mutate to count the number of years of data for each country,
#' then sort of "carry that along" to use as the denominator after i've counted how many years 
#' had a life expectancy of 50+:
#' 

library(gapminder)
library(dplyr)

gapminder %>%
  group_by(country) %>%
  mutate(n_years_data = n(),  # count the number of years of data by country
         life_exp_over_50 = lifeExp >= 50) %>%  # count instances of lifeExp >= 50
  group_by(country, n_years_data) %>%  # group_by country and number years of data
  summarise(n_years_life_exp_over_50 = sum(life_exp_over_50)) %>%  # calculate total lifeExp >= 50
  ungroup() %>%  # ungroup but carry along the values created by group_by
  mutate(prop_years_life_exp_over_50 = n_years_life_exp_over_50/n_years_data)  # calculate percentage
