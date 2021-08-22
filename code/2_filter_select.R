# This is a script file. Green text is comments, black text is commands, 


# Processing data in R


# We start by activating the 'tidyverse' library
library(tidyverse)
#This should show that it is attaching a few packages, and may give some 'conflicts'. This is nothing to worry about at this point.


# Let's read in some data
# This gapminder dataset is often used as an example in learning R commands.
gapminder <- read_csv("data/gapminder.csv")


# As before we can look within a variable to see what it contains. In this case it is a dataframe, a variant of the dataframe in tidyverse universe is called a tibble.
gapminder

# The dataset includes variables country, continent, year, lifeExp (life expectancy), pop (population), and gdpPercap (gdp per capita)



# Generally, we can also have a look at what is within the dataframe by clicking on its name in the environment menu top right. The same can be accomplished by running View(varname) - this is one of the rare functions starting with a capital letter.


View(gapminder)


# In tidyverse 'dialect' of R, the main way of operation is a pipe %>% . Pipe indicates to R that something follows to the element written before, and feeds it forward to the next function. RStudio has a convenient shortcut to make a pipe in ctrl+m. Try it.

# For example we can feed forward some data into a function. or a number into some calculation.

1 %>% # Pipe just continues the line, and feeds the input forward. 
  + 1

9 %>% # Here the pipe feeds the number into the argument of the sqrt() function.
  sqrt()

# This doesn't make things much clearer with these simple calculations, however working with data, this starts to justify itself.



# The core setup in tidyverse is thus the following.
## data %>%
##  function1() %>%
##  function2()
## 

# Function is something like we sqrt() that we used before, or read_csv(), or something that works with a table of data.




# The first command that we will get acquinted with is filter(). This allows rows to be selected from a dataset based on some criteria.

# For example, we can take all data from Finland. This will give us 12 yearly observations on Finland.
gapminder %>% 
  filter(country=="Finland")

# Notice that within the filter we are checking for equivalence. In this case between values in the column of country, and a a character sequence (string) Finland.

# Let's try to adapt this command to look for data on Germany.







# Alternatively we can take all data from the year 1952. Here we get one datapoint per country.
gapminder %>% 
  filter(year==1952)

# To spell it out, we are making a test for all the values in the column year or country, and keeping only the ones that match our case.


# Because it works sequentially, we can add one multiple filters
gapminder %>% 
  filter(country=="Finland") %>% 
  filter(year==1952)


# We can place here different types of tests that we encountered before.
gapminder %>% 
  filter(country%in%c("Finland","Germany"))


gapminder %>% 
  filter(year > 2000)


#And we can again add several criteria


gapminder %>% 
  filter(year <2000) %>% 
  filter(year >1980)

# We can also place several options within the filter. 

# AND & function means that both statements need to be true.
gapminder %>% 
  filter(year <2000&year >1980)

# , comma accomplishes the same function
gapminder %>% 
  filter(year <2000,year >1980)


# OR | function means that at least one statement needs to be true
gapminder %>% 
  filter(year >2000|year <1980)


# If we replace the earlier and with or, we get the whole dataset.
gapminder %>% 
  filter(year <2000|year >1980)

# There are a number of different combinations we can make.

gapminder %>% 
  filter(year==1952,pop<1000000)

gapminder %>% 
  filter(year==1952,lifeExp>70)


# And we can also include negation.
gapminder %>% 
  filter(!year==1952,gdpPercap>500,gdpPercap<1000)



# When running queries in sequence, make sure there is no pipe %>%  at the end of the query.
gapminder %>% 
  filter(country=="Finland") %>% 
  filter(year==1952) %>%
errror




### Small exercise

# 1. Find all data from Poland.


# 2. Find the population of Poland in 1972.


# 3. Find all data from Europe.


# 4. Find all European countries that had their life expectancy above 75 at some point in the 1970s.



### Extra:: Making life a bit more interesting

# Very frequently, getting an understanding of the dataset means visalizing and creating many graphs/plots to show what is in there
# This is done in R usually with ggplot2, part of the tidyverse universe.
# We will not look at it in much detail here - see Andres Karjus's workshop tomorrow. 
# But we will use it in the very basic setup.


# ggplot() is a function like filter, in this case it takes the data and makes a plot out of them.
# It has its own grammar that is similar to what we just saw with some quirks. E.g. instead of %>%  use +.
# But then we can plot any dataset.

# For example, let's take the whole dataset, and simply place a point on each of the values. Each row has year and also gdpPercap, so let's plot those.
# We just need to determine what goes on the x axis and what goes on the y axis.

# It will create many points that are difficult to understand initially as they are all together, but gives us an overview of what is in there.
# Already we see that one country is rather anomalous compared to the general trends
gapminder %>% 
  ggplot(aes(x=year,y=gdpPercap))+
  geom_point()

# We can get a better understandable subset by using the same filter command that we used before. Let's pick Finland.
gapminder %>% 
  filter(country=="Finland") %>% 
  ggplot(aes(x=year,y=gdpPercap))+
  geom_point()

# And let's pick Finland and Germany at the same time.
gapminder %>% 
  filter(country=="Finland"|country=="Germany") %>% 
  ggplot(aes(x=year,y=gdpPercap))+
  geom_point()

# And we can set a few extra parameters here. For example we can use the country value to color the points.
gapminder %>% 
  filter(country=="Finland"|country=="Germany") %>% 
  ggplot(aes(x=year,y=gdpPercap, color=country))+
  geom_point()


# Try to use this at the end of a few commands we used above, and see what you get.
# This is just an extra trick for now to get an understanding of the data, we will use just the basics here.
# A much more detailed overview will be given by Andres Karjus tomorrow.



######################################################################################3

# We can now expand our vocabulary a bit.


 
#' So far we know: ' 
#' - %>% - move data into the next process
#' - filter() - filter data by some criteria
#' 
#' Now we will add three more functions
#' - select() - pick certain columns of the dataset
#' - unique() - keep only unique rows
#' 
#' - arrange() - sort the data by some parameter
#' - arrange(desc()) - sort the data by some parameter in descending order
#' 


# The select() command can be used to select different parts of the dataframe. Although this dataset is quite compact, and not much selection is needed.
gapminder %>% 
  select(country,continent,year,lifeExp)

# We can also use numbers to select columns
gapminder %>% 
  select(1:4)

# We can take just country and continent
gapminder %>% 
  select(1:2)

# And the unique values there
gapminder %>% 
  select(1:2) %>% 
  unique()

# Or the same for continents
gapminder %>% 
  select(continent) %>% 
  unique()



# We can use arrange() to sort the data.

# The simplest option, we can find from throughout the dataset, which country had the highest population.

# First when we just arrange, we get the lowest population.
gapminder %>% 
  arrange(pop)

# Then, when we arrange in descending order, we get the highest population
gapminder %>% 
  arrange(desc(pop))

#However, as we see, in the 10 lowest, and the 10 highest values, there is a lot of repetitions. If we want to get a top10 or bottom10 list based on these parameters across all time, we can use a combination of select() and unique(). There are always many ways to accomplish the same task here.

# We can select() the columns country and continent, and we can keep only one option of each. The commands preserve the original order, and we get an all-time bottom10 list.
gapminder %>% 
  arrange(pop) %>% 
  select(country,continent) %>% 
  unique()

# Or a top 10 list, try here.





# But a more sensible question may be, which was the most populous country in 1952. For this we can use the filters again.
gapminder %>% 
  filter(year == 1952) %>% 
  arrange(desc(pop))

# Or what's the lowest life expectancy in 2007
gapminder %>% 
  filter(year == 2007) %>% 
  arrange(lifeExp) %>% 
  select(country, lifeExp)



# Select can be used here also to find the subset of the data that we are interested in.
gapminder %>% 
  filter(country=="Finland") %>% 
  select(year,pop,lifeExp)




# Try this out yourself! Find:

# 1. The country and year with the highest gdp per capita.


# 2. The trends in gdpPercap and life expectancy in that country. When was it lowest?


# 3. The top 10 countries in all time life expectancy.


# 4. An overview of the population of India

