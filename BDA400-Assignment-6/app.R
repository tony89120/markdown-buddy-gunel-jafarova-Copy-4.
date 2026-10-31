# BDA400 A06 — Gunel Jafarova (664430131)
# R Shiny dashboard. Install shiny, ggplot2 and quantmod before running.
library(shiny)
library(ggplot2)
library(quantmod)
ui <- fluidPage(
 titlePanel("Portfolio Technical Analysis Dashboard"),
 p("Gunel Jafarova | BDA400 Assignment 6 | 664430131"),
 sidebarLayout(
  sidebarPanel(
   textInput("symbol","Yahoo Finance ticker","AAPL"),
   dateRangeInput("dates","Date range",start="2023-01-01",end=Sys.Date()),
   selectInput("frequency","Time frame",c("Daily","Weekly","Monthly")),
   selectInput("chart_type","Price chart",c("Line","Area","Candlestick")),
   checkboxGroupInput("indicators","Technical indicators",c("Moving Averages"="MA","RSI"="RSI","MACD"="MACD"),selected=c("MA","RSI","MACD")),
   numericInput("fast","Fast SMA period",20,min=2),
   numericInput("slow","Slow SMA period",50,min=3),
   checkboxInput("signals","Show Buy/Sell markers",TRUE),
   actionButton("refresh","Refresh Yahoo Finance data"),
   helpText("Buy: fast SMA crosses above slow SMA. Sell: crosses below. Otherwise Hold.")
  ),
  mainPanel(
   fluidRow(column(4,wellPanel(strong("Last close"),textOutput("last_price"))),
            column(4,wellPanel(strong("Latest signal"),textOutput("last_signal"))),
            column(4,wellPanel(strong("Bars"),textOutput("n_obs")))),
   plotOutput("price_plot",height="430px"),
   conditionalPanel("input.indicators.indexOf('RSI') !== -1",plotOutput("rsi_plot",height="200px")),
   conditionalPanel("input.indicators.indexOf('MACD') !== -1",plotOutput("macd_plot",height="220px")),
   h4("Recent crossover events"),tableOutput("signal_table")
  )
 )
)
server <- function(input,output,session) {
 raw <- reactive({
  input$refresh
  ticker <- toupper(trimws(input$symbol))
  validate(need(grepl("^[A-Z0-9.^=-]{1,20}$",ticker),"Invalid ticker"))
  validate(need(length(input$dates)==2 && input$dates[1]<input$dates[2],"Select a valid date range"))
  tryCatch({
   x <- suppressWarnings(getSymbols(ticker,src="yahoo",from=as.Date(input$dates[1]),
                                    to=as.Date(input$dates[2])+1,auto.assign=FALSE))
   validate(need(NROW(x)>0,"No stock observations returned"))
   x
  },error=function(e) validate(need(FALSE,paste("Yahoo Finance error:",conditionMessage(e)))))
 })
 prices <- reactive({
  x <- raw()
  if(input$frequency=="Weekly") x <- to.weekly(x,indexAt="lastof",name=NULL)
  if(input$frequency=="Monthly") x <- to.monthly(x,indexAt="lastof",name=NULL)
  data.frame(Date=as.Date(index(x)),Open=as.numeric(Op(x)),High=as.numeric(Hi(x)),
             Low=as.numeric(Lo(x)),Close=as.numeric(Cl(x)))
 })
 analysed <- reactive({
  d <- prices(); f <- as.integer(input$fast); s <- as.integer(input$slow)
  validate(need(is.finite(f)&&is.finite(s)&&f>=2&&s>f,"Slow SMA must exceed fast SMA"))
  validate(need(nrow(d)>=s+2,paste("Need at least",s+2,"bars; extend range or reduce periods")))
  d$Fast <- as.numeric(SMA(d$Close,n=f));d$Slow <- as.numeric(SMA(d$Close,n=s))
  d$RSI <- as.numeric(RSI(d$Close,n=14))
  m <- MACD(d$Close,nFast=12,nSlow=26,nSig=9,maType="EMA")
  d$MACD <- as.numeric(m[,1]);d$MACDSignal <- as.numeric(m[,2])
  d$Histogram <- d$MACD-d$MACDSignal
  pf <- c(NA_real_,head(d$Fast,-1));ps <- c(NA_real_,head(d$Slow,-1))
  buy <- !is.na(pf)&!is.na(ps)&!is.na(d$Fast)&!is.na(d$Slow)&pf<=ps&d$Fast>d$Slow
  sell <- !is.na(pf)&!is.na(ps)&!is.na(d$Fast)&!is.na(d$Slow)&pf>=ps&d$Fast<d$Slow
  d$Signal <- ifelse(buy,"Buy",ifelse(sell,"Sell","Hold"))
  d
 })
 output$last_price <- renderText({sprintf("$%.2f",tail(analysed()$Close,1))})
 output$last_signal <- renderText({tail(analysed()$Signal,1)})
 output$n_obs <- renderText({nrow(analysed())})
 output$price_plot <- renderPlot({
  d <- analysed()
  p <- ggplot(d,aes(x=Date))+labs(title=paste(toupper(input$symbol),"stock prices"),x=NULL,y="USD")+theme_minimal()
  if(input$chart_type=="Line") p <- p+geom_line(aes(y=Close),color="#245d91")
  if(input$chart_type=="Area") p <- p+geom_area(aes(y=Close),fill="#b4d3ec",alpha=.7)+geom_line(aes(y=Close),color="#245d91")
  if(input$chart_type=="Candlestick") {
   d$Up <- d$Close>=d$Open
   p <- p+geom_linerange(aes(ymin=Low,ymax=High),color="#526276")+
     geom_rect(data=d,aes(xmin=Date-.35,xmax=Date+.35,ymin=pmin(Open,Close),ymax=pmax(Open,Close),fill=Up),color="#445",linewidth=.2)+
     scale_fill_manual(values=c("TRUE"="#3ba780","FALSE"="#d76e71"),guide="none")
  }
  if("MA"%in%input$indicators) p <- p+
    geom_line(aes(y=Fast,color="Fast SMA"),na.rm=TRUE)+geom_line(aes(y=Slow,color="Slow SMA"),na.rm=TRUE)+
    scale_color_manual(values=c("Fast SMA"="#d58b1d","Slow SMA"="#7954a3"),name="MA overlays")
  if(isTRUE(input$signals)) {
   marks <- d[d$Signal!="Hold",,drop=FALSE]
   if(nrow(marks)>0) p <- p+
     geom_point(data=marks,aes(y=Close,shape=Signal),size=3,color="#bd4141")+
     geom_text(data=marks,aes(y=Close,label=Signal),vjust=-1,size=3,check_overlap=TRUE)+
     scale_shape_manual(values=c(Buy=24,Sell=25))
  }
  p
 })
 output$rsi_plot <- renderPlot({
  d<-analysed()
  ggplot(d,aes(Date,RSI))+geom_hline(yintercept=c(30,70),linetype="dashed",color="gray")+
   geom_line(color="#7954a3",na.rm=TRUE)+coord_cartesian(ylim=c(0,100))+
   labs(title="RSI (14)",x=NULL,y="RSI")+theme_minimal()
 })
 output$macd_plot <- renderPlot({
  d<-analysed()
  ggplot(d,aes(Date))+geom_col(aes(y=Histogram),fill="#c2d3e5",na.rm=TRUE)+
   geom_line(aes(y=MACD,color="MACD"),na.rm=TRUE)+
   geom_line(aes(y=MACDSignal,color="Signal"),na.rm=TRUE)+
   scale_color_manual(values=c(MACD="#245d91",Signal="#d58b1d"))+
   labs(title="MACD (12,26,9)",x="Date",y="MACD")+theme_minimal()
 })
 output$signal_table <- renderTable({
  d<-analysed();d<-d[d$Signal!="Hold",c("Date","Close","Signal"),drop=FALSE]
  if(!nrow(d)) return(data.frame(Message="No crossover events in selected period"))
  tail(d,10)
 },digits=2)
}
shinyApp(ui,server)
