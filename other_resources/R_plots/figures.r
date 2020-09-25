library(data.table)
library(ggplot2)

rm(list=ls())
gc()

# load data
load("datafiles.RData")


### power bar-plots

## by affiliation

power_inst_dt <- power_inst_dt[,.(Affiliation,Country,Continent,Location,Power_Inst,Power_Top5_Inst,Power_Not5_Inst=Power_Inst-Power_Top5_Inst)]

power_inst_dt <- power_inst_dt[order(-Power_Inst,-Power_Top5_Inst)]
top10_inst_dt <- power_inst_dt[1:10]

top10_inst_dt$Institution <- gsub(",.*$", "", top10_inst_dt$Affiliation)
top10_inst_dt$Institution[6] <- "U Penn"

top10_inst_dt$Top5 <- top10_inst_dt$Power_Top5_Inst
top10_inst_dt$Not5 <- top10_inst_dt$Power_Not5_Inst

top10_inst_lg <- melt(top10_inst_dt,id.vars = "Institution",measure.vars = c("Top5","Not5"))

colnames(top10_inst_lg) <- c("Institution","Tier","Power")

top10_inst_lg$Institution <- factor(top10_inst_lg$Institution,levels=unique(top10_inst_lg$Institution))

top10_inst_lg$Tier <- factor(top10_inst_lg$Tier,levels=unique(top10_inst_lg$Tier)[2:1])

## bar-plot of the institutional power by journal tiers
gg_inst <- ggplot(top10_inst_lg,aes(x=Institution,y=Power,fill=Tier))+
  geom_bar(stat="identity")+
  scale_fill_manual(breaks=c("Top5","Not5"),values=c("gray70","gray30"))+
  labs(ylab="Power")+
  theme_classic()+
  theme(axis.title.x=element_blank(),axis.text.x=element_text(size=12,angle=45,hjust=1),axis.title.y = element_text(size=14),axis.text.y = element_text(size=12),legend.text = element_text(size=12),legend.position =c(.8,.9),legend.title = element_blank())

gg_inst

ggsave("PowerRank_Top10_Institutions.png",gg_inst,width=6.5,height=4.5)


## by country

power_ctry_dt <- power_ctry_dt[,.(Country,Continent,Power_Ctry,Power_Top5_Ctry,Power_Not5_Ctry=Power_Ctry-Power_Top5_Ctry)]

power_ctry_dt <- power_ctry_dt[order(-Power_Ctry,-Power_Top5_Ctry)]
top10_ctry_dt <- power_ctry_dt[1:10]

top10_ctry_dt$Top5 <- top10_ctry_dt$Power_Top5_Ctry
top10_ctry_dt$Not5 <- top10_ctry_dt$Power_Not5_Ctry

top10_ctry_lg <- melt(top10_ctry_dt,id.vars = "Country",measure.vars = c("Top5","Not5"))

colnames(top10_ctry_lg) <- c("Country","Tier","Power")

top10_ctry_lg$Country <- factor(top10_ctry_lg$Country,levels=unique(top10_ctry_lg$Country))

top10_ctry_lg$Tier <- factor(top10_ctry_lg$Tier,levels=unique(top10_ctry_lg$Tier)[2:1])

## bar-plot of the country power by journal tiers
gg_ctry <- ggplot(top10_ctry_lg,aes(x=Country,y=Power,fill=Tier))+
  geom_bar(stat="identity")+
  scale_fill_manual(breaks=c("Top5","Not5"),values=c("gray70","gray30"))+
  labs(ylab="Power")+
  theme_classic()+
  theme(axis.title.x=element_blank(),axis.text.x=element_text(size=12,angle=45,hjust=1),axis.title.y = element_text(size=14),axis.text.y = element_text(size=12),legend.text = element_text(size=12),legend.position =c(.8,.9),legend.title = element_blank())

gg_ctry

ggsave("PowerRank_Top10_Countries.png",gg_ctry,width=6.5,height=4.5)


top11_ctry_dt <- power_ctry_dt[2:11]

top11_ctry_dt$Top5 <- top11_ctry_dt$Power_Top5_Ctry
top11_ctry_dt$Not5 <- top11_ctry_dt$Power_Not5_Ctry

top11_ctry_lg <- melt(top11_ctry_dt,id.vars = "Country",measure.vars = c("Top5","Not5"))

colnames(top11_ctry_lg) <- c("Country","Tier","Power")

top11_ctry_lg$Country <- factor(top11_ctry_lg$Country,levels=unique(top11_ctry_lg$Country))

top11_ctry_lg$Tier <- factor(top11_ctry_lg$Tier,levels=unique(top11_ctry_lg$Tier)[2:1])

## bar-plot of the country power (less USA) by journal tiers
gg_ctry <- ggplot(top11_ctry_lg,aes(x=Country,y=Power,fill=Tier))+
  geom_bar(stat="identity")+
  scale_fill_manual(breaks=c("Top5","Not5"),values=c("gray70","gray30"))+
  labs(ylab="Power")+
  theme_classic()+
  theme(axis.title.x=element_blank(),axis.text.x=element_text(size=12,angle=45,hjust=1),axis.title.y = element_text(size=14),axis.text.y = element_text(size=12),legend.text = element_text(size=12),legend.position =c(.8,.9),legend.title = element_blank())

gg_ctry

ggsave("PowerRank_Top10_Countries_NonUSA.png",gg_ctry,width=6.5,height=4.5)


### geo-diverse scatterplot

# scatter-plot journal age and standard distances (degrees) by journal field
gg_journaldist <- ggplot(journals_dt,aes(x=Journal_Age,y=journal_stdist_linear_1st2nd_deg))+
  geom_point(aes(shape=Field),size=3,alpha=.5)+
  scale_shape_manual(values=c(1,15,16,17),labels=c("Top 5","Theory","Applied","Econometrics"))+
  coord_cartesian(xlim=c(0,150),ylim=c(0,60))+
  labs(x="Journal Age (years)",y="Standard Distance (degrees)")+
  theme_classic()+
  theme(axis.title = element_text(size=14),axis.text = element_text(size=12),legend.title = element_blank(),legend.text = element_text(size=12),legend.position = c(.85,.85))

gg_journaldist

ggsave("AgeDistField.png",gg_journaldist,width=6.5,height=4.5)


### geo-diverse densities

# plot densities of standard distances (degrees) by journal field
gg_journaldense <- ggplot(journals_dt,aes(x=journal_stdist_linear_1st2nd_deg,linetype=Field))+
  stat_density(geom="line",position="identity",bw=3,size=1)+
  scale_linetype_manual(values=c(1400,1401,1402,1403),labels=c("Top 5","Theory","Applied","Econometrics"))+
  coord_cartesian(xlim=c(0,60))+
  labs(x="Standard Distance (degrees)",y="Density")+
  theme_classic()+
  theme(axis.title = element_text(size=14),axis.text = element_text(size=12),legend.title = element_blank(),legend.text = element_text(size=12),legend.position = c(.85,.85))

gg_journaldense

ggsave("DistFieldDensity.png",gg_journaldense,width=6.5,height=4.5)


