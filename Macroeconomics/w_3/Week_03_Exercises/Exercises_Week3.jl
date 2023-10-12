### A Pluto.jl notebook ###
# v0.19.27

using Markdown
using InteractiveUtils

# This Pluto notebook uses @bind for interactivity. When running this notebook outside of Pluto, the following 'mock version' of @bind gives bound variables a default value (instead of an error).
macro bind(def, element)
    quote
        local iv = try Base.loaded_modules[Base.PkgId(Base.UUID("6e696c72-6542-2067-7265-42206c756150"), "AbstractPlutoDingetjes")].Bonds.initial_value catch; b -> missing; end
        local el = $(esc(element))
        global $(esc(def)) = Core.applicable(Base.get, el) ? Base.get(el) : iv(el)
        el
    end
end

# ╔═╡ 01b087aa-0d7c-455d-816d-3b87fabc6ac2
begin
	using PlotlyBase, HypertextLiteral, PlutoUI , PlutoPlotly
	using CSV, DataFrames , Dates , PeriodicalDates , StatsBase , SparseArrays
	#import PlotlyJS:savefig
end

# ╔═╡ 943edb36-acc8-4b2a-94ab-c544f9eb279b
md"""
# Week 3 - Measuring Macroeconomic Activity

## Exercises

**Macroeconomics, ISCTE-IUL**
"""

# ╔═╡ 1245aef9-18ce-42f5-af82-c2e6cce70798
md"""
**Vivaldo Mendes, Ricardo Gouveia-Mendes, Luís Casinhas**

**September 2023**
"""

# ╔═╡ 8c364c56-7e98-4b46-933f-60db0572a589


# ╔═╡ 4618a663-f77e-4ccc-9b00-e84dbd5beb34
md"""
### Packages used in this notebook
"""

# ╔═╡ 74de9f66-d5b4-4e0f-a75d-5177b1842191
begin
	function Base.show(io::IO, mimetype::MIME"text/html", plt::PlotlyBase.Plot)
       # Remove responsive flag on the plot as we handle responsibity via ResizeObeserver and leaving it on makes the div flickr during updates
	hasproperty(plt,:config) && plt.config.responsive && (plt.config.responsive = false)   
	show(io,mimetype, @htl("""
			<div>
			<script id=asdf>
			const {plotly} = await import("https://cdn.plot.ly/plotly-2.2.0.min.js")
			const PLOT = this ?? document.createElement("div");
		

		
			Plotly.react(PLOT, $(HypertextLiteral.JavaScript(PlotlyBase.json(plt))));


		
			const pluto_output = currentScript.parentElement.closest('pluto-output')

			const resizeObserver = new ResizeObserver(entries => {
				Plotly.Plots.resize(PLOT)
			})

			resizeObserver.observe(pluto_output)

			invalidation.then(() => {
				resizeObserver.disconnect()
			})
		
			return PLOT
			</script>
			</div>
	"""))
	end
end

# ╔═╡ dcd13560-0f73-4aaa-b59a-b7961d8cdc63
md"""
## Exercise 1. What counts as GDP? I
"""

# ╔═╡ df9417d2-ebe1-498c-b299-f2b8fdee1084
md"""
*From the textbook "Macroeconomics" 4th Edition, by Charles I. Jones, Chapter 2*

By how much does GDP rise in each of the following
scenarios? Explain.

(a) You spend \$5,000 on college tuition this semester.

(b) You buy a used car from a friend for \$2,500.

(c) The government spends \$100 million to build a dam.

(d) Foreign graduate students work as teaching assistants at the local university and earn \$5,000 each.
"""

# ╔═╡ cec1d956-027e-445e-9b9e-db2aacfe71b1
md"""
!!! answers

	(a) ΔGDP =  5000$, spent it on a service

	(b) ΔGDP = 0$ it is used product

	(c) ΔGDP =  100 mil. $ it is new investment

	(d) ΔGDP =  5000$ per each student , it doesn't matter if student is foreign or not

"""

# ╔═╡ 17d64843-f7a2-45f7-9b32-e2978c0f1974
md"""
____________________________________________________________________________________________________________
"""

# ╔═╡ 9e05bc6e-a423-41c2-a236-41432276af88
md"""
## Exercise 2. What counts as GDP? II
"""

# ╔═╡ 72e235dd-e402-483b-9567-28fb05c364f8
md"""

*From the textbook "Macroeconomics", 4th Edition, by Charles I. Jones, Chapter 2*

By how much does GDP rise in each of the following
scenarios? Explain.

(a) A computer company buys parts from a local distributor for \$1 million, assembles the parts, and sells the resulting computers for \$2 million.

(b) A real estate agent sells a house for \$200,000 that the previous owners had bought 10 years earlier for $100,000. The agent earns a commission of \$6,000.

(c) During a recession, the government raises unemployment benefits by \$100 million.

(d) A new U.S. airline purchases and imports \$50 million worth of airplanes from the European company Airbus.

(e) A new European airline purchases \$50 million worth of airplanes from the American company Boeing.

(f) A store buys \$100,000 of chocolate from Belgium and sells it to consumers in the United States for \$125,000.
"""

# ╔═╡ 96e1035c-a937-4385-b5bd-18ee56204651
md"""
!!! answers

	(a) ΔGDP = 1mil. $ from first comapany and 1mil.$ from second comapny  OR 2mil$ as a final product of computers (both are correct)

	(b) ΔGDP = 6000$ only the agent's commission, house is not a new good

	(c) ΔGDP = 0$  

	(d) ΔGDP = 0$ for USA but 50mil.$ for country where airbus is based
		
	(e) ΔGDP = 50mil.$ for USA's GDP 

	(f) ΔGDP =  expenditure approach is it by 25000$ and because 100000$ is import, and constumption of final goods increasess by 125000$ ; porduction approach, the value added for the chocolate is 25 000$

"""

# ╔═╡ 7f063405-715a-498e-8842-ae3f06a2b058
md"""
____________________________________________________________________________________________________________
"""

# ╔═╡ adb106a5-23f6-4a1c-b4f0-2f7d26b51709
md"""
## Exercise 3. Approaches to estimate GDP
"""

# ╔═╡ 7b68feda-27a4-4ef5-8faf-698be306e3f0
md"""

Consider a simple economy where there are two goods: wheat and bread. It is known that this economy produces \$500 of wheat and \$1000 of bread, and bakers buy all the wheat for producing bread. 

(a) What approaches can be used to calculate the level of GDP in this economy?

(b) What is the total amount of sales of final goods in this economy?

(c) How much of intermediate goods are traded?

(d) What is the amount of total sales in this economy?

(e) What is the value-added produced by the bakers and by the farmers?

"""

# ╔═╡ a3668c3c-b417-4fc0-8708-5b4bdd937969
md"""
!!! answers

	(a) we can use the production and the expenditure approach

	(b) the value of total amount of sales of final good is 1000$ 

	(c) 500$ which is the value of the sale of wheat

	(d) the total amout of sales is 1500$
		
	(e) Farmers (wheat) 500$ and Bakers (bread) 500$

"""

# ╔═╡ 4e61281c-a3f0-415b-934d-3dacc3750357
md"""
____________________________________________________________________________________________________________
"""

# ╔═╡ 781d8783-f530-4859-b531-7e1495c53cc4
md"""
## Exercise 4. Pandora vs Utopia
"""

# ╔═╡ 8b753d01-766e-437b-8c45-80a8444564ca
md"""

*From the textbook* 

The inhabitants of Pandora value their natural environment (e.g., forests, springs, breathable air, etc.) twice as much as the inhabitants of Utopia. Suppose that the **value added** for all goods and services *increases by the same amount in both countries*, but has a negative effect on the environment (e.g., pollution).

(a) According to the production approach to the measurement of GDP, is this good or bad?

(b) Are both countries necessarily better off? Which country benefits more for sure?

(c) The inhabitants of Utopia are very concerned about income distribution, which is not that important for the inhabitants of Pandora. If the increase in value added results in further wealth concentration, how
will this affect your answers to part (b)?
"""

# ╔═╡ 67d77103-51d2-4915-bf45-7069fe3c996e
md"""
	!!! note 
	    Students should try to answer this question on their own.

	"""

# ╔═╡ 7bb44b4c-dca1-4425-b6b9-c88cb9cddc0d
md"""
!!! tip "Answer (a)"

	Here

"""

# ╔═╡ 387cdbcf-2537-4bd8-9c5f-2689bb1b5741
md"""
!!! tip "Answer (b)"

	Here

"""

# ╔═╡ ec7b3625-280c-4442-9bb7-5d9eab3d2728
md"""
!!! tip "Answer (c)"

	Here

"""

# ╔═╡ ac61e4b5-0082-47a6-a868-812208e35ee6
md"""
____________________________________________________________________________________________________________
"""

# ╔═╡ 97a85466-47ff-4869-ba43-a36dea571284
md"""
## Exercise 5. GDP and its shares
"""

# ╔═╡ 839c6baf-dad8-4a97-97ea-d5da508c4263
md"""
According to the Expenditure approach to measure the level of GDP, what do you think about the following sentence:

*"One of the themes in my new study, “Why the Federal Government Fails,” is that the federal government has grown too large to manage with any reasonable level of efficiency and competence. Even if politicians worked diligently to advance the general interest, and even if federal bureaucracies focused on delivering quality services, the vast size of the government would still generate failure after failure."*

by Chris Edwards, "Federal Government: Too Big to Manage", July 2015, 
[The Cato Institute](https://www.cato.org/blog/federal-government-too-big-manage)

We provide some evidence in the following plots obtained with data from FRED.
"""

# ╔═╡ a66f7887-82b2-4826-a8a2-5a95fb070b84
GDP_shares = CSV.read("GDP_shares.csv", DataFrame)

# ╔═╡ 889e4d68-9d11-4bd7-8234-991f3d3647ab
period5_1 = QuarterlyDate(1947, 1):Quarter(1):QuarterlyDate(2022, 2);

# ╔═╡ d7bce0a6-1a1b-4626-ae34-e546154dcbec
begin
	fig5_1 = Plot(Date.(period5_1), GDP_shares.CONS, Layout(title_text = "Personal consumption expenditures as a % of GDP (US)", title_x = 0.5, hovermode = "x", yaxis_title = "Percentage points", xaxis_title = "Quarterly observations"))
end


# ╔═╡ a7e5e83a-df8f-4aad-91f9-687a70de5b60
begin
	fig5_2 = Plot(Date.(period5_1), GDP_shares.GOV, marker_color = "gray", Layout(title_text = "Government consumption expenditures and gross investment as a % of GDP (US)", title_x = 0.5, hovermode = "x", yaxis_title = "Percentage points", xaxis_title = "Quarterly observations"))
end

# ╔═╡ d937a483-f279-4ceb-93c9-3d72907a8e76
md"""
!!! answer "Suggested answer"

	Here

"""

# ╔═╡ cbefa2ab-40bb-4c71-a147-00cd779259c5
md"""
____________________________________________________________________________________________________________
"""

# ╔═╡ 640dd806-873f-4868-b5a8-0db0992e113d
md"""
## Exercise 6. Income vs Product

"""

# ╔═╡ 5346e2c7-e4a6-47bf-bf64-5f6f575160e2
md"""
Using the information in Table 5.1, calculate the following macroeconomic aggregates using the income approach. Take into account that the income aggregates in the table below are net of income taxation imposed by the government (that is, their values are after-income taxation):

- (a) Total National Income (NI)

- (b) Gross National Product (GNP)

- (c) Gross Domestic Product (GDP)

 
$$\begin{aligned}
& \text {Table 5.1. Income distribution in Pandora's economy (2020)}\\
&\begin{array}{cllr}
\hline \hline \text {  } & \text { Code } & \text { Aggregates } & \text { Billions of dollars } \\
\hline  1 & ce & \text{Compensation of employees} & 6637 &  \\
2 & git & \text{Government income transfers to households} & 800 \\
3 &ri & \text{Rents and  interest} & 2500 \\
4 & rcp &\text{Retained corporate profits} & 1500 &  \\
5 & div &\text{Dividends} & 450 &  \\
6 & nfi &\text{Net factor income with the  world} & 300 &  \\
7 & pit &\text{Personal income taxes} & 2100 &  \\
8 & cit &\text{Corporate income taxes} & 700 &  \\
9 & vat &\text{VAT taxes} & 2900 &  \\
10 & dep &\text{Depreciation} & 2500 &  \\
\hline
\end{array}
\end{aligned}$$
"""

# ╔═╡ 6f960cb6-0736-41ed-9e47-5606d2ba698a
ce = 6637; git = 800; ri = 2500; rcp = 1500; div = 450;	nfi = 300; 	pit = 2100; cit = 700; vat = 2900; dep = 2500 ;   

# ╔═╡ eee8690c-8755-4a66-b1a7-799325262fed
md"""

	!!! hint

		Notice that "git" is a mere transfer of income from the government to households. For this reason, it should not be considered for the calculation of GDP by the income method (or any other method).  On the other hand, "vat" is indeed a source of funds for the government. However, "vat" is not imposed upon the **income** generated in the production process. For this reason, it can not be considered for the calculation of GDP by the income method (or any other method).

	"""

# ╔═╡ dd345eb4-a059-47fd-b014-7ede6f82e902
md"""
Use the following cells to calculate NI, GNP and GDP:
"""

# ╔═╡ f614f74c-762e-4a36-9b9f-d8d8bb2df9cd
NI=ce+ri+rcp+div+pit+cit

# ╔═╡ c4574d9d-8315-45b5-baef-d056e1cb4000
GNP= NI+dep

# ╔═╡ 47081011-0d56-4197-b357-8ffdd2711d57
GDP = GNP+nfi

# ╔═╡ e35a674f-3244-471e-806b-8615af388a21
md"""
!!! answers
		
	(a) NI = 13887

	(b) GNP = 16387

	(c) GDP = 16687

"""

# ╔═╡ 4699b6b5-8c87-4bd0-ac04-5b512b89ba5e
md"""
____________________________________________________________________________________________________________
"""

# ╔═╡ 0fb973c6-e2dc-491a-84a5-3dba2480c262
md"""
## Exercise 7. Price indexes and real GDP
"""

# ╔═╡ d884cbdb-32bc-4d97-8a31-78f87765166c
md"""
Consider an economy where only the following goods are produced:

$$\begin{array}{lcccc}
\hline \hline &  \quad \quad \quad \quad   {2004}  &  & \quad \quad \quad \quad {2005} \\
\hline & \text { Quantities } & \text { Prices } & \text { Quantities } & \text { Prices } \\
\hline \text { Computers } & 450 & 6 & 500 & 6 \\
\text { Bikes } & 900 & 4 & 800 & 5 \\
\hline \hline
\end{array}$$
"""

# ╔═╡ ed57ce50-6fed-4977-993d-dd22c8914afc
md"""
We should pass the values of our variables into the notebook:
"""

# ╔═╡ 409acc90-1d55-4720-85fd-07d9960eb985
begin
	# data for 2004     data for 2005
	Qc_04 = 450   ;   	Qc_05 = 500 			# Quantities of Computers
	Qb_04 = 900   ;   	Qb_05 = 800  			# Quantities of Bikes
	Pc_04 =   6   ;  	Pc_05 =   6  			# Price of Computers
	Pb_04 =   4   ; 	Pb_05 =   5  			# Price of Bikes
end;

# ╔═╡ ffab81a6-b645-402b-853b-b2af386b8e81
md"""
**(a)** Why have economists developed the concept of a Price Index?
"""

# ╔═╡ 6ff58637-473f-4cf2-b02c-66d90186d835
md"""
!!! tip "Answer (a)"
		
	- we need price indexes to change a nominal variable to real variable
	- we need price indexes to calculate inflation, which is the growth rate of price index

"""

# ╔═╡ 82469cc2-47e7-4ec6-8f55-c7f3d86f47b2
md"""
---
"""

# ╔═╡ 1755e765-8a3a-4c8b-a19f-e2bd908d2f7c
md"""
**b)** Calculate the value of nominal GDP for 2004 and 2005. Between these two years, how much did nominal GDP grow (as a percentage)?
"""

# ╔═╡ d25a5045-8089-45c7-ac80-108958f1439d
begin
	NGDP04 = Qc_04 * Pc_04 + Qb_04 * Pb_04    		# Quantities 2004 x prices 2004
	NGDP05 = Qc_05 * Pc_05 + Qb_05 * Pb_05    		# Quantities 2005 x prices 2005
	Ngr     = (NGDP05/NGDP04) - 1                	# Growth rate of nominal GDP
	Print([NGDP04 , NGDP05 , Ngr])         		# Print the values of nominal GDP and its growth rate 
end

# ╔═╡ 82faf62f-4e88-456c-ba2b-a8d0bff16e18
md"""
!!! tip "Answer (b)"

	- Nominal GDP 2004 = 6300.0

	- Nominal GDP 2005 = 7000.0

	- Growth rate of nominal GDP = 0.11111111111111116

"""

# ╔═╡ 54513b73-ed6d-4b4a-9c81-004efa584f01
md"""
---
"""

# ╔═╡ eefa994d-96b5-4ffb-b677-a91395513790
md"""
**c)** Calculate the value of real GDP using **_2004 as the base year_**. Calculate the growth rate of real GDP between 2004 and 2005.
"""

# ╔═╡ df15fe97-3132-4893-93e0-e894c347c37a
begin
	# 2004 as the base year (prices of 2004)
	RGDP04_04 = Qc_04 * Pc_04 + Qb_04 * Pb_04 			# Quantities 2004 x prices 2004
	RGDP05_04 = Qc_05 * Pc_04 + Qb_05 * Pb_04 			# Quantities 2005 x prices 2004
	Rgr_04   = (RGDP05_04/RGDP04_04) - 1 				# Growth rate of real GDP
	Print([RGDP04_04 , RGDP05_04 , Rgr_04]) 			# Print the values of real GDP and its growth rate 
end

# ╔═╡ 64aca5c6-f797-4a9d-9995-1fdcc77ef059
md"""
!!! tip "Answer (c)"

	- Real GDP 2004 = 6300.0

	- Real GDP 2005 = 6200.0

	- Growth rate of real GDP = -1.587%

"""

# ╔═╡ 372d7305-2f74-4fd0-9953-e852c9540fb9
md"""
---
"""

# ╔═╡ 7194f2f3-6e00-4bc6-8e9d-49e7fcf545eb
md"""
**d)** Calculate the value of real GDP using **_2005 as the base year_**. Calculate the growth rate of real GDP between 2004 and 2005.
"""

# ╔═╡ cc355268-59e0-4165-bbe9-051218168ae8
begin
	# 2005 as the base year (prices of 2005)
	RGDP04_05 = Qc_04 * Pc_05 + Qb_04 * Pb_05  			# Quantities 2004 x prices 2005
	RGDP05_05 = Qc_05 * Pc_05 + Qb_05 * Pb_05 			# Quantities 2005 x prices 2005
	Rgr_05   = (RGDP05_05/RGDP04_05) - 1 				# Growth rate of real GDP
	Print([RGDP04_05 , RGDP05_05 , Rgr_05]) 			# Print the values of real GDP and its growth rate 
end

# ╔═╡ 2546322e-d739-4152-a371-9c291ab4bfb4
md"""
!!! tip "Answer (d)"

	- Real GDP 2004 = 7200.0

	- Real GDP 2005 = 7000.0

	- Growth rate of real GDP = -2.777%

"""

# ╔═╡ 55398c96-e1c7-4d0c-bcb5-a6314985ab77
md"""
---
"""

# ╔═╡ cfa7d5b3-827b-4f57-b6f5-cc001ff33b13
md"""
**e)** Using 2004 as the base year, calculate the value of the GDP price index for both years. What was the rate of inflation in this economy between 2004 and 2005?
"""

# ╔═╡ 884c2749-df2b-4900-8591-cca66af15082
md"""
	!!! hint

		Remember that 

		$$RealGDP = NominalGDP/PriceIndex$$
	"""

# ╔═╡ 3cc3fd22-e404-4cbe-9d9f-e90a27072a9a
begin
	IP_04 = NGDP04/RGDP04_04 				# GDP Price Index for 2004
	IP_05 = NGDP05/RGDP05_04				# GDP Price Index for 2005
	gr_PI = (IP_05-IP_04)/IP_04   			# growth rate of the price index (the rate of inflation)
	Print([IP_04   IP_05  gr_PI])
end

# ╔═╡ b9ed2165-941b-4965-a33b-4adb026eedbb
md"""
!!! tip "Answer (e)"

	- GDP Price Index for 2004 = 1.0

	- GDP Price Index for 2005 = 1.129

"""

# ╔═╡ fa40cfd7-84a6-44ea-9046-8f34339dc3a0
md"""
---
"""

# ╔═╡ 569fb694-c7c9-40ec-ad99-cb5c2cee063c
md"""
**f)** If we use 2005 as the base year, would we expect to get the same real GDP growth rates and inflation rate as calculated in the case of 2004 as the base year? Why?
"""

# ╔═╡ 40679f74-0237-451e-bf1b-70ca69aa75ea
md"""
!!! tip "Answer (f)"

	Here

"""

# ╔═╡ ea76636d-06d8-40ea-b6b5-52be10f0752f
md"""
____________________________________________________________________________________________________________
"""

# ╔═╡ 53eea00b-84b6-4106-b0a0-6966d02b4230
md"""
## Exercise 8. Unemployment
"""

# ╔═╡ 9d4ef9e8-6a11-4ec8-a3ab-2d1a4168a5a2
md"""
(a) Actual unemployment is the sum of frictional, structural, and cyclical unemployment. Explain the meaning of each type of unemployment.

(b) What is "natural unemployment"?
"""

# ╔═╡ d54f57cb-d5e7-48fd-a1d8-baedde9c4f78
md"""
	!!! note 
	    Students should try to answer this question on their own.

	"""

# ╔═╡ d5f8b50e-48ea-4a83-a7fd-6344d552d979
md"""
!!! tip "Answer (a)"

	Here

"""

# ╔═╡ 8bacd80c-a576-414b-a63f-1ff8c134f80d
md"""
!!! tip "Answer (b)"

	Here

"""

# ╔═╡ 15b231f4-eb48-4ea9-89c4-3afc7872912a
md"""
____________________________________________________________________________________________________________
"""

# ╔═╡ 90774c46-4424-4489-90f1-73cb1564381b
md"""
## Exercise 9. The natural unemployment rate
"""

# ╔═╡ 2c910e16-e262-4ee8-91eb-9cfc2ab8ba82
md"""
The three figures below present the plots for the US and UK unemployment rates between 1954 and 2016. According to the "Natural Rate of Unemployment" theory, we should expect the actual unemployment rate should always be significantly above zero at any period in time due to frictional unemployment and structural unemployment. Do you consider it acceptable, as a theory, that, e.g., the UK had a natural unemployment rate equal to 11.26% in 1984.Q3? Does it look so "natural" to have an unemployment rate higher than 10% of the total labor force? Comment upon this apparent contradiction.
"""

# ╔═╡ 20b8cdab-4c63-42ff-8efa-afd78fc0e5d0
begin
	unemp = CSV.read("Unemployment_US_UK.csv", DataFrame)
	unemp2 = select(unemp, Not(:1))
end


# ╔═╡ 87d3e73f-0be5-4d30-a9c5-3649c5c25820
period_9 = QuarterlyDate(1953, 4):Quarter(1):QuarterlyDate(2016, 3);

# ╔═╡ 2c13ecfe-b545-4596-871c-2844058e473d
begin
	trace3_3 = scatter(;x = Date.(period_9), y = unemp[:,2], name = "USA", line_color = "Blue", 
						mode = "markers+lines", line_width="0.5", marker_size ="4.5")
	trace3_4 = scatter(;x = Date.(period_9), y = unemp[:,3], name = "UK", line_color = "Red", 
						mode = "markers+lines", line_width="0.5", marker_size ="4.5")

	layout3_4 = Layout(;
				title_text = "Actual unemployment rate in the USA and UK: (1954.Q4--2016.Q3)",  
				title_x = 0.5,
				hovermode = "x",
            	xaxis = attr(
                title = "Quarterly obervations",
                #tickformat = "%Y",
                #hoverformat = "%Y-Q%q",
                #tick0 = "1954/01/01",
                dtick = "M60",
        				),
        		xaxis_range = [Date.(1953), Date.(2017)],
        		yaxis_title = "Percentage points",
        		#yaxis_range=[-2, 2], 
        		titlefont_size = 16)

	fig9_1 = Plot([trace3_3 , trace3_4], layout3_4)
end

# ╔═╡ cff06464-55ea-4362-8595-0b2028bddad9
begin
	function hpfilter(unemp2::Array{Float64,1}, lambda::Float64)
    	n = length(unemp2)
    	@assert n >= 4
    	diag2 = lambda*ones(n-2)
    	diag1 = [ -2lambda; -4lambda*ones(n-3); -2lambda ]
    	diag0 = [ 1+lambda; 1+5lambda; (1+6lambda)*ones(n-4); 1+5lambda; 1+lambda ]
    	D = spdiagm(-2 => diag2, -1 => diag1, 0 => diag0, 1 => diag1, 2 => diag2)
    	D\unemp2
	end
end;

# ╔═╡ 015807a9-b434-47be-8274-3cc1027b8565
begin
	hptrend = zeros(252,2)
	for k = 1:2
    	hptrend[:,k] = hpfilter(unemp2[:,k], 1600.0)
	end
	hptrend
end;

# ╔═╡ 2594311f-928a-4508-b401-418d26731de6
begin
	#For the USA
	
	trace3_5 = scatter(;x = Date.(period_9), y = unemp2[:,1], name = "U",  line_color = "Blue", 
						mode = "markers+lines", line_width="0.5", marker_size ="4.5")
	trace3_6 = scatter(;x = Date.(period_9), y = hptrend[:,1], name = "Un", line_color = "Red", 
						mode = "markers+lines", line_width="0.5", marker_size ="4.5")

	layout3_6 = Layout(;
			title_text = "Actual vs Natural Unemployment (US)", 
				title_x = 0.5,
				hovermode = "x",
            	xaxis = attr(
                title = "Quarterly obervations",
                #tickformat = "%Y",
                #hoverformat = "%Y-Q%q",
                #tick0 = "1954/01/01",
                dtick = "M60",
        				),
        		xaxis_range = [Date.(1953), Date.(2017)],
        		yaxis_title = "Percentage points",
        		#yaxis_range=[-2, 2], 
        		titlefont_size = 16)

	fig9_2 = Plot([trace3_5 , trace3_6], layout3_6)
	
end 

# ╔═╡ b6a95d8d-a765-47f0-b818-0ba42c28e823
begin
	#For the USA
	
	trace3_7 = scatter(;x = Date.(period_9), y = unemp2[:,2], name = "U",  line_color = "Blue", 
						mode = "markers+lines", line_width="0.5", marker_size ="4.5")
	
	trace3_8 = scatter(;x = Date.(period_9), y = hptrend[:,2], name = "Un", line_color = "Red", 
						mode = "markers+lines", line_width="0.5", marker_size ="4.5")

	layout3_8 = Layout(;
				title_text = "Actual vs Natural Unemployment (UK)",  	 			  title_x = 0.5,
				hovermode = "x",
            	xaxis = attr(
                title = "Quarterly obervations",
                #tickformat = "%Y",
                #hoverformat = "%Y-Q%q",
                #tick0 = "1954/01/01",
                dtick = "M60",
        				),
        		xaxis_range = [Date.(1953), Date.(2017)],
        		yaxis_title = "Percentage points",
        		#yaxis_range=[-2, 2], 
        		titlefont_size = 16)

	fig9_3 = Plot([trace3_7 , trace3_8], layout3_8)
	
end 

# ╔═╡ 7c06e74a-92fc-449c-b0af-3997e3b66e3f
md"""
!!! answer "Suggested answer"

    Here

"""

# ╔═╡ 2ce95b19-58be-4fd9-b22a-e5a0a449a77e
md"""
____________________________________________________________________________________________________________
"""

# ╔═╡ 8c6d0a2b-cb11-4284-8ade-39543b006c45
md"""
## Exercise 10. Negative real-interest rates
"""

# ╔═╡ 779d5e72-bfdf-401b-839e-a0a65beb3646
md"""
From an economic perspective, it seems highly relevant to see if negative real-interest rates are standard behavior or just sporadic facts. From mere intuition, one would be inclined to conclude that those occurrences should be rare because such rates do not make much economic sense. Let us see what has happened in the case of the US since the early 1950s.

By definition, the real-interest rate is the difference between the nominal interest rate and the rate of inflation. It is familiar to use the Fed Funds Rate as the proxy for the nominal interest rate and compare it with the inflation rate. However, it is better to use the 3-month maturity Treasury Bills rate (3MTB) instead of the Fed Funds rate because the Fed has no control over the yields of 3MTB (they are essentially a market phenomenon).

👉 **a)** Given the figures below, what would you conclude about the frequency of negative real-interest rates? Do you consider such frequency a good or a bad signal about economic performance?

👉 **b)** With western economies currently displaying a poor performance in economic growth and with such negative real-interest rates, do you consider it risky for governments to borrow to finance investment in infrastructure, health, and education?
"""

# ╔═╡ 81917d80-2fe4-40e6-ad99-61e4838ba781
RIR = CSV.read("Real_InterRate.csv", DataFrame)

# ╔═╡ 098bbd80-8f34-4420-bbde-124258366032
period10_1 = MonthlyDate(1950,1):Month(1):MonthlyDate(2022,7);

# ╔═╡ 53db2a25-d9a9-4c43-b739-b622e07707c7
begin
	fig10_1=Plot(Date.(period10_1), [RIR.CPI RIR[:,2]])
	restyle!(fig10_1, 1:2, name = ["CPI", ""]) # names Germany and Portugal on variables 1 and 2
	
	relayout!(fig10_1, Layout(title_text = "3-Month Treasury Bills rate vs CPI rate: US (1950.M1--2022.M4)", title_x = 0.5, hovermode = "x", yaxis_title = "Percentage points", xaxis_title = "Monthly observations")) # introduces a title, y-axis label, and the hover-mode
	
	fig10_1 # Updates the plot
end

# ╔═╡ ce601515-f87c-4641-90bb-d63a6902d27f
begin
	
	trace10_1 = bar(;x = Date.(period10_1), y = RIR[:,2]-RIR[:,3], marker=attr(color="Darkblue", opacity=1))

	layout10_1 = Layout(;
				title_text = "Real Interest Rate: US (1950.M1--2022.M4)", 
				title_x = 0.5,
				hovermode = "x",
            	xaxis = attr(
                title = "Monthly obervations",
                #tickformat = "%Y",
                #hoverformat = "%Y-Q%q",
                #tick0 = "1960/01/01",
                #dtick = "M120",
        				),
        		#xaxis_range = [1960, 2020],
        		yaxis_title = "Percentage points",
        		#yaxis_range=[-2, 2], 
        		titlefont_size = 16)

	fig10_2 = Plot([trace10_1], layout10_1)
	
end

# ╔═╡ 5c9256d8-7db9-4a3a-874a-54be3e2f7e84
md"""
!!! answer "Suggested answer (a)"

	Here

"""

# ╔═╡ 797eace8-0095-4df3-964e-6384bb30bc8b
md"""
!!! answer "Suggested answer (b)"

	Here 

"""

# ╔═╡ 03d1583c-1f61-470c-99b3-9d5ca071fa66
md"""
The figure below was obtained from here [European Central Bank](https://www.ecb.europa.eu/stats/financial_markets_and_interest_rates/euro_area_yield_curves/html/index.en.html)
"""

# ╔═╡ 21b404da-b630-4b19-8c26-b0f5ad05cf2c
Resource("https://vivaldomendes.org/images/depot/ECB_Yields2.png")

# ╔═╡ 9effedd9-8288-47fa-97d4-ca8a17866e1b
md"""
____________________________________________________________________________________________________________
"""

# ╔═╡ 56cd68b7-b242-40d4-8ee6-4836294bfbc3
md"""
## Exercise 11. Answer to (10.b) ... in the summer of 2021
"""

# ╔═╡ 2b04de6c-b157-4c9a-bf48-ec1c8b4c22c2
md"""
!!! answer "Suggested answer (b)"

	In the US, 10-Year Treasury Bills rates have moved around 1% over the last couple of years, and long-term inflation expectations are below 2%. This suggests that the scenario of maintaining very low real-interest rates is highly probable. So, as long as public borrowing is allocated to productive activities, which increases production and growth, the risk of public borrowing in the US is negligible.

	In the EuroZone, the situation is even darker. The ECB publishes the yields on long-term bonds with maturities up to 30 years. However surprising, all countries in the EZ with triple AAA public bonds (Germany, France, Netherlands, Austria, Luxembourg, and Belgium) will have to pay negative interest rates for the entire maturity period on the newly issued public debt (!!): 30 years. See link and figure below.

	Where is the danger with much-needed public infrastructure to repair and much to do about environmental issues? Negative rates for 30 years!
"""

# ╔═╡ 89e96c9a-a582-4ede-90ae-7f0723fa9dcc
md"""
The figure below was obtained from here [European Central Bank](https://www.ecb.europa.eu/stats/financial_markets_and_interest_rates/euro_area_yield_curves/html/index.en.html)
"""

# ╔═╡ a39eafa6-7412-4748-89f1-398c7f5c1c1a
Resource("http://ebs.de.iscte.pt/ECB_AAA_bonds.png", :width=>900)

# ╔═╡ 712ac759-1fea-4775-97cb-a3feed435303
md"""
____________________________________________________________________________________________________________
"""

# ╔═╡ 446aa8e7-13e3-42b3-9fbb-4c0ebeb173da
md"""
## Exercise 12. Chain-Weighted prices (not covered)
"""

# ╔═╡ c3bc75f0-032e-44b3-8b39-0c2f0a413402
md"""
##### This exercise is related to material that was not covered in our classes
"""

# ╔═╡ ff17deea-a50b-493f-89f3-8f4b545595e2
md"""
Consider the information in the following Table:

$$\begin{array}{lcccc}
\hline \hline &  \quad \quad \quad \quad   {2010}  &  & \quad \quad \quad \quad {2011} \\
\hline & \text { Quantities } & \text { Prices } & \text { Quantities } & \text { Prices } \\
\hline \text { Scooters } & 100 & 2 & 120 & 1.5 \\
\text { Cars } & 20 & 50 & 25 & 40 \\
\hline \hline
\end{array}$$
"""

# ╔═╡ b6fac239-be5b-4b99-b333-1e5023873363
qs10 = 100 ; qc10 = 20 ;

# ╔═╡ a1dbcd7f-fb3f-43a1-b89d-f6be2a2de23b
md"""
while we will use sliders below to assign the values of rest of the entries in that table: 
"""

# ╔═╡ c6f5694e-3048-4785-8fac-4f2c659b5c86
begin
	aslider = @bind ps10 Slider(0.0:0.5:4.0, default=2.0, show_value=true)
	bslider = @bind pc10 Slider(20.0:5.0:80.0, default=50.0, show_value=true)
	
	cslider = @bind qs11 Slider(100.0:5.0:140.0, default=120.0, show_value=true)
	dslider = @bind qc11 Slider(10.0:5.0:40.0, default=25.0, show_value=true)
	
	eslider = @bind ps11 Slider(0.0:0.5:3.5, default=1.5, show_value=true)
	fslider = @bind pc11 Slider(20.0:5.0:60.0, default=40.0, show_value=true)
end;

# ╔═╡ aa75c9a8-b76d-47ae-afbd-8aaf31290813
md"""
----
"""

# ╔═╡ 10cabf00-5d76-4674-96f3-7472a89f3b6f
md"""
----
"""

# ╔═╡ 7a520563-ff9b-4a15-b0d3-53715ac2258c
md"""
**a)** Calculate the value of nominal GDP for 2010 and 2011 years, and the growth rate for that period.
"""

# ╔═╡ 3f1f82c0-da35-47bb-a07c-0b6f24c62c4b
begin
	NGDP2010 = qs10 * ps10 + qc10 * pc10
	NGDP2011 = qs11 * ps11 + qc11 * pc11
	Ng   = (NGDP2011/NGDP2010)-1
	Print([NGDP2010  , NGDP2011  , Ng])
end

# ╔═╡ 838e537d-1c1c-4021-addf-82038dfbe5b7
md"""
!!! tip "Answer (a)"
		
	Nominal GDP 2010 = 1200; 

	Nominal GDP 2011 = 1180;

	Growth rate of nominal GDP= --1.66(7)%

"""

# ╔═╡ d1c2f596-dac8-4900-9bd4-8fd6303ebbff
md"""
---
"""

# ╔═╡ b2b0202d-d1b1-4ebd-8dee-58bf4fdb2da0
md"""
**b)** Calculate the level of real GDP for both years, in chained 2010 prices. What is the growth rate of real GDP in this case.
"""

# ╔═╡ 345c9b8e-56ed-4ae1-9a86-d525ed236765
md"""

!!! hint

	Firstly we have to calculate the real GDP growth rate using 2010 as the base year. Then we have to do the same, but for 2011 as the base year. Thirdly, we have to calculate the chained growth rate real GDP as a geometric average of the two previous rates. Finally, we should apply this chained real GDP growth rate to move "forward" or "backward" in calculating real GDP in chain-weighted prices.

"""

# ╔═╡ 6f50b174-5f20-475e-b64e-2783fbca239b
md"""
Step 1:
"""

# ╔═╡ 79ef1593-db6c-48a1-a439-3b6d7343c414
begin
	# 2010 as the base year
	RGDP2010_10 = qs10 * ps10 + qc10 * pc10
	RGDP2011_10 = qs11 * ps10 + qc11 * pc10
	Rg_10   = (RGDP2011_10/RGDP2010_10)-1
	Print([RGDP2010_10 , RGDP2011_10 , Rg_10])
end

# ╔═╡ 7a1451f0-c0e4-4b5d-b1f8-6f3345afdb58
md"""
!!! tip "Answer (b.2)"
		
	Real GDP 2010 (base 2010) = 1200 

	Real GDP 2011 (base 2010) = 1490

	Growth rate of real GDP (base 2010) = 24.166%

"""

# ╔═╡ 8f94d66c-8115-4b47-b8d5-723e91d56ddb
md"""
------
"""

# ╔═╡ d1b82885-70a7-4986-ba20-229e44ce8813
md"""
Step 2:
"""

# ╔═╡ aaee7709-9154-4093-af98-55228bfee2d4
begin
	# 2011 as the base year
	RGDP2010_11 = qs10 * ps11 + qc10 * pc11
	RGDP2011_11 = qs11 * ps11 + qc11 * pc11
	Rg_11   = (RGDP2011_11/RGDP2010_11)-1
	Print([RGDP2010_11 , RGDP2011_11 , Rg_11])
end

# ╔═╡ 9429853f-5bca-4c37-a770-dfefe58b3555
md"""
!!! tip "Answer (b.2)"
		
	Real GDP 2010 (base 2011) = 950 

	Real GDP 2011 (base 2011) = 1180

	Growth rate of real GDP (base 2011) = 24.21%

"""

# ╔═╡ 5406ee07-82d8-4c0b-ab7b-0250e111fdd1
md"""
Step 3:
"""

# ╔═╡ 77390e5f-02a9-4482-af56-774c0c46e781
Rc = sqrt(Rg_10 * Rg_11)

# ╔═╡ 0a7d9e59-6502-4b3d-ba63-56fdf6f525b9
md"""
!!! tip "Answer (b.3)"
		
	The chained growth rate of Real GDP is equal: Rc= 0.2418 

"""

# ╔═╡ eb968506-49e2-40fc-8a8e-824ae95e6988
md"""
Sep 4. Multiply the base year real GDP by the chained growth rate to obtain the following year real GDP:
"""

# ╔═╡ 41220b57-fa1e-4405-b7aa-376e659f52c9
begin
	#Real GDP at 2010 chain weighted prices
	RGDP2010_C10 = RGDP2010_10 					# Real GDP 2010 is equal to nominal GDP 2010
	RGDP2011_C10 = RGDP2010_10 * (1+ Rc) 		# Real GDP 2011 is obtained multiplying RGDP2010 by 1+Rc
	Print([RGDP2010_C10 , RGDP2011_C10])
end

# ╔═╡ 6829067e-0e00-4463-853e-15c05635e667
md"""
!!! tip "Answer (b.4)"
		
	Real GDP 2010 (2010 chained prices) = 1200 

	Real GDP 2011 (2010 chained prices) = 1490.263

	Growth rate of real GDP= 24.188%

"""

# ╔═╡ b4aae946-f0a4-4010-ade1-9cf076f47ca4
md"""
---
"""

# ╔═╡ 3b6c4971-7880-499b-a321-9ef3691a172f
md"""

**c)** Calculate the level of real GDP for both years, in chained 2011 prices. What is the growth rate of real GDP in this case.
"""

# ╔═╡ e5e5669a-6c81-4218-b72e-4cfe65c3c1a1
begin
	#Real GDP at 2011 chain weighted prices
	RGDP2010_C11 = RGDP2011_11/(1+ Rc) 			# Real GDP 2010 is obtained dividing RGDP2011 by 1+Rc
	RGDP2011_C11 = RGDP2011_11  				# Real GDP 2011 is equal to nominal GDP 2011
	Print([RGDP2010_C11 , RGDP2011_C11])
end

# ╔═╡ 5688f44a-4697-4087-966a-922aa2516f82
md"""
!!! tip "Answer (c)"
		
	Real GDP 2010 (2011 chained prices) = 950.157 

	Real GDP 2011 (2011 chained prices) = 1180

	Growth rate of real GDP= 24.188%   (the same as in the previous question because they are "chained" growth rates)

"""

# ╔═╡ 085833c8-4e9f-4a00-9815-2115ee1a492b
md"""
----
"""

# ╔═╡ 3650b5bc-5f6b-4b13-9e09-ab8eb560482b
md"""
**(d)** What limitations may be inputed to the construction of Price indexes?
"""

# ╔═╡ 749e8401-ce1b-45e1-88ca-a38fec6500a9
md"""
!!! answer "Answer (d)"

	For the answer, see slide 28 "Some Caution with Price Indexes"

"""

# ╔═╡ 2d7a894f-7331-4052-afc0-e4e28dd580c5
md"""
____________________________________________________________________________________________________________
"""

# ╔═╡ 47736022-aadf-4e06-9dfd-ef2033139fef
md"""
## Auxiliary cells (do not delete)
"""

# ╔═╡ a385a0ae-d2e0-4b4e-862c-e69ec5bd6843
html"""<style>
main {
    max-width: 900px;
    align-self: flex-start;
    margin-left: 100px;
}
"""


# ╔═╡ 9fa87191-7c90-4738-a45a-acd929c8bd1b
  TableOfContents()

# ╔═╡ 6f118f35-3641-4fb0-8b6c-eeb3b4ccfe23
begin
      struct TwoColumns{L, R}
    left::L
    right::R
      end
      
      function Base.show(io, mime::MIME"text/html", tc::TwoColumns)
          write(io, """<div style="display: flex;"><div style="flex: 48%;margin-right:2%;">""")
          show(io, mime, tc.left)
          write(io, """</div><div style="flex: 48%;">""")
          show(io, mime, tc.right)
          write(io, """</div></div>""")
      end
end

# ╔═╡ e7c49268-972d-45cc-8b24-33e9a06b5fa9
TwoColumns(
md"""

ps10 = $(aslider)

qs11 = $(cslider)

ps11 = $(eslider) 

""",
	
md"""

pc10 = $(bslider)   

qc11 = $(dslider)

pc11 = $(fslider) 

"""
)

# ╔═╡ 00000000-0000-0000-0000-000000000001
PLUTO_PROJECT_TOML_CONTENTS = """
[deps]
CSV = "336ed68f-0bac-5ca0-87d4-7b16caf5d00b"
DataFrames = "a93c6f00-e57d-5684-b7b6-d8193f3e46c0"
Dates = "ade2ca70-3891-5945-98fb-dc099432e06a"
HypertextLiteral = "ac1192a8-f4b3-4bfe-ba22-af5b92cd3ab2"
PeriodicalDates = "276e7ca9-e0d7-440b-97bc-a6ae82f545b1"
PlotlyBase = "a03496cd-edff-5a9b-9e67-9cda94a718b5"
PlutoPlotly = "8e989ff0-3d88-8e9f-f020-2b208a939ff0"
PlutoUI = "7f904dfe-b85e-4ff6-b463-dae2292396a8"
SparseArrays = "2f01184e-e22b-5df5-ae63-d93ebab69eaf"
StatsBase = "2913bbd2-ae8a-5f71-8c99-4fb6c76f3a91"

[compat]
CSV = "~0.10.9"
DataFrames = "~1.4.4"
HypertextLiteral = "~0.9.4"
PeriodicalDates = "~2.0.0"
PlotlyBase = "~0.8.19"
PlutoPlotly = "~0.3.9"
PlutoUI = "~0.7.49"
StatsBase = "~0.33.21"
"""

# ╔═╡ 00000000-0000-0000-0000-000000000002
PLUTO_MANIFEST_TOML_CONTENTS = """
# This file is machine-generated - editing it directly is not advised

julia_version = "1.9.3"
manifest_format = "2.0"
project_hash = "a19156b1909baf18b9bbc1f6c5c6454a1885cfcc"

[[deps.AbstractPlutoDingetjes]]
deps = ["Pkg"]
git-tree-sha1 = "91bd53c39b9cbfb5ef4b015e8b582d344532bd0a"
uuid = "6e696c72-6542-2067-7265-42206c756150"
version = "1.2.0"

[[deps.ArgTools]]
uuid = "0dad84c5-d112-42e6-8d28-ef12dabb789f"
version = "1.1.1"

[[deps.Artifacts]]
uuid = "56f22d72-fd6d-98f1-02f0-08ddc0907c33"

[[deps.Base64]]
uuid = "2a0f44e3-6c83-55bd-87e4-b1978d98bd5f"

[[deps.CSV]]
deps = ["CodecZlib", "Dates", "FilePathsBase", "InlineStrings", "Mmap", "Parsers", "PooledArrays", "PrecompileTools", "SentinelArrays", "Tables", "Unicode", "WeakRefStrings", "WorkerUtilities"]
git-tree-sha1 = "44dbf560808d49041989b8a96cae4cffbeb7966a"
uuid = "336ed68f-0bac-5ca0-87d4-7b16caf5d00b"
version = "0.10.11"

[[deps.CodecZlib]]
deps = ["TranscodingStreams", "Zlib_jll"]
git-tree-sha1 = "02aa26a4cf76381be7f66e020a3eddeb27b0a092"
uuid = "944b1d66-785c-5afd-91f1-9de20f533193"
version = "0.7.2"

[[deps.ColorSchemes]]
deps = ["ColorTypes", "ColorVectorSpace", "Colors", "FixedPointNumbers", "PrecompileTools", "Random"]
git-tree-sha1 = "d9a8f86737b665e15a9641ecbac64deef9ce6724"
uuid = "35d6a980-a343-548e-a6ea-1d62b119f2f4"
version = "3.23.0"

[[deps.ColorTypes]]
deps = ["FixedPointNumbers", "Random"]
git-tree-sha1 = "eb7f0f8307f71fac7c606984ea5fb2817275d6e4"
uuid = "3da002f7-5984-5a60-b8a6-cbb66c0b333f"
version = "0.11.4"

[[deps.ColorVectorSpace]]
deps = ["ColorTypes", "FixedPointNumbers", "LinearAlgebra", "Requires", "Statistics", "TensorCore"]
git-tree-sha1 = "a1f44953f2382ebb937d60dafbe2deea4bd23249"
uuid = "c3611d14-8923-5661-9e6a-0046d554d3a4"
version = "0.10.0"

    [deps.ColorVectorSpace.extensions]
    SpecialFunctionsExt = "SpecialFunctions"

    [deps.ColorVectorSpace.weakdeps]
    SpecialFunctions = "276daf66-3868-5448-9aa4-cd146d93841b"

[[deps.Colors]]
deps = ["ColorTypes", "FixedPointNumbers", "Reexport"]
git-tree-sha1 = "fc08e5930ee9a4e03f84bfb5211cb54e7769758a"
uuid = "5ae59095-9a9b-59fe-a467-6f913c188581"
version = "0.12.10"

[[deps.Compat]]
deps = ["UUIDs"]
git-tree-sha1 = "e460f044ca8b99be31d35fe54fc33a5c33dd8ed7"
uuid = "34da2185-b29b-5c13-b0c7-acf172513d20"
version = "4.9.0"
weakdeps = ["Dates", "LinearAlgebra"]

    [deps.Compat.extensions]
    CompatLinearAlgebraExt = "LinearAlgebra"

[[deps.CompilerSupportLibraries_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "e66e0078-7015-5450-92f7-15fbd957f2ae"
version = "1.0.5+0"

[[deps.Crayons]]
git-tree-sha1 = "249fe38abf76d48563e2f4556bebd215aa317e15"
uuid = "a8cc5b0e-0ffa-5ad4-8c14-923d3ee1735f"
version = "4.1.1"

[[deps.DataAPI]]
git-tree-sha1 = "8da84edb865b0b5b0100c0666a9bc9a0b71c553c"
uuid = "9a962f9c-6df0-11e9-0e5d-c546b8b5ee8a"
version = "1.15.0"

[[deps.DataFrames]]
deps = ["Compat", "DataAPI", "Future", "InvertedIndices", "IteratorInterfaceExtensions", "LinearAlgebra", "Markdown", "Missings", "PooledArrays", "PrettyTables", "Printf", "REPL", "Random", "Reexport", "SnoopPrecompile", "SortingAlgorithms", "Statistics", "TableTraits", "Tables", "Unicode"]
git-tree-sha1 = "d4f69885afa5e6149d0cab3818491565cf41446d"
uuid = "a93c6f00-e57d-5684-b7b6-d8193f3e46c0"
version = "1.4.4"

[[deps.DataStructures]]
deps = ["Compat", "InteractiveUtils", "OrderedCollections"]
git-tree-sha1 = "3dbd312d370723b6bb43ba9d02fc36abade4518d"
uuid = "864edb3b-99cc-5e75-8d2d-829cb0a9cfe8"
version = "0.18.15"

[[deps.DataValueInterfaces]]
git-tree-sha1 = "bfc1187b79289637fa0ef6d4436ebdfe6905cbd6"
uuid = "e2d170a0-9d28-54be-80f0-106bbe20a464"
version = "1.0.0"

[[deps.Dates]]
deps = ["Printf"]
uuid = "ade2ca70-3891-5945-98fb-dc099432e06a"

[[deps.DelimitedFiles]]
deps = ["Mmap"]
git-tree-sha1 = "9e2f36d3c96a820c678f2f1f1782582fcf685bae"
uuid = "8bb1440f-4735-579b-a4ab-409b98df4dab"
version = "1.9.1"

[[deps.DocStringExtensions]]
deps = ["LibGit2"]
git-tree-sha1 = "2fb1e02f2b635d0845df5d7c167fec4dd739b00d"
uuid = "ffbed154-4ef7-542d-bbb7-c09d3a79fcae"
version = "0.9.3"

[[deps.Downloads]]
deps = ["ArgTools", "FileWatching", "LibCURL", "NetworkOptions"]
uuid = "f43a241f-c20a-4ad4-852c-f6b1247861c6"
version = "1.6.0"

[[deps.FilePathsBase]]
deps = ["Compat", "Dates", "Mmap", "Printf", "Test", "UUIDs"]
git-tree-sha1 = "e27c4ebe80e8699540f2d6c805cc12203b614f12"
uuid = "48062228-2e41-5def-b9a4-89aafe57970f"
version = "0.9.20"

[[deps.FileWatching]]
uuid = "7b1f6079-737a-58dc-b8bc-7a2ca5c1b5ee"

[[deps.FixedPointNumbers]]
deps = ["Statistics"]
git-tree-sha1 = "335bfdceacc84c5cdf16aadc768aa5ddfc5383cc"
uuid = "53c48c17-4a7d-5ca2-90c5-79b7896eea93"
version = "0.8.4"

[[deps.Future]]
deps = ["Random"]
uuid = "9fa8497b-333b-5362-9e8d-4d0656e87820"

[[deps.Hyperscript]]
deps = ["Test"]
git-tree-sha1 = "8d511d5b81240fc8e6802386302675bdf47737b9"
uuid = "47d2ed2b-36de-50cf-bf87-49c2cf4b8b91"
version = "0.0.4"

[[deps.HypertextLiteral]]
deps = ["Tricks"]
git-tree-sha1 = "c47c5fa4c5308f27ccaac35504858d8914e102f9"
uuid = "ac1192a8-f4b3-4bfe-ba22-af5b92cd3ab2"
version = "0.9.4"

[[deps.IOCapture]]
deps = ["Logging", "Random"]
git-tree-sha1 = "d75853a0bdbfb1ac815478bacd89cd27b550ace6"
uuid = "b5f81e59-6552-4d32-b1f0-c071b021bf89"
version = "0.2.3"

[[deps.InlineStrings]]
deps = ["Parsers"]
git-tree-sha1 = "9cc2baf75c6d09f9da536ddf58eb2f29dedaf461"
uuid = "842dd82b-1e85-43dc-bf29-5d0ee9dffc48"
version = "1.4.0"

[[deps.InteractiveUtils]]
deps = ["Markdown"]
uuid = "b77e0a4c-d291-57a0-90e8-8db25a27a240"

[[deps.InvertedIndices]]
git-tree-sha1 = "0dc7b50b8d436461be01300fd8cd45aa0274b038"
uuid = "41ab1584-1d38-5bbf-9106-f11c6c58b48f"
version = "1.3.0"

[[deps.IrrationalConstants]]
git-tree-sha1 = "630b497eafcc20001bba38a4651b327dcfc491d2"
uuid = "92d709cd-6900-40b7-9082-c6be49f344b6"
version = "0.2.2"

[[deps.IteratorInterfaceExtensions]]
git-tree-sha1 = "a3f24677c21f5bbe9d2a714f95dcd58337fb2856"
uuid = "82899510-4779-5014-852e-03e436cf321d"
version = "1.0.0"

[[deps.JSON]]
deps = ["Dates", "Mmap", "Parsers", "Unicode"]
git-tree-sha1 = "31e996f0a15c7b280ba9f76636b3ff9e2ae58c9a"
uuid = "682c06a0-de6a-54ab-a142-c8b1cf79cde6"
version = "0.21.4"

[[deps.LaTeXStrings]]
git-tree-sha1 = "f2355693d6778a178ade15952b7ac47a4ff97996"
uuid = "b964fa9f-0449-5b57-a5c2-d3ea65f4040f"
version = "1.3.0"

[[deps.LibCURL]]
deps = ["LibCURL_jll", "MozillaCACerts_jll"]
uuid = "b27032c2-a3e7-50c8-80cd-2d36dbcbfd21"
version = "0.6.3"

[[deps.LibCURL_jll]]
deps = ["Artifacts", "LibSSH2_jll", "Libdl", "MbedTLS_jll", "Zlib_jll", "nghttp2_jll"]
uuid = "deac9b47-8bc7-5906-a0fe-35ac56dc84c0"
version = "7.84.0+0"

[[deps.LibGit2]]
deps = ["Base64", "NetworkOptions", "Printf", "SHA"]
uuid = "76f85450-5226-5b5a-8eaa-529ad045b433"

[[deps.LibSSH2_jll]]
deps = ["Artifacts", "Libdl", "MbedTLS_jll"]
uuid = "29816b5a-b9ab-546f-933c-edad1886dfa8"
version = "1.10.2+0"

[[deps.Libdl]]
uuid = "8f399da3-3557-5675-b5ff-fb832c97cbdb"

[[deps.LinearAlgebra]]
deps = ["Libdl", "OpenBLAS_jll", "libblastrampoline_jll"]
uuid = "37e2e46d-f89d-539d-b4ee-838fcccc9c8e"

[[deps.LogExpFunctions]]
deps = ["DocStringExtensions", "IrrationalConstants", "LinearAlgebra"]
git-tree-sha1 = "7d6dd4e9212aebaeed356de34ccf262a3cd415aa"
uuid = "2ab3a3ac-af41-5b50-aa03-7779005ae688"
version = "0.3.26"

    [deps.LogExpFunctions.extensions]
    LogExpFunctionsChainRulesCoreExt = "ChainRulesCore"
    LogExpFunctionsChangesOfVariablesExt = "ChangesOfVariables"
    LogExpFunctionsInverseFunctionsExt = "InverseFunctions"

    [deps.LogExpFunctions.weakdeps]
    ChainRulesCore = "d360d2e6-b24c-11e9-a2a3-2a2ae2dbcce4"
    ChangesOfVariables = "9e997f8a-9a97-42d5-a9f1-ce6bfc15e2c0"
    InverseFunctions = "3587e190-3f89-42d0-90ee-14403ec27112"

[[deps.Logging]]
uuid = "56ddb016-857b-54e1-b83d-db4d58db5568"

[[deps.MIMEs]]
git-tree-sha1 = "65f28ad4b594aebe22157d6fac869786a255b7eb"
uuid = "6c6e2e6c-3030-632d-7369-2d6c69616d65"
version = "0.1.4"

[[deps.Markdown]]
deps = ["Base64"]
uuid = "d6f4376e-aef5-505a-96c1-9c027394607a"

[[deps.MbedTLS_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "c8ffd9c3-330d-5841-b78e-0817d7145fa1"
version = "2.28.2+0"

[[deps.Missings]]
deps = ["DataAPI"]
git-tree-sha1 = "f66bdc5de519e8f8ae43bdc598782d35a25b1272"
uuid = "e1d29d7a-bbdc-5cf2-9ac0-f12de2c33e28"
version = "1.1.0"

[[deps.Mmap]]
uuid = "a63ad114-7e13-5084-954f-fe012c677804"

[[deps.MozillaCACerts_jll]]
uuid = "14a3606d-f60d-562e-9121-12d972cd8159"
version = "2022.10.11"

[[deps.NetworkOptions]]
uuid = "ca575930-c2e3-43a9-ace4-1e988b2c1908"
version = "1.2.0"

[[deps.OpenBLAS_jll]]
deps = ["Artifacts", "CompilerSupportLibraries_jll", "Libdl"]
uuid = "4536629a-c528-5b80-bd46-f80d51c5b363"
version = "0.3.21+4"

[[deps.OrderedCollections]]
git-tree-sha1 = "2e73fe17cac3c62ad1aebe70d44c963c3cfdc3e3"
uuid = "bac558e1-5e72-5ebc-8fee-abe8a469f55d"
version = "1.6.2"

[[deps.PackageExtensionCompat]]
git-tree-sha1 = "f9b1e033c2b1205cf30fd119f4e50881316c1923"
uuid = "65ce6f38-6b18-4e1d-a461-8949797d7930"
version = "1.0.1"
weakdeps = ["Requires", "TOML"]

[[deps.Parameters]]
deps = ["OrderedCollections", "UnPack"]
git-tree-sha1 = "34c0e9ad262e5f7fc75b10a9952ca7692cfc5fbe"
uuid = "d96e819e-fc66-5662-9728-84c9c7592b0a"
version = "0.12.3"

[[deps.Parsers]]
deps = ["Dates", "PrecompileTools", "UUIDs"]
git-tree-sha1 = "716e24b21538abc91f6205fd1d8363f39b442851"
uuid = "69de0a69-1ddd-5017-9359-2bf0b02dc9f0"
version = "2.7.2"

[[deps.PeriodicalDates]]
deps = ["Dates", "Printf", "RecipesBase"]
git-tree-sha1 = "e616941f8093e50a373e7d51875143213f82eca4"
uuid = "276e7ca9-e0d7-440b-97bc-a6ae82f545b1"
version = "2.0.0"

[[deps.Pkg]]
deps = ["Artifacts", "Dates", "Downloads", "FileWatching", "LibGit2", "Libdl", "Logging", "Markdown", "Printf", "REPL", "Random", "SHA", "Serialization", "TOML", "Tar", "UUIDs", "p7zip_jll"]
uuid = "44cfe95a-1eb2-52ea-b672-e2afdf69b78f"
version = "1.9.2"

[[deps.PlotlyBase]]
deps = ["ColorSchemes", "Dates", "DelimitedFiles", "DocStringExtensions", "JSON", "LaTeXStrings", "Logging", "Parameters", "Pkg", "REPL", "Requires", "Statistics", "UUIDs"]
git-tree-sha1 = "56baf69781fc5e61607c3e46227ab17f7040ffa2"
uuid = "a03496cd-edff-5a9b-9e67-9cda94a718b5"
version = "0.8.19"

[[deps.PlutoPlotly]]
deps = ["AbstractPlutoDingetjes", "Colors", "Dates", "HypertextLiteral", "InteractiveUtils", "LaTeXStrings", "Markdown", "PackageExtensionCompat", "PlotlyBase", "PlutoUI", "Reexport"]
git-tree-sha1 = "9a77654cdb96e8c8a0f1e56a053235a739d453fe"
uuid = "8e989ff0-3d88-8e9f-f020-2b208a939ff0"
version = "0.3.9"

    [deps.PlutoPlotly.extensions]
    PlotlyKaleidoExt = "PlotlyKaleido"

    [deps.PlutoPlotly.weakdeps]
    PlotlyKaleido = "f2990250-8cf9-495f-b13a-cce12b45703c"

[[deps.PlutoUI]]
deps = ["AbstractPlutoDingetjes", "Base64", "ColorTypes", "Dates", "FixedPointNumbers", "Hyperscript", "HypertextLiteral", "IOCapture", "InteractiveUtils", "JSON", "Logging", "MIMEs", "Markdown", "Random", "Reexport", "URIs", "UUIDs"]
git-tree-sha1 = "e47cd150dbe0443c3a3651bc5b9cbd5576ab75b7"
uuid = "7f904dfe-b85e-4ff6-b463-dae2292396a8"
version = "0.7.52"

[[deps.PooledArrays]]
deps = ["DataAPI", "Future"]
git-tree-sha1 = "a6062fe4063cdafe78f4a0a81cfffb89721b30e7"
uuid = "2dfb63ee-cc39-5dd5-95bd-886bf059d720"
version = "1.4.2"

[[deps.PrecompileTools]]
deps = ["Preferences"]
git-tree-sha1 = "03b4c25b43cb84cee5c90aa9b5ea0a78fd848d2f"
uuid = "aea7be01-6a6a-4083-8856-8a6e6704d82a"
version = "1.2.0"

[[deps.Preferences]]
deps = ["TOML"]
git-tree-sha1 = "7eb1686b4f04b82f96ed7a4ea5890a4f0c7a09f1"
uuid = "21216c6a-2e73-6563-6e65-726566657250"
version = "1.4.0"

[[deps.PrettyTables]]
deps = ["Crayons", "LaTeXStrings", "Markdown", "Printf", "Reexport", "StringManipulation", "Tables"]
git-tree-sha1 = "ee094908d720185ddbdc58dbe0c1cbe35453ec7a"
uuid = "08abe8d2-0d0c-5749-adfa-8a2ac140af0d"
version = "2.2.7"

[[deps.Printf]]
deps = ["Unicode"]
uuid = "de0858da-6303-5e67-8744-51eddeeeb8d7"

[[deps.REPL]]
deps = ["InteractiveUtils", "Markdown", "Sockets", "Unicode"]
uuid = "3fa0cd96-eef1-5676-8a61-b3b8758bbffb"

[[deps.Random]]
deps = ["SHA", "Serialization"]
uuid = "9a3f8284-a2c9-5f02-9a11-845980a1fd5c"

[[deps.RecipesBase]]
deps = ["PrecompileTools"]
git-tree-sha1 = "5c3d09cc4f31f5fc6af001c250bf1278733100ff"
uuid = "3cdcf5f2-1ef4-517c-9805-6587b60abb01"
version = "1.3.4"

[[deps.Reexport]]
git-tree-sha1 = "45e428421666073eab6f2da5c9d310d99bb12f9b"
uuid = "189a3867-3050-52da-a836-e630ba90ab69"
version = "1.2.2"

[[deps.Requires]]
deps = ["UUIDs"]
git-tree-sha1 = "838a3a4188e2ded87a4f9f184b4b0d78a1e91cb7"
uuid = "ae029012-a4dd-5104-9daa-d747884805df"
version = "1.3.0"

[[deps.SHA]]
uuid = "ea8e919c-243c-51af-8825-aaa63cd721ce"
version = "0.7.0"

[[deps.SentinelArrays]]
deps = ["Dates", "Random"]
git-tree-sha1 = "04bdff0b09c65ff3e06a05e3eb7b120223da3d39"
uuid = "91c51154-3ec4-41a3-a24f-3f23e20d615c"
version = "1.4.0"

[[deps.Serialization]]
uuid = "9e88b42a-f829-5b0c-bbe9-9e923198166b"

[[deps.SnoopPrecompile]]
deps = ["Preferences"]
git-tree-sha1 = "e760a70afdcd461cf01a575947738d359234665c"
uuid = "66db9d55-30c0-4569-8b51-7e840670fc0c"
version = "1.0.3"

[[deps.Sockets]]
uuid = "6462fe0b-24de-5631-8697-dd941f90decc"

[[deps.SortingAlgorithms]]
deps = ["DataStructures"]
git-tree-sha1 = "c60ec5c62180f27efea3ba2908480f8055e17cee"
uuid = "a2af1166-a08f-5f64-846c-94a0d3cef48c"
version = "1.1.1"

[[deps.SparseArrays]]
deps = ["Libdl", "LinearAlgebra", "Random", "Serialization", "SuiteSparse_jll"]
uuid = "2f01184e-e22b-5df5-ae63-d93ebab69eaf"

[[deps.Statistics]]
deps = ["LinearAlgebra", "SparseArrays"]
uuid = "10745b16-79ce-11e8-11f9-7d13ad32a3b2"
version = "1.9.0"

[[deps.StatsAPI]]
deps = ["LinearAlgebra"]
git-tree-sha1 = "1ff449ad350c9c4cbc756624d6f8a8c3ef56d3ed"
uuid = "82ae8749-77ed-4fe6-ae5f-f523153014b0"
version = "1.7.0"

[[deps.StatsBase]]
deps = ["DataAPI", "DataStructures", "LinearAlgebra", "LogExpFunctions", "Missings", "Printf", "Random", "SortingAlgorithms", "SparseArrays", "Statistics", "StatsAPI"]
git-tree-sha1 = "d1bf48bfcc554a3761a133fe3a9bb01488e06916"
uuid = "2913bbd2-ae8a-5f71-8c99-4fb6c76f3a91"
version = "0.33.21"

[[deps.StringManipulation]]
deps = ["PrecompileTools"]
git-tree-sha1 = "501d5f98610e6b946689a1d698b170d7a23770aa"
uuid = "892a3eda-7b42-436c-8928-eab12a02cf0e"
version = "0.3.1"

[[deps.SuiteSparse_jll]]
deps = ["Artifacts", "Libdl", "Pkg", "libblastrampoline_jll"]
uuid = "bea87d4a-7f5b-5778-9afe-8cc45184846c"
version = "5.10.1+6"

[[deps.TOML]]
deps = ["Dates"]
uuid = "fa267f1f-6049-4f14-aa54-33bafae1ed76"
version = "1.0.3"

[[deps.TableTraits]]
deps = ["IteratorInterfaceExtensions"]
git-tree-sha1 = "c06b2f539df1c6efa794486abfb6ed2022561a39"
uuid = "3783bdb8-4a98-5b6b-af9a-565f29a5fe9c"
version = "1.0.1"

[[deps.Tables]]
deps = ["DataAPI", "DataValueInterfaces", "IteratorInterfaceExtensions", "LinearAlgebra", "OrderedCollections", "TableTraits", "Test"]
git-tree-sha1 = "1544b926975372da01227b382066ab70e574a3ec"
uuid = "bd369af6-aec1-5ad0-b16a-f7cc5008161c"
version = "1.10.1"

[[deps.Tar]]
deps = ["ArgTools", "SHA"]
uuid = "a4e569a6-e804-4fa4-b0f3-eef7a1d5b13e"
version = "1.10.0"

[[deps.TensorCore]]
deps = ["LinearAlgebra"]
git-tree-sha1 = "1feb45f88d133a655e001435632f019a9a1bcdb6"
uuid = "62fd8b95-f654-4bbd-a8a5-9c27f68ccd50"
version = "0.1.1"

[[deps.Test]]
deps = ["InteractiveUtils", "Logging", "Random", "Serialization"]
uuid = "8dfed614-e22c-5e08-85e1-65c5234f0b40"

[[deps.TranscodingStreams]]
deps = ["Random", "Test"]
git-tree-sha1 = "9a6ae7ed916312b41236fcef7e0af564ef934769"
uuid = "3bb67fe8-82b1-5028-8e26-92a6c54297fa"
version = "0.9.13"

[[deps.Tricks]]
git-tree-sha1 = "aadb748be58b492045b4f56166b5188aa63ce549"
uuid = "410a4b4d-49e4-4fbc-ab6d-cb71b17b3775"
version = "0.1.7"

[[deps.URIs]]
git-tree-sha1 = "b7a5e99f24892b6824a954199a45e9ffcc1c70f0"
uuid = "5c2747f8-b7ea-4ff2-ba2e-563bfd36b1d4"
version = "1.5.0"

[[deps.UUIDs]]
deps = ["Random", "SHA"]
uuid = "cf7118a7-6976-5b1a-9a39-7adc72f591a4"

[[deps.UnPack]]
git-tree-sha1 = "387c1f73762231e86e0c9c5443ce3b4a0a9a0c2b"
uuid = "3a884ed6-31ef-47d7-9d2a-63182c4928ed"
version = "1.0.2"

[[deps.Unicode]]
uuid = "4ec0a83e-493e-50e2-b9ac-8f72acf5a8f5"

[[deps.WeakRefStrings]]
deps = ["DataAPI", "InlineStrings", "Parsers"]
git-tree-sha1 = "b1be2855ed9ed8eac54e5caff2afcdb442d52c23"
uuid = "ea10d353-3f73-51f8-a26c-33c1cb351aa5"
version = "1.4.2"

[[deps.WorkerUtilities]]
git-tree-sha1 = "cd1659ba0d57b71a464a29e64dbc67cfe83d54e7"
uuid = "76eceee3-57b5-4d4a-8e66-0e911cebbf60"
version = "1.6.1"

[[deps.Zlib_jll]]
deps = ["Libdl"]
uuid = "83775a58-1f1d-513f-b197-d71354ab007a"
version = "1.2.13+0"

[[deps.libblastrampoline_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "8e850b90-86db-534c-a0d3-1478176c7d93"
version = "5.8.0+0"

[[deps.nghttp2_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "8e850ede-7688-5339-a07c-302acd2aaf8d"
version = "1.48.0+0"

[[deps.p7zip_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "3f19e933-33d8-53b3-aaab-bd5110c3b7a0"
version = "17.4.0+0"
"""

# ╔═╡ Cell order:
# ╟─943edb36-acc8-4b2a-94ab-c544f9eb279b
# ╟─1245aef9-18ce-42f5-af82-c2e6cce70798
# ╟─8c364c56-7e98-4b46-933f-60db0572a589
# ╟─4618a663-f77e-4ccc-9b00-e84dbd5beb34
# ╠═01b087aa-0d7c-455d-816d-3b87fabc6ac2
# ╟─74de9f66-d5b4-4e0f-a75d-5177b1842191
# ╟─dcd13560-0f73-4aaa-b59a-b7961d8cdc63
# ╟─df9417d2-ebe1-498c-b299-f2b8fdee1084
# ╟─cec1d956-027e-445e-9b9e-db2aacfe71b1
# ╟─17d64843-f7a2-45f7-9b32-e2978c0f1974
# ╟─9e05bc6e-a423-41c2-a236-41432276af88
# ╟─72e235dd-e402-483b-9567-28fb05c364f8
# ╟─96e1035c-a937-4385-b5bd-18ee56204651
# ╟─7f063405-715a-498e-8842-ae3f06a2b058
# ╟─adb106a5-23f6-4a1c-b4f0-2f7d26b51709
# ╟─7b68feda-27a4-4ef5-8faf-698be306e3f0
# ╠═a3668c3c-b417-4fc0-8708-5b4bdd937969
# ╟─4e61281c-a3f0-415b-934d-3dacc3750357
# ╟─781d8783-f530-4859-b531-7e1495c53cc4
# ╟─8b753d01-766e-437b-8c45-80a8444564ca
# ╟─67d77103-51d2-4915-bf45-7069fe3c996e
# ╟─7bb44b4c-dca1-4425-b6b9-c88cb9cddc0d
# ╟─387cdbcf-2537-4bd8-9c5f-2689bb1b5741
# ╟─ec7b3625-280c-4442-9bb7-5d9eab3d2728
# ╟─ac61e4b5-0082-47a6-a868-812208e35ee6
# ╟─97a85466-47ff-4869-ba43-a36dea571284
# ╟─839c6baf-dad8-4a97-97ea-d5da508c4263
# ╟─a66f7887-82b2-4826-a8a2-5a95fb070b84
# ╟─889e4d68-9d11-4bd7-8234-991f3d3647ab
# ╟─d7bce0a6-1a1b-4626-ae34-e546154dcbec
# ╟─a7e5e83a-df8f-4aad-91f9-687a70de5b60
# ╟─d937a483-f279-4ceb-93c9-3d72907a8e76
# ╟─cbefa2ab-40bb-4c71-a147-00cd779259c5
# ╟─640dd806-873f-4868-b5a8-0db0992e113d
# ╟─5346e2c7-e4a6-47bf-bf64-5f6f575160e2
# ╠═6f960cb6-0736-41ed-9e47-5606d2ba698a
# ╟─eee8690c-8755-4a66-b1a7-799325262fed
# ╟─dd345eb4-a059-47fd-b014-7ede6f82e902
# ╟─f614f74c-762e-4a36-9b9f-d8d8bb2df9cd
# ╟─c4574d9d-8315-45b5-baef-d056e1cb4000
# ╟─47081011-0d56-4197-b357-8ffdd2711d57
# ╟─e35a674f-3244-471e-806b-8615af388a21
# ╟─4699b6b5-8c87-4bd0-ac04-5b512b89ba5e
# ╟─0fb973c6-e2dc-491a-84a5-3dba2480c262
# ╟─d884cbdb-32bc-4d97-8a31-78f87765166c
# ╟─ed57ce50-6fed-4977-993d-dd22c8914afc
# ╠═409acc90-1d55-4720-85fd-07d9960eb985
# ╟─ffab81a6-b645-402b-853b-b2af386b8e81
# ╟─6ff58637-473f-4cf2-b02c-66d90186d835
# ╟─82469cc2-47e7-4ec6-8f55-c7f3d86f47b2
# ╟─1755e765-8a3a-4c8b-a19f-e2bd908d2f7c
# ╠═d25a5045-8089-45c7-ac80-108958f1439d
# ╟─82faf62f-4e88-456c-ba2b-a8d0bff16e18
# ╟─54513b73-ed6d-4b4a-9c81-004efa584f01
# ╟─eefa994d-96b5-4ffb-b677-a91395513790
# ╠═df15fe97-3132-4893-93e0-e894c347c37a
# ╟─64aca5c6-f797-4a9d-9995-1fdcc77ef059
# ╟─372d7305-2f74-4fd0-9953-e852c9540fb9
# ╟─7194f2f3-6e00-4bc6-8e9d-49e7fcf545eb
# ╠═cc355268-59e0-4165-bbe9-051218168ae8
# ╟─2546322e-d739-4152-a371-9c291ab4bfb4
# ╟─55398c96-e1c7-4d0c-bcb5-a6314985ab77
# ╟─cfa7d5b3-827b-4f57-b6f5-cc001ff33b13
# ╟─884c2749-df2b-4900-8591-cca66af15082
# ╠═3cc3fd22-e404-4cbe-9d9f-e90a27072a9a
# ╟─b9ed2165-941b-4965-a33b-4adb026eedbb
# ╟─fa40cfd7-84a6-44ea-9046-8f34339dc3a0
# ╟─569fb694-c7c9-40ec-ad99-cb5c2cee063c
# ╟─40679f74-0237-451e-bf1b-70ca69aa75ea
# ╟─ea76636d-06d8-40ea-b6b5-52be10f0752f
# ╟─53eea00b-84b6-4106-b0a0-6966d02b4230
# ╟─9d4ef9e8-6a11-4ec8-a3ab-2d1a4168a5a2
# ╟─d54f57cb-d5e7-48fd-a1d8-baedde9c4f78
# ╟─d5f8b50e-48ea-4a83-a7fd-6344d552d979
# ╟─8bacd80c-a576-414b-a63f-1ff8c134f80d
# ╟─15b231f4-eb48-4ea9-89c4-3afc7872912a
# ╟─90774c46-4424-4489-90f1-73cb1564381b
# ╟─2c910e16-e262-4ee8-91eb-9cfc2ab8ba82
# ╟─20b8cdab-4c63-42ff-8efa-afd78fc0e5d0
# ╟─87d3e73f-0be5-4d30-a9c5-3649c5c25820
# ╟─2c13ecfe-b545-4596-871c-2844058e473d
# ╟─cff06464-55ea-4362-8595-0b2028bddad9
# ╟─015807a9-b434-47be-8274-3cc1027b8565
# ╟─2594311f-928a-4508-b401-418d26731de6
# ╟─b6a95d8d-a765-47f0-b818-0ba42c28e823
# ╟─7c06e74a-92fc-449c-b0af-3997e3b66e3f
# ╟─2ce95b19-58be-4fd9-b22a-e5a0a449a77e
# ╟─8c6d0a2b-cb11-4284-8ade-39543b006c45
# ╟─779d5e72-bfdf-401b-839e-a0a65beb3646
# ╟─81917d80-2fe4-40e6-ad99-61e4838ba781
# ╟─098bbd80-8f34-4420-bbde-124258366032
# ╟─53db2a25-d9a9-4c43-b739-b622e07707c7
# ╟─ce601515-f87c-4641-90bb-d63a6902d27f
# ╟─5c9256d8-7db9-4a3a-874a-54be3e2f7e84
# ╟─797eace8-0095-4df3-964e-6384bb30bc8b
# ╟─03d1583c-1f61-470c-99b3-9d5ca071fa66
# ╟─21b404da-b630-4b19-8c26-b0f5ad05cf2c
# ╟─9effedd9-8288-47fa-97d4-ca8a17866e1b
# ╟─56cd68b7-b242-40d4-8ee6-4836294bfbc3
# ╟─2b04de6c-b157-4c9a-bf48-ec1c8b4c22c2
# ╟─89e96c9a-a582-4ede-90ae-7f0723fa9dcc
# ╟─a39eafa6-7412-4748-89f1-398c7f5c1c1a
# ╟─712ac759-1fea-4775-97cb-a3feed435303
# ╟─446aa8e7-13e3-42b3-9fbb-4c0ebeb173da
# ╟─c3bc75f0-032e-44b3-8b39-0c2f0a413402
# ╟─ff17deea-a50b-493f-89f3-8f4b545595e2
# ╠═b6fac239-be5b-4b99-b333-1e5023873363
# ╟─a1dbcd7f-fb3f-43a1-b89d-f6be2a2de23b
# ╟─c6f5694e-3048-4785-8fac-4f2c659b5c86
# ╟─e7c49268-972d-45cc-8b24-33e9a06b5fa9
# ╠═aa75c9a8-b76d-47ae-afbd-8aaf31290813
# ╟─10cabf00-5d76-4674-96f3-7472a89f3b6f
# ╟─7a520563-ff9b-4a15-b0d3-53715ac2258c
# ╠═3f1f82c0-da35-47bb-a07c-0b6f24c62c4b
# ╟─838e537d-1c1c-4021-addf-82038dfbe5b7
# ╟─d1c2f596-dac8-4900-9bd4-8fd6303ebbff
# ╟─b2b0202d-d1b1-4ebd-8dee-58bf4fdb2da0
# ╟─345c9b8e-56ed-4ae1-9a86-d525ed236765
# ╟─6f50b174-5f20-475e-b64e-2783fbca239b
# ╠═79ef1593-db6c-48a1-a439-3b6d7343c414
# ╟─7a1451f0-c0e4-4b5d-b1f8-6f3345afdb58
# ╟─8f94d66c-8115-4b47-b8d5-723e91d56ddb
# ╟─d1b82885-70a7-4986-ba20-229e44ce8813
# ╠═aaee7709-9154-4093-af98-55228bfee2d4
# ╟─9429853f-5bca-4c37-a770-dfefe58b3555
# ╟─5406ee07-82d8-4c0b-ab7b-0250e111fdd1
# ╠═77390e5f-02a9-4482-af56-774c0c46e781
# ╟─0a7d9e59-6502-4b3d-ba63-56fdf6f525b9
# ╟─eb968506-49e2-40fc-8a8e-824ae95e6988
# ╠═41220b57-fa1e-4405-b7aa-376e659f52c9
# ╟─6829067e-0e00-4463-853e-15c05635e667
# ╟─b4aae946-f0a4-4010-ade1-9cf076f47ca4
# ╟─3b6c4971-7880-499b-a321-9ef3691a172f
# ╠═e5e5669a-6c81-4218-b72e-4cfe65c3c1a1
# ╟─5688f44a-4697-4087-966a-922aa2516f82
# ╟─085833c8-4e9f-4a00-9815-2115ee1a492b
# ╟─3650b5bc-5f6b-4b13-9e09-ab8eb560482b
# ╟─749e8401-ce1b-45e1-88ca-a38fec6500a9
# ╟─2d7a894f-7331-4052-afc0-e4e28dd580c5
# ╟─47736022-aadf-4e06-9dfd-ef2033139fef
# ╟─a385a0ae-d2e0-4b4e-862c-e69ec5bd6843
# ╠═9fa87191-7c90-4738-a45a-acd929c8bd1b
# ╟─6f118f35-3641-4fb0-8b6c-eeb3b4ccfe23
# ╟─00000000-0000-0000-0000-000000000001
# ╟─00000000-0000-0000-0000-000000000002
