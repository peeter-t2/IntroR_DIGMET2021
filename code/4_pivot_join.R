
# So far we have worked with the clean gapminder dataset. We will here extend it with a few more datasets that are collected on gapminder.
# Namely there is a collection called 'Systema globalis' aimed to collect global information over time over a number of indicators.
# See more info in https://www.gapminder.org/data/, https://github.com/open-numbers/ddf--gapminder--systema_globalis, and https://open-numbers.github.io/ddf.html



# We can now try to read in several datasets and combine them with each other.
data_cells <- read_csv("data/ddf--datapoints--cell_phones_total--by--geo--time.csv")
data_pop <- read_csv("data/ddf--datapoints--population_total--by--geo--time.csv")
data_geo_meta <- read_csv("data/ddf--entities--geo--country.csv")

simple_meta <- data_geo_meta %>% 
  select(country, name, un_state, world_4region, world_6region, un_sdg_region)

data_geo_meta %>% 
  select(country, name, un_state, matches("region"))



# We now have the information we need given in separate dataframes and files. 



# See also the illustrations in the files
#' <center>
#' ![](figures/pivot_wider_tidybook.png)
#' </center>
#' 
#' <center>
#' ![](figures/pivot_longer_tidybook.png)
#' </center>
#' 

data_cells %>% 
  pivot_wider(id_cols=c("geo"),names_from="time",values_from="cell_phones_total")


# Should we want to turn that to longer again, we can use pivot_longer on the result.
data_cells %>% 
  pivot_wider(id_cols=c("geo"),names_from="time",values_from="cell_phones_total") %>% 
  pivot_longer(cols=matches("[0-9]"), names_to="time", values_to="cell_phones_total")


#nojah, midagi-midagi cellphones jmt



# This is now a very typical situation for in data analysis - the values we need are in different datasets and we need to combine them somehow. For this there are a number of commands in tidyverse to *join* datasets in different ways. (In other R packages, merge() is often used for this purpose.)

# There are a few main ways to join tables. The image below illustrates, and depicts the rows that will be kept.

#
#' <center>
#' ![](figures/joins.png)
#' </center>
#' 
#' 
#' - left_join() - joins the matching lines from right to the left, keeping the left table intact.
#' - right_join() - joins the matching lines from left to the right, keeping the right table intact.
#' - inner_join() - keeps only the matching lines from both tables
#' - full_join() - keeps all lines from both tables, even if nothing matches.
#' - anti_join() - works in an opposite way, and removes any matching rows from the first (left) table.
#' 
#' 


#inner_join

cellphonepop <- data_cells %>% 
  inner_join(data_pop,by=c("geo","time"))

data_cells %>% 
  anti_join(data_pop,by=c("geo","time"))

data_cells %>% 
  left_join(data_pop,by=c("geo","time"))

see <- data_cells %>% 
  right_join(data_pop,by=c("geo","time"))


data_cells %>% 
  rename(country=geo) %>% 
  anti_join(metainfo %>% filter(world_4region=="europe"),by="country")


#per population this
cellphonepop %>% 
  mutate(perpop=cell_phones_total/population_total) %>% 
  rename(country=geo) %>% 
  anti_join(metainfo %>% filter(world_4region=="europe"),by="country")%>% 
  ggplot(aes(x=time,y=perpop))+
  geom_point()


cellphonepop %>% 
  mutate(perpop=cell_phones_total/population_total) %>% 
  rename(country=geo) %>% 
  inner_join(metainfo %>% filter(world_4region=="europe"),by="country")%>% 
  ggplot(aes(x=time,y=perpop))+
  geom_point()


cellphonepop %>% 
  mutate(perpop=cell_phones_total/population_total) %>% 
  rename(country=geo) %>% 
  inner_join(metainfo %>% filter(world_4region=="europe"),by="country")%>% 
  ggplot(aes(x=time,y=perpop))+
  geom_point()


## group by year.
# meadian cellphone_per_pop



data_cells %>% 
  rename(country=geo) %>% 
  inner_join(data_geo_meta,by="country")


data_cells %>% 
  rename(country=geo) %>% 
  left_join(data_geo_meta,by="country")

data_cells %>% 
  rename(country=geo) %>% 
  right_join(data_geo_meta,by="country")

data_cells %>% 
  rename(country=geo) %>% 
  right_join(data_geo_meta,by="country")




# Try this yourself.

# 1. Now start with the EU dataset. First, pick a country.

# 2. Filter out only the data relevant to that country.

# 3. Calculate its gdp in the first year there is data.

# 4. Calculate its average life expectancy in the last 5 years for which there is data.

# 5. Create a table with the life expectancy, gdp per capita, population and gdp by year for the 2000s. Save it in a file. Preferably in a wide format.


# For saving the file you can use write_tsv(). Simply replace data with your variable name, or remove data, and attach this to the end of a block via a pipe %>%. Change the filename as needed. This writes a tsv. See write_csv, write_csv2, write_delim for more options.




# Explorations

# Look inside the data folder, there are a few more datasets given there. Pick one or two of them and try to merge them with the current data. 
# Can you think of any interesting relations to check? Give it a try.
# More information on the datasets is given here https://www.gapminder.org/data/, https://github.com/open-numbers/ddf--gapminder--systema_globalis, and https://open-numbers.github.io/ddf.html. However, for current purposes, the filenames ought to be explanatory enough.




