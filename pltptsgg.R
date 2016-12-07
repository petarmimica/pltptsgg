# Plotting routine
pltptsgg.plot1D <- function(data = NULL, theme = NULL, linetypes = NULL, colours = NULL, linesizes = NULL, labels = NULL, legend.name = NULL, points = NULL, shapes = NULL, legend.length = 36, xlog = FALSE, ylog = FALSE, xlim = NULL, ylim = NULL, major.xticks = NULL, minor.xticks = NULL, major.yticks = NULL, minor.yticks = NULL, grid = TRUE, xformat = NULL, yformat = NULL, xdigits = 1, ydigits = 1, xlab=NULL, ylab=NULL) {
  # my theme
  if (is.null(theme)) {
    mytheme <-  theme_bw()+theme(axis.text=element_text(size=18))+theme(axis.title=element_text(size=18))+theme(axis.line=element_line(size=2))+theme(legend.text=element_text(size=16))+theme(legend.title=element_text(size=18))+theme(legend.key = element_blank(), legend.key.width = unit(legend.length, "points"))
    if (grid) {
      mytheme <- mytheme + theme(panel.grid.major = element_line(size=0.75, colour="darkgray"), panel.grid.minor = element_line(size=0.4, colour="gray"), panel.border = element_blank(), panel.background = element_blank())
    } else {
      mytheme <- mytheme + theme(panel.grid.major = element_line(size=0, colour="white"), panel.grid.minor = element_line(size=0, colour="white"), panel.border = element_blank(), panel.background = element_blank(), axis.line.x = element_line(size = 1, colour="black"), axis.line.y = element_line(size = 1, colour="black"), axis.ticks.x = element_line(size = 1), axis.ticks.length = unit(-15, "points"), axis.text.x = element_text(margin=unit(c(25, 0, 0, 0), "points")), axis.text.y = element_text(margin=unit(c(0, 25, 0, 0), "points")))
    }
  } else {
    mytheme <- theme
  }
  
  # set line types
  if (is.null(linetypes)) {
    mytypes <- rep(c(1, 2, 3, 4, 5, 6), 16)
  } else {
    mytypes <- linetypes
  }
  
  # set line sizes
  if (is.null(linesizes)) {
    mysizes <- rep(1, 64)
  } else {
    mysizes <- linesizes
  }
  
  # set symbol shapes
  if (is.null(shapes)) {
    myshapes <- rep(c(1, 2, 3, 4, 5, 6), 16)
  } else {
    myshapes <- shapes
  }
  
  # set colors
  if (!is.null(colours)) {
    mycolours <- colours
  } else {
    mycolours <- rep(c("black", "red", "blue", "green", "orange", "gray"), 16)
  }
  
  # set labels
  if (!is.null(labels)) {
    mylabels <- labels
  } else {
    mylabels <- vector(mode = "numeric", length = length(data))
    for (i in 1:length(data)) {
      mylabels[i] <- (names(data))[i]
    }
  }
  
  # generate colour scale to be used for the legend
  mycolourscale <- vector("character", length(data))
  for (i in 1:length(data)) {
    mycolourscale[i] <- mycolours[i]
    names(mycolourscale)[i] <- mylabels[i]
  }
  
  # generate line type scale to be used for the legend
  mylinetypescale <- vector("numeric", length(data))
  for (i in 1:length(data)) {
    mylinetypescale[i] <- mytypes[i]
    names(mylinetypescale)[i] <- mylabels[i]
  }
  
  # generate shape scale to be used for the legend
  myshapescale <- vector("numeric", length(data))
  for (i in 1:length(data)) {
    myshapescale[i] <- myshapes[i]
    names(myshapescale)[i] <- mylabels[i]
  }
  
  # set legend name
  if (!is.null(legend.name)) {
    mylegendname <- legend.name
  } else {
    mylegendname <- "curves"
  }
  
  # set points mask
  if (!is.null(points)) {
    mypoints <- points
  } else {
    mypoints <- rep(FALSE, length(data))
  }
  
  # add auxiliary variables for colours, line type and symbol shapes
  for (i in 1:length(data)) {
    data[[i]]$which <- rep(mylabels[i], length(data[[i]]$x))
    data[[i]]$linetype <- rep(mylabels[i], length(data[[i]]$x))
    data[[i]]$points <- rep(mypoints[i], length(data[[i]]$x))
  }
  
  # additional auxiliary variables to be able to correctly plot a mixture of lines and points
  myltypes <- mytypes[1:length(data)]
  mylshapes <- myshapes[1:length(data)]
  
  myltypes[mypoints] <- 0
  mylshapes[!mypoints] <- NA
  
  # determine axis limits automatically
  minx <- min(data[[1]]$x)
  maxx <- max(data[[1]]$x)
  miny <- min(data[[1]]$y)
  maxy <- max(data[[1]]$y)
  
  # start the plot
  ret.val <- ggplot(NULL) + mytheme
  
  for (i in 1:length(data)) {
    # determine axis limits automatically
    minx <- min(c(minx, data[[i]]$x))
    maxx <- max(c(maxx, data[[i]]$x))
    miny <- min(c(miny, data[[i]]$y))
    maxy <- max(c(maxy, data[[i]]$y))
    
    # add either a point (scatter) or a line plot
    if (mypoints[i]) {
      ret.val <- ret.val + geom_point(data = data[[i]], aes(x = x, y = y, colour = which, shape = which))
    } else {
      ret.val <- ret.val + geom_line(data = data[[i]], aes(x = x, y = y, colour = which, linetype = linetype), size = mysizes[i])
    }
  }
  
  # add legends
  ret.val <- ret.val + scale_colour_manual(name=mylegendname, values=mycolourscale) + scale_linetype_manual(name=mylegendname, values=mylinetypescale, guide="none") + scale_shape_manual(name=mylegendname, values=myshapescale, guide="none") + guides(colour = guide_legend(override.aes = list(shape=mylshapes, linetype = myltypes)))
   
  # set the axis limits
  if (is.null(xlim)) {
    myxlim <- c(minx, maxx)
  } else {
    myxlim <- xlim
  }
  
  if (is.null(ylim)) {
    myylim <- c(miny, maxy)
  } else {
    myylim <- ylim
  }
    
  # set x axis format
  if (is.null(xformat)) {
    xlabels <- waiver()
  } else {
    if (xformat == "pow") {
      if (xlog) {
        xlabels <- function(breaks) {
          sapply(breaks, function(x) {
            text <- as.character(log10(x))
            bquote("10"^~.(text))
          })
        }
      } else {
        xlabels <- waiver()
      }
    }
    if (xformat == "sci") {
      xlabels <- function(breaks) {
        sapply(breaks, function(x) {
          val <- as.numeric(x)
          formatC(val, digits = xdigits, width = xdigits, format = "e")
        })
      }
    }
  }
  
  # set x axis log scale if necessary
  if (xlog) {
    if (!is.null(major.xticks)) {
      imin <- floor(log10(myxlim[1]) / log10(major.xticks))
      imax <- ceiling(log10(myxlim[2]) / log10(major.xticks))
      major.xbreaks <- major.xticks^seq(from = imin, to = imax)
      if (!is.null(minor.xticks)) {
        mbby <- minor.xticks
      } else {
        mbby <- 1
      }
      minor.xbreaks <- vector("numeric")
      for (i in imin:imax) {
        partial.breaks <- seq(from = 1, to = 10, by = mbby) * 10^i
        minor.xbreaks <- cbind(minor.xbreaks, partial.breaks)
      }
    } else {
      major.xbreaks <- waiver()
      minor.xbreaks <- waiver()
    }
    xscl <- scale_x_log10(lim = myxlim, expand = c(0, 0), breaks = major.xbreaks, minor_breaks = minor.xbreaks, labels = xlabels)
  } else {
    if (!is.null(major.xticks)) {
      imin <- floor(myxlim[1] / major.xticks)
      imax <- ceiling(myxlim[2] / major.xticks)
      major.xbreaks <- seq(from = imin, to = imax) * major.xticks
    } else {
      major.xbreaks <- waiver()
    }
    
    if (!is.null(minor.xticks)) {
      imin <- floor(myxlim[1] / minor.xticks)
      imax <- ceiling(myxlim[2] / minor.xticks)
      minor.xbreaks <- seq(from = imin, to = imax) * minor.xticks
     } else {
      minor.xbreaks <- waiver()
    }
    
    
    xscl <- scale_x_continuous(lim = myxlim, expand = c(0, 0), breaks = major.xbreaks, minor_breaks = minor.xbreaks, labels = xlabels)
  }

  # set y axis format
  if (is.null(yformat)) {
    ylabels <- waiver()
  } else {
    if (yformat == "pow") {
      if (ylog) {
        ylabels <- function(breaks) {
          sapply(breaks, function(x) {
            text <- as.character(log10(x))
            bquote("10"^~.(text))
          })
        }
      } else {
        ylabels <- waiver()
      }
    }
    if (yformat == "sci") {
      ylabels <- function(breaks) {
        sapply(breaks, function(x) {
          val <- as.numeric(x)
          formatC(val, digits = ydigits, width = ydigits, format = "e")
        })
      }
    }
  }
  
  # set y axis log scale if necessary
  if (ylog) {
    if (!is.null(major.yticks)) {
      jmin <- floor(log10(myylim[1]) / log10(major.yticks))
      jmax <- ceiling(log10(myylim[2]) / log10(major.yticks))
      major.ybreaks <- major.yticks^seq(from = jmin, to = jmax)
      if (!is.null(minor.yticks)) {
        mbby <- minor.yticks
      } else {
        mbby <- 1
      }
      minor.ybreaks <- vector("numeric")
      for (j in jmin:jmax) {
        partial.breaks <- seq(from = 1, to = 10, by = mbby) * 10^j
        minor.ybreaks <- cbind(minor.ybreaks, partial.breaks)
      }
    } else {
      major.ybreaks <- waiver()
      minor.ybreaks <- waiver()
    }
   yscl <- scale_y_log10(lim = myylim, expand = c(0, 0), breaks = major.ybreaks, minor_breaks = minor.ybreaks, labels = ylabels)
  } else {
    if (!is.null(major.yticks)) {
      jmin <- floor(myylim[1] / major.yticks)
      jmax <- ceiling(myylim[2] / major.yticks)
      major.ybreaks <- seq(from = jmin, to = jmax) * major.yticks
    } else {
      major.ybreaks <- waiver()
    }
    
    if (!is.null(minor.yticks)) {
      jmin <- floor(myylim[1] / minor.yticks)
      jmax <- ceiling(myylim[2] / minor.yticks)
      minor.ybreaks <- seq(from = jmin, to = jmax) * minor.yticks
    } else {
      minor.ybreaks <- waiver()
    }
    yscl <- scale_y_continuous(lim = myylim, expand = c(0, 0), breaks = major.ybreaks, minor_breaks = minor.ybreaks, labels = ylabels)
  }
  
  # in case one or two axes are logarithmic, plot the logticks
  if ((xlog || ylog) && !grid) {
    
    if (xlog && ylog) {
      sides <- "bl"
    } else {
      if (xlog) {
        sides <- "b"
      } else {
        sides <- "l"
      }
    }
    
    myann <- annotation_logticks(sides = sides, long = unit(15, "points"), mid = unit(10, "points"), short = unit(8, "points"))
  } else {
    myann <- NULL
  }
  
  # set axis labels
  if (!is.null(xlab))
    ret.val <- ret.val + xlab(xlab)
  
  if (!is.null(ylab))
    ret.val <- ret.val + ylab(ylab)
  
  
  ret.val <- ret.val + xscl + yscl + myann
  
  
  
  return(ret.val)
}

# Packaging routines

# Returns a data frame containing the current curve. A list of these can be passed to pltptsgg.get.data
pltptsgg.get.curve <- function(x, y) {
    if (length(x) != length(y)) {
        stop("Length of x and y must be equal!")
    } else {
        ret.val <- data.frame(x = x, y = y)   
    }
    
    return(ret.val)
}



# Returns a list of a number of data frames (e.g., created by pltptsgg.get.dfs). This list can be passed as an argument to pltptsgg.plot1D
pltptsgg.get.data <- function(dfs, curve.names = NULL) {
    
    ret.val <- list()
    
    for (i in 1:(length(dfs))) {
        if (is.null(curve.names)) {
            curve.name <- paste("curve", sprintf("%.2d", i), sep="")
        } else {
            curve.name <- curve.names[i]
        }
        df <- data.frame(x = dfs[[i]]$x, y = dfs[[i]]$y)
        ret.val[[i]] <- df
        names(ret.val)[i] <- curve.name
    }
    
    return(ret.val)    
    
}