head(d)
colnames(d)
unique(d$in_event)
unique(d$color)
sum(d$color == "Black")
nrow(d)
dens(d$intake_age)

dat <- list(
    N = nrow(d),
    days = d$days_to_event,
    adopted = ifelse( d$out_event == "Adoption" , 1 , 0 ),
    color = ifelse( d$color == "Black" , 1 , 2 )
)

sim_cats1 <- function( n = 1e3 , p = c(0.1, 0.2) ) {
    color <- sample( c(1,2) , size = n , replace = TRUE )
    days <- rgeom( n , p[color] ) + 1
    return( list( N = n , days = days , color = color , adopted = rep(1, n) ) )
}


rgeom( 10 , 0.1 ) + 1


dens(rbeta(10000, 1, 10))
