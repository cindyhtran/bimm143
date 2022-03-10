#' ---
#' title: "Class 5 Data Visualization Lab"
#' author: "Cindy Tran (A15830581)"
#' date: "Winter 2022"
#' ---

# Week 4 Data Visualization Lab

# Install the package ggplot2
#install.packages("ggplot2")

# Any time I want to use this package, I need to load it
library(ggplot2)

View(cars)

# A quick baseR plot - this is not ggplot
plot(cars)

# Our first ggplot
#We need data + aes + geom
ggplot(data = cars) +
  aes(x = speed, y = dist) +
  geom_point() 

p <- ggplot(data = cars) +
  aes(x = speed, y = dist) +
  geom_point() 

# Add a line geom with geom_line()
p + geom_line()

# Add a trend line close to the data

p + geom_smooth()

p + geom_smooth(method = "lm")

# Adding labels
p + geom_smooth(method = "lm", se = FALSE) +
  labs(title = "Speed and Stopping Distances of Cars",
       x = "Speed (MPH)",
       y = "Stopping Distance (ft)",
       subtitle = "Your informative subtitle text here",
       caption = "Dataset: 'cars'") + 
  theme_bw()

##

#Read in drug expression data

url <- "https://bioboot.github.io/bimm143_S20/class-material/up_down_expression.txt"

genes <- read.delim(url)
head(genes)

# How many genes
nrow(genes)

# Column names and number of columns
colnames(genes)
ncol(genes)

#How many upreglated genes
table(genes$State)

#Fraction of genes up-regulated
round ( (table(genes$State) / nrow(genes)) * 100, 2)

# Let's make a first plot attempt
ggplot(data = genes) + 
  aes(x = Condition1, y = Condition2, col = State) + 
  geom_point()

#Change colors
ggplot(data = genes) +
  aes(x = Condition1, y = Condition2, col = State) +
  geom_point() +
  scale_color_manual(values = c("blue", "gray", "red")) +
  labs(title = "Gene Expression Changes Upon Drug Treatment",
       x = "Control (no drug)",
       y = "Drug Treatment") +
  theme_bw()

##

#Optional Part 6

#install.packages("gapminder")
library(gapminder)

# File location online
url2 <- "https://raw.githubusercontent.com/jennybc/gapminder/master/inst/extdata/gapminder.tsv"
gapminder <- read.delim(url2)

#install.packages(dplyr)
library(dplyr)

gapminder_2007 <- gapminder %>%
  filter(year == 2007)

ggplot(gapminder_2007) +
  aes(x = gdpPercap, y = lifeExp, color = continent, size = pop) +
  geom_point(alpha = 0.5)

# Color by pop
ggplot(gapminder_2007) + 
  aes(x = gdpPercap, y = lifeExp,
      size = pop) +
  geom_point(alpha = 0.5)

#Scale to reflect actual population differences
ggplot(gapminder_2007) + 
  geom_point(aes(x = gdpPercap, y = lifeExp,
                 size = pop),
             alpha = 0.5) +
  scale_size_area(max_size = 10)

#1957 Plot
gapminder_1957 <- gapminder %>% 
  filter(year == 1957)

ggplot(gapminder_1957) +
  aes(x = gdpPercap, y = lifeExp,
      color = continent,
      size = pop) +
  geom_point(alpha = 0.7)
scale_size_area(max_size = 10)

#Combine 1957 and 2007
gapminder_combined <- gapminder %>%
  filter(year == 1957 | year == 2007)

ggplot(gapminder_combined) + 
  geom_point(aes(x = gdpPercap, y = lifeExp,
                 color=continent,
                 size = pop), alpha=0.7) +
  scale_size_area(max_size = 10) +
  facet_wrap(~year)

##

#Optional Part 7

gapminder_top5 <- gapminder %>% 
  filter(year == 2007) %>% 
  arrange(desc(pop)) %>% 
  top_n(5, pop)
gapminder_top5

#Creating a bar chart
ggplot(gapminder_top5) +
  geom_col(aes(x = country, y = pop))

ggplot(gapminder_top5) +
  geom_col(aes(x = country, y = lifeExp))

#Filling bars with color
ggplot(gapminder_top5) + 
  geom_col(aes(x = country, y = pop, fill = continent))

ggplot(gapminder_top5) + 
  geom_col(aes(x = country, y = pop, fill = lifeExp))

#Population size by country
ggplot(gapminder_top5) +
  aes(x = country, y = pop, fill = gdpPercap) +
  geom_col()

#Change order of bars
ggplot(gapminder_top5) +
  aes(x = reorder(country, -pop), y=pop,
      fill = gdpPercap) +
  geom_col()

ggplot(gapminder_top5) +
  aes(x = reorder(country, -pop), y = pop,
      fill = country) +
  geom_col(col = "gray30") +
  guides(fill = FALSE)

#Flipping bar charts
head(USArrests)

USArrests$State <- rownames(USArrests)

ggplot(USArrests) +
  aes(x = reorder(State, Murder), y = Murder) +
  geom_col() +
  coord_flip()

ggplot(USArrests) +
  aes(x = reorder(State, Murder), y = Murder) +
  geom_point() +
  geom_segment(aes(x=State, 
                   xend=State, 
                   y=0, 
                   yend=Murder),
               color = "blue") +
  coord_flip()

##

#Optional Part 8

#install.packages("gifski")
#install.packages("gganimate")

library(gapminder)
library(gganimate)

# Setup nice regular ggplot of the gapminder data
ggplot(gapminder, aes(gdpPercap, lifeExp, size = pop, colour = country)) +
  geom_point(alpha = 0.7, show.legend = FALSE) +
  scale_colour_manual(values = country_colors) +
  scale_size(range = c(2, 12)) +
  scale_x_log10() +
  # Facet by continent
  facet_wrap(~continent) +
  # Here comes the gganimate specific bits
  labs(title = 'Year: {frame_time}', x = 'GDP per capita', y = 'life expectancy') +
  transition_time(year) +
  shadow_wake(wake_length = 0.1, alpha = FALSE)

##

#Optional Part 9

#Combining Plots

#install.packages("patchwork")
library(patchwork)

# Setup some example plots 
p1 <- ggplot(mtcars) + geom_point(aes(mpg, disp))
p2 <- ggplot(mtcars) + geom_boxplot(aes(gear, disp, group = gear))
p3 <- ggplot(mtcars) + geom_smooth(aes(disp, qsec))
p4 <- ggplot(mtcars) + geom_bar(aes(carb))

# Use patchwork to combine them here:
(p1 | p2 | p3) / 
  p4

sessionInfo()