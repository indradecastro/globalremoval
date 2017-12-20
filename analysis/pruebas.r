waterdif <- ddply(raw, .(codigo_parcela, unidad, manejo, no_unidad), .fun=summarize, 
                  "waterdif" = initial_dung - final_dung_wet)

waterdif.cont <- waterdif[waterdif$unidad=="Cont",]
waterdif.cont$ID <- strtrim(waterdif.cont$codigo_parcela, width=5)

# significance
water.pval <- ddply(waterdif.cont, .(ID), summarize,
                    # "pval"=coefficients(summary(lm(waterdif ~ manejo)))[2,4])
                    "pval"=wilcox.test(waterdif ~ manejo)$p.value)
                    

waterdif.cont <- merge(waterdif.cont, water.pval)
waterdif.cont <- arrange(waterdif.cont, pval)
waterdif.cont$ID <- factor(waterdif.cont$ID, levels=unique(waterdif.cont$ID))

# plotting
library(ggplot2)
library(ggsignif)
white.violins <- ggplot(waterdif.cont) +
      aes(x=manejo, y=waterdif) +
      geom_violin() +
      facet_wrap(~ID, ncol=4) +
      labs(x="manejo", y="water loss", title="Evaporation in each treatment") +
      scale_y_continuous(expand = c(0,0), limits=c(0,250)) +
      geom_signif(comparisons = list(c("Int", "Ext")), map_signif_level=TRUE)

white.violins

# library(plotly)
# ggplotly(white.violins)




# comp.loss <- reshape(waterdif.cont, v.names="waterdif", idvar=c("ID", "no_unidad"), timevar="manejo",
                     # direction="wide", drop=c("codigo_parcela", "unidad"))

# names(comp.loss) <- c("no_unidad", "ID", "ext", "int")
# arrange(comp.loss, ID)







