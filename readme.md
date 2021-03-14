# Deer-vehicle collisions in Scotland

<!-- badges: start -->
[![Project Status: Concept – Minimal or no implementation has been done yet, or the repository is only intended to be a limited example, demo, or proof-of-concept.](https://www.repostatus.org/badges/latest/concept.svg)](https://www.repostatus.org/#concept)
![](https://img.shields.io/badge/Shiny-not_hosted-blue?style=flat&labelColor=white&logo=RStudio&logoColor=blue)
[![Blog post](https://img.shields.io/badge/rostrum.blog-post-008900?labelColor=000000&logo=data%3Aimage%2Fgif%3Bbase64%2CR0lGODlhEAAQAPEAAAAAABWCBAAAAAAAACH5BAlkAAIAIf8LTkVUU0NBUEUyLjADAQAAACwAAAAAEAAQAAAC55QkISIiEoQQQgghRBBCiCAIgiAIgiAIQiAIgSAIgiAIQiAIgRAEQiAQBAQCgUAQEAQEgYAgIAgIBAKBQBAQCAKBQEAgCAgEAoFAIAgEBAKBIBAQCAQCgUAgEAgCgUBAICAgICAgIBAgEBAgEBAgEBAgECAgICAgECAQIBAQIBAgECAgICAgICAgECAQECAQICAgICAgICAgEBAgEBAgEBAgICAgICAgECAQIBAQIBAgECAgICAgIBAgECAQECAQIBAgICAgIBAgIBAgEBAgECAgECAgICAgICAgECAgECAgQIAAAQIKAAAh%2BQQJZAACACwAAAAAEAAQAAAC55QkIiESIoQQQgghhAhCBCEIgiAIgiAIQiAIgSAIgiAIQiAIgRAEQiAQBAQCgUAQEAQEgYAgIAgIBAKBQBAQCAKBQEAgCAgEAoFAIAgEBAKBIBAQCAQCgUAgEAgCgUBAICAgICAgIBAgEBAgEBAgEBAgECAgICAgECAQIBAQIBAgECAgICAgICAgECAQECAQICAgICAgICAgEBAgEBAgEBAgICAgICAgECAQIBAQIBAgECAgICAgIBAgECAQECAQIBAgICAgIBAgIBAgEBAgECAgECAgICAgICAgECAgECAgQIAAAQIKAAA7)](https://www.rostrum.blog/2019/01/18/deer-collisions/)
<!-- badges: end -->


A small R Shiny app for exploring geographic data about collisions between vehicles and deer in Scotland between 2000 and 2017. You can read more in [the accompanying blog post](https://www.rostrum.blog/2019/01/18/deer-collisions/).

![Gif preview of the app in action](https://media.giphy.com/media/ZvK6zz5E4agAL2gf6u/giphy.gif)

## Use

The app is not hosted online. You can clone or download this repo and then run the app, or you can run these lines from an R session:

``` r
shiny::runGitHub(
  repo = "scot-deer-collisions", 
  username = "matt-dray"
)
```

The app depends on a few packages: {shiny}, {shinydashboard}, {leaflet}, {DT}, {dplyr}, {sf} and {icon}.


## Data

From the blogpost:

>[The National Deer-Vehicle Collisions Project](http://www.deercollisions.co.uk/), administered by [The Deer Initiative](http://www.thedeerinitiative.co.uk/), has been monitoring data on deer-vehicle collisions in the UK.
>
>The data are open. I found the dataset when skimming through [data.gov.uk](https://data.gov.uk/dataset/838b88d8-7509-435c-9649-90f1881b5ad7/deer-vehicle-collisions). It links to the [SNH Natural Spaces site](https://gateway.snh.gov.uk/natural-spaces/dataset.jsp?dsid=DVC) where you can download the data as shapefile, GML or KML under the [Open Government Licence](http://www.nationalarchives.gov.uk/doc/open-government-licence/version/3/).

I produced this app independently and I don't work for any of these organisations.
