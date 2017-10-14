This is an R subroutine that makes it possible to make quality plots with a minimal learning curve. You do not need to learn all the ggplot2 options (right away) to produce nice figures. At the end of this document there is a full example.

Prerequisites
-------------

You need to install the following packages: ggplot2. If you plan to use plotimggg to convolve the arrays, you also need to install spatialfil.

A reminder: to install these packages, you can run the following code:

``` r
install.packages("ggplot2")
```

Including the plotting routine
------------------------------

For the time being the plotting routine is not an R package, but rather it should be included using the source function. The file can be found here: [pltptsgg.R](http://www.uv.es/mimica/Rblog/pltptsgg.R). Put the file somewhere (in your working directory, for example) and include it:

``` r
source("pltptsgg.R")
```

1D plots
--------

### Basic usage

The idea is that we have one or more data series and wish to display them. Let us start with the simplest case of just one series:

``` r
# generate x
x <- seq(from = 1, to = 10, by = 0.5)

# compute y from x
y <- x^2
```

To plot using pltptsgg.plot1D routine, we need to prepare the data. Since we wish to be able to plot multiple datasets, each with possibly different number of elements, pltptsgg provides two routines to convert the raw data into something pltptsgg.plot1D can easily use. First, we need to create a data frame, either manually or using pltptsgg.get.curve:

``` r
data.curve <- pltptsgg.get.curve(x, y)
```

The returned variable is a two-variable data frame (a two-column table), containing the "x" and "y" columns:

``` r
str(data.curve)
```

    ## 'data.frame':    19 obs. of  2 variables:
    ##  $ x: num  1 1.5 2 2.5 3 3.5 4 4.5 5 5.5 ...
    ##  $ y: num  1 2.25 4 6.25 9 ...

If we were plotting more than one series, we would create curves for each of them and then use pltptsgg.get.data to create a single list. In this case we use the only curve we have:

``` r
# create the list
data.list <- pltptsgg.get.data(list(data.curve))

# get information about the list
str(data.list)
```

    ## List of 1
    ##  $ curve01:'data.frame': 19 obs. of  2 variables:
    ##   ..$ x: num [1:19] 1 1.5 2 2.5 3 3.5 4 4.5 5 5.5 ...
    ##   ..$ y: num [1:19] 1 2.25 4 6.25 9 ...

Note that pltptsgg.get.data return a list of an arbitrary number of data frames, and each data frame contains only two columns named "x" and "y". You can use your own list instead of the one prepared by the routine, as long as the list is in this format.

Now we can call the plotting routine:

``` r
pltptsgg.plot1D(data.list)
```

![](README_files/figure-markdown_github/unnamed-chunk-7-1.png)

This is the default plot. If you wish to avoid storing the intermediate results, you can inline the other functions into the pltptsgg.plot1D call:

``` r
pltptsgg.plot1D(pltptsgg.get.data(list(pltptsgg.get.curve(x, y))))
```

![](README_files/figure-markdown_github/unnamed-chunk-8-1.png)

#### Plotting two series

Let's add another series to our plot:

``` r
# generate a new series
x2 <- c(1, 8, 9)
y2 <- c(2, 16, 75)

# generate curves
data.curve1 <- pltptsgg.get.curve(x, y)
data.curve2 <- pltptsgg.get.curve(x2, y2)

# generate data list
data.list <- pltptsgg.get.data(list(data.curve1, data.curve2))

# plot
pltptsgg.plot1D(data.list)
```

![](README_files/figure-markdown_github/unnamed-chunk-9-1.png)

As before, we can use a single call to plot everything:

``` r
pltptsgg.plot1D(pltptsgg.get.data(list(pltptsgg.get.curve(x, y), pltptsgg.get.curve(x2, y2))))
```

![](README_files/figure-markdown_github/unnamed-chunk-10-1.png)

Note that pltptsgg.get.data accepts a list of data frames as an argument. If you already have a data frame and it contains columns calles "x" and "y", you can pass it directly to pltptsgg.get.data.

#### Plotting points instead of lines

By default the lines are connecting the points. If we wish to plot some of the series as points, we can indicate it via the points logicalvector:

``` r
pltptsgg.plot1D(pltptsgg.get.data(list(pltptsgg.get.curve(x, y), pltptsgg.get.curve(x2, y2))), points=c(FALSE, TRUE))
```

![](README_files/figure-markdown_github/unnamed-chunk-11-1.png)

We can also change the shape type by passing the shapes vector:

``` r
pltptsgg.plot1D(pltptsgg.get.data(list(pltptsgg.get.curve(x, y), pltptsgg.get.curve(x2, y2))), points=c(FALSE, TRUE), shapes=c(0, 1))
```

![](README_files/figure-markdown_github/unnamed-chunk-12-1.png)

Note that the first element of shapes is ignored since we are plotting lines.

#### Changing the line type, width and colour

We can change the linetypes by using the linetypes keyword:

``` r
pltptsgg.plot1D(pltptsgg.get.data(list(pltptsgg.get.curve(x, y), pltptsgg.get.curve(x2, y2))), linetypes=c(2, 4))
```

![](README_files/figure-markdown_github/unnamed-chunk-13-1.png)

To change the width use linesizes:

``` r
pltptsgg.plot1D(pltptsgg.get.data(list(pltptsgg.get.curve(x, y), pltptsgg.get.curve(x2, y2))), linesizes=c(2, 4))
```

![](README_files/figure-markdown_github/unnamed-chunk-14-1.png)

Similarly, the colours keyword changes colours:

``` r
pltptsgg.plot1D(pltptsgg.get.data(list(pltptsgg.get.curve(x, y), pltptsgg.get.curve(x2, y2))), colours=c("red", "yellow"))
```

![](README_files/figure-markdown_github/unnamed-chunk-15-1.png)

### Adjusting legends

By default, the routine labels the curves automatically: "curve01", "curve02", etc. We can adjust this by using labels keyword:

``` r
pltptsgg.plot1D(pltptsgg.get.data(list(pltptsgg.get.curve(x, y), pltptsgg.get.curve(x2, y2))), labels=c("Quantity 1", "Quantity 2"))
```

![](README_files/figure-markdown_github/unnamed-chunk-16-1.png)

The legend title can be changed using the legend.name keyword:

``` r
pltptsgg.plot1D(pltptsgg.get.data(list(pltptsgg.get.curve(x, y), pltptsgg.get.curve(x2, y2))), labels=c("Quantity 1", "Quantity 2"), legend.name = "Quantities shown")
```

![](README_files/figure-markdown_github/unnamed-chunk-17-1.png)

### Adjusting axes

Often the axes generated by ggplot2 are good enough. Nevertheless, pltptsgg.plot1D provides a number of keywords which can be used to adjust them.

#### Axis labels

To change axis labels, use xlab and ylab keywords:

``` r
pltptsgg.plot1D(pltptsgg.get.data(list(pltptsgg.get.curve(x, y), pltptsgg.get.curve(x2, y2))), xlab="time", ylab="space")
```

![](README_files/figure-markdown_github/unnamed-chunk-18-1.png)

#### Axis limits

The limits can be changed using xlim and ylim keywords:

``` r
pltptsgg.plot1D(pltptsgg.get.data(list(pltptsgg.get.curve(x, y), pltptsgg.get.curve(x2, y2))), xlim=c(1, 100), ylim=c(-100, 100))
```

![](README_files/figure-markdown_github/unnamed-chunk-19-1.png)

#### Axis scale

The scale can be changed to logarithmic using xlog and ylog keywords:

``` r
pltptsgg.plot1D(pltptsgg.get.data(list(pltptsgg.get.curve(x, y), pltptsgg.get.curve(x2, y2))), xlog = TRUE, ylog = TRUE)
```

![](README_files/figure-markdown_github/unnamed-chunk-20-1.png)

In order to obtain a more traditional logarithmic plot, with minor grid lines denoting the intermediate values use major.xticks = 10 and major.yticks = 10 (see below for the explanation of these keywords):

``` r
pltptsgg.plot1D(pltptsgg.get.data(list(pltptsgg.get.curve(x, y), pltptsgg.get.curve(x2, y2))), xlog = TRUE, ylog = TRUE, major.xticks = 10, major.yticks = 10)
```

![](README_files/figure-markdown_github/unnamed-chunk-21-1.png)

#### Axis number format

Keeping the logarithmic plot example, we may wish to change the number format to powers of 10:

``` r
pltptsgg.plot1D(pltptsgg.get.data(list(pltptsgg.get.curve(x, y), pltptsgg.get.curve(x2, y2))), xlog = TRUE, ylog = TRUE, major.xticks = 10, major.yticks = 10, xformat = "pow", yformat = "pow")
```

![](README_files/figure-markdown_github/unnamed-chunk-22-1.png)

Another option, apart from the defualt one, is the scientific. Reverting to the linear scale for this example:

``` r
pltptsgg.plot1D(pltptsgg.get.data(list(pltptsgg.get.curve(x, y), pltptsgg.get.curve(x2, y2))), xformat = "sci", yformat = "sci")
```

![](README_files/figure-markdown_github/unnamed-chunk-23-1.png)

The number of digits in this format can be changed using xdigits and ydigits keywords:

``` r
pltptsgg.plot1D(pltptsgg.get.data(list(pltptsgg.get.curve(x, y), pltptsgg.get.curve(x2, y2))), xformat = "sci", yformat = "sci", xdigits = 2, ydigits = 6)
```

![](README_files/figure-markdown_github/unnamed-chunk-24-1.png)

#### Axis ticks

We can also change the spacing of the major and minor ticks. For example, we can set the major ticks (the points where numbers will appear) to be multiples of 5 for the x axis and multiples of 50 for the y axis using major.xticks and major.yticks:

``` r
pltptsgg.plot1D(pltptsgg.get.data(list(pltptsgg.get.curve(x, y), pltptsgg.get.curve(x2, y2))), major.xticks = 5, major.yticks = 50)
```

![](README_files/figure-markdown_github/unnamed-chunk-25-1.png)

To set the spacing of the intermediate lines we can use minor.xticks and minor.yticks. Let's add them every 1 unit in x and every 10 units in y:

``` r
pltptsgg.plot1D(pltptsgg.get.data(list(pltptsgg.get.curve(x, y), pltptsgg.get.curve(x2, y2))), major.xticks = 5, major.yticks = 50, minor.xticks = 1, minor.yticks = 10)
```

![](README_files/figure-markdown_github/unnamed-chunk-26-1.png)

For the logarithmic plots it is recommended to use a power of 10 for major ticks and to set minor ticks to 1 (or to omit that keyword, since 1 is the default value). Here are few examples. The "standard" case:

``` r
pltptsgg.plot1D(pltptsgg.get.data(list(pltptsgg.get.curve(x, y), pltptsgg.get.curve(x2, y2))), major.xticks = 10, major.yticks = 10, xlim=c(0.9, 1001), ylim = c(0.9, 1001), xlog = TRUE, ylog = TRUE, xformat="pow", yformat="pow")
```

![](README_files/figure-markdown_github/unnamed-chunk-27-1.png)

Plotting every 100 instead of 10:

``` r
pltptsgg.plot1D(pltptsgg.get.data(list(pltptsgg.get.curve(x, y), pltptsgg.get.curve(x2, y2))), major.xticks = 100, major.yticks = 100, xlim=c(0.9, 1001), ylim = c(0.9, 1001), xlog = TRUE, ylog = TRUE, xformat="pow", yformat="pow")
```

![](README_files/figure-markdown_github/unnamed-chunk-28-1.png)

Changing the number of minor ticks:

``` r
pltptsgg.plot1D(pltptsgg.get.data(list(pltptsgg.get.curve(x, y), pltptsgg.get.curve(x2, y2))), major.xticks = 10, major.yticks = 10, xlim=c(0.9, 1001), ylim = c(0.9, 1001), xlog = TRUE, ylog = TRUE, xformat="pow", yformat="pow", minor.xticks = 2, minor.yticks = 2)
```

![](README_files/figure-markdown_github/unnamed-chunk-29-1.png)

### Disabling grid

By default, ggplot2 plots a grid, but it can be disabled by setting grid = FALSE. This is my preferred option:

``` r
pltptsgg.plot1D(pltptsgg.get.data(list(pltptsgg.get.curve(x, y), pltptsgg.get.curve(x2, y2))), grid = FALSE)
```

![](README_files/figure-markdown_github/unnamed-chunk-30-1.png)

The logarithmic plot also looks nice without a grid:

``` r
pltptsgg.plot1D(pltptsgg.get.data(list(pltptsgg.get.curve(x, y), pltptsgg.get.curve(x2, y2))), major.xticks = 10, major.yticks = 10, xlim=c(0.9, 1001), ylim = c(0.9, 1001), xlog = TRUE, ylog = TRUE, xformat="pow", yformat="pow", grid=FALSE)
```

![](README_files/figure-markdown_github/unnamed-chunk-31-1.png)

### Using custom theme

If you have your own preferred theme, you can replace the one used by pltptsgg.plot1D by using the theme keyword. This sets the theme to theme\_classic():

``` r
pltptsgg.plot1D(pltptsgg.get.data(list(pltptsgg.get.curve(x, y), pltptsgg.get.curve(x2, y2))), theme = theme_classic())
```

![](README_files/figure-markdown_github/unnamed-chunk-32-1.png)

Full example
------------

This is a full documented example that you can copy and adapt to your needs. It uses the Cars93 built-in dataset plots miles per gallon in the city and on the highway as a function of car price.

``` r
# load plotting libraries and routines
library(ggplot2)
source("pltptsgg.R")

# use built-in MASS library
library(MASS)

# create the data curves
city.curve <- pltptsgg.get.curve(Cars93$Price * 1000, Cars93$MPG.city)
highway.curve <- pltptsgg.get.curve(Cars93$Price * 1000, Cars93$MPG.highway)

# create the data list
data.list <- pltptsgg.get.data(list(city.curve, highway.curve))

# plot
pltptsgg.plot1D(data.list, xlab="Price (USD)", ylab = "Miles per gallon", labels = c("City", "Highway"), legend.name = "Driving location", grid=FALSE)
```

![](README_files/figure-markdown_github/unnamed-chunk-33-1.png)

Advanced plotting
-----------------

### Errorbars

It is possible to specify both horizontal and vertical errorbars. Let us go back to our original dataset and add random errors to x and y:

``` r
# generate x
x <- seq(from = 1, to = 10, by = 2)

# compute y from x
y <- x^2

# add errors
xerr <- runif(length(x), min = -1, max = 1)
yerr <- runif(length(y), min = -8, max = 8)
```

Now we can use pltptsgg.get.curve to generate a dataset including errors:

``` r
data.curve <- pltptsgg.get.curve(x, y, xerr = xerr, yerr = yerr)
```

Then we call the plotting routine as usual (here plotted with points instead of lines):

``` r
pltptsgg.plot1D(pltptsgg.get.data(list(data.curve)), point=c(TRUE))
```

![](README_files/figure-markdown_github/unnamed-chunk-36-1.png)

We can change the length of the errorbars using errorbar.width and errorbar.height keywords:

``` r
pltptsgg.plot1D(pltptsgg.get.data(list(data.curve)), point=c(TRUE), errorbar.width = 2, errorbar.height = 10)
```

![](README_files/figure-markdown_github/unnamed-chunk-37-1.png)

Typically only vertical errorbars are present:

``` r
data.curve <- pltptsgg.get.curve(x, y, yerr = yerr)
pltptsgg.plot1D(pltptsgg.get.data(list(data.curve)), point=c(TRUE))
```

![](README_files/figure-markdown_github/unnamed-chunk-38-1.png)
