#hello 1.2.20

#mAPS FOR STB WGS isolates


####
#sTART WITH SURVEY SITES BY CROP TYPE to check data
#####

setwd("D:/Shared drives/DPI   Plant Pathology   Cereal Pathology/Culture collection details/WGS STB Megan list 2020/")

require(XLConnect)
require(asreml) #opens multiple packages asreml, latice (graps package)

require(lattice)
require(latticeExtra)
require(directlabels)
require(RColorBrewer)
require(ggplot2)
require(reshape2)
#require(drc)
require(plyr)
require(GGally)
require(scatterplot3d)
require(dplyr)

library(ggmap)
library(gdata)

library("FactoMineR")
library("factoextra")

#The data

#df <- readWorksheetFromFile(file="WGS STB Megan 2020 check09042020.xlsx", sheet=c("Sheet1"), header=TRUE)
#used direct import function instead but can also use above

df<-WGS_STB_Megan_2020_check09042020

str(df)



names(df)
#[1] "SPECIES"                        "ID"                             "SYNONYM_1"                      "SYNONYM_2"                     
#[5] "Sample #"                       "Single spore source ID"         "ENTRY"                          "LOCCODE"                       
#[9] "COL_DATE...9"                   "EXPT"                           "COL_YEAR"                       "GPS_WITH"                      
#[13] "HOSTGEN"                        "Variety"                        "SAMPL_NO"                       "LEAF_NO"                       
#[17] "PYCNIDIA"                       "SPORE_NO"                       "Collection details"             "COMMENT"                       
#[21] "Dry Storage"                    "GPS Type"                       "Specific Latitude"              "Specific Longitude"            
#[25] "Latitude, Longitude (Specific)" "Specific Altitude"              "COL_DATE...27"                  "Received date"                 
#[29] "Locality"                       "Locality Latitude"              "Locality Longitude"             "Comment"                       
#[33] "Sample type"                    "State"                          "WGS"                            "SEQ BATCH"                     
#[37] "Population_name" "Latitude"                       "Longitude"                     


#rename the lat long so one word

df$Latitude<-df$`Specific Latitude`
df$Longitude<-df$`Specific Longitude`

###mapping of STB survey sites and incidence

#More Q&A - https://github.com/dkahle/ggmap/issues/51

#We need this to access google maps, not sure if you will also ANU may have a key
#DPI API key "AIzaSyCX8w-wvuSqNRvzF14PFs3XY1S60zTbRdk"

####
if(!requireNamespace("devtools")) install.packages("devtools")
devtools::install_github("dkahle/ggmap", ref = "tidyup")
library(ggmap)
register_google(key = "AIzaSyCX8w-wvuSqNRvzF14PFs3XY1S60zTbRdk") 

#test this works....YES it does!!!!
p <- ggmap(get_googlemap(center = c(lon = -122.335167, lat = 47.608013),
                         zoom = 11, scale = 2,
                         maptype ='terrain',
                         color = 'color'))
p

#test on Aus site ...Yes this works
p <- ggmap(get_googlemap(center = c(lon = 142.31443124884743, lat = -37.55279466696095), #Mortlake, Vic
                         zoom = 6, scale = 2,
                         maptype ='terrain',
                         color = 'bw'))
p



# Load the relevant libraries - do this every time
library(lubridate)
library(ggplot2)
library(dplyr)
library(data.table)
library(ggrepel)
library(tidyverse)

#some different map types and zooms


##All survey sites

#Function to remove the axis on the map 
ditch_the_axes <- theme(
  axis.text = element_blank(),
  axis.line = element_blank(),
  axis.ticks = element_blank(),
  panel.border = element_blank(),
  panel.grid = element_blank(),
  axis.title = element_blank()
)



#plot the all survey points 
p2 <- p + geom_point(aes(x=Longitude, y=Latitude, size= 1, colour = as.factor(COL_YEAR)),data=all_isolates,
                     alpha =0.8)+
  #scale_shape_manual(values=c(18,17,16))+                           #you can set shapes and colour scales etc using these functions
  #scale_color_manual(values=c('blue','red', 'yellow', 'green'))+
  scale_size(range=c(2))+
  ditch_the_axes #run the function above
p2


p3<-p2 + guides(size = FALSE) #remove the unnecesary guide from legend
p3

#save the map
png(file="STBcollection site.png", width=4800, height=4800, res=600, pointsize=10,
    type="windows", antialias="cleartype")
p3
dev.off()

##############################################
#End here
##
#example of setting size and colour and text to the image

#Biploaris

Pbi <- p + geom_point(aes(x=Longitude.E, y=Latitude.S, size=c(log10(tops$Bipolaris..pgDNA.g.Sample.+1)), #need to add 1 to the total so that "0" graph on the log scale
                          colour=c(log10(tops$Bipolaris..pgDNA.g.Sample.+1))),data=tops,
                      alpha =0.9)+
  scale_colour_gradientn(colours = c("red","yellow","black"),
                         values=c(1.0,0.2,0)) +
  scale_size(range=c(1,4))+
  annotate(geom="text", x=142.5, y=-26.5, label="Tops",   #adding text
           color="black")

Pbi



# change name of legend to generic word "Population"
Pbi <- Pbi + guides(size=guide_legend(title="Biploaris (Log10 pgDNA/g Sample)"),
                    color=guide_legend(title="Biploaris (Log10 pgDNA/g Sample)") )
Pbi
Pbi<- Pbi+ theme(legend.position = "top")
Pbi
png(file="2019 Biploaris total_tops.png", width=4800, height=4800, res=600, pointsize=10,
    type="windows", antialias="cleartype")
Pbi
dev.off()
############################################################




#Calculating the distances between populations
##############################################################################
#create a dataframe with just the location and gps co-ordinates
names(df)
#df$pop<-paste(df$Locality,as.factor(df$COL_YEAR)) #don't need this as created Population_name
#df$pop
dfa <- df[,c(37,38,39)]
head(dfa)
#remove duplicated rows
dfb<-dfa %>% distinct(dfa$Population_name, .keep_all = TRUE)


# now calculate the distsances between the points
#function to run first
##https://eurekastatistics.com/calculating-a-distance-matrix-for-geographic-points-using-r/
ReplaceLowerOrUpperTriangle <- function(m, triangle.to.replace){
  # If triangle.to.replace="lower", replaces the lower triangle of a square matrix with its upper triangle.
  # If triangle.to.replace="upper", replaces the upper triangle of a square matrix with its lower triangle.
  
  if (nrow(m) != ncol(m)) stop("Supplied matrix must be square.")
  if      (tolower(triangle.to.replace) == "lower") tri <- lower.tri(m)
  else if (tolower(triangle.to.replace) == "upper") tri <- upper.tri(m)
  else stop("triangle.to.replace must be set to 'lower' or 'upper'.")
  m[tri] <- t(m)[tri]
  return(m)
}

GeoDistanceInMetresMatrix <- function(df.geopoints){
  # Returns a matrix (M) of distances between geographic points.
  # M[i,j] = M[j,i] = Distance between (df.geopoints$lat[i], df.geopoints$lon[i]) and
  # (df.geopoints$lat[j], df.geopoints$lon[j]).
  # The row and column names are given by df.geopoints$name.
  
  GeoDistanceInMetres <- function(g1, g2){
    # Returns a vector of distances. (But if g1$index > g2$index, returns zero.)
    # The 1st value in the returned vector is the distance between g1[[1]] and g2[[1]].
    # The 2nd value in the returned vector is the distance between g1[[2]] and g2[[2]]. Etc.
    # Each g1[[x]] or g2[[x]] must be a list with named elements "index", "lat" and "lon".
    # E.g. g1 <- list(list("index"=1, "lat"=12.1, "lon"=10.1), list("index"=3, "lat"=12.1, "lon"=13.2))
    DistM <- function(g1, g2){
      require("Imap")
      return(ifelse(g1$index > g2$index, 0, gdist(lat.1=g1$lat, lon.1=g1$lon, lat.2=g2$lat, lon.2=g2$lon, units="m")))
    }
    return(mapply(DistM, g1, g2))
  }
  
  n.geopoints <- nrow(df.geopoints)
  
  # The index column is used to ensure we only do calculations for the upper triangle of points
  df.geopoints$index <- 1:n.geopoints
  
  # Create a list of lists
  list.geopoints <- by(df.geopoints[,c("index", "lat", "lon")], 1:n.geopoints, function(x){return(list(x))})
  
  # Get a matrix of distances (in metres)
  mat.distances <- ReplaceLowerOrUpperTriangle(outer(list.geopoints, list.geopoints, GeoDistanceInMetres), "lower")
  
  # Set the row and column names
  rownames(mat.distances) <- df.geopoints$name
  colnames(mat.distances) <- df.geopoints$name
  
  return(mat.distances)
}

#now the code to generate the matrix

#make sure names are correct for function
names(dfb)
str(dfb)
dfb$lat<-dfb$Latitude
dfb$lon<-dfb$Longitude
dfb$name<-dfb$Population_name
distmat<-round(GeoDistanceInMetresMatrix(dfb) / 1000)
#This worked very cool
#create a csv file of the distances
write.table(distmat,
            file="Popdistance matrix.csv",row.names=TRUE,quote=TRUE,append=TRUE,sep=",")

#write table of df so Megan has all the info I used
write.table(df,
            file="WGS STB set.csv",row.names=TRUE,quote=TRUE,append=TRUE,sep=",")


#######################################################################################################################################
#
#END
#
######################################################################################################################################




