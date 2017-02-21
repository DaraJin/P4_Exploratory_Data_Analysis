Wine Quality Analysis by Dara Jin
========================================================


Dataset can be downloaded [here](https://s3.amazonaws.com/udacity-hosted-downloads/ud651/wineQualityWhites.csv).

Paulo Cortez (Univ. Minho), Antonio Cerdeira, Fernando Almeida, Telmo Matos and Jose Reis (CVRVV) @ 2009
   
P. Cortez, A. Cerdeira, F. Almeida, T. Matos and J. Reis. 
Modeling wine preferences by data mining from physicochemical properties.
In Decision Support Systems, Elsevier, 47(4):547-553. ISSN: 0167-9236.


```{r echo=FALSE, message=FALSE, warning=FALSE, packages}
# Load all of the packages that you end up using
# in your analysis in this code chunk.

# Notice that the parameter "echo" was set to FALSE for this code chunk.
# This prevents the code from displaying in the knitted HTML output.
# You should set echo=FALSE for all code chunks in your file.



library(ggplot2)
```

```{r echo=FALSE, Load_the_Data}
# Load the Data
wineQuality <- read.csv("wineQualityWhites.csv")

```

# Univariate Plots Section
```{r echo=FALSE, Univariate_Plots}
dim(wineQuality)
```
```{r echo=FALSE, Table_Column}
n <- names(wineQuality)
n
```
```{r echo=FALSE, message=FALSE, warning=FALSE, Wine_Attributes}
str(wineQuality)
```
```{r echo=FALSE, message=FALSE, warning=FALSE, Data_Summary}
summary(wineQuality)
```

All together, the dataset has 4894 records with 11 attributes to describe the wine. Quality is the main target, and the investigation will be about how other attributes influences the overall quality.



```{r echo=FALSE, message=FALSE, warning=FALSE, Quality_Counts}
p1 <- ggplot(wineQuality, aes(quality)) + 
  geom_histogram() +
  scale_x_continuous(breaks = seq(3, 9, 1))
p1
```

The with quality is normally distributed with implicit left tail and centered at 6 level. Most wines are between 5~7 levels, while very few wines are at the bottom and top levels. 


```{r echo=FALSE, message=FALSE, warning=FALSE}
create_plot <- function(varname, binwidth = 50) {
  return (ggplot(aes(x = varname), data = wineQuality) +
            geom_histogram(bins = binwidth) + xlab(varname))
}
```

Below are the distributions for different attributes. Most of them are somehow normally distributed.

```{r echo=FALSE, message=FALSE, warning=FALSE}
create_plot(wineQuality$fixed.acidity)+
  coord_cartesian(xlim =c(4, 11)) +
  scale_x_continuous(breaks=seq(4, 11, 1)) + 
  xlab("fixed acidity (tartaric acid - g/dm^3)")
```


```{r echo=FALSE, message=FALSE, warning=FALSE}
create_plot(wineQuality$volatile.acidity) +
  coord_cartesian(xlim =c(0, 0.9)) +
  scale_x_continuous(breaks=seq(0, 0.9, 0.1)) +
  xlab("volatile acidity (acetic acid - g/dm^3)")
```


```{r echo=FALSE, message=FALSE, warning=FALSE}
ggplot(wineQuality, aes(citric.acid)) +
      geom_histogram(bins=80) +
      coord_cartesian(xlim = c(0, 0.8)) +
      scale_x_continuous(breaks=seq(0, 0.8, 0.1)) +
  xlab("citric acid (g/dm^3)")
```

```{r echo=FALSE, message=FALSE, warning=FALSE}
ggplot(wineQuality, aes(residual.sugar)) + 
  geom_histogram(bins=200) +
  coord_cartesian(xlim = c(0, 20)) + 
  scale_x_continuous(breaks = seq(0, 20, 1)) +
  xlab("residual sugar (g/dm^3)")
```

```{r echo=FALSE, message=FALSE, warning=FALSE}
summary(wineQuality$residual.sugar)
```

The distribution of residual sugar stands out as it has a very sharp peak in a low-sugar level, some fluctuations in the middle level and decreases as sugar increases in the high level. 75% of wines has residual sugar between 1.7g/dm^3 ~ 9.9 g/dm^3.

```{r echo=FALSE, message=FALSE, warning=FALSE}
ggplot(wineQuality, aes(chlorides)) +
  geom_histogram(bins=100) +
  xlab("chlorides (sodium chloride - g/dm^3 )") +
  scale_x_log10(breaks = seq(0,0.08,0.01))
```

```{r echo=FALSE, message=FALSE, warning=FALSE}
summary(wineQuality$chlorides)
```

There are many outliers. To get a better shape, I reshape the x-axis to get a better view on the centre distribution.

```{r echo=FALSE, message=FALSE, warning=FALSE}
ggplot(wineQuality, aes(free.sulfur.dioxide)) +
  geom_histogram(bins=80) +
  xlab("free sulfur dioxide (mg/dm^3)") +
  scale_x_log10(breaks = seq(0,120,20))
```

```{r echo=FALSE, message=FALSE, warning=FALSE}
ggplot(wineQuality, aes(total.sulfur.dioxide)) + 
  geom_histogram(bins=80) +
  xlab("total sulfur dioxide (mg/dm^3)") +
  scale_x_log10(breaks = seq(0,250,50))
```

```{r echo=FALSE, message=FALSE, warning=FALSE}
ggplot(wineQuality, aes(density)) + 
  geom_histogram(bins=100)+
  coord_cartesian(xlim = c(0.985, 1.005)) +
  xlab("density (g/cm^3)")
```

```{r echo=FALSE, message=FALSE, warning=FALSE}
ggplot(wineQuality, aes(pH)) + 
  geom_histogram(bins=50)
```

```{r echo=FALSE, message=FALSE, warning=FALSE}
ggplot(wineQuality, aes(sulphates)) + 
  geom_histogram(bins=50) +
  xlab("sulphates (potassium sulphate - g/dm3)")
```

```{r echo=FALSE, message=FALSE, warning=FALSE}
ggplot(wineQuality, aes(alcohol)) + 
  geom_histogram(bins=50) +
  xlab("alcohol (% by volume)")
```

```{r echo=FALSE, message=FALSE, warning=FALSE}
ggplot(wineQuality, aes(alcohol)) + 
  geom_histogram(bins=10) +
  xlab("alcohol (% by volume)")
```


# Univariate Analysis

### What is the structure of your dataset?
The dataset has 4894 observations and 13 variables with 11 attributes to describe the wine.The variables are all numerical.

### What is/are the main feature(s) of interest in your dataset?

1. The quality is, overall, normally distributed with the median of 6 and mean of 5.878 slightly below. It's slightly left-skewed.
2. Most attributes are of a bell shape.


### What other features in the dataset do you think will help support your investigation into your feature(s) of interest?

Most plots are of a normal distribution, and it's hard to find the linear relationships between two variables. Let's assume that there are linear relationships between attributes and quality level, then if I want to get higher qualities (which is rare), we need to find out fixed acidity, for example, with low counts. However, after reviewing the shape, I find there are two choices, extremely high or extreme low. And therefore, linear relation might fail in this case.
It makes sense because we can't expect to add one single type of chemical will make the wine better.


### Did you create any new variables from existing variables in the dataset?
No. I tried to do something with residual sugar with the help of log10, sqrt, it doesn't work here.

### Of the features you investigated, were there any unusual distributions? Did you perform any operations on the data to tidy, adjust, or change the form of the data? If so, why did you do this?

Following the 3rd question, however, alcohol distribution is slightly different from others. I tried to increase the bin width and get an interesting 'big picture'. There are might be a close relationship between alcohol and quality. So might be the density and residual sugar to quality. But no much useful information has been found by univariate investigation. More investigations should be done.


There are no changes to the form of the data.


# Bivariate Plots Section


```{r echo=FALSE, message=FALSE, warning=FALSE}
# pairs.panel can help to plot togather all the correlation coeffecient between variables, 
# the distribution of each variable and the scatterplot of every two variables ("X" is excluded). 
library(psych) 
wineQuality <- wineQuality[, c(1, 13, 12, 2:11)]
pairs.panels(wineQuality[, 2:13])
```

I changed the column order to bring the core variable, quality, into focus.

There is no distinctive linear correlation between quality and other attributes. It makes sense because the quality of wines won't achieve excellence simply by adding more volume of a certain element. But, the correlation does exist in 

There are indeed linear relationships between density and alcohol as well as density and sugar.It makes sense because the density of alcohol is lower than water while sugar is in reverse. When investigating multivariate, I need to be careful on these two pairs of variables.


To investigate by statistics, I created a correlation table to see correlation coefficient between every two elements. 

```{r echo=FALSE, message=FALSE, warning=FALSE}
# correlation coefficient between every two elements in the data set except for 'X' which explains the id of wines.
wq <- subset(wineQuality, select = -c(X))
cor_table <- cor(wq)

cor_table
```

Above is a table showing all correlation coefficient. It's really hard to find useful information by looking at the table, So I decided to plot the correlation coefficient table. The 'corrplot' plot is helpful in visualizing the data.


```{r echo=FALSE, message=FALSE, warning=FALSE}
# This is a visualization of correlation coreffecient between variables of interets.
# In order to have a better view of the plot, I rename the variable names.
library(corrplot)
rn <- wq
names(rn) <- c("qlt", "ach", "fx.ac", "vt.ac", "ct.ac", 
               "rd.sg", "chrd",  "fsd", "tsd", "dst", "pH", "spt")
cor_table_rn <- cor(rn)
corrplot.mixed(cor_table_rn)
```

It's really helpful to get insights of correlations between variables. There are indeed close relationship between alcohol and quality with CORR of 0.44 and density-quality with CORR of 0.31. Beware that there are also strong correlation coefficient between different attributes, for example, alcohol and density with CORR of -0.78. It's pretty high. When doing the regression, it's more useful to have independent variables observed. In the case of alcohol and density to quality, is the quality level more likely driven by alcohol or by density? The first impression would be alcohol.


```{r echo=FALSE, message=FALSE, warning=FALSE}
# Divide the all data by quanlity level (1 ~ 9) and compare each group
library(dplyr)
library(gridExtra)
wq_group <- group_by(wineQuality, quality)

p1 <-  ggplot(wineQuality, aes(y=alcohol, 
                               x=as.character(wineQuality$quality))) + 
  geom_boxplot() + 
  ylab("Alcohol (% by volume)") + 
  xlab("Quality")
  

p2 <- ggplot(wineQuality, aes(y=alcohol, x=quality))+
  geom_jitter(alpha = 1/5)+
  geom_line(aes(y=alcohol), stat="summary", fun.y=mean, color='black')+
  scale_x_continuous(breaks = seq(3, 9, 1)) +
  ylab("Alcohol (% by volume)") +
  xlab("Quality")

grid.arrange(p1, p2, ncol=2)
  
```

Dividing the quality into two groups, level 3~5 and level 5~9, the lower level group has a negative correlation and the higher group has a positive correlation. As a whole, however, that's not linear. Let's see what the statistics can show. Even though alcohol has the largest CORR with the quality compared to other variables, the R-squared of 0.2 means only 20% of the quality level is explained by alcohol. That's far from understanding the big picture.


```{r echo=FALSE, message=FALSE, warning=FALSE}
# Try to find a linear model between quality and alcohol
# Also, some statistics are listed to evaluate the model.
library('memisc')
m1 <- lm(quality ~ I(alcohol), data = wineQuality)
mtable(m1, sdigits = 2)
```

More variables were plotted below.

```{r echo=FALSE, message=FALSE, warning=FALSE}
ggplot(wineQuality, aes(y=chlorides, x=quality)) +
  geom_jitter(alpha = 1/5) +
  geom_line(aes(y=chlorides), stat="summary", fun.y=mean, 
            color='black') +
  coord_cartesian(ylim = quantile(wineQuality$chlorides,  
                                  c(0.03, 0.97))) +
  scale_x_continuous(breaks = seq(3, 9, 1)) +
  ylab("chlorides (sodium chloride - g / dm^3)")
```


```{r echo=FALSE, message=FALSE, warning=FALSE}
ggplot(wineQuality, aes(y=volatile.acidity, x=quality)) +
  geom_jitter(alpha = 1/5) +
  geom_line(aes(y = volatile.acidity), stat="summary", 
            fun.y = mean, color='black') +
  scale_x_continuous(breaks = seq(3, 9, 1)) +
  coord_cartesian(ylim = quantile(wineQuality$volatile.acidity,  c(0.03, 0.97))) +
  ylab("volatile acidity (acetic acid - g/dm^3)")
  
```



```{r echo=FALSE, message=FALSE, warning=FALSE}
ggplot(wineQuality, aes(y=total.sulfur.dioxide, x=quality)) +geom_jitter(alpha=1/5) +
  geom_line(aes(y=total.sulfur.dioxide), stat="summary",  
            fun.y=mean, color='black') +
  scale_x_continuous(breaks = seq(3, 9, 1)) +
  coord_cartesian(ylim = c(30, 260)) +
  coord_cartesian(ylim = quantile(wineQuality$total.sulfur.dioxide, 
                                  c(0.03, 0.97))) +
  ylab("total sulfur dioxide (mg/dm^3)")
```

```{r echo=FALSE, message=FALSE, warning=FALSE}
ggplot(wineQuality, aes(y=fixed.acidity, x=quality)) +
  geom_jitter(alpha = 1/5) +
  geom_line(aes(y=fixed.acidity), stat="summary",  
            fun.y=mean, color='black') +
  scale_x_continuous(breaks = seq(3, 9, 1)) +
  coord_cartesian(ylim = quantile(wineQuality$fixed.acidity, 
                                  c(0.03, 0.97)))+ 
  ylab("fixed acidity (tartaric acid - g/dm^3)")
  
```


To find out most useful variables, I tried to avoid strong dependencies. Two ways ahead - 'alcohol group' v.s. 'density group'. 

Alcohol is such a influential factors that many other variables are highly related to it. The graph below shows the dependency. The variables were chosen according to the CORR plot. These valuables should be less effective in telling a good story of quality together with alcohol.

```{r echo=FALSE, message=FALSE, warning=FALSE }

library('gridExtra')
p1 <- ggplot(wineQuality, aes(x=alcohol, y=quality)) +
  geom_jitter(alpha = 1/10)

p2 <- ggplot(wineQuality, aes(x=alcohol, y=density)) +
  geom_point(alpha = 1/10) + 
  coord_cartesian(ylim = quantile(wineQuality$density,  
                                  c(0.001, 0.999)))

p3 <- ggplot(wineQuality, aes(x=alcohol, y=residual.sugar)) +geom_point(alpha = 1/10) + 
  coord_cartesian(ylim = quantile(wineQuality$residual.sugar, 
                                  c(0.001, 0.999)))

p4 <- ggplot(wineQuality, aes(x=alcohol, y=total.sulfur.dioxide)) +geom_point(alpha = 1/10)

p5 <- ggplot(wineQuality, aes(x=alcohol, y=chlorides)) +
  geom_point(alpha = 1/10) + 
  coord_cartesian(ylim = quantile(wineQuality$chlorides,  
                                  c(0.005, 0.995)))

p6 <- ggplot(wineQuality, aes(x=alcohol, y=free.sulfur.dioxide)) +
  geom_point(alpha = 1/10)

grid.arrange(p1, p2, p3, p4, p5, p6, ncol=2)
```

Density also has several linear relationships with other variables.

```{r echo=FALSE, message=FALSE, warning=FALSE}
p1 <- ggplot(wineQuality, aes(x=density, y=quality)) +
  geom_jitter(alpha = 1/10) +
  scale_x_continuous(limits = c(0.987, 1.003))
  
p2 <- ggplot(wineQuality,aes(x=density, y=residual.sugar)) +
  geom_point(alpha = 1/10) +
  coord_cartesian(ylim = quantile(wineQuality$residual.sugar, 
                                  c(0.01, 0.99))) +
  scale_x_continuous(limits = c(0.987, 1.003))

p3 <- ggplot(wineQuality, aes(x=density, y=total.sulfur.dioxide)) +
  geom_jitter(alpha = 1/10) +
  scale_x_continuous(limits = c(0.987, 1.003))
  coord_cartesian(ylim = quantile(wineQuality$total.sulfur.dioxide,
                                  c(0.01,0.99)))

p4 <- ggplot(wineQuality,aes(x=density,y=chlorides)) +
  geom_point(alpha = 1/10) +
  scale_x_continuous(limits = c(0.987, 1.003)) +
  coord_cartesian(ylim = quantile(wineQuality$chlorides, 
                                  c(0.01, 0.99)))
grid.arrange(p1, p2, p3, p4, ncol=2)
```


Then, what should I choose to observe? 
Except for alcohol-like attributes, I divided variables into other 2 groups that might be helpful. One for sulfur dioxide and the other is concerning acidity.


```{r echo=FALSE, message=FALSE, warning=FALSE}
ggplot(wineQuality, aes(x=total.sulfur.dioxide, 
                        y=free.sulfur.dioxide)) +
  geom_point(alpha = 1/5) + 
  stat_smooth(method="lm") +
  coord_cartesian(xlim = quantile(wineQuality$total.sulfur.dioxide, 
                                  c(0.01, 0.99))) +
  coord_cartesian(ylim = quantile(wineQuality$free.sulfur.dioxide, 
                                  c(0.01, 0.99))) +
  ylab("free sulfur dioxide (mg/dm^3)")
```

In sulfur dioxide 'family', free.sulfur.dioxide is highly correlated with total sulfur dioxide. I may only choose one at a time.


```{r echo=FALSE, message=FALSE, warning=FALSE}
ggplot(wineQuality, aes(x=pH, y=fixed.acidity)) +
  geom_point(alpha = 1/5) + 
  stat_smooth(method="lm") +
  coord_cartesian(xlim = quantile(wineQuality$pH, c(0.01,0.99))) +
  coord_cartesian(ylim = quantile(wineQuality$fixed.acidity,
                                  c(0.01,0.99))) + 
  ylab("fixed acidity (tartaric acid - g/dm^3)")
```

The fixed acidity is closely related to pH.




# Bivariate Analysis

### Talk about some of the relationships you observed in this part of the investigation. How did the feature(s) of interest vary with other features in the dataset?

Overall, alcohol volume appears to be the attribute that influences the wine quality. However, that only explain 20% of why the wine is good or bad. Other important contributors might be include density, residual sugar, chlorides volume. Still, more methods should be used to fully understand the relationships.


### Did you observe any interesting relationships between the other features (not the main feature(s) of interest)?


Yes, there are several interesting relationships between the attributes of the wines. 

Density is strongly negatively correlated to alcohol volume, while positively related to residual sugar volume. I may guess alcohol and sugar volume are the reason that explaining the correlation between density and quality. It intuitively makes sense. 

Alcohol is correlated with several other attributes for example. negatively related to residual sugar, total sulfur dioxide and chlorides volume. 

Total sulfur dioxide and free sulfur dioxide shows similar relationships with quality. Fixed acidity volume and pH value appear to be another pair of attributes with a similar contribution. 

### What was the strongest relationship you found?

The strongest relationship is between residual sugar and density, and they are strongly correlated. Alcohol is the closest feature to quality in terms of the feature of interest, and they are positively correlated. 



# Multivariate Plots Section

3 principles for choosing variables to be observed. First of all, the contribution. It means how much, the chosen variable correlated to the wine quality. Secondly, low correlation between chosen feature. Thirdly, domain attributes diversity. Variables in the same domain can not be chosen at a time. I put this in the third place, because the intuitive understanding of wine and chemicals may easily go wrong.

First of all, alcohol is chosen as the core variable for its strong relationship with quality. Then, I excluded variables that are very dependent on alcohol. From acidity feature group, I introduced fixed acidity and volatile acidity to make a comparison. From sulfur feature group, I introduced free sulfur dioxide.

```{r echo=FALSE, message=FALSE, warning=FALSE}
ggplot(wineQuality, aes(x=alcohol, y=fixed.acidity)) +
  geom_point(alpha=1/10) +
  ylim(quantile(wineQuality$fixed.acidity, 0.01), 
       quantile(wineQuality$fixed.acidity, 0.99)) +
  xlim(quantile(wineQuality$alcohol, 0.01), 
       quantile(wineQuality$alcohol, 0.99)) +
  facet_grid(~quality)+ 
  ylab("fixed acidity (tartaric acid - g/dm^3)") +
  xlab("alcohol (% by volume)")
```


```{r echo=FALSE, message=FALSE, warning=FALSE}
ggplot(wineQuality, aes(x=alcohol, y=volatile.acidity)) +
  geom_point(alpha=1/10) +
  ylim(quantile(wineQuality$volatile.acidity, 0.01), 
       quantile(wineQuality$volatile.acidity, 0.99)) +
  xlim(quantile(wineQuality$alcohol, 0.01), 
       quantile(wineQuality$alcohol, 0.99)) +
  facet_grid(~quality)+ 
  ylab("volatile acidity (tartaric acid - g/dm^3)") +
  xlab("alcohol (% by volume)")
```

It seems that volatile acidity plot is slightly more distinguishable than the plot of fixed acidity.

Add one more dimension to the graph.

```{r echo=FALSE, message=FALSE, warning=FALSE}
ggplot(wineQuality, aes(x=alcohol, y= volatile.acidity,  
                       color = free.sulfur.dioxide)) +
  geom_point(alpha=1/2) +
  ylim(quantile(wineQuality$volatile.acidity, 0.01), 
       quantile(wineQuality$volatile.acidity, 0.99)) +
  xlim(quantile(wineQuality$alcohol, 0.01), 
       quantile(wineQuality$alcohol, 0.99)) +
  facet_grid(~quality) +
  scale_color_gradientn(colors = c('yellow', 'green', 'blue', 'black'), 
                        limits=quantile(wineQuality$free.sulfur.dioxide, 
                                        c(0.01, 0.99))) +
  xlab("alcohol (% by volume)")+
  labs(color = "FSD")+
  ylab("volatile acidity (acetic acid - g/dm^3)")
```

Even though it seemed to be information-overloaded, I'll still think it's a good visualization in terms of exploratory analysis. 
The scatter points tend to move down-right and it reveals that wines with better quality tend to have higher alcohol concentration and lower total sulfur dioxide. The color change shows better wine tends to have lower volatile acidity, but it may not work in terms of wines that among top level.

```{r echo=FALSE, message=FALSE, warning=FALSE}
ggplot(wineQuality, aes(x=alcohol, y=residual.sugar)) +
  geom_point(alpha=1/10) +
  ylim(quantile(wineQuality$residual.sugar, 0.01), 
       quantile(wineQuality$residual.sugar, 0.98)) +
  xlim(quantile(wineQuality$alcohol, 0.01), 
       quantile(wineQuality$alcohol, 0.99)) +
  facet_grid(~quality) +
  ylab(" residual sugar (g/dm^3)") +
  xlab("alcohol (% by volume)")
```



```{r echo=FALSE, message=FALSE, warning=FALSE}
library(RColorBrewer)
ggplot(wineQuality, aes(x=volatile.acidity, y=alcohol, 
                        color=as.character(quality))) +
  geom_jitter(alpha=1/1) +
  coord_cartesian(ylim = quantile(wineQuality$alcohol, c(0.01, 0.99)),
                  xlim = quantile(wineQuality$volatile.acidity, c(0.01, 0.98))) +
 # scale_color_gradientn(colors = c('red','yellow','green','blue')) +
  scale_color_brewer(type = 'div', 
                     guide = guide_legend(title = 'quality')) +
  scale_colour_brewer(palette = "Spectral") +
  theme(panel.background = element_rect(fill = "grey")) +
  ylab("alcohol (% by volume)") +
  labs(color = "quality")
```

There are indeed some segregation between different wines of quality.


```{r echo=FALSE, message=FALSE, warning=FALSE}
ggplot(wineQuality, aes(y=density, x=volatile.acidity,  
                       color=as.character(quality))) +
  geom_jitter() +
  coord_cartesian(ylim = quantile(wineQuality$density,  
                                  c(0.005, 0.99)), 
                  xlim = quantile(wineQuality$volatile.acidity, 
                                  c(0.005, 0.99))) +
#  scale_color_gradientn(colors = c('red','yellow','green','blue'))
  scale_color_brewer(type = 'div',
                     guide = guide_legend(title = 'quality')) +
  scale_colour_brewer(palette = "Spectral") +
  theme(panel.background = element_rect(fill = "grey"))+
  xlab("volatile acidity (acetic acid - g/dm^3)") +
  ylab("density (g/cm^3)") +
  labs(colour = "quality")

```

Let me at least try the linear model to see if it somehow help predict the result.

```{r echo=FALSE, message=FALSE, warning=FALSE}
# Try to find a linear model between quality and alcohol
# Also, some statistics are listed to evaluate the model.
library('memisc')
m1 <- lm(quality ~ alcohol, data = wineQuality)
m2 <- update(m1, ~. +volatile.acidity)
m3 <- update(m2, ~. +free.sulfur.dioxide)
m4 <- update(m3, ~. +residual.sugar)
mtable(m1, m2, m3, m4, digits = 2, sdigits = 2)
```
Just like what I've assumed in the begining, even for carefully selected variables, the linear model is still far from satisfactory.


# Multivariate Analysis

### Talk about some of the relationships you observed in this part of the investigation. Were there features that strengthened each other in terms of looking at your feature(s) of interest?

Good wines tend to have close relationships with higher alcohol concentration, lower free sulfur dioxide concentration, lower volatile acidity and low chlorides concentration. However, that does not make the wine extremely good. 

Good wines tend to have a lower concentration of volatile acidity and lower density. However, if the alcohol volume reaches certain high level, the volatile acidity level can be less weighted.


### Were there any interesting or surprising interactions between features?

There are some interesting patterns, but not very much surprising, though.


### OPTIONAL: Did you create any models with your dataset? Discuss the strengths and limitations of your model.

Yes, I tried linear regression models. The model can only explain 25% of the quality variance due to selected features, i.e. alcohol, volatile acidity, free sulfur dioxide.

------

# Final Plots and Summary

### Plot One

```{r echo=FALSE, message=FALSE, warning=FALSE}
ggplot(wineQuality, aes(alcohol)) + 
  geom_histogram(bins=10) +
  xlab("alcohol (% by volume)") +
  ggtitle("Count by Alcohol (% by Volumn)")+
  theme(plot.title = element_text(hjust = 0.5))
```

By adding noice to the alcohol plot above, I notice there might be a linear trends for the count of alcohol that is larger 10% by volume. This may reveal some relationships between alcohol and other features of the wines.

### Description One

The plot very clearly shows the relationships between all features in the dataset. It reveals features that have strong relationships with wine quality such as alcohol and quality, and strong relationships that should be cautious with such as density and alcohol.


### Plot Two

```{r echo=FALSE, message=FALSE, warning=FALSE}
ggplot(wineQuality, aes(y=alcohol, x=quality))+
  geom_jitter(alpha = 1/5)+
  geom_line(aes(y=alcohol), stat="summary", fun.y=mean, color='black')+
  scale_x_continuous(breaks = seq(3, 9, 1)) +
  ylab("Alcohol (% by volume)") +
  xlab("Quality") +
  ggtitle("Wine Quality by Alcohol")+
  theme(plot.title = element_text(hjust = 0.5))
  
```

This plot well shows the relationship between quality and alcohol. The linear pattern is strong of the wines with the quality above 4 level. However, there are still too much noise. And according to the linear model statistics, the model can only explain less than 20% of the quality of the wines.

### Description Two



### Plot Three

```{r echo=FALSE, message=FALSE, warning=FALSE}
library(RColorBrewer)
ggplot(wineQuality, aes(x=volatile.acidity, y=alcohol, 
                        color=as.character(quality))) +
  geom_jitter(alpha=1/1) +
  coord_cartesian(ylim = quantile(wineQuality$alcohol, c(0.01, 0.99)),
                  xlim = quantile(wineQuality$volatile.acidity, c(0.01, 0.98))) +
 # scale_color_gradientn(colors = c('red','yellow','green','blue')) +
  scale_color_brewer(type = 'div', 
                     guide = guide_legend(title = 'quality')) +
  scale_colour_brewer(palette = "Spectral") +
  theme(panel.background = element_rect(fill = "grey")) +
  ylab("alcohol (% by volume)") +
  xlab("volatile acidity (acetic acid - g/dm^3)") +
  labs(color = "quality") +
  ggtitle("Wine Quality by Alcohol and Volatile Acidity") +
  theme(plot.title = element_text(hjust = 0.5))
```


### Description Three

There are seemed to be 3 clusters in the plot. 
1. low level quality: low alcohol volume ~ middle high level volatile acidity.
2. middle level quality: widely distributed alcohol level ~ low bolatile acidity.
3. high level quality: high alcohol volume ~ widely distributed volatile acidity level.

To sum up, good wines tend to have high alcohol volume and lower volatile acidity level. However, if the alcohol volume reaches certain high level, the volatile acidity level can be less weighted.
 
------

# Reflection

The wineQualityWhites data set contains 4898 instances of white wine and 13 its features. To begin with, I checked out the concepts of all variables and got some general statistics of the data set. Since I wasn't familiar with the investigated features, the sense was not well built at the first place. To have more senses of each of those variables on how features related to wine quality, I started by exploring them by plotting all the variables aiming at seeking some patterns.I found that most variables had a pattern of normal distribution which, again, I failed to get the sense of how features related to each other. But there were some nuances. The distribution of alcohol seemed to have a tendency. 

Then I dived in to investigate relationships between different variables and got a basic idea of how features were related to each other by the CORR plot. I found two things are really important. Alcohol and density are the leading ones that have a close relationship with wine quality and alcohol and density was even closely related to each other. I tried to find linear model among variables to find even for alcohol, the contribution for explaining the wine quality is only around 20%. More methods were needed. Still, there were two takeaways from the findings: Either alcohol or density would be my first target and I needed to be cautious for dependency within variable pairs that telling the same story. Then comes my 3 rules for visualization as mentioned above. Finally, by scatterplot, some patterns of how variables related to each other showed up.  

There were a bunch of limitations in terms of the exploration process. Only one method was tried in modeling the features and was failed. variables behaviors and patterns were not that well portrayed. However, it's a good startup in investigating the relationships and logics among all those features. It did bring some useful information for further modeling the case by showing how wines of different quality have some certain features. 





