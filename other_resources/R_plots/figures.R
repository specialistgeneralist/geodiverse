# load packages
library(data.table)
library(ggplot2)
library(ggrepel)
library(cowplot)

# clean-up the environment (just in case)
rm(list=ls())
gc()

# load the data
load("datafiles.RData")

####################################
# -1- generate the power bar-plots #
####################################

## by affiliation

power_inst_dt <- power_inst_dt[,.(Affiliation=Institution_Short,Country,Continent,Power,Power_Top5,Power_Not5)]

power_inst_dt <- power_inst_dt[order(-Power,-Power_Top5)]
top10_inst_dt <- power_inst_dt[1:10]

top10_inst_dt$Institution <- gsub(",.*$", "", top10_inst_dt$Affiliation)
top10_inst_dt$Institution[6] <- "U Penn"

top10_inst_dt$Top5 <- top10_inst_dt$Power_Top5
top10_inst_dt$Not5 <- top10_inst_dt$Power_Not5

top10_inst_lg <- melt(top10_inst_dt,id.vars = "Institution",measure.vars = c("Top5","Not5"))

colnames(top10_inst_lg) <- c("Institution","Tier","Power")

top10_inst_lg$Institution <- factor(top10_inst_lg$Institution,levels=unique(top10_inst_lg$Institution))

top10_inst_lg$Tier <- factor(top10_inst_lg$Tier,levels=unique(top10_inst_lg$Tier)[2:1])

## bar-plot of the institutional power by journal tiers
gg_inst <- ggplot(top10_inst_lg,aes(x=Institution,y=Power,fill=Tier))+
  geom_bar(stat="identity")+
  scale_fill_manual(values=c("indianred","steelblue"))+
  labs(ylab="Power")+
  theme_classic()+
  theme(axis.title.x=element_blank(),axis.text.x=element_text(size=12,angle=45,hjust=1),axis.title.y = element_text(size=14),axis.text.y = element_text(size=12),legend.text = element_text(size=12),legend.position =c(.8,.9),legend.title = element_blank())

gg_inst

ggsave("PowerRank_Top10_Institutions_Color.png",gg_inst,width=6.5,height=4.5)


## by country

power_ctry_dt <- power_ctry_dt[,.(Country,Continent,Power,Power_Top5,Power_Not5)]

power_ctry_dt <- power_ctry_dt[order(-Power,-Power_Top5)]
top10_ctry_dt <- power_ctry_dt[1:10]

top10_ctry_dt$Top5 <- top10_ctry_dt$Power_Top5
top10_ctry_dt$Not5 <- top10_ctry_dt$Power_Not5

top10_ctry_lg <- melt(top10_ctry_dt,id.vars = "Country",measure.vars = c("Top5","Not5"))

colnames(top10_ctry_lg) <- c("Country","Tier","Power")

top10_ctry_lg$Country <- factor(top10_ctry_lg$Country,levels=unique(top10_ctry_lg$Country))

top10_ctry_lg$Tier <- factor(top10_ctry_lg$Tier,levels=unique(top10_ctry_lg$Tier)[2:1])

## bar-plot of the country power by journal tiers
gg_ctry <- ggplot(top10_ctry_lg,aes(x=Country,y=Power,fill=Tier))+
  geom_bar(stat="identity")+
  scale_fill_manual(values=c("indianred","steelblue"))+
  labs(ylab="Power")+
  theme_classic()+
  theme(axis.title.x=element_blank(),axis.text.x=element_text(size=12,angle=45,hjust=1),axis.title.y = element_text(size=14),axis.text.y = element_text(size=12),legend.text = element_text(size=12),legend.position =c(.8,.9),legend.title = element_blank())

gg_ctry

ggsave("PowerRank_Top10_Countries_Color.png",gg_ctry,width=6.5,height=4.5)


top11_ctry_dt <- power_ctry_dt[2:11]

top11_ctry_dt$Top5 <- top11_ctry_dt$Power_Top5
top11_ctry_dt$Not5 <- top11_ctry_dt$Power_Not5

top11_ctry_lg <- melt(top11_ctry_dt,id.vars = "Country",measure.vars = c("Top5","Not5"))

colnames(top11_ctry_lg) <- c("Country","Tier","Power")

top11_ctry_lg$Country <- factor(top11_ctry_lg$Country,levels=unique(top11_ctry_lg$Country))

top11_ctry_lg$Tier <- factor(top11_ctry_lg$Tier,levels=unique(top11_ctry_lg$Tier)[2:1])

## bar-plot of the country power (less USA) by journal tiers
gg_ctry <- ggplot(top11_ctry_lg,aes(x=Country,y=Power,fill=Tier))+
  geom_bar(stat="identity")+
  scale_fill_manual(values=c("indianred","steelblue"))+
  labs(ylab="Power")+
  theme_classic()+
  theme(axis.title.x=element_blank(),axis.text.x=element_text(size=12,angle=45,hjust=1),axis.title.y = element_text(size=14),axis.text.y = element_text(size=12),legend.text = element_text(size=12),legend.position =c(.8,.9),legend.title = element_blank())

gg_ctry

ggsave("PowerRank_Top10_Countries_LessUSA_Color.png",gg_ctry,width=6.5,height=4.5)



#######################################
# -2- generate the geodiversity plots #
#######################################

# editor and author standard distances (degrees) by journal field and IF
gg_scatter <- ggplot(journals_dt,aes(x=StDist_deg_Editors,y=StDist_deg_Authors,size=IF))+
  geom_abline(aes(intercept=0,slope=1),size=.5,color="gray30",linetype=2)+
  geom_point(aes(shape=Field,color=Field),alpha=.75,fill="gray90",na.rm=T)+
  geom_text_repel(aes(label=Journal_Abbr),size=3,seed=9,force=3,na.rm=T)+
  scale_shape_manual(name="Tier/Field",values=c(16,15,21,17),labels=c("Top 5","Theory","Applied","Econometrics"))+
  scale_color_manual(name="Tier/Field",values=c("indianred","steelblue","seagreen","orchid"),labels=c("Top 5","Theory","Applied","Econometrics"))+
  scale_size_continuous(range=c(1,6),breaks=c(1,3,5,10))+
  labs(x="Standard Distance, Editors (degrees)",y="Standard Distance, Authors (degrees)",size="Impact Factor")+
  coord_cartesian(xlim=c(0,55),ylim=c(0,55))+
  scale_x_continuous(expand=c(0,0),limits=c(0,55))+
  scale_y_continuous(expand=c(0,0),limits=c(0,55))+
  guides(shape=guide_legend(override.aes=list(size=3)))+
  theme_classic()+
  theme(axis.title = element_text(size=12),axis.text = element_text(size=10),legend.title = element_text(size=11),legend.text = element_text(size=9),legend.position = c(.78,.18),legend.box = "horizontal")

gg_scatter

ggsave("Editors_Authors_Scatter_Color.png",gg_scatter,width=6.5,height=5.5)

# editor standard distances (degrees) and journal age by journal field and IF
gg_journaldist <- ggplot(journals_dt,aes(x=StDist_deg_Editors,y=Age,size=IF))+
  geom_point(aes(shape=Field,color=Field),alpha=.75,fill="gray90",na.rm=T)+
  scale_shape_manual(name="Tier/Field",values=c(16,15,21,17),labels=c("Top 5","Theory","Applied","Econometrics"))+
  scale_color_manual(name="Tier/Field",values=c("indianred","steelblue","seagreen","orchid"),labels=c("Top 5","Theory","Applied","Econometrics"))+
  scale_size_continuous(range=c(1,6),breaks=c(1,3,5,10))+
  geom_text_repel(aes(label=Journal_Abbr),size=3,seed=9,force=3,na.rm=T)+
  coord_cartesian(xlim=c(0,55),ylim=c(0,145))+
  scale_x_continuous(expand=c(0,0),limits=c(0,55))+
  scale_y_continuous(expand=c(0,0),limits=c(0,145))+
  labs(x="Standard Distance, Editors (degrees)",y="Journal Age (years)",size="Impact Factor")+
  guides(shape=guide_legend(override.aes=list(size=3)))+
  theme_classic()+
  theme(axis.title = element_text(size=12),axis.text = element_text(size=10),legend.title = element_text(size=11),legend.text = element_text(size=9),legend.spacing.y=unit(0.1,'cm'),legend.position = c(.88,.68))

gg_journaldist

ggsave("Editors_Age_Scatter_Color.png",gg_journaldist,width=6.5,height=5.5)


# plot densities of editor standard distances (degrees) by journal field
gg_journaldense <- ggplot(journals_dt,aes(x=StDist_deg_Editors,linetype=Field,color=Field))+
  stat_density(geom="line",position="identity",bw=3,size=1)+
  scale_linetype_manual(name="Tier/Field",values=c(1400,1401,1402,1403),labels=c("Top 5","Theory","Applied","Econometrics"))+
  scale_color_manual(name="Tier/Field",values=c("indianred","steelblue","seagreen","orchid"),labels=c("Top 5","Theory","Applied","Econometrics"))+
  coord_cartesian(xlim=c(0,60))+
  labs(x="Standard Distance, Editors (degrees)",y="Density")+
  theme_classic()+
  theme(axis.title = element_text(size=14),axis.text = element_text(size=12),legend.title = element_blank(),legend.text = element_text(size=12),legend.position = c(.85,.85))

gg_journaldense

ggsave("Editors_Density_Color.png",gg_journaldense,width=6.5,height=4.5)
