#' Import ggmap library (this will import ggplot2 as a dependency)
library(ggmap)
library(RCurl)


#' Get the data from github
download.file("https://raw.githubusercontent.com/ianwells/tabc/master/tabc_houston_small.csv", 
              destfile = "tabc_houston_small.csv", method = "curl")

#' Import data to R, the first argument is pointing to the file we just
#' downloaded.
d <- read.csv('tabc_houston_small.csv',
              colClasses = c('character', 'character', 'numeric',
                             'numeric', 'character', 'character',
                             'character', 'character', 'numeric',
                             'numeric'))
#' The colClasses part is telling R how to interpret each column, otherwise it
#' may think numbers are categories, etc. In the original version I coerced each
#' column to be the appropriate type when I was using it, here we ensure it will
#' always be right from the beginning. 

#'Compute a binary categorical variable for High or Low revenue
d$HighRev <- factor(as.numeric(d$rev > median(d$rev)),
                    labels=c("Low", "High"))

#' For now, let's remove all the bars that have $0 revenue, as they're
#' either too new or aren't paying taxes!
d <- subset(d, d$rev != 0)
  
#' Have ggmap's get_map function go get us a map of Houston from Google
#' We'll use coords, following up on Colin's question regarding centering the
#' map. Here we've just taken the median longitude and latitudes. Originally
#' we had used a call like this: houston <- get_map('houston', zoom=12)
houston <- get_map(c(-95.44, 29.76), zoom=12)

#' Set a base-layer for our map called HoustonMap
HoustonMap <- ggmap(houston, extent='device', legend='topright')


#' We need to plot something on the base-layer before we can draw it.
#' Let's draw dots for where the bars are.

plt1 <- HoustonMap +
  geom_point(data=d, 
             aes(x=lng,
                 y=lat)) +
  ggtitle("Bars in Houston")
print(plt1)

#' Now let's color the dots to represent whether the bars are in the
#' High revenue or Low revenue categories.

point.layer <- geom_point(data=d, 
             aes(x=lng,
                 y=lat,
                 color=HighRev))
plt2 <- HoustonMap + point.layer +
  scale_color_brewer("Revenue\nClass", palette='Set1') +
  ggtitle("Bars in Houston coded by revenue")
print(plt2)

#' Here we'll draw contours to represent the density of bars around Houston.
#' Or, in other words, where's the party at?
contour.layer <- stat_density2d(data=d,
                 aes(x=lng,
                     y=lat,
                     fill = ..level..
                     ),
                 alpha = 0.5)

plt3 <- HoustonMap + point.layer + contour.layer +
  ggtitle("Bars in Houston with countours \n for density") +
  theme(legend.position=0) + scale_color_brewer(palette='Set1')
print(plt3)

#'And here we'll change the geom within the density2d function call to change
#'the effect completely. We suppress the contours and instead compute small
#'tiled bins that represent density with their alpha. We get a cool effect.
tile.layer <- stat_density2d(data=d,
                             geom='tile',
                             contour=FALSE,
                             n=30,
                             aes(x=lng,
                                 y=lat,
                                 alpha = ..density..),
                             fill = 'blue')

plt4 <- HoustonMap + tile.layer + point.layer +
  theme(legend.position=0) + scale_color_brewer(palette='Set1') +
  scale_alpha(range=c(0.01,0.50))

print(plt4)
  