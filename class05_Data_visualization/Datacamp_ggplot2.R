
library(ggplot2)
str(mtcars)
ggplot(mtcars, aes(cyl, mpg)) +
  geom_point()

# Introduction==================================================================
# Data columns type affect plot types:
#   R sometimes treats numbers as continuous numerical values (连续数值), even when those numbers actually represent categories（类别）
#   Here cyl = number of engine cylinders, we want to treat cars as belonging to three catehories: 4/6/8-cylinder cars.
#   Now R treats cyl as a continuous numerical variable.
#   factor(cyl) --> treat 4,6, and 8 as three separate categories
ggplot(mtcars, aes(factor(cyl), mpg)) +
  geom_point()

# Introd to Aesthetics
# color=disp --> the color of each point depends on the car's engine displacement
ggplot(mtcars, aes(factor(cyl), mpg,color=disp)) +
  geom_point()
# size=disp --> , the size of each point will depend on the car's engine displacement
ggplot(mtcars, aes(factor(cyl), mpg,size=disp)) +
  geom_point()

# Intro to geometries
str(diamonds)
ggplot(diamonds,aes(carat, price))+
  geom_point() + # adds points as in a scatter plot
  geom_smooth() # adds a smooth trend curve

# alpha in geom_point controls opacity (1=opaque,0=transparent) 
ggplot(diamonds,aes(carat, price, color=clarity))+
  geom_point(alpha=0.4) + 
  geom_smooth() 

# Apply only to one layer of geom if you don't want other layers to inherit the same aesthetics or when mixing data sources
plt_price_vs_carat_by_clarity <- plt_price_vs_carat + geom_point(aes(color=clarity))
plt_price_vs_carat_by_clarity

# These two are the same 
plt_price_vs_carat <- ggplot(diamonds) + aes(carat,price) + geom_point()
plt_price_vs_carat <- ggplot(diamonds + aes(carat,price)) + geom_point()

# Aesthetics====================================================================
str(mtcars)
ggplot(mtcars, aes(wt, mpg, color = factor(cyl))) +
  # Set the shape and size of the points
  geom_point(shape=1,size=4)

# 26 shapes in R
#   pch = point shapes
#   cex = point size
#   col/color = outline color (exception: geom_point() shape=0-19 uses only color and not fill as a whole; shape 21-25 can use both fill and color)
#   fill = inside color 
# Run this to check out all the shapes
plot(0:25, pch = 0:25, cex = 2)

# check out different aesthetics
#   label and shape are only applicable to categorical data
plt_mpg_vs_wt <- ggplot(mtcars, aes(wt, mpg))
plt_mpg_vs_wt + geom_point(aes(size = factor(cyl)))
plt_mpg_vs_wt +geom_point(aes(alpha = factor(cyl)))
plt_mpg_vs_wt + geom_point(aes(shape = factor(cyl)))
plt_mpg_vs_wt + geom_text(aes(label = factor(cyl)))

# Attributes vs Aesthetics!
#   Aesthetics: Map a variable from your dataset to a visual property（根据数据改变外观）
#   Attributes: Set a fixed visual property, independent of the data（直接指定固定外观）

# Attributes - Color
#   A hexadecimal color
my_blue <- "#4ABEFF"
ggplot(mtcars, aes(wt, mpg)) + geom_point(color=my_blue,alpha=0.6)
# Add text layer with label rownames(mtcars) and color red
ggplot(mtcars, aes(wt, mpg, color = factor(cyl))) + geom_text(label=rownames(mtcars),color="red")

# Updating aesthetic labels
# labs()
# scale_fill_manual() defines properties of the color scale. First argument = legend title
mtcars$fam <- factor(mtcars$am, levels = c(0, 1), labels = c("automatic", "manual"))
ggplot(mtcars, aes(factor(cyl), fill = fam)) + geom_bar() + labs(x="Number of Cylinders",y="Count")
# Set the fill color scale
palette <- c(automatic = "#377EB8", manual = "#E41A1C")
ggplot(mtcars, aes(factor(cyl), fill = fam)) + geom_bar() + labs(x = "Number of Cylinders", y = "Count") +
  scale_fill_manual("Transmission", values = palette)
# Modify the code to set the position to dodge so that the bars for transmissions are displayed side by side.
ggplot(mtcars, aes(factor(cyl), fill = fam)) + geom_bar(position="dodge") + labs(x = "Number of Cylinders", y = "Count") +
  scale_fill_manual("Transmission", values = palette)

# Jitters
ggplot(mtcars, aes(mpg,0)) + geom_jitter()
ggplot(mtcars, aes(mpg,0)) + geom_point(position="jitter")

# ylim() set the limit on y-axis
ggplot(mtcars, aes(mpg, 0)) + geom_jitter() + ylim(-2,2)


# Geometries====================================================================

# Overplotting - large dataset
# Plot price vs. carat, colored by clarity
plt_price_vs_carat_by_clarity <- ggplot(diamonds, aes(carat, price, color = clarity))
# Add a point layer with tiny points
plt_price_vs_carat_by_clarity + geom_point(shape=".",alpha=0.5)
plt_price_vs_carat_by_clarity + geom_point(shape=16,alpha=0.5)

# Overplotting - Aligned values
#   We can use position="jitter" inside geom_point() OR geom_jitter
# Plot base
plt_mpg_vs_fcyl_by_fam <- ggplot(mtcars, aes(factor(cyl), mpg, color = fam))
# Default points are shown for comparison
plt_mpg_vs_fcyl_by_fam + geom_point()
# Alter the point positions by jittering, width 0.3
plt_mpg_vs_fcyl_by_fam + geom_point(position=position_jitter(width=0.3))
# Now jitter and dodge the point positions
plt_mpg_vs_fcyl_by_fam + geom_point(position = position_jitterdodge(jitter.width=0.3, dodge.width=0.3))

# Overplotting - Low precision data --> Different ways of Jitters!
# geom_jitter()
ggplot(iris, aes(Sepal.Length, Sepal.Width, color = Species)) + geom_jitter(alpha = 0.5,width=0.1)
# position=position_jitter() inside geom_point, essentially the same as above
ggplot(iris, aes(Sepal.Length, Sepal.Width, color = Species)) + geom_point(alpha = 0.5,position=position_jitter(width=0.1))
# position="jitter" inside geom_point, but cannot customize width and heights
ggplot(iris, aes(Sepal.Length, Sepal.Width, color = Species)) + geom_point(alpha = 0.5,position="jitter")

# ****Histograms ==> Continuous X-axis
# Plot mpg
ggplot(mtcars,aes(x=mpg)) + geom_histogram()
ggplot(mtcars,aes(x=mpg)) + geom_histogram(binwidth = 1)

# Map y to density
#   after_stat(density) or ..density.. tells ggplot2 to use this calculated density for the y-axis instead of the default count.
#   density is not an original column in the dataset; it is automatically calculated by geom_histogram()
#   => density = count / (total observations*binwidth)
#   => observation = one individual data record, usually one row in a dataset
ggplot(mtcars, aes(mpg, ..density..)) + geom_histogram(binwidth = 1,fill="red") # old way, deprecated
ggplot(mtcars, aes(mpg, after_stat(density))) + geom_histogram(binwidth = 1, fill="blue")

# Positions in Histograms
# Stack(default): Bars for different groups are stacked on top of each other.
ggplot(mtcars, aes(mpg, fill = fam)) + geom_histogram(binwidth = 1)
# dodge: Bars for different groups are placed side by side.
ggplot(mtcars, aes(mpg, fill = fam)) + geom_histogram(binwidth = 1, position="dodge")
# fill: Bars for different groups are shown as proportions
ggplot(mtcars, aes(mpg, fill = fam)) + geom_histogram(binwidth = 1, position="fill")
# identity: Plot the values as they appear in the dataset
ggplot(mtcars, aes(mpg, fill = fam)) + geom_histogram(binwidth = 1, position="identity",alpha=0.4)

# ****Bar plots ==> Categorical X-axis
# geom_bar() -> count the number of cases in each category of the variable mapped to the x-axis ("count")
# geom_col() -> plot the actual value it finds in the dataset ("identity")
ggplot(mtcars, aes(factor(cyl), fill = fam)) + geom_bar(position = "dodge")
ggplot(mtcars, aes(factor(cyl), fill = fam)) + geom_bar(position = "fill")
ggplot(mtcars, aes(cyl, fill = fam)) + geom_bar(position = position_dodge(width = 0.2),alpha=0.6)

# Plot education, filled by vocabulary
ggplot(Vocab, aes(education, fill = vocabulary)) +
  # Add a bar layer with position "fill"
  geom_bar(position = "fill") +
  # Add a brewer fill scale with default palette
  scale_fill_brewer()

# ****Line plots
# Print the head of economics
head(economics)
# Using economics, plot unemploy vs. date
plot <- ggplot(economics,aes(date,unemploy)) + geom_line()


# Themes========================================================================

# Themes layer:
#   All non-data ink
#   Visual elements not part of the data
#   Three types: element_X() -> text, line, rectangle

# Legend
#     plot + theme(legend.position = new_val)
#     new_val: "top","bottom","left","right","none"(don't draw it)
#     new_val: c(x,y) --> c(0,0) bottom-left; c(1,1) top right

# element_line(); element_rect(); element_text(); element_blank()
#     plot + theme(axis.line = element_line(color = "red", linetype = "dashed"))

# Whitespace - all non-visible margins and spacing in the plot
#     unix(x,unit) --> set a single white space value, x = amount; unit = unit of measure
#     margin(top,right,bot,left,unit) --> border
#     pt (points) --> default unit

# Built-in themes: theme_X()
#     theme_gray() - default
#     theme_bw() - useful when you use transparency
#     theme_classic() - more traditional
#     theme_void() - removes everything but the data
# ggthemes

# theme_set() - resume themes to the default