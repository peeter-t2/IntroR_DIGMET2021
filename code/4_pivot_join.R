
# So far we have worked with the clean gapminder dataset. We will here extend it with a few more datasets that are collected on gapminder.
# Namely there is a collection called 'Systema globalis' aimed to collect global information over time over a number of indicators.
# See more info in https://www.gapminder.org/data/, https://github.com/open-numbers/ddf--gapminder--systema_globalis, and https://open-numbers.github.io/ddf.html

# If we are restarting, then we need to activate the library again.
library(tidyverse)

# We can now try to read in several datasets and combine them with each other.
data_cells <- read_csv("data/ddf--datapoints--cell_phones_total--by--geo--time.csv")
data_pop <- read_csv("data/ddf--datapoints--population_total--by--geo--time.csv")
data_geo_meta <- read_csv("data/ddf--entities--geo--country.csv")

#Let's look inside the datasets
data_cells
data_pop
data_geo_meta

#The first 2 are very basic tidy datasets with one value column and just enough information to identify it.
#The third column is a rather wide file - it has 21 variables in there.
#Now we can put the select command to work!


# Let's pick some basic info about the country abbreviation, name, and location
simple_meta <- data_geo_meta %>% 
  select(country, name, un_state, world_4region, world_6region, un_sdg_region)

#select() has more interesting functions to experiment with that we do not discuss here.
#see ?select for more information
data_geo_meta %>% 
  select(country, name, un_state, matches("region"))


# Try to pick a sensible combination of the data there yourself












# In this case our data is distributed between several files.
# This is now a very typical situation for in data analysis - the values we need are in different datasets and we need to combine them somehow. For this there are a number of commands in tidyverse to *join* datasets in different ways. (In other R packages, merge() is often used for this purpose.)

# There are a few main ways to join tables. There is an image in the figures folder called 'joins.png' that captures the different variants.
# A very nice animated summary is visible here: https://www.garrickadenbuie.com/project/tidyexplain/


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



# When joining dataframes, we need to also specify what do we join them by. 
# For the first two datasets, cellphones and population, joining by location and year makes sense.
# They follow a similar structure so we can simply say that we join by geo and time

# For example let's do an inner_join (we keep only matching values from both datasets)
cellphonepop <- data_cells %>% 
  inner_join(data_pop,by=c("geo","time"))
# As a result we get a merger of the two dataframes with the values added where matches were found.
# In this case, we can nicely make a new variable - cellphones per population. And in principle compare them.


cellphonepop %>% 
  mutate(cell_phones_perpop=cell_phones_total/population_total)

cellphonepop %>% 
  mutate(cell_phones_perpop=cell_phones_total/population_total) %>% 
  ggplot(aes(x=time,y=population_total))+
  geom_point()
  

cellphonepop %>% 
  mutate(cell_phones_perpop=cell_phones_total/population_total) %>% 
  ggplot(aes(x=time,y=cell_phones_total))+
  geom_point()


cellphonepop %>% 
  mutate(cell_phones_perpop=cell_phones_total/population_total) %>% 
  ggplot(aes(x=time,y=cell_phones_perpop))+
  geom_point()


# Let's try and experiment with the other join types too here. Can you see what is happening within each dataset? Run them and have a look at the results.
data_cells %>% 
  anti_join(data_pop,by=c("geo","time"))

data_cells %>% 
  left_join(data_pop,by=c("geo","time"))

see <- data_cells %>% 
  right_join(data_pop,by=c("geo","time"))

# What happens if we join just by location?

data_cells %>% 
  left_join(data_pop,by=c("geo"))








# If we want to join dataframes with these commands, the names of the columns need to match between dataframes. (There are other methods, where this is not the case.) When we look at the cellphone and population data, and the simple_meta, we see that the first column does have the same values, but not the same name.
# Therefore we need to rename that column. Let's make it into a country. We can then again experiment with different join functions.

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
  anti_join(data_geo_meta,by="country")



# When we have the new meta functions, we can then start again experimenting with different grouping values. For example we can keep only Europe in our dataset.
# Let's plot this to have a nice overview
cellphonepop %>% 
  mutate(cell_phones_perpop=cell_phones_total/population_total) %>% 
  rename(country=geo) %>% 
  inner_join(simple_meta %>% filter(world_4region=="europe"),by="country")%>% 
  ggplot(aes(x=time,y=perpop))+
  geom_point()



# Or we can exclude all data from Europe in our dataset.
data_cells %>% 
  rename(country=geo) %>% 
  anti_join(simple_meta %>% filter(world_4region=="europe"),by="country")


#Let's plot the data without Europe. The lower values look quite different now.
cellphonepop %>% 
  mutate(cell_phones_perpop=cell_phones_total/population_total) %>% 
  rename(country=geo) %>% 
  anti_join(simple_meta %>% filter(world_4region=="europe"),by="country")%>% 
  ggplot(aes(x=time,y=perpop))+
  geom_point()


cellphonepop %>% 
  mutate(cell_phones_perpop=cell_phones_total/population_total) %>% 
  rename(country=geo) %>% 
  inner_join(simple_meta %>% filter(world_4region=="europe"),by="country")%>% 
  ggplot(aes(x=time,y=perpop))+
  geom_point()



## As before we can start experimenting with grouping data.

# We can get the average over time
cellphonepop %>% 
  mutate(cell_phones_perpop=cell_phones_total/population_total) %>% 
  rename(country=geo) %>% 
  inner_join(simple_meta,by="country") %>% 
  group_by(world_4region) %>% 
  summarise(avg_perpop=mean(cell_phones_perpop))

# And we can get the average for each year over time. This gives a nice time series to plot
cellphonepop %>% 
  mutate(cell_phones_perpop=cell_phones_total/population_total) %>% 
  rename(country=geo) %>% 
  inner_join(simple_meta,by="country") %>% 
  group_by(world_4region,time) %>% 
  summarise(avg_perpop=mean(cell_phones_perpop))

cellphonepop %>% 
  mutate(cell_phones_perpop=cell_phones_total/population_total) %>% 
  rename(country=geo) %>% 
  inner_join(simple_meta,by="country") %>% 
  group_by(world_4region,time) %>% 
  summarise(avg_perpop=mean(cell_phones_perpop)) %>% 
  ggplot(aes(x=time,y=avg_perpop,color=world_4region))+
  geom_point()
# The difference does not seem so high today, but the difference in averages more reflects a lag - africa is catching up.







# One thing that you may notice with these tables, that they may not look like tables that you have used to see. These are all dataframes in long, 'tidy' format, which means that you have just one observation per row. This is good for data processing, but maybe not usual for visual comparisons. 
# Very often data is given not in this long, but wide format (in various different ways). 
# Since this is a fairly simple transformation of the data, we can do that in R as well, we can transform the table so that each year is a column, each row is a location and the value is the number of cell phones. 
# For this, pivot_longer() and pivot_wider() are used. They are not really necessary for our purposes here, but may be very useful in some dataset that you may encounter.
# Or for a visual overview we can just save it.

# See also the illustrations in the files
#' <center>
#' ![](figures/pivot_wider_tidybook.png)
#' </center>
#' 
#' <center>
#' ![](figures/pivot_longer_tidybook.png)
#' </center>
#' 

# We can make the table from long to wide.
data_cells %>% 
  pivot_wider(id_cols=c("geo"),names_from="time",values_from="cell_phones_total")

# And save it into a file to see.
data_cells %>% 
  pivot_wider(id_cols=c("geo"),names_from="time",values_from="cell_phones_total") %>% 
  write_csv("data/cells_wide.csv")


# Should we want to turn that to longer again, we can use pivot_longer on the result.
# Typically, pivot_longer is something that is commonly used to get the data from an excel spreadsheet to tidy data, to allow this data processing.
data_cells %>% 
  pivot_wider(id_cols=c("geo"),names_from="time",values_from="cell_phones_total") %>% 
  pivot_longer(cols=matches("[0-9]"), names_to="time", values_to="cell_phones_total")








# Now we can try some more complicated questions. These require a combination of the functions already learned, combined for our purposes.
# If you're not sure where to begin with a question, you can try ask your neighbor for help, or skip it for now and try the next.

# 1. First pick two countries and compare their trajectories in acquiring cell phones. Use the total number of cell_phones.

# 2. Find the first year for each country that cell phones first arrived there. (First year that is not zero.)

# 3. Calculate the average cellphones per capita for each country in the 2000s. Which has the highest value, which the lowest.

# 4. Create an overview table and save it into a file.

# For saving the file you can use write_tsv(). Simply replace data with your variable name, or remove data, and attach this to the end of a block via a pipe %>%. Change the filename as needed. This writes a tsv. See write_csv, write_csv2, write_delim for more options.

# 5. Explorations!

# Look inside the data folder, there are a few more datasets given there. Pick one or two of them and try to merge them with the current data. 
# Can you think of any interesting relations to check? Give it a try.
# More information on the datasets is given here https://www.gapminder.org/data/, https://github.com/open-numbers/ddf--gapminder--systema_globalis, and https://open-numbers.github.io/ddf.html. However, for current purposes, the filenames ought to be explanatory enough.


# Try to find some interesting connections, share if you find something in the shared notes.









# At the very beginning we showed a graph with some country values in there. This may have looked complex at first, but in fact this is the same what we have been doing there. Simply the x axis is no longer time, we also use size as a value, and we scale it on a logarithm scale (this brings larger values closer to each other).

gapminder %>%
  group_by(country) %>%
  filter(year==max(year)) %>%
  ggplot(aes(y=lifeExp,x=gdpPercap,size=pop,color=continent))+
  geom_point()+
  scale_x_log10()

# So generally each of these elements can give be used to combine them in data manipulations, and if you know what you are looking for, then even simple steps can make for rather interesting stories.
# These have been the basics, I hope it gives some background for further steps in learning. Particularly the workshop on Data Exploration and Visualization in R by Andres Karjus.
