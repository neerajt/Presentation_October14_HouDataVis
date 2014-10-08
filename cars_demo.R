#' Get ggplot2 loaded in the environment
require(ggplot2)

#' Get our cars data loaded from the
#' included datasets.
data(mpg)

#' Upon inspection, we find that there are only two
#' timepoints for which these data were collected, 1999
#' and 2008. We can split our dataset into 'old' and 'new'

mpg_old <- subset(mpg, year == 1999)
mpg_new <- subset(mpg, year == 2008)

#' Let's see which manufacturers have the best gas mileage! We can start by
#' looking in the new cars data at highway mileage. Starting with the base-layer,
#' we'll give it the dataset and the aesthetic mappings for x and y positions.
p <- ggplot(mpg_old, aes(x=manufacturer, y=hwy))
#' Before we can draw anything, we need to plot something on top of the
#' base-layer. We'll tell ggplot to give us a boxplot with a blue fill color and
#' it will use the x and y position set in the base layer.
p <- p + geom_boxplot(fill='blue', alpha=0.5)
print(p)
#' Next we can add the city data to the same plot,
#' we'll choose a red fill color for this layer, and point
#' the y position to the city variable, and voila!
plt3 <- p + geom_boxplot(aes(y=cty), fill='red', alpha=0.5)
print(plt3)

#' It's kind of hard to read the labels of the manufacturers,
#' isn't it? Let's fix that by editing the default theme to
#' give us rotated labels. We'll give the figure a title and
#' fix the y axis label while we're at it.

plt4 <- plt3 + theme(axis.text.x = element_text(angle = 45, hjust = 1)) +
  ggtitle("Gas mileage by manufacturer") + 
  ylab("Gas mileage in miles per gallon")
print(plt4)

#' Or we can flip the whole thing.

plt5 <- plt3 + coord_flip()

print(plt5)

#' More to come