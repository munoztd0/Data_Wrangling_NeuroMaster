---
title: "Data wrangling workshop I for Neuroscience Master students"
author: "David Munoz Tord"
date: "`r format(Sys.time(), '%d %B, %Y')`"
output:   
  pdf_document:
    extra_dependencies: ["float"]
  html_document:     
    toc: true
    toc_float: true
    number_sections: false
---

```{r setup, include=FALSE}
#knitr::opts_chunk$set(echo = TRUE)
if(!require(pacman)) {
  install.packages("pacman")
  library(pacman)
}
pacman::p_load(reticulate, R.matlab, sessioninfo) #reticulate for python and R.matlab for... Matlab
use_virtualenv(virtualenv = "r-reticulate")
``` 

# Data wrangling workshop for Neuroscience Master students - Part I
This file was automatically created with Rmarkdown using `r session_info()$platform[1]`
![](./img/stack.jpg){style="float: left;margin-right: 7px; margin-left: 7px;margin-top: 7px; width:400px;"}
<br><br><br><br><br><br><br>
Make sure you have read the ReadMe file.

If you are struggling I suggest you look at the "cheat sheet" documents and/or you just look it up on the internet. 

A huge part of being good at programming/scritpting is knowing where/what to look for. I definitely encourage each of you to familiarize yourself with [how to use search terms in google](https://www.dailyinfographic.com/how-to-become-a-google-power-user) or any other search engine and to look for answers in [StackOverflow](https://stackoverflow.com/) or in [GitHub](https://github.com/)


If you are still struggling after that just try posting an issue on this github repo so I or other people following can help you.
<br><br><br><br><br><br><br>



# Git basics
![](./img/git.png){style="float: right;margin-right: 7px; margin-left: 7px;margin-top: 7px; width:250px;"}

Fork [this repository](https://github.com/munoztd0/Data_Wrangling_NeuroMaster) onto your github page. You can also "star" it by clicking the little star icon so you will get information about this workshop and comments from others.

Clone YOUR fork (e.g. git clone https<!-- -->://github.com/'YOURUSERNAME'/Data_Wrangling_NeuroMaster inside a terminal)
Open the test.txt file, add whatever you want e.g. "doneso" or whatever) and save it.

Open up you terminal within the "Data_Wrangling_NeuroMaster" directory, and type :



```{bash eval=FALSE}
$ git add -A
$ git commit -m "test" #or whatever
$ git push 
```
You will have to give you github username and password.

Now go to your repository (again https<!-- -->://github.com/'YOURUSERNAME'/Data_Wrangling_NeuroMaster) and check that the modifications are there.



That's it first task done! 

![](./img/xkcd_code.png){style="float: left;margin-right: 7px; margin-left: 7px;margin-top: 7px; width:300px;"}
<br><br><br><br>
Additional tip: If you are as lazy as I am sometimes (remember laziness WILL get you far in programming) you can add this function to your ~/.bash_profile or whatever your OS uses to replace this three lines by one.
<br><br><br>

```{r, eval=FALSE}
function lazygit() {
            git add .
            git commit -a -m "$1"
            git push
            }
```
<br><br><br>


# Exercices
Now that we are on point. Let's actually start. First thing will be to create a file that will contain the responses to this workshop's exercises. The extension will of course depend on which languages you want to use (e.g. exercise.py, exercise.R, exercise.m, exercise.rmd, exercise.ipynb)

I definitely recommend that you start familiarizing yourself with Rmarkdown and Jupyter notebooks if you are not.
<br><br><br> 

![](./img/my_machine.png){style="float: left;margin-right: 7px; margin-left: 7px;margin-top: 7px; width:400px;"}
<br><br>

## 1) Make you code reproducible (AKA work on other machines) <br> 


An important thing that will make you and your coworkers save a ton of time and hassle is to make your code flexible and reproducible.

This will take you a tiny bit more work but you will thank yourself later down the line. 

So the first thing will be to make the current path of your "exercise.**" file flexible. There are different ways to do that depending on which program you are using and how much flexibility you want but here a some cues on how to start you journey.
<br><br><br>

### For python:
```{python}
import os
print(os.getcwd().strip('"\''))
```

### For R:
```{r}
homepath = getwd()
cat(homepath)
```

### For Matlab/Octave:
```{octave}
homepath = pwd;
disp(homepath)
```

Now try to load the dataset "data/data.csv" using the "homepath" dynamic variable !

In this vibe try to make ALL your code work seamlessly on another computer with the same operating system you have (you can try to do that on your own machine but on a different user for example). Especially make sure you scripts imports/downloads the functions/packages/libraries/modules you use in your script.    


<br>
<center>
![](./img/xkcd_repro.png)
</center>
<br>



### Optional:

Try to make ALL your code work seamlessly on another computer with the another operating system (OS) than yours (if you are on mac/linux try on windows and vice versa since mac/linux are often really similar). 

To make your life easier (and impress you colleagues and supervisors) you might want to take a look at reproducible workflows such as [repro](https://github.com/aaronpeikert/repro) for R or [this](https://swcarpentry.github.io/2014-01-31-ucsb/lessons/jk-python/reproducible_workflow.html) for Python. If you want to know more about that and how I personally created this file let me know !

If you can't get your hands on another OS you are encouraged to post an issue on this workshop's github page so you guys can find a "partner" than can try your code and vice-versa.

Alternatively, you can also create tiny virtual machines to try you code on different OS (more on that [here](https://www.virtualbox.org/)). Tip: windows is actually "free" for trying software so you can "skip" the license in the installation and it will still run.

#### For R (put that a the beginning of your script):
```{r eval=FALSE}
if(!require(pacman)) {
  install.packages("pacman")
  library(pacman)
}
pacman::p_load(tidyr, R.matlab)
``` 

#### For Python (do that within your terminal when you finished your scripts):
It will automatically save module requirements in a ./requirements.txt file
```{bash eval=FALSE}
$ pip install pipreqs # install pipreqs on your machine
$ pipreqs .  #run that in the directory where you have you script
```
Then someone can run "pip install -r requirements.txt" before running your script


<br><br>

## 2) Rearrange the data <br> 

![](./img/pivot.jpg){style="float: right;margin-right: 7px; margin-left: 7px;margin-top: 7px; width:450px;"}

First let's just describe the dataset. This is a real dataset that I used but the measurement variables names have been removed and some of them have been "tweaked" for this workshop purpose to create real word issues. The experiment can be summarized by a 2x2 mixed design.

1 repeated (within) factorial variable with 2 levels ("pre" and "post") and 1 group (between) factorial variable with 2 levels ("placebo" and "treatment"). Then there is a bunch of continuous variables those are biomedical variables of interest.

However as you can see, this dataset is in "wide" format (var1_ses1, var1_ses2,  ...) instead of a "long" format, which is something that I often encounter. If you are not familiar with the terms I suggest you take a look [here](https://discuss.analyticsvidhya.com/t/difference-between-wide-and-long-data-format/8110/2). 



Anyway here you will have first to transform this dataset from wide to long, this means that we want 1 row per measurement (i.e. var1, var2,..., with a "session" column that either has a "pre" or "post" value).

You could of course do it by hand, but that of course not why we are here.. So try to implement a way of doing so automatically.

<br> <br> 

## 3) Plot the data <br> 
![](./img/xkcd_viz.png){style="float: right;margin-right: 7px; margin-left: 7px;margin-top: 7px; width:450px;"}

But right now, our variables are in all sort of different scales and it's impossible to compare apple to oranges. Plus since you don't know what the variables are supposed to measure anyway, we will scale all variables (x - mean /sd). Like always try to implement a way of doing so for all variables at once !


Now that you have you nice long format standardized data you will want to visualize it. Visualizing data has always a subjective part but there are plenty of people that have created guidelines and rules to make it clearer for everybody, so take a look when you can (e.g. [here for beautiful examples](https://www.data-to-viz.com/) or [here for tips about how to efficiently use colors in your plots](https://www.sigmacomputing.com/blog/7-best-practices-for-using-color-in-data-visualizations/)) and try to think about it.

Anyway, for now we will want to visualize the overall density of each variable (no matter which session or group) and the correlation between each pair of variable (pair plots).

Again try to look for a way of doing so efficiently this might require a similar skim than just before for gathering variables per keys (this is a clue).

What do you see, anything weird (e.g. outliers, correlations, densities) ? Write it down and we will discuss it.

<br>

### Optional:

Try to "clean" the dataset (e.g. remove outliers, log transform, etc..) as best as you think to be able to analyze the data based on the observations you did on the plots. Then maybe try to do an 2x2 anova (watch out for the repeated measurement) on a problematic variable before and after you cleaned/transformed it. 

<br><br>

## 4) Feature selection (optional but at least try to think about it)

![](./img/machine_learning.png){style="float: right;margin-right: 7px; margin-left: 7px;margin-top: 7px; width:300px;"}
Let's say you want to test for the significance of the intervention variable (placebo VS treatment) on var1.
You also want to control for baseline difference between groups (session pre-post) and other nuisance covariates (e.g. age, weight, number of cigarette smoked per week, etc..). Here you have many "nuisance" variables (var2 all the way to var20) and not that much observations... 

One thing you could do is enter ALL of them into an ANCOVA, but that's a bit dubious because you are artificially decreasing your degrees of freedom (and increasing the chances of multi-colinearity). We are not gonna enter too much into the details about that right here but try to think why we generally wouldn't want that.

Another thing one might do is to enter all these variables and then removing the ones that are not "statically significant" and then rerun the analysis with only the ones left. Again that is definitely not the best way to go for because you doing multiple tests (and also some variables that were significant before might still be once you removed others). 
 
So one way to circumvent these issues is to first implement a proper variable selection method (not based on p-values). You can achieve this via several methods. One way to do that could be to fit different models (with and without certain variables) and compare them with a model selection criterion (AIC, BIC, SIC, loo, R², etc..) to only keep the "best model". 

![](./img/data_science_model.png){style="float: left;margin-right: 7px; margin-left: 7px;margin-top: 7px; width:300px;"}
<br><br>
Alternatively you could also select only variables that explain a certain threshold of variance (i.e. how useful is this variable to predict an outcome, here "is the individual in the placebo or treatment group?"). Finally, you can also create composite variables (component) that reflects most of the variance from those variables (however try to think about what is the drawback of this last method if you use it).



This is a rather complex and technical exercise (as well as time and computationally consuming) but I think it's definitely primordial for scientists to know how to select variables (feature) from dataset.

PS: No need to do the ANCOVA, the purpose of this exercise is really about which variables you would retain in the final model and there is definitely no "right or wrong" answers.

<br><br>


## 5) Preparing behavioral data for fMRI analysis

Now we are entering the realm of task-based functional MRI. We will definitely go more into details in a future workshop but let's just go through a bit of data wrangling anyone confronted to fMRI will have to go through.

Let's start by loading the events associated to an fMRI acquisition. Here (in data/sub-control100/data.mat) is just an example of a typical file that you will have to extract from: the onsets (AKA when does the stuff you showed to your participant appeared), the durations (how long did it appear) and the behavioral (also generally called modulators) data associated to your task (e.g. reaction times or liking ratings for each condition). You WILL need these regressors to model you fMRI data later on.

The thing is.. these files are generally (at least here in Geneva) generated for each participant in a .mat format. So that's why I gave it to you here since you will probably get it in your lab too. If you don't feel concerned by that and your lab and moved on to python as its presentation software for fMRI, good for you and you might skip this. Otherwise this task might be quite instructive for you. So let's dive in.


This files contain a matlab "structure array" which simply put is "a data type that groups related data using data containers called 'fields'. Each field can contain any type of data". This might be confusing at first (trust me .. it is) but so let's go step by step. This is a really simple design were we have only 3 odor conditions and the "start" of each trial.

### For Matlab/Octave
```{octave, comment=""}
load('data/sub-control100/data.mat')  %loading data

disp('Each structure has two fields named:'); disp(fieldnames(durations2))

%to access the data in a field you must use dot notation (e.g. structName.fieldName)

disp(['The "start" field contains ', num2str(length(durations2.start)), ' observations'])
disp('The "odor" field has 3 nested substructures named'); disp(fieldnames(durations2.odor))
disp(['Each of the 3 nested substructure in the "odor" field contains ', num2str(length(durations2.odor.reward)), ' observations'])
```

Now what we would like for most MRI software is a "3 column timing files" with respectively the onset time (in seconds); the duration (in seconds); the relative magnitude of each stimulus (set to 1 for none). I put examples of what it should look like in the /data folder.

So basically the task will be to recreate that type of files for sub-01 and make you code easily scale to more subjects (here is just duplicated the sub-01 into more subjects to test your code).


Of course you are not forced to use matlab/octave here to achieve that.
<br><br>
![](./img/nest.jpeg){style="float: right;margin-right: 7px; margin-left: 7px;margin-top: 7px; width:300px;"}

### For python:
```{python}
import scipy.io
mat = scipy.io.loadmat('data/sub-control100/data.mat')
dict.keys(mat) #its read as a dictionary so this gonna get ugly but stay with me
#mat["modulators2"]["start"][0] #this gets you an array within an array !not good enough!  
mat["modulators2"]["start"][0][0][0:2] #this actually get you the array (but remove the [0:2])
#mat["modulators2"]["odor"]["control"][0][0] #this doesn't work!
mat["modulators2"]["odor"][0][0]["control"][0][0][0:2] #you have to get you dictionary from the array first ! (but remove the [0:2])
```
<br><br>
![](./img/nestR.jpeg){style="float: left;margin-right: 7px; margin-left: 7px;margin-top: 7px; width:300px;"}

### For R:
```{r, comment=""}
library(R.matlab)
mat <- readMat("data/sub-control100/data.mat")
mat$modulators2  #check structure -> this a list
head(mat$modulators2[[1]],2) #Accessing list number 1 (i.e. "start")
mat$modulators2[[2]] #Accessing list number 2 (i.e. "odor") -> stil a list !
head(mat$modulators2[[2]][[3]],2) #Accessing list number 3 (i.e "control") within embedded list number 1 (i.e. "odor")
#of course remove head(,2) here it's just for display purpose
```
### Optional:

Try to create a dataset that includes each subjects behavioral dataset appended together with a column with their ID (numbers following control or treatment), a column with their group (control or treatment), a column with the condition name (reward, control or neutral) and 1 column with their behavioral data (from the modulators2.odor field) and a column with the number of the trial (1-54). Have extra caution to put the behavioral data back into the right order (you can get that by sorting them by their  onsets !). Hang in there..
<br><br>

## 6) The end

![](./img/programmer.jpeg){style="float: left;margin-right: 7px; margin-left: 7px;margin-top: 7px; width:300px;"}
![](./img/brent.jpg){style="float: right;margin-right: 7px; margin-left: 7px;margin-top: 7px; width:300px;"}
<br><br>
There you are, you finished this list of exercise. Good job! You deserve a pat on the shoulder and a good cup (jar?) of coffee.

I hope you learned things that will be useful for your research/career and let me know what you liked/disliked.



<br>
<br><br><br><br>
Credit for all the comic goes to Randall Munroe
