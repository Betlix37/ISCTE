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

# ╔═╡ a145e2fe-a903-11eb-160f-df7ea83fa3e6
begin
	using PlotlyBase, HypertextLiteral, PlutoUI, ColorSchemes, PlutoPlotly
	using CSV, DataFrames , Dates, PeriodicalDates
	using LinearAlgebra, NLsolve , StatsBase, SparseArrays
	#import PlotlyJS:savefig
end

# ╔═╡ 943edb36-acc8-4b2a-94ab-c544f9eb279b
md"""
# Week 2 - Introduction to Macroeconomics

## Exercises

**Macroeconomics, ISCTE-IUL**
"""

# ╔═╡ 1245aef9-18ce-42f5-af82-c2e6cce70798
md"""
**Vivaldo Mendes, Ricardo Gouveia-Mendes, Luís Casinhas**

**September 2023**
"""

# ╔═╡ b370036f-a10b-4a66-8839-29e1e95c91c0


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
## Exercise 1. Endogenous vs exogenous variables
"""

# ╔═╡ df9417d2-ebe1-498c-b299-f2b8fdee1084
md"""
*From the textbook*

Sciences other than economics also use models to explain the behavior of endogenous variables based on assumptions about the environment and changes in exogenous variables.
Suppose you have to design a model that links childhood obesity and diabetes.

a) Which one would be the exogenous variable? Which one would be the endogenous variable?

b) Can you think of other exogenous variables?
"""

# ╔═╡ cec1d956-027e-445e-9b9e-db2aacfe71b1
md"""
!!! answers

	**a.** Childhood obesity, diabetes

	**b.** Here
	
"""

# ╔═╡ 902604c3-155b-4f95-9d50-b11c133b836a
md"""
____________________________________________________________________________________________________________
"""

# ╔═╡ 9e05bc6e-a423-41c2-a236-41432276af88
md"""
## Exercise 2. Solving a macroeconomic model
"""

# ╔═╡ 5222cb8c-363c-4fbd-b9a9-ec9553d4c8ab
md"""

Slide 7 (week 2) displays a graphical representation of an artificial macroeconomic model (its figure can be found below). In this model, we know the impact each variable will have on the other variables (given by the number attached to each arrow) and we also know that **X1 = 10, X2 = 5**.

"""

# ╔═╡ 8cb0b7ad-282a-4ee4-8507-d77fe14f4f29
Resource("http://ebs.de.iscte.pt/Tikz_model.png",:width=>500)

# ╔═╡ 33898360-dfa8-4a63-b122-ad9ed71cc987
md"""
👉 a) Which ones are the endogenous variables? And Why?
"""

# ╔═╡ f1ba33fa-e242-424d-9891-51d5e4d9addd
md"""
!!! tip "Answer (a)"

	Qa - Qd

"""

# ╔═╡ 09426867-1b5e-45c0-8e88-b81832e99bc9
md"""
👉 b) Which ones are the exogenous variables? And Why?
"""

# ╔═╡ e3ff7943-d008-49f6-882d-f911da21e6d8
md"""
!!! tip "Answer (b)"

	X1, X2 

"""

# ╔═╡ 71f8374a-7f2e-41a5-a713-bfdad0309990
md"""
👉 c) What is the structure of the model?
"""

# ╔═╡ 33ec3e63-9b6e-48cb-b7dd-c98ac5878e2a
md"""
!!! tip "Answer (c)"

	- 8 parametrs 

"""

# ╔═╡ d24009b0-67e8-430d-a585-c0b88fe8d669
md"""
👉 d) What has the structure to do with the outputs and the inputs of the model?
"""

# ╔═╡ eb496df8-cb83-46bb-9f82-61108c6fd892
md"""
!!! tip "Answer (d)"

	The stucture of models (parametrs) uses exogenous variables to obtain the endgenous

"""

# ╔═╡ 3cf179b7-db29-4f93-99ee-abe2d348aa75
md"""
👉 e) Solve numerically the model represented in the figure above.
"""

# ╔═╡ 53d6dc4d-b4cc-48e3-8b6e-fb0ca690dc81
md"""
We can solve this model using Linear Algebra or the package NLsolve. The solution by Linear Algebra can be found in Exercise 10. We recommend the use of NLsolve because it is simple and more intuitive. As we will see, the syntax makes the original model and its computational counterpart exactly the same.
"""

# ╔═╡ 935f5b31-a293-46d1-ba7c-83637ce6a6b7
md"""
#### Solution using NLsolve
"""

# ╔═╡ e1117af1-2a87-44ab-adac-f99844d144e0
md"""
The model in the figure above can be written down as:

$$\begin{aligned}
Q_ b &=2 Q_{a}+8 X_{2} \\
Q_{a} &=0.1 Q_{d}-0.5 Q_{c} \\
Q_{d} &=0.5 Q_{c} \\
Q_{c} &=1.5 Q_{a}+2.5 Q_{b}+5 X_{1}
    \end{aligned}$$
"""

# ╔═╡ 525e50f7-a253-476d-99e9-fa2fe670de42
md"""
First, NLsolve requires the model to be written as a homogeneous system, which in this case looks like:


$$\begin{aligned}
&0=2 Q_a+8 X_2 -Q_b\\
&0 = 0.1 Q_{d} -0.5 Q_{c}-Q_{a} \\
&0=0.5 Q_c -Q_d\\
&0=1.5 Q_a+2.5 Q_b+5 X_1 -Q_c
\end{aligned}$$

"""

# ╔═╡ e5151b0e-8f56-487e-89f2-b27b940d3ad8
md"""
Then we have to write down our problem according to the syntax of NLsolve: 

- give a name to our problem: let us name it as _zazu_

- define the variables in our problem: v[1] , v[2] , v[3] , v[4] 

- define the equations in our problem: F[1] , F[2] , F[3] , F[4]
"""

# ╔═╡ 8a79bfda-718e-4be2-8784-9771830aee45
md"""
Finally, we should compute the solution to our problem according to the syntax of NLsolve: 

- give a name to the solution to our problem: let us name it as _solution _ zazu_

- call the NLsolve function that will solve the problem: _nlsolve_ 

- pass the problem to be solved (in this case is _zazu_), and give four initial guesses for the package to start the computation. For linear problems $[0.0 ; 0.0 ; 0.0 ; 0.0]$ always works. The number of initial guesses must equal the number of unknowns in the model.
"""

# ╔═╡ 17b52f12-1ffe-4d2b-a85c-ec39a4ab2716
md"""
!!! answer "Answer (e)"

	Therefore, the solution for the *default case* (X1=$10$, X2 =$5$) is given by:

$Q_a$ = -17.1975
$Q_b$ = 5.6051
$Q_c$ =  38.2166
$Q_d$ = 19.1083

"""

# ╔═╡ 1c645c0e-5cf2-4c88-b813-df7bdb99997f
md"""
👉 f) Using the slider associated with X2 (see below), change the value of X2 to 7.5. What happens?
"""

# ╔═╡ c68ad919-3953-434e-86eb-0c3994ec6257
md"""
!!! answer "Answer (f)"

	Here

"""

# ╔═╡ 31b69cd9-3cea-4064-9d4a-e9a154d86336
md"""
____________________________________________________________________________________________________________
"""

# ╔═╡ c7d27ed4-69b4-4e67-9dce-4323ddea4b59
md"""
## Exercise 3. Plotting real GDP
"""

# ╔═╡ 0328e243-0b07-4480-8d9d-36d321287766
md"""
Using data from the CONFERENCE BOARD, ["The  Total Economy Database"](https://www.conference-board.org/data/economydatabase/total-economy-database-productivity), we plot the levels of Real GDP for Portugal and France.

Can we get much information about these plots, as far as the performance of the two economies are concerned? Which country performed better? Which one showed more volatility in GDP?
"""

# ╔═╡ e5dad7e7-68e4-4a47-854a-4ad61ba34f7a
mydata = CSV.read("OECD_MajorAggreg.csv", DataFrame);

# ╔═╡ 52d8edb2-4ba8-4dc9-a828-f18edd740839
period2_1= 1950 : 1 : 2021;  			# Define the time period

# ╔═╡ 00c5aa04-41de-43b1-b825-421fdbf01fe9
begin
	trace2_1 = scatter(;x = period2_1, y = mydata[:,20], name = "Real GDP", line_color = "Blue")

	layout2_1 = Layout(;
					title_text = "Real GDP: Portugal (1950-2021)",
					title_x = 0.5,
					hovermode = "x",
        			xaxis_title = "Years",
        			#xaxis_range = [1960, 2020],
        			yaxis_title = "Millions of 2020 international dollars",
        			#yaxis_range=[-2, 2],
        			titlefont_size = 16)

	p2_1 = Plot([trace2_1], layout2_1)
	#savefig(p0, "Portugal_Real_GDP.pdf")
end


# ╔═╡ 4b150ec7-fddc-4d82-83e7-3032a1368833
begin
	trace2_2 = scatter(;x = period2_1, y = mydata[:,13], name = "Real GDP", line_color = "Red")

	layout2_2 = Layout(;
					title_text = "Real GDP: France (1950-2021)",
					title_x = 0.5,
					hovermode = "x",
        			xaxis_title = "Years",
        			#xaxis_range = [1960, 2020],
        			yaxis_title = "Millions of 2020 international dollars",
        			#yaxis_range=[-2, 2],
        			titlefont_size = 16)

	p2_2 = Plot([trace2_2], layout2_2)
	#savefig(p1_2, "Portugal_Real_GDP.pdf")
end

# ╔═╡ f33600d1-a1d9-41e8-b9b3-4107de25df54
md"""
!!! answer "Suggested answer"

	No

"""

# ╔═╡ de1a9561-f0c0-4046-b38b-8fae087e583e
md"""
____________________________________________________________________________________________________________
"""

# ╔═╡ 3af6b135-74d4-45f2-aa2e-aab24a5307ed
md"""
## Exercise 4. Business cycles
"""

# ╔═╡ 42f371eb-ff16-4017-8deb-e53d92e85b2e
md"""
In the various plots below, we present the following:

1. The evolution of Real GDP and Potential (Real) GDP for Portugal and France;

2. The business cycles as the percentage deviation of Real GDP from Potential GDP for Portugal, France, and the UK.

3. The coss-correlation of business cycles in the Euro Area.

Based on the information provided by these plots, answer the following questions.

"""

# ╔═╡ 6134353f-870b-44fb-83b2-a6bc02d04d8a
md"""

👉  a) By looking at the evolution of Real GDP and Potential GDP, can you spot one period where each economy was in a recession? And in an economic boom?

"""

# ╔═╡ f4dab38f-262f-421f-b3a9-a5a4759b95c8
md"""
!!! answer "Answer (a)"

	Portugal
	+  +1973
	-  -1976

"""

# ╔═╡ 9dfbe21a-6ba0-4f50-8554-67a5b9150aad
md"""
👉  The following plot displays the business cycles in Portugal, France, and the UK. What are the main points we can observe by inspecting this figure?
"""

# ╔═╡ cd9202f0-939e-4356-9560-a12540169fe2
md"""
!!! answer "Answer (b)"

	- the bussiness cycles in these 3 countries seem to be corralted
	- for the majority of time the bussiness cycle for these 3 countries seem equaly volatile, but in the 70's portugal was more volatile

"""

# ╔═╡ 560e72fe-f816-41f3-9d01-e7d0ef4a8cb4
md"""

👉 c) By looking at the correlation matrix of the business cycles in the Euro Area, which is presented below, mention three highly positively correlated countries and three with cycles that display low or no correlation at all.
"""

# ╔═╡ 1376e940-0024-42c7-8c81-bf027afc6e6a
md"""
#### What is a correlation matrix?
"""

# ╔═╡ 223b825a-4064-4c4a-b3f1-ada438f25286
md"""

- A correlation matrix plots the cross-correlation coefficients between (in our case) the cycles of a set of countries. 

- The cross-correlation coefficient is a statistical measure of the similarity of two series over time. It assumes values between $-1$ and $1$). Between the business cycles of Portugal and France, the cross-correlation is equal to 0.6879 (see cell below). This value means that if France is going into an economic boom/recession, there is a likelihood of 68.79% that Portugal will follow France. 

"""

# ╔═╡ f6d4c42c-a074-4f9b-98f5-e5f40a88e03a
md"""
Example: the cross-correlation between Portugal (country 19 in the data), and France (country 12 in the data) equal $+0.6879$.
"""

# ╔═╡ 3de00a00-fee4-4611-8a13-0c0ee6c736c2
md"""
	!!! hint

		In countries with a column with many blue entries, the cross-correlation is low or close to $0$. The more yellow it becomes, the higher the cross-correlation.

	"""

# ╔═╡ 6f6b5a36-05c9-4624-bc6a-135e5b6d7ba6
md"""
!!! answer "Answer (c)"

	- Highger correlation => France and Austria, France and Belgium, Belgium and Czech Republic
	- Lower correlation => Norway spain, norway and portugal, norway and france
	-


"""

# ╔═╡ 351f2247-485e-4850-84b6-1c03dd381bc4
md"""
____________________________________________________________________________________________________________
"""

# ╔═╡ 98ffd713-b851-4bca-8e20-99e21cd42561
md"""
## Exercise 5: The impact of business cycles
"""

# ╔═╡ a2641d70-f16c-45e2-9aa6-6a880a9c2bad
md"""
In 2007, the world economy was stroke by a financial crisis of enormous proportions. This crisis affected some countries more than others in the European Union and affected more some zones of the world economy than others. Let us see what happens for 23 economies since 2007. For that purpose, we should normalize Real GDP levels for all the 23 economies: Real GDP is set to 100 in 2007.

We apply such procedure to three groups of countries:

- The EuroZone periphery countries
- The EuroZone core countries + US, Canada, Switzerland and Japan
- South Estern Asian countries +  Australia and New Zealand

After looking at the three plots that you will find in this exercise, rank the three groups of countries according to their macroeconomic performance after the impact of the financial crisis. What is your opinion about what is happening with Greece?
"""

# ╔═╡ 5a240502-4e3d-4dae-a53b-5428c21e0237
md"""
!!! hint

	Look at how many years it took the various countries to get back to the level of real GDP they had when the crisis hit them (2007).
"""

# ╔═╡ 134a3f92-1475-4c1d-ad7d-bf00ba9291d7
md"""
!!! answer "Suggested answer"

	- Asian countries performed the best followed by european countires  + USA, Canada, Japan and a last comes the Eurozone
	- For Greece the reasons behind such a drop of could be massive debt, labor market, drop of tourism   
"""

# ╔═╡ cc592fff-c25b-4e66-960d-6b18f445c352
md"""
____________________________________________________________________________________________________________
"""

# ╔═╡ add07024-b7eb-445d-b4f4-6a6757c2ecd3
md"""
## Exercise 6. Important macroeconomic variables
"""

# ╔═╡ bfb890be-fba4-4d55-9e39-a52d40a5adad
md"""

In macroeconomics, one of the most important data types is quarterly data. It presents the data relevant to analyzing short-term variations in economic activity. We use the file "Data\_US.csv", which comprises quarterly observations for five macroeconomic variables for the USA economy, to plot the behavior of the following variables:

1. The unemployment rate
2. The inflation rate
3. The Fed Funds Rate (the interest rate set by the central bank of the USA, called the Federal Reserve Board or simply: **Fed**)
3. The Monetary Base (the quantity of money created by the Fed)
4. The M2 (the total amount of money supplied to the US economy).

"""

# ╔═╡ 3df87bac-8e0f-4a9a-8c98-69b96cee9f6c
md"""
👉 a) The following two figures plot the evolution of the rate of inflation (CPI) and the Federal Funds Rate (FFR). What important information about the relationship between these two macroeconomic variables can we get by inspecting these plots?
"""

# ╔═╡ de9f98b3-8ec8-4c25-9cff-26654b3b7d44
md"""
!!! hint

	Note that the correlation coefficient between these two variables equals $+0.712$, as we can check in the following cell.

"""

# ╔═╡ 1400248d-3455-4b89-bfb1-64addeeba799
md"""
!!! answer "Suggested answer (a)"

	- Inflation and interest rate are in positive correlation.
	- Interest rate is major inflation measure, by increasing the interest rate banks are lowering inflation

"""

# ╔═╡ c7a08720-2e79-47e0-8895-da38047b2acf
md"""
👉 b) The following two figures plot the evolution of the rate of inflation (CPI) and the unemployment rate (UR). What kind of information about the relationship between these two macroeconomic variables can we get by inspecting these plots?
"""

# ╔═╡ 43da915a-3bb0-424d-b841-221f0fd64575
md"""
!!! hint

	Note that the correlation coefficient between these two variables equals $+0.067$, as we can check in the following cell.

"""

# ╔═╡ 18ee1822-e759-4944-9a67-326bb3f3ded2
md"""
!!! answer "Suggested answer (b)"

	- With very low correlation coefficient it seems that these two series (inflation rate and unemployment rate) are not correlated

"""

# ╔═╡ 61f40209-b582-493a-bb59-07dbe12b8067
md"""
👉 c) The following two figures plot the evolution of the Monetary Base (MB) and the Money Supply (M2) in the US economy. What is striking about these plots?
"""

# ╔═╡ 721d6272-60d4-449a-bfcb-55cfc66230f0
md"""
!!! answer "Suggested answer (c)"
	-Although the monetary base increases sharply, the money supply did not change by as much
"""

# ╔═╡ 6b3b1bd8-0ef4-440b-a913-654ae02a75dd
md"""
____________________________________________________________________________________________________________
"""

# ╔═╡ 4c9e3c52-771a-4601-9dbc-0c267f432c2f
md"""
## Exercise 7. The sustainability of public debt
"""

# ╔═╡ d755c827-494d-47f1-b43b-32e20b45e97b
md"""

We will deal with the sustainability of public debt in great detail in Week 11. Until then, we will only briefly introduce the topic during the current week. It is a terribly important topic, and we call upon your basic intuition rather than knowledge. Read the following sentence, which came out in a book with the suggestive title "Sovereign Debt: A Guide for Economists and Practitioners":

"_Under normal conditions for growth and interest rates, solvency imposes public debt to be at most equal to the present value of all future primary balances. Equivalently, primary deficits must at some point be fully offset by surpluses_."

Debrun, Xavier and Ostry, Jonathan D. and Willems, Tim and Wyplosz, Charles (2019), "Public Debt Sustainability", in "Sovereign Debt: A Guide for Economists and Practitioners", Oxford University Press, available [here](https://www.imf.org/-/media/Files/News/Seminars/2018/091318SovDebt-conference/chapter-4-debt-sustainability.ashx)

"""

# ╔═╡ 279bd6a5-fdb6-4253-a99d-1dfd781fe726
md"""
---
"""

# ╔═╡ 154e4eb9-1c8d-4241-ba51-6ca649d57f54
md"""
👉 a) What do you think is the main point raised by Debrun et al. in the sentence above? Based on **your intuition**, do you agree with their main point?
"""

# ╔═╡ 49b6eac5-e635-48a5-8938-6688ad47ff5d
md"""
!!! answer "Answer (a)"

	Here

"""

# ╔═╡ 5391f561-1b1e-40c9-a333-a34bd55c82ec
md"""
👉 b)  In the following figure, we present the evolution of the federal budget of the USA from 1929 and 2020. Based on this single piece of evidence, what do you expect that has happened to this country's public debt?
"""

# ╔═╡ b6a765be-7bd6-486a-95bb-8361c1a4f818
md"""
!!! answer "Answer (b)"

	Here

"""

# ╔═╡ 2ff5976d-b8b6-43c5-b2ae-1c8855d309f1
md"""
👉 c) Assume, for now, that the sustainability of public debt depends on two main macroeconomic variables: the rate of growth of real GDP $(g)$ and the real interest rate paid on public debt $(r^d)$. A standard result in macroeconomics (that you will learn in a detailed manner in week 11) says that if $g>r^d$, the public debt will tend to decline over time and increase if the opposite occurs. Looking at the following figure, which confronts the federal budget and the public debt, what do you conclude for the period between 1947 and 1974?
"""

# ╔═╡ 2de00e18-ed34-477c-a3f8-4b67baf2b112
md"""
!!! answer "Answer (c)"

	Here

"""

# ╔═╡ 5e6d3a85-a715-4e38-a7f7-962b7bef40c3
md"""
👉 d) In the following figure, we present evidence for the US economy concerning the difference between the real GDP growth rate and the yield of 10-year issued US public debt. The mean of this difference is, for the period considered (1962-2022), close to $+0.948$. What does this number tell us about public debt sustainability in the USA?
"""

# ╔═╡ c767240a-136b-4725-8120-50d96a5c2fa8
md"""
!!! answer "Answer (d)"

	Here

"""

# ╔═╡ 4208af03-d240-4936-9851-9f124b35d738
md"""
____________________________________________________________________________________________________________
"""

# ╔═╡ 408e4904-84be-478c-a1f7-40f1e5fd4e8c
md"""
## Exercise 8. Financial frictions
"""

# ╔═╡ 57083988-9a53-45e4-bac3-8844077aeed0
md"""

One of the significant characteristics of a financial crisis is the dramatic increase in the so-called "risk premium". One indicator of such premium predominantly used is the "Moody's Baa Corporate Bond Yield Relative to Yield on 10-Year Treasury Constant Maturity". The former bond is considered the lowest-ranked safe financial investment, while the latter is the risk-free financial investment instrument. This risk premium, or spread, is also denominated as a "financial friction". This is the term used in our textbook.

Using the file "Moodys_BAA10Y.csv", we plot the evolution of such friction/spread for the USA. Comment upon what happened to this macroeconomic variable in the period between 2007--2010.

"""

# ╔═╡ da593bbf-b3f5-42f8-aca3-52115e8a7703
md"""
!!! answer "Suggested answer"

	Here

"""

# ╔═╡ 4e2541f6-dd41-49d9-a8bc-62d07ce13bbf
md"""
____________________________________________________________________________________________________________
"""

# ╔═╡ 5773b804-b89c-4254-9bbf-1759eff1f0ba
md"""
## Exercise 9. Rules vs discretion
"""

# ╔═╡ ca46c228-8321-4f79-85e0-05a2c4fc000d
md"""
*From the textbook*

"*Consider the difficult task of raising children. One of the most widely recognized challenges of this task is to properly balance rules and ad-hoc decisions. Constantly breaking rules might send the wrong message to a kid, while strictly enforcing rules every time might result in excessive punishments. The debate about the conduct of macroeconomic policy is not significantly different from this example.*"

a) Comment on the American Recovery and Reinvestment Act of 2009 (ARRA 2009). Can this Act be characterized as discretionary policy?

b) Is it possible for this set of policies to affect the incentives of financial intermediaries or other major economic agents?
"""

# ╔═╡ 2040bb61-81f9-4c16-8ba3-9ec419dbce31
md"""
!!! hint
    "The approximate cost of the [ARRA 2009] economic stimulus package was estimated to be $787 billion at the time of passage, later revised to \$831 billion between 2009 and 2019", from [Wikipedia] (https://en.wikipedia.org/wiki/American_Recovery_and_Reinvestment_Act_of_2009). In fact, given that the level of Real GDP of the US in 2008 was \$15752.3 billion, \$831 billion over ten years correspond to less than a 0.5% increase in public spending *per year*. Looking at these numbers and comparing them with what happened recently with the COVID19 relief plan (an increase of 6 trillion dollars in two years), the numbers of the ARRA 2009 stimulus package look ridiculously irrelevant.
"""

# ╔═╡ 5b1860bb-30e7-485d-b643-30222c8f4ce0
md"""
!!! answer "Suggested answer (a)"

	Here

"""

# ╔═╡ febd8e59-417f-4190-9814-9115abef99f9
md"""
!!! answer "Suggested answer (b)"

	Here

"""

# ╔═╡ 49313d24-84e6-43a8-9e31-040d84e6bf62
md"""
____________________________________________________________________________________________________________
"""

# ╔═╡ 1ccaf9c4-c972-4877-bfa8-a49cc126ca6a
md"""
## Exercise 10. Solving exercise 2 with linear algebra (optional)
"""

# ╔═╡ a414e917-e746-434f-b26e-3dfff16bd9a1
md"""
We solved exercise 2 above using NLsolve. However, we could have used Linea Algebra for the same task. The two methods deliver the same result. We recommend that students in this course use NLsolve, but if one wants to have a go with the use of algebra, that is perfectly acceptable.
"""

# ╔═╡ 6bd27e4a-0f32-45ca-9b2a-4e2eecb22071
md"""
The model in the slides can be written down as:

$$\begin{aligned}
Q_ b &=2 Q_{a}+8 X_{2} \\
Q_{a} &=0.1 Q_{d}-0.5 Q_{c} \\
Q_{d} &=0.5 Q_{c} \\
Q_{c} &=1.5 Q_{a}+2.5 Q_{b}+5 X_{1}
    \end{aligned}$$

Solving the model above by substitution is quite an exasperating task. There is a much more accessible way to solve this model: use **linear algebra**. We can write the model as follows (we use decimal places to make visual inspection easier):

$$\begin{aligned}
-2.0Q_{a} + 1.0Q_{b} + 0.0 Q_{c} + 0.0 Q_{d} & = 0.0 X_{1}+8.0 X_{2} \\
1.0 Q_{a}  +  0.0 Q_{b}+ 0.5 Q_{c}-0.1 Q_{d} & = 0.0 X_{1}+0.0 X_{2} \\
0.0 Q_{a} +  0.0 Q_ b - 0.5 Q_{c}+1.0 Q_{d} & = 0.0 X_{1}+0.0 X_{2} \\
-1.5 Q_{a} - 2.5 Q_{b}+1.0 Q_{c}+0.0 Q_{d}& = 5.0 X_{1}+0.0 X_{2}
    \end{aligned}$$


Let's organize the equations above using matrices:

$$\underbrace{\left[\begin{array}{cccc}
-2.0 & 1.0 & 0.0 & 0.0 \\
1.0 & 0.0 & 0.5 & -0.1 \\
0.0 & 0.0 & -0.5 & 1.0 \\
-1.5 & -2.5 & 1.0 & 0.0
\end{array}\right]}_{A} \cdot \underbrace{\left[\begin{array}{c}
Q_{a} \\
Q_{b} \\
Q_{c} \\
Q_{d}
\end{array}\right]}_{Q} = \ \underbrace{\left[\begin{array}{cc}
0.0 & 8.0 \\
0.0 & 0.0 \\
0.0 & 0.0 \\
5.0 & 0.0
\end{array}\right]}_{B} \cdot \underbrace{\left[\begin{array}{l}
X_{1} \\
X_{2} \\
\end{array}\right]}_{X}
$$

so, we can write

$$A \cdot Q=B \cdot X$$

or

$$Q = \underbrace{(A^{-1}\cdot B}_{C}) \ X$$

where $A^{-1}$ is called the inverse matrix of $A$ (extremely easy to calculate using a computer).

That is:


- "$Q$" is the output of the model (endogenous variables)

- "$X$" is the input of the model (exogenous variables)

- "$C$" is the structure of the model (parameters)
"""

# ╔═╡ f35219aa-0dc5-4e92-8ce9-85b1bfa72998
md"""
Now let us pass the four matrices into the notebook.
"""

# ╔═╡ f9e5a05d-1f88-4579-9d28-596f3bd672e0
A= [-2.0  1.0  0.0  0.0 ; 1.0  0.0  0.5 -0.1 ; 0.0  0.0 -0.5  1.0 ; -1.5  -2.5  1.0  0.0]

# ╔═╡ ff46bc55-750c-4ea9-a934-3b01cf046a8d
inv(A)

# ╔═╡ a4e3d715-8e01-48de-8127-3edd6bd278c0
B = [0.0  8.0 ;  0.0  0.0 ; 0.0  0.0 ; 5.0  0.0]


# ╔═╡ 4877135b-3d4b-43c2-a34e-f1ed68955406
C = inv(A)*B # inv(A) is the inverse matrix of A

# ╔═╡ ab42d6ff-6926-410d-993d-cd4e1cd99a21
md"""
	!!! answer "Answer (e)"

		As expected, the solution is the same as that obtained by using NLsolve:

		$$Q_a=-17.1975 \ , \ Q_b=5.6051 \ , \ Q_c=38.2166 \ , \ Q_d=19.1083.$$
	"""

# ╔═╡ 89cbc406-e188-4e59-98ed-1fd255d9a260
md"""
____________________________________________________________________________________________________________
"""

# ╔═╡ 437c44ae-bb54-4b31-975b-9924eb1e30cc
md"""
## Auxiliary cells (do not remove them)
"""

# ╔═╡ 9fa87191-7c90-4738-a45a-acd929c8bd1b
  TableOfContents()

# ╔═╡ a385a0ae-d2e0-4b4e-862c-e69ec5bd6843
html"""<style>
main {
    max-width: 900px;
    align-self: flex-start;
    margin-left: 100px;
}
"""


# ╔═╡ dde9a9f6-0013-401e-9081-8ef5d599d8ca
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

# ╔═╡ 16228d57-1e45-4856-b100-cb30ea680eb9
TwoColumns(
md"""

`X1 = `$(@bind X1 Slider(0.0:5.0:20.0, default=10.0, show_value=true))

""",
	
md"""

`X2 = `$(@bind X2 Slider(0.0:2.5:10.0, default=5.0, show_value=true))

"""
)

# ╔═╡ 20e7c708-ba16-40c5-a888-fbc98e2e0671
begin
	function zazu!(F, v)

           	Qa = v[1]
           	Qb = v[2]
		   	Qc = v[3]
			Qd = v[4]

           	F[1] = 2Qa + 8X2 - Qb
           	F[2] = 0.1Qd - 0.5Qc - Qa
			F[3] = 0.5Qc - Qd
			F[4] = 1.5Qa + 2.5Qb + 5X1 - Qc
	end
end

# ╔═╡ 66bb1d87-4e2d-465d-9b5c-16fc4321ac52
begin
	solution_zazu = nlsolve(zazu!, [0.0 ; 0.0 ; 0.0 ; 0.0])
	solution_zazu.zero
end

# ╔═╡ 1feff701-2a76-494e-a822-935bb436986f
X = [X1 ; X2]

# ╔═╡ bf22ae24-4cdd-460b-8664-ffbd62568e15
Q = C*X

# ╔═╡ e12d354f-3e41-4925-8ac7-e0b9f2203d27
md"""
##### Supporting cells for exercise 4
"""

# ╔═╡ 24dcd4c4-8655-4c1a-b86f-580c28c2ac49
log_mydata = log.(mydata[:,2:end]);

# ╔═╡ 1f9c7f64-bd8d-4d26-89ea-bce5bf697247
begin
	function hp_filter(log_mydata::Array{Float64,1}, lambda::Float64)
    	n = length(log_mydata)
    	@assert n >= 4
    	diag2 = lambda*ones(n-2)
    	diag1 = [ -2lambda; -4lambda*ones(n-3); -2lambda ]
    	diag0 = [ 1+lambda; 1+5lambda; (1+6lambda)*ones(n-4); 1+5lambda; 1+lambda ]
    	D = spdiagm(-2 => diag2, -1 => diag1, 0 => diag0, 1 => diag1, 2 => diag2)
    	D\log_mydata
	end
end;

# ╔═╡ 991002ef-4999-43eb-9370-dccc77eabea0
begin
	hp_trend = zeros(72,23)
	for n = 1:23
    	hp_trend[:,n] = hp_filter(log_mydata[:,n], 7.0)
	end
	hp_trend
end;

# ╔═╡ 478501bf-5bc3-482d-aae0-ebbf972ff616
begin

	trace2_3 = scatter(;x = period2_1, y = log_mydata[:,19], name = "Real GDP", line_color = "Blue")
	trace2_4 = scatter(;x = period2_1, y = hp_trend[:,19], name = "Potential GDP", line_color = "Red")

	layout2_4 = Layout(;
		title_text = "Real vs Potential Real GDP: Portugal (1950-2021)",
		title_x = 0.5,
		hovermode = "x",
        xaxis_title = "Years",
        #xaxis_range = [1960, 2020],
        yaxis_title = "Log of Real GDP",
        #yaxis_range=[-2, 2],
        titlefont_size = 16)

	p2_4 = Plot([trace2_3 , trace2_4], layout2_4)

end

# ╔═╡ 4cf851a1-f517-41ce-a97b-df43815bb95c
# For France
begin

	trace2_5 = scatter(;x = period2_1, y = log_mydata[:,12], name = "Real GDP", line_color = "Blue")
	trace2_6 = scatter(;x = period2_1, y = hp_trend[:,12], name = "Potential GDP", line_color = "Red")

	layout2_6 = Layout(;
		title_text = "Real vs Potential Real GDP: France (1950-2021)",
		title_x = 0.5,
		hovermode = "x",
        xaxis_title = "Years",
        #xaxis_range = [1960, 2020],
        yaxis_title = "Log of Real GDP",
        #yaxis_range=[-2, 2],
        titlefont_size = 16)

	p2_6 = Plot([trace2_5 , trace2_6], layout2_6)

end

# ╔═╡ 4e75e662-f1af-43f0-ac1e-30459c1d0814
countries = names(log_mydata);

# ╔═╡ 32326d0c-7be1-40e5-aac8-ee60ab34e418
begin
	cycles = zeros(72,23)
	for n = 1:23
    	cycles[:,n] = log_mydata[:,n] - hp_trend[:,n]
	end
	cycles
end;

# ╔═╡ 75b3c457-246b-4509-8ff2-b00f0de38c19
begin
	trace2_7 = scatter(;x = period2_1, y = cycles[:,19] , name = "Portugal", line_color = "Blue",
         			mode="markers+lines", marker_size=6, marker_symbol="circle", line_width=0.3)

	trace2_8 = scatter(;x = period2_1, y = cycles[:,12], name = "France", line_color = "Red",
         			mode="markers+lines", marker_size=6, marker_symbol="circle", line_width=0.3)

	trace2_9 = scatter(;x = period2_1, y = cycles[:,23], name = "UK", line_color = "Gray",
         			mode="markers+lines", marker_size=6, marker_symbol="circle", line_width=0.3)

	layout2_9 = Layout(;
					title_text = "Business cycles: Portugal, France and UK (1950-2021)",
					title_x = 0.5,
					hovermode = "x",
        			xaxis_title = "Years",
        			xaxis_range = [1949, 2022],
        			yaxis_title = "% deviations from Potential GDP",
        			#yaxis_range=[-2, 2],
        			titlefont_size = 16)

	p2_9 = Plot([trace2_7 , trace2_8 , trace2_9], layout2_9)
end

# ╔═╡ 6c6af3c9-66e5-4735-a891-16cde6bf3f2b
crosscor(cycles[:,19],cycles[:,12], [0]; demean=true) # 19 is Portugal, 12 is France in our Data Frame

# ╔═╡ be6cccff-4731-4eeb-9134-1f98b5942cc0
cross_corr_matrix = crosscor(cycles[:,:],cycles[:,:], [0]; demean=true);

# ╔═╡ 59014736-a141-423b-8f27-243aadbc08b6
heat_matrix = reshape(cross_corr_matrix, 23, 23);

# ╔═╡ e022b698-e9cf-44c4-aeb4-8ad2245ed5aa
begin
	function heatmap2()
    trace = heatmap(
			
        x=["AUT", "BEL", "DNK", "FIN", "FRA", "DEU", "GRC", "IRL", "ITA", "NLD", "NOR", "PRT", "ESP", "SWE", 								"CHE", "GBR"],
        y=["AUT", "BEL", "DNK", "FIN", "FRA", "DEU", "GRC", "IRL", "ITA", "NLD", "NOR", "PRT", "ESP", "SWE", 								"CHE", "GBR"],
        z= heat_matrix[8:end,8:end]
    				)
    Plot(trace, 
		Layout(title_text= " Correlation matrix of the business cycles in the Euro Area: 1950-2021", 
			title_x = 0.5))
	end
	heatmap2()
	#savefig(heatmap2(), "correl_matrix.svg")
end

# ╔═╡ fd131773-e508-4586-a6dc-1e22c8b6fe4f
begin
	function heatmap1()
    trace = heatmap(
			
        x=["JPN", "KOR", "TWN", "CAN", "USA", "AUS", "NZL", "AUT", "BEL", "DNK", "FIN", "FRA", "DEU", "GRC", 							"IRL", "ITA", "NLD", "NOR", "PRT", "ESP", "SWE", "CHE", "GBR"],
        y=["JPN", "KOR", "TWN", "CAN", "USA", "AUS", "NZL", "AUT", "BEL", "DNK", "FIN", "FRA", "DEU", "GRC", 							"IRL", "ITA", "NLD", "NOR", "PRT", "ESP", "SWE", "CHE", "GBR"],
        z= heat_matrix
    				)
    Plot(trace)
	end
	heatmap1()
end;

# ╔═╡ 910927a2-47ae-40ff-b8cd-73ef2b5a93aa
md"""
##### Supporting cells for exercise 5
"""

# ╔═╡ 6274bc02-6c47-4a52-9b02-669ded01960d
period2_2 = 2007:1:2021;

# ╔═╡ c6aea9b9-8cb2-4ccf-bd3c-034a702585e4
data2007 = mydata[58:72,1:24];

# ╔═╡ 25ada4af-7a6c-47ec-87b6-facd3ffd3e64
begin
	PRT_1 = data2007[1,20] * 100 / data2007[1,20] # Fixing the initial level to 100
	PRT_2 = data2007[2,20] * 100 / data2007[1,20]
	PRT_3 = data2007[3,20] * 100 / data2007[1,20]
	PRT_2
end;

# ╔═╡ 9fe70f93-faca-4ea9-917b-8e594d78cdc3
begin
	t = 15;
	PRT1 = data2007[1,20] * 100 / data2007[1,20] 		# Fixing the initial value to 100
	PRTn = length(PRT1) 								# the number of initial conditions (1 in this case)
	PRTt = [PRT1  zeros(PRTn, t-1)]; 					# Preallocating memory for the output

		for i = 1 : t-1
    		PRTt[i+1] = data2007[i+1,20] * 100 / data2007[1,20];
		end
	PRTt
end;

# ╔═╡ 1eb1551d-491d-4955-9d2f-853a0971fb0c
begin
	data2007_2 = DataFrame([(c ./ first(c))*100
        for c ∈ eachcol(data2007[:,2:end])], names(data2007[:,2:end]))
end;

# ╔═╡ 4932c69b-6536-4067-9d87-6b1bfe34cac8
begin
	data1 = AbstractTrace[]
	##################################
	col_idx1 = [11, 14, 15, 16, 19, 20]
	some_colnames1 = []
		for k in col_idx1
    		push!(some_colnames1, names(data2007_2)[k])
		end
	##################################
		for col in some_colnames1
    		push!(data1, scatter(x = period2_2, y = data2007_2[!,col], name = col, mode = "markers+lines",
            		marker_size = 7, marker_symbol = "circle", line_width = 0.5 ))
		end

	layout2_11 = Layout(;
			title_text = "The impact of the financial crisis in the EZ Periphery (Real GDP)", 
			title_x = 0.5,
			colorway=ColorSchemes.phase.colors[1:40:end],
			hovermode="x",		
        	xaxis_title = "Years",
        	xaxis_range = [2006, 2022],
        	yaxis_title = "GDP Index",
        	#yaxis_range=[-2, 2],
        	titlefont_size=16)

	p2_11 = Plot(data1, layout2_11)
end

# ╔═╡ f2776549-3b8f-4a11-b500-53276c252fce
begin
	data2 = AbstractTrace[]
	#################
	col_idx2 = [1, 4, 5, 8, 9, 10, 12, 13, 17, 18, 21, 22, 23]
	some_colnames2 = []
		for k in col_idx2
    		push!(some_colnames2, names(data2007_2)[k])
		end
#################
		for col in some_colnames2
    		push!(data2, scatter(x = period2_2, y = data2007_2[!,col], name = col, mode = "markers+lines",
            	marker_size = 7, marker_symbol = "circle", line_width = 0.5 ))
		end

	layout2_12 = Layout(;
				#colorway=ColorSchemes.phase.colors[1:20:end],
				title_text = "The impact of the financial crisis in the EZ-Core+ (Real GDP)", 
				title_x=0.5,
				hovermode="x",
				#colorway=ColorSchemes.phase.colors[1:25:end],
        		xaxis_title = "Years",
        		xaxis_range = [2006, 2022],
        		yaxis_title = "GDP Index",
        		#yaxis_range=[-2, 2],
        		titlefont_size=16)

	p2_12 = Plot(data2, layout2_12)
end

# ╔═╡ b2fa9b87-0387-4c1a-baba-cd756568d4d7
begin
	data3 = AbstractTrace[]
	#################
	col_idx3 = [1, 2, 3, 6, 7]
	some_colnames3 = []
		for k in col_idx3
    		push!(some_colnames3, names(data2007_2)[k])
		end
#################
		for col in some_colnames3
    		push!(data3, scatter(x = period2_2, y = data2007_2[!,col], name = col, mode = "markers+lines",
            	marker_size = 7, marker_symbol = "circle", line_width = 0.5 ))
		end

	layout2_13 = Layout(;
				title_text = "The impact of the financial crisis in Asia + Australasia (Real GDP)", 	  					title_x=0.5,
				hovermode="x",		
        		xaxis_title = "Years",
        		xaxis_range = [2006, 2022],
        		yaxis_title = "GDP Index",
        		#yaxis_range=[-2, 2],
        		titlefont_size=16)

	p2_13 = Plot(data3, layout2_13)
end

# ╔═╡ 6cc8c3bd-5619-480e-9454-e9c64bad8689
begin
	 layout2_10 = Layout(;
			title_text = "The impact of the financial crisis in Portugal (Real GDP)",
			title_x = 0.5,
			hovermode = "x",
        	xaxis_title = "Years",
        	#xaxis_range = [1960, 2020],
        	yaxis_title = "GDP Index",
        	#yaxis_range=[-2, 2],
        	titlefont_size=16)


	p2_10 = Plot(period2_2,PRTt', layout2_10, name = "Portugal", line_color = "Blue",
         		mode="markers+lines", marker_size=7, marker_symbol="circle", line_width=0.3)
end;

# ╔═╡ 6d001dc9-5977-4b02-bcc2-1a2106ede495

md"""
##### Supporting cells for exercise 6
"""

# ╔═╡ 335c550f-fbd9-44e2-bc69-c13b54250a45
DataUS = CSV.read("Data_US.csv", DataFrame);

# ╔═╡ 90a1f7b0-492e-4f3d-8e06-d2f4092ed93f
crosscor(DataUS.FFR, DataUS.CPI, [0]; demean=true)

# ╔═╡ 356367d5-9127-4a93-bda0-9c7ff1efe9f8
crosscor(DataUS.UR, DataUS.CPI, [0]; demean=true)

# ╔═╡ b5b58aae-1a82-44bd-a9ca-31559ebbbe5e
period1 = QuarterlyDate("1960-Q1"):Quarter(1):QuarterlyDate("2022-Q4");

# ╔═╡ 40f34f88-3d33-4557-831e-22607f3682f7
begin
	trace1_14 = scatter(;x = Date.(period1), y = DataUS.CPI, name = "FFR", line_color = "Blue",
						mode = "markers+lines", line_width="0.5", marker_size ="4.5")
	trace1_15 = scatter(;x = Date.(period1), y = DataUS.FFR, name = "CPI", line_color = "Red",
						mode = "markers+lines", line_width="0.5", marker_size ="4.5")

	layout1_15 = Layout(;
				title_text = "Inflation (CPI) versus Fed Funds Rate (FFR): USA (1960.Q1--2022.Q4)",
				title_x = 0.5,
				hovermode = "x",
	
            	axis = attr(
                	title = "Quarterly obervations",
                	#tickformat = "%Y",
                	#hoverformat = "%Y-Q%q",
                	#tick0 = "1959/01/01",
               	 	#dtick = "M120"
				),
        		xaxis_range = [Date.(1959), Date.(2024)],
        		yaxis_title = "Percentage points",
        		#yaxis_range=[-2, 2],
        		titlefont_size = 16)

	p1_15 = Plot([trace1_14 , trace1_15], layout1_15)
end

# ╔═╡ 3aad82ff-baa4-48d5-aa66-51344c754421
begin
	layout1_16 = Layout(;
					title_text = "Inflation (CPI) versus Fed Funds Rate (FFR): USA (1960.Q1--2022.Q4)",
					title_x = 0.5,
        			yaxis_title = "Rate of inflation",
        			xaxis_range = [-1, 18],
        			xaxis_title = "Fed Funds Rate",
        			yaxis_range=[-3, 16],
        			titlefont_size=18)

	trace2 = scatter(; x = [-2, 20] , y = [-2, 20], line_width = 3 )

	p1_16 = Plot(DataUS.FFR, DataUS.CPI, mode="markers+lines", text=period1,
            	marker_symbol="circle", marker_size="6.5",line_width=0.3,
            	#marker_color="LightSteelBlue",
            	marker_color="Blue",layout1_16)
	addtraces!(p1_16, trace2)
	restyle!(p1_16, 1:2, name=["Rates", "45º"])
	p1_16
end
		

# ╔═╡ 52b6eb6e-1566-4e0f-b787-404cdc5f9edb
begin
	trace2_17 = scatter(;x = Date.(period1), y = DataUS.UR, name = "UR", line_color = "BlueViolet",
						mode = "markers+lines", line_width="0.5", marker_size ="4.5")
	trace2_18 = scatter(;x = Date.(period1), y = DataUS.CPI, name = "CPI", line_color = "Red",
						mode = "markers+lines", line_width="0.5", marker_size ="4.5")

	layout2_18 = Layout(;
				title_text = "Inflation (CPI) versus Unemployment Rate (UR): USA (1960.Q1--2022.Q4)",
				title_x = 0.5,
				hovermode = "x",
            	xaxis = attr(
                title = "Quarterly obervations",
                tickformat = "%Y",
                hoverformat = "%Y-Q%q",
                tick0 = "1960/01/01",
                dtick = "M120",
        				),
        		xaxis_range = [Date.(1959), Date.(2024)],
        		yaxis_title = "Percentage points",
        		#yaxis_range=[-2, 2],
        		titlefont_size = 16)

	p2_18 = Plot([trace2_17 , trace2_18], layout2_18)
end

# ╔═╡ 8ae18d1b-dcd1-43f4-828e-63dab4373091
begin
	layout2_19 = Layout(;
					title_text = "Inflation (CPI) versus Unemployment Rate (UR): USA (1960.Q1--2022.Q4)",
					title_x = 0.5,
        			yaxis_title = "Rate of inflation",
        			#xaxis_range = [1960, 2020],
        			xaxis_title = "Rate of unemployment",
        			#yaxis_range=[-2, 2],
        			titlefont_size=18)

	p2_19 = Plot(DataUS.UR, DataUS.CPI, mode="markers+lines", text=period1,
            	marker_symbol="circle", marker_size="6",line_width=0.3,
            	#marker_color="LightSteelBlue",
            	marker_color="BlueViolet",layout2_19)

end

# ╔═╡ 920b681a-bd29-4f33-829c-ee4d2f704318
begin
	trace2_20 = scatter(;x = Date.(period1), y = DataUS.MB, name = "MB", line_color = "Blue",
						mode = "markers+lines", line_width="0.5", marker_size ="4.5")

	layout2_20 = Layout(;
				title_text = "Monetary Base (MB): USA (1960.Q1--2022.Q4)",
				title_x = 0.5,
				hovermode = "x",
            	xaxis = attr(
                title = "Quarterly obervations",
                #tickformat = "%Y",
                #hoverformat = "%Y-Q%q",
                #tick0 = "1960/01/01",
                #dtick = "M120",
        				),
        		xaxis_range = [Date.(1959), Date.(2024)],
        		yaxis_title = "Millions of dollars",
        		#yaxis_range=[-2, 2],
        		titlefont_size = 16)

	p2_20 = Plot(trace2_20, layout2_20)
end

# ╔═╡ 20efbdb4-1045-4d36-92f3-84001783fcad
begin
	trace2_21 = scatter(;x = Date.(period1), y = DataUS.M2, name = "FFR", line_color = "Red",
						mode = "markers+lines", line_width="0.5", marker_size ="4.5")

	layout2_21 = Layout(;
				title_text = "Money supply (M2): USA (1960.Q1--2022.Q4)",
				title_x = 0.5,
				hovermode = "x",
            	xaxis = attr(
                title = "Quarterly obervations",
                tickformat = "%Y",
                hoverformat = "%Y-Q%q",
                tick0 = "1960/01/01",
                dtick = "M120",
        				),
        		xaxis_range = [Date.(1959), Date.(2024)],
        		yaxis_title = "Billions of dollars",
        		#yaxis_range=[-2, 2],
        		titlefont_size = 16)

	p2_21 = Plot(trace2_21, layout2_21)
end

# ╔═╡ 04421307-25ad-4bb3-a686-caeedc56dd61
md"""
##### Supporting cells for exercise 7
"""

# ╔═╡ 3ecd4946-8bee-4ed1-84dd-1f172d3adef4
 USBudget = CSV.read("US_Budget_Deficits_1929_2020.csv", DataFrame);

# ╔═╡ 2807f3bd-4b64-437e-9e79-bfcbe9723e2a
USDebt = CSV.read("US_PublicDebt.csv", DataFrame);

# ╔═╡ 3c166b5a-11bf-4d40-a55e-6bf3f0f5e67d
period2_6 = 1939:1:2019;

# ╔═╡ 5bee3291-9ec8-4761-b732-352c460e474a
begin
	trace2_28 = bar(;x= period2_6, y= USDebt[:,2], mode="markers+lines",
				marker_symbol="circle", marker_size="5",line_width= 0.3,
            	marker_color = "Blue", name="Budget", yaxis = "y2",
				fillcolor = "blue", opacity = 0.4)#, text = period1_6)

	trace2_29 = scatter(;x= period2_6, y= USDebt[:,3], mode="markers+lines",
				marker_symbol="circle", marker_size="5",line_width= 0.3,
            	marker_color = "DarkRed", name="Debt")#, text = period1_6)

	layout2_29 = Layout(

			title_text = "Federal Budget and Federal Debt as a % of GDP : USA (1939-2019)",
			title_x = 0.5,
			hovermode = "x",

			titlefont_size = 16,

			xaxis = attr(
                		title = "Annual obervations",
						showgrid = true),
                		#tickformat = "%Y",
                		#hoverformat = "%Y-Y%y",
                		#tick0 = "1939/10/01",
                		#dtick = "M240"
				        #xaxis_range = [Date.(1938), Date.(2029)],


			yaxis1 = attr(
						title = "Public Debt/GDP",
						titlefont_color=  "Red",
						tickfont_color = "Red",
						#overlaying = "y",
						#side = "right",
						#yaxis1_tickvals = [1.5, 2.5, 3.5, 5.5],
						showgrid= true,
						zeroline=false,
						yaxis1_range=[1.5 , 5.5],
    					#dtick = 5.6 / 7
						  ),

			yaxis2 = attr(
    					title = "Federal Budget/GDP",
    					titlefont_color=  "blue",
    					tickfont_color = "blue",
    					overlaying = "y",
    					side = "right",
						showgrid = false,
						yaxis2_range=[-25 , 5],
						#dtick = 30 / %
						  )
						)
	p2_29 = Plot([trace2_28, trace2_29], layout2_29)

end

# ╔═╡ 561b005d-6c30-47a3-8643-1aff26b907d8
period2_5 = 1929:1:2020;

# ╔═╡ ed446d9d-27be-4f0d-b7dd-5046174bc425
begin
	trace2_27 = bar(;x= period2_5, y= USBudget[:,2],
               marker=attr(color="Blue", opacity=0.5),
               name="BD US")

	layout2_27 = Layout(;
		title_text = "Federal Budget as a % of GDP : USA (1929-2020)",
		title_x = 0.5,
		hovermode = "x",
        xaxis_title = "Anual obervations",
        #xaxis_range = [Date.(1925), Date.(2025)],
        separators = ".",
        yaxis_title = "% points",
        #yaxis_range=[-2, 2],
        titlefont_size = 16,
        bargap=0.25)
	p2_27 = Plot(trace2_27, layout2_27)
end

# ╔═╡ f906a80e-947e-4480-85f8-e4776ef9ea23
g_vs_r= CSV.read("g_versus_r.csv", delim=";", DataFrame);

# ╔═╡ 21c0779a-ff1d-47d2-9736-57486457ce53
mean(g_vs_r.GDP_growth-g_vs_r.Real10Y_yield)

# ╔═╡ 48d62487-3673-499c-9a48-16b3be47b1e2
period10= QuarterlyDate(1962, 1):Quarter(1):QuarterlyDate(2022, 4);

# ╔═╡ eff3b751-4671-4f0d-88c9-e51f969d53b4
begin
	fig10_1 = Plot(bar(x=Date.(period10), y=g_vs_r.GDP_growth-g_vs_r.Real10Y_yield))
	relayout!(fig10_1, Layout(hovermode="x", title_text="GDP growth rate minus real interest rate on US debt: 1962-Q1--2022-Q4", title_x = 0.5, titlefont_size="17", tick0 = "1960"), xaxis_range = [Date.(1961), Date.(2023)])
	fig10_1
end

# ╔═╡ bb95ec43-80db-408f-9b2d-954e43a6de02
md"""
##### Supporting cells for exercise 8
"""

# ╔═╡ fb3975d0-da4d-4bc6-a413-753cf07f146e
BAA10Y = CSV.read("BAA10Y.csv", DataFrame);

# ╔═╡ 4de4ea24-606e-4110-b73e-b7ddce215ba1
period8_7 = MonthlyDate(2004,1):Month(1):MonthlyDate(2023,1);

# ╔═╡ cb5946f9-4901-40e4-ad2e-da4e058b7df3
begin
	trace2_30 = scatter(;x = Date.(period8_7), y = BAA10Y.BAA10Y,
				name = "Spread", mode="markers+lines",
				marker_symbol="circle", marker_size="4",line_width= 0.3,
            	#marker_color="LightSteelBlue",
            	marker_color = "Blue")

	layout2_30 = Layout(;
	title_text = "Moody's Baa Corporate Bond Yield Relative to Yield on 10-Year Treasury Constant Maturity",
			title_x = 0.5,
			hovermode = "x",
            xaxis = attr(
               title = "Monthly obervations",
               tickformat = "%Y",
               hoverformat = "%Y-M%m",
               #tick0 = "2003/12/01",
               dtick = "M36",
        ),
        xaxis_range = [Date.(2003), Date.(2024)],
        yaxis_title = "Percentage points",
        #yaxis_range=[-2, 2],
        titlefont_size = 16)

	p2_30 = Plot([trace2_30], layout2_30)
end

# ╔═╡ 00000000-0000-0000-0000-000000000001
PLUTO_PROJECT_TOML_CONTENTS = """
[deps]
CSV = "336ed68f-0bac-5ca0-87d4-7b16caf5d00b"
ColorSchemes = "35d6a980-a343-548e-a6ea-1d62b119f2f4"
DataFrames = "a93c6f00-e57d-5684-b7b6-d8193f3e46c0"
Dates = "ade2ca70-3891-5945-98fb-dc099432e06a"
HypertextLiteral = "ac1192a8-f4b3-4bfe-ba22-af5b92cd3ab2"
LinearAlgebra = "37e2e46d-f89d-539d-b4ee-838fcccc9c8e"
NLsolve = "2774e3e8-f4cf-5e23-947b-6d7e65073b56"
PeriodicalDates = "276e7ca9-e0d7-440b-97bc-a6ae82f545b1"
PlotlyBase = "a03496cd-edff-5a9b-9e67-9cda94a718b5"
PlutoPlotly = "8e989ff0-3d88-8e9f-f020-2b208a939ff0"
PlutoUI = "7f904dfe-b85e-4ff6-b463-dae2292396a8"
SparseArrays = "2f01184e-e22b-5df5-ae63-d93ebab69eaf"
StatsBase = "2913bbd2-ae8a-5f71-8c99-4fb6c76f3a91"

[compat]
CSV = "~0.10.4"
ColorSchemes = "~3.20.0"
DataFrames = "~1.3.5"
HypertextLiteral = "~0.9.4"
NLsolve = "~4.5.1"
PeriodicalDates = "~2.0.0"
PlotlyBase = "~0.8.19"
PlutoPlotly = "~0.3.9"
PlutoUI = "~0.7.40"
StatsBase = "~0.33.21"
"""

# ╔═╡ 00000000-0000-0000-0000-000000000002
PLUTO_MANIFEST_TOML_CONTENTS = """
# This file is machine-generated - editing it directly is not advised

julia_version = "1.9.3"
manifest_format = "2.0"
project_hash = "cd8f97558c35a32c338cf177ee34456a426d78e1"

[[deps.AbstractPlutoDingetjes]]
deps = ["Pkg"]
git-tree-sha1 = "91bd53c39b9cbfb5ef4b015e8b582d344532bd0a"
uuid = "6e696c72-6542-2067-7265-42206c756150"
version = "1.2.0"

[[deps.Adapt]]
deps = ["LinearAlgebra", "Requires"]
git-tree-sha1 = "76289dc51920fdc6e0013c872ba9551d54961c24"
uuid = "79e6a3ab-5dfb-504d-930d-738a2a938a0e"
version = "3.6.2"

    [deps.Adapt.extensions]
    AdaptStaticArraysExt = "StaticArrays"

    [deps.Adapt.weakdeps]
    StaticArrays = "90137ffa-7385-5640-81b9-e52037218182"

[[deps.ArgTools]]
uuid = "0dad84c5-d112-42e6-8d28-ef12dabb789f"
version = "1.1.1"

[[deps.ArrayInterface]]
deps = ["Adapt", "LinearAlgebra", "Requires", "SparseArrays", "SuiteSparse"]
git-tree-sha1 = "f83ec24f76d4c8f525099b2ac475fc098138ec31"
uuid = "4fba245c-0d91-5ea0-9b3e-6abc04ee57a9"
version = "7.4.11"

    [deps.ArrayInterface.extensions]
    ArrayInterfaceBandedMatricesExt = "BandedMatrices"
    ArrayInterfaceBlockBandedMatricesExt = "BlockBandedMatrices"
    ArrayInterfaceCUDAExt = "CUDA"
    ArrayInterfaceGPUArraysCoreExt = "GPUArraysCore"
    ArrayInterfaceStaticArraysCoreExt = "StaticArraysCore"
    ArrayInterfaceTrackerExt = "Tracker"

    [deps.ArrayInterface.weakdeps]
    BandedMatrices = "aae01518-5342-5314-be14-df237901396f"
    BlockBandedMatrices = "ffab5731-97b5-5995-9138-79e8c1846df0"
    CUDA = "052768ef-5323-5732-b1bb-66c8b64840ba"
    GPUArraysCore = "46192b85-c4d5-4398-a991-12ede77f4527"
    StaticArraysCore = "1e83bf80-4336-4d27-bf5d-d5a4f845583c"
    Tracker = "9f7883ad-71c0-57eb-9f7f-b5c9e6d3789c"

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
deps = ["ColorTypes", "ColorVectorSpace", "Colors", "FixedPointNumbers", "Random", "SnoopPrecompile"]
git-tree-sha1 = "aa3edc8f8dea6cbfa176ee12f7c2fc82f0608ed3"
uuid = "35d6a980-a343-548e-a6ea-1d62b119f2f4"
version = "3.20.0"

[[deps.ColorTypes]]
deps = ["FixedPointNumbers", "Random"]
git-tree-sha1 = "eb7f0f8307f71fac7c606984ea5fb2817275d6e4"
uuid = "3da002f7-5984-5a60-b8a6-cbb66c0b333f"
version = "0.11.4"

[[deps.ColorVectorSpace]]
deps = ["ColorTypes", "FixedPointNumbers", "LinearAlgebra", "SpecialFunctions", "Statistics", "TensorCore"]
git-tree-sha1 = "600cc5508d66b78aae350f7accdb58763ac18589"
uuid = "c3611d14-8923-5661-9e6a-0046d554d3a4"
version = "0.9.10"

[[deps.Colors]]
deps = ["ColorTypes", "FixedPointNumbers", "Reexport"]
git-tree-sha1 = "fc08e5930ee9a4e03f84bfb5211cb54e7769758a"
uuid = "5ae59095-9a9b-59fe-a467-6f913c188581"
version = "0.12.10"

[[deps.CommonSubexpressions]]
deps = ["MacroTools", "Test"]
git-tree-sha1 = "7b8a93dba8af7e3b42fecabf646260105ac373f7"
uuid = "bbf7d656-a473-5ed7-a52c-81e309532950"
version = "0.3.0"

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

[[deps.ConstructionBase]]
deps = ["LinearAlgebra"]
git-tree-sha1 = "fe2838a593b5f776e1597e086dcd47560d94e816"
uuid = "187b0558-2788-49d3-abe0-74a17ed4e7c9"
version = "1.5.3"

    [deps.ConstructionBase.extensions]
    ConstructionBaseIntervalSetsExt = "IntervalSets"
    ConstructionBaseStaticArraysExt = "StaticArrays"

    [deps.ConstructionBase.weakdeps]
    IntervalSets = "8197267c-284f-5f27-9208-e0e47529a953"
    StaticArrays = "90137ffa-7385-5640-81b9-e52037218182"

[[deps.Crayons]]
git-tree-sha1 = "249fe38abf76d48563e2f4556bebd215aa317e15"
uuid = "a8cc5b0e-0ffa-5ad4-8c14-923d3ee1735f"
version = "4.1.1"

[[deps.DataAPI]]
git-tree-sha1 = "8da84edb865b0b5b0100c0666a9bc9a0b71c553c"
uuid = "9a962f9c-6df0-11e9-0e5d-c546b8b5ee8a"
version = "1.15.0"

[[deps.DataFrames]]
deps = ["Compat", "DataAPI", "Future", "InvertedIndices", "IteratorInterfaceExtensions", "LinearAlgebra", "Markdown", "Missings", "PooledArrays", "PrettyTables", "Printf", "REPL", "Reexport", "SortingAlgorithms", "Statistics", "TableTraits", "Tables", "Unicode"]
git-tree-sha1 = "db2a9cb664fcea7836da4b414c3278d71dd602d2"
uuid = "a93c6f00-e57d-5684-b7b6-d8193f3e46c0"
version = "1.3.6"

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

[[deps.DiffResults]]
deps = ["StaticArraysCore"]
git-tree-sha1 = "782dd5f4561f5d267313f23853baaaa4c52ea621"
uuid = "163ba53b-c6d8-5494-b064-1a9d43ac40c5"
version = "1.1.0"

[[deps.DiffRules]]
deps = ["IrrationalConstants", "LogExpFunctions", "NaNMath", "Random", "SpecialFunctions"]
git-tree-sha1 = "23163d55f885173722d1e4cf0f6110cdbaf7e272"
uuid = "b552c78f-8df3-52c6-915a-8e097449b14b"
version = "1.15.1"

[[deps.Distances]]
deps = ["LinearAlgebra", "Statistics", "StatsAPI"]
git-tree-sha1 = "b6def76ffad15143924a2199f72a5cd883a2e8a9"
uuid = "b4f34e82-e78d-54a5-968a-f98e89d6e8f7"
version = "0.10.9"
weakdeps = ["SparseArrays"]

    [deps.Distances.extensions]
    DistancesSparseArraysExt = "SparseArrays"

[[deps.Distributed]]
deps = ["Random", "Serialization", "Sockets"]
uuid = "8ba89e20-285c-5b6f-9357-94700520ee1b"

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

[[deps.FiniteDiff]]
deps = ["ArrayInterface", "LinearAlgebra", "Requires", "Setfield", "SparseArrays"]
git-tree-sha1 = "c6e4a1fbe73b31a3dea94b1da449503b8830c306"
uuid = "6a86dc24-6348-571c-b903-95158fe2bd41"
version = "2.21.1"

    [deps.FiniteDiff.extensions]
    FiniteDiffBandedMatricesExt = "BandedMatrices"
    FiniteDiffBlockBandedMatricesExt = "BlockBandedMatrices"
    FiniteDiffStaticArraysExt = "StaticArrays"

    [deps.FiniteDiff.weakdeps]
    BandedMatrices = "aae01518-5342-5314-be14-df237901396f"
    BlockBandedMatrices = "ffab5731-97b5-5995-9138-79e8c1846df0"
    StaticArrays = "90137ffa-7385-5640-81b9-e52037218182"

[[deps.FixedPointNumbers]]
deps = ["Statistics"]
git-tree-sha1 = "335bfdceacc84c5cdf16aadc768aa5ddfc5383cc"
uuid = "53c48c17-4a7d-5ca2-90c5-79b7896eea93"
version = "0.8.4"

[[deps.Formatting]]
deps = ["Printf"]
git-tree-sha1 = "8339d61043228fdd3eb658d86c926cb282ae72a8"
uuid = "59287772-0a20-5a39-b81b-1366585eb4c0"
version = "0.4.2"

[[deps.ForwardDiff]]
deps = ["CommonSubexpressions", "DiffResults", "DiffRules", "LinearAlgebra", "LogExpFunctions", "NaNMath", "Preferences", "Printf", "Random", "SpecialFunctions"]
git-tree-sha1 = "cf0fe81336da9fb90944683b8c41984b08793dad"
uuid = "f6369f11-7733-5829-9624-2563aa707210"
version = "0.10.36"

    [deps.ForwardDiff.extensions]
    ForwardDiffStaticArraysExt = "StaticArrays"

    [deps.ForwardDiff.weakdeps]
    StaticArrays = "90137ffa-7385-5640-81b9-e52037218182"

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

[[deps.JLLWrappers]]
deps = ["Artifacts", "Preferences"]
git-tree-sha1 = "7e5d6779a1e09a36db2a7b6cff50942a0a7d0fca"
uuid = "692b3bcd-3c85-4b1f-b108-f13ce0eb3210"
version = "1.5.0"

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

[[deps.LineSearches]]
deps = ["LinearAlgebra", "NLSolversBase", "NaNMath", "Parameters", "Printf"]
git-tree-sha1 = "7bbea35cec17305fc70a0e5b4641477dc0789d9d"
uuid = "d3d80556-e9d4-5f37-9878-2ab0fcc64255"
version = "7.2.0"

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

[[deps.MacroTools]]
deps = ["Markdown", "Random"]
git-tree-sha1 = "9ee1618cbf5240e6d4e0371d6f24065083f60c48"
uuid = "1914dd2f-81c6-5fcd-8719-6d5c9610ff09"
version = "0.5.11"

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

[[deps.NLSolversBase]]
deps = ["DiffResults", "Distributed", "FiniteDiff", "ForwardDiff"]
git-tree-sha1 = "a0b464d183da839699f4c79e7606d9d186ec172c"
uuid = "d41bc354-129a-5804-8e4c-c37616107c6c"
version = "7.8.3"

[[deps.NLsolve]]
deps = ["Distances", "LineSearches", "LinearAlgebra", "NLSolversBase", "Printf", "Reexport"]
git-tree-sha1 = "019f12e9a1a7880459d0173c182e6a99365d7ac1"
uuid = "2774e3e8-f4cf-5e23-947b-6d7e65073b56"
version = "4.5.1"

[[deps.NaNMath]]
deps = ["OpenLibm_jll"]
git-tree-sha1 = "0877504529a3e5c3343c6f8b4c0381e57e4387e4"
uuid = "77ba4419-2d1f-58cd-9bb1-8ffee604a2e3"
version = "1.0.2"

[[deps.NetworkOptions]]
uuid = "ca575930-c2e3-43a9-ace4-1e988b2c1908"
version = "1.2.0"

[[deps.OpenBLAS_jll]]
deps = ["Artifacts", "CompilerSupportLibraries_jll", "Libdl"]
uuid = "4536629a-c528-5b80-bd46-f80d51c5b363"
version = "0.3.21+4"

[[deps.OpenLibm_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "05823500-19ac-5b8b-9628-191a04bc5112"
version = "0.8.1+0"

[[deps.OpenSpecFun_jll]]
deps = ["Artifacts", "CompilerSupportLibraries_jll", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "13652491f6856acfd2db29360e1bbcd4565d04f1"
uuid = "efe28fd5-8261-553b-a9e1-b2916fc3738e"
version = "0.5.5+0"

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
deps = ["Crayons", "Formatting", "Markdown", "Reexport", "Tables"]
git-tree-sha1 = "dfb54c4e414caa595a1f2ed759b160f5a3ddcba5"
uuid = "08abe8d2-0d0c-5749-adfa-8a2ac140af0d"
version = "1.3.1"

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

[[deps.Setfield]]
deps = ["ConstructionBase", "Future", "MacroTools", "StaticArraysCore"]
git-tree-sha1 = "e2cc6d8c88613c05e1defb55170bf5ff211fbeac"
uuid = "efcf1570-3423-57d1-acb7-fd33fddbac46"
version = "1.1.1"

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

[[deps.SpecialFunctions]]
deps = ["IrrationalConstants", "LogExpFunctions", "OpenLibm_jll", "OpenSpecFun_jll"]
git-tree-sha1 = "e2cfc4012a19088254b3950b85c3c1d8882d864d"
uuid = "276daf66-3868-5448-9aa4-cd146d93841b"
version = "2.3.1"

    [deps.SpecialFunctions.extensions]
    SpecialFunctionsChainRulesCoreExt = "ChainRulesCore"

    [deps.SpecialFunctions.weakdeps]
    ChainRulesCore = "d360d2e6-b24c-11e9-a2a3-2a2ae2dbcce4"

[[deps.StaticArraysCore]]
git-tree-sha1 = "36b3d696ce6366023a0ea192b4cd442268995a0d"
uuid = "1e83bf80-4336-4d27-bf5d-d5a4f845583c"
version = "1.4.2"

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

[[deps.SuiteSparse]]
deps = ["Libdl", "LinearAlgebra", "Serialization", "SparseArrays"]
uuid = "4607b0f0-06f3-5cda-b6b1-a6196a1729e9"

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
# ╟─b370036f-a10b-4a66-8839-29e1e95c91c0
# ╟─4618a663-f77e-4ccc-9b00-e84dbd5beb34
# ╠═a145e2fe-a903-11eb-160f-df7ea83fa3e6
# ╟─74de9f66-d5b4-4e0f-a75d-5177b1842191
# ╟─dcd13560-0f73-4aaa-b59a-b7961d8cdc63
# ╟─df9417d2-ebe1-498c-b299-f2b8fdee1084
# ╟─cec1d956-027e-445e-9b9e-db2aacfe71b1
# ╟─902604c3-155b-4f95-9d50-b11c133b836a
# ╟─9e05bc6e-a423-41c2-a236-41432276af88
# ╟─5222cb8c-363c-4fbd-b9a9-ec9553d4c8ab
# ╟─8cb0b7ad-282a-4ee4-8507-d77fe14f4f29
# ╟─33898360-dfa8-4a63-b122-ad9ed71cc987
# ╟─f1ba33fa-e242-424d-9891-51d5e4d9addd
# ╟─09426867-1b5e-45c0-8e88-b81832e99bc9
# ╟─e3ff7943-d008-49f6-882d-f911da21e6d8
# ╟─71f8374a-7f2e-41a5-a713-bfdad0309990
# ╟─33ec3e63-9b6e-48cb-b7dd-c98ac5878e2a
# ╟─d24009b0-67e8-430d-a585-c0b88fe8d669
# ╟─eb496df8-cb83-46bb-9f82-61108c6fd892
# ╟─3cf179b7-db29-4f93-99ee-abe2d348aa75
# ╟─53d6dc4d-b4cc-48e3-8b6e-fb0ca690dc81
# ╟─935f5b31-a293-46d1-ba7c-83637ce6a6b7
# ╟─e1117af1-2a87-44ab-adac-f99844d144e0
# ╟─525e50f7-a253-476d-99e9-fa2fe670de42
# ╟─e5151b0e-8f56-487e-89f2-b27b940d3ad8
# ╟─20e7c708-ba16-40c5-a888-fbc98e2e0671
# ╟─8a79bfda-718e-4be2-8784-9771830aee45
# ╠═66bb1d87-4e2d-465d-9b5c-16fc4321ac52
# ╟─17b52f12-1ffe-4d2b-a85c-ec39a4ab2716
# ╟─1c645c0e-5cf2-4c88-b813-df7bdb99997f
# ╟─16228d57-1e45-4856-b100-cb30ea680eb9
# ╟─c68ad919-3953-434e-86eb-0c3994ec6257
# ╟─31b69cd9-3cea-4064-9d4a-e9a154d86336
# ╟─c7d27ed4-69b4-4e67-9dce-4323ddea4b59
# ╟─0328e243-0b07-4480-8d9d-36d321287766
# ╟─e5dad7e7-68e4-4a47-854a-4ad61ba34f7a
# ╟─52d8edb2-4ba8-4dc9-a828-f18edd740839
# ╟─00c5aa04-41de-43b1-b825-421fdbf01fe9
# ╟─4b150ec7-fddc-4d82-83e7-3032a1368833
# ╠═f33600d1-a1d9-41e8-b9b3-4107de25df54
# ╟─de1a9561-f0c0-4046-b38b-8fae087e583e
# ╟─3af6b135-74d4-45f2-aa2e-aab24a5307ed
# ╟─42f371eb-ff16-4017-8deb-e53d92e85b2e
# ╟─6134353f-870b-44fb-83b2-a6bc02d04d8a
# ╠═f4dab38f-262f-421f-b3a9-a5a4759b95c8
# ╟─478501bf-5bc3-482d-aae0-ebbf972ff616
# ╟─4cf851a1-f517-41ce-a97b-df43815bb95c
# ╟─9dfbe21a-6ba0-4f50-8554-67a5b9150aad
# ╟─75b3c457-246b-4509-8ff2-b00f0de38c19
# ╟─cd9202f0-939e-4356-9560-a12540169fe2
# ╟─560e72fe-f816-41f3-9d01-e7d0ef4a8cb4
# ╟─1376e940-0024-42c7-8c81-bf027afc6e6a
# ╟─223b825a-4064-4c4a-b3f1-ada438f25286
# ╟─f6d4c42c-a074-4f9b-98f5-e5f40a88e03a
# ╠═6c6af3c9-66e5-4735-a891-16cde6bf3f2b
# ╟─3de00a00-fee4-4611-8a13-0c0ee6c736c2
# ╟─e022b698-e9cf-44c4-aeb4-8ad2245ed5aa
# ╟─6f6b5a36-05c9-4624-bc6a-135e5b6d7ba6
# ╟─351f2247-485e-4850-84b6-1c03dd381bc4
# ╟─98ffd713-b851-4bca-8e20-99e21cd42561
# ╟─a2641d70-f16c-45e2-9aa6-6a880a9c2bad
# ╟─5a240502-4e3d-4dae-a53b-5428c21e0237
# ╟─4932c69b-6536-4067-9d87-6b1bfe34cac8
# ╟─f2776549-3b8f-4a11-b500-53276c252fce
# ╟─b2fa9b87-0387-4c1a-baba-cd756568d4d7
# ╟─134a3f92-1475-4c1d-ad7d-bf00ba9291d7
# ╟─cc592fff-c25b-4e66-960d-6b18f445c352
# ╟─add07024-b7eb-445d-b4f4-6a6757c2ecd3
# ╟─bfb890be-fba4-4d55-9e39-a52d40a5adad
# ╟─3df87bac-8e0f-4a9a-8c98-69b96cee9f6c
# ╟─40f34f88-3d33-4557-831e-22607f3682f7
# ╟─3aad82ff-baa4-48d5-aa66-51344c754421
# ╟─de9f98b3-8ec8-4c25-9cff-26654b3b7d44
# ╠═90a1f7b0-492e-4f3d-8e06-d2f4092ed93f
# ╟─1400248d-3455-4b89-bfb1-64addeeba799
# ╟─c7a08720-2e79-47e0-8895-da38047b2acf
# ╟─52b6eb6e-1566-4e0f-b787-404cdc5f9edb
# ╟─8ae18d1b-dcd1-43f4-828e-63dab4373091
# ╟─43da915a-3bb0-424d-b841-221f0fd64575
# ╠═356367d5-9127-4a93-bda0-9c7ff1efe9f8
# ╠═18ee1822-e759-4944-9a67-326bb3f3ded2
# ╟─61f40209-b582-493a-bb59-07dbe12b8067
# ╟─920b681a-bd29-4f33-829c-ee4d2f704318
# ╟─20efbdb4-1045-4d36-92f3-84001783fcad
# ╠═721d6272-60d4-449a-bfcb-55cfc66230f0
# ╟─6b3b1bd8-0ef4-440b-a913-654ae02a75dd
# ╟─4c9e3c52-771a-4601-9dbc-0c267f432c2f
# ╟─d755c827-494d-47f1-b43b-32e20b45e97b
# ╟─279bd6a5-fdb6-4253-a99d-1dfd781fe726
# ╟─154e4eb9-1c8d-4241-ba51-6ca649d57f54
# ╟─49b6eac5-e635-48a5-8938-6688ad47ff5d
# ╟─5391f561-1b1e-40c9-a333-a34bd55c82ec
# ╟─ed446d9d-27be-4f0d-b7dd-5046174bc425
# ╟─b6a765be-7bd6-486a-95bb-8361c1a4f818
# ╟─2ff5976d-b8b6-43c5-b2ae-1c8855d309f1
# ╟─5bee3291-9ec8-4761-b732-352c460e474a
# ╟─2de00e18-ed34-477c-a3f8-4b67baf2b112
# ╟─5e6d3a85-a715-4e38-a7f7-962b7bef40c3
# ╠═21c0779a-ff1d-47d2-9736-57486457ce53
# ╟─eff3b751-4671-4f0d-88c9-e51f969d53b4
# ╟─c767240a-136b-4725-8120-50d96a5c2fa8
# ╟─4208af03-d240-4936-9851-9f124b35d738
# ╟─408e4904-84be-478c-a1f7-40f1e5fd4e8c
# ╟─57083988-9a53-45e4-bac3-8844077aeed0
# ╟─cb5946f9-4901-40e4-ad2e-da4e058b7df3
# ╟─da593bbf-b3f5-42f8-aca3-52115e8a7703
# ╟─4e2541f6-dd41-49d9-a8bc-62d07ce13bbf
# ╟─5773b804-b89c-4254-9bbf-1759eff1f0ba
# ╟─ca46c228-8321-4f79-85e0-05a2c4fc000d
# ╟─2040bb61-81f9-4c16-8ba3-9ec419dbce31
# ╟─5b1860bb-30e7-485d-b643-30222c8f4ce0
# ╟─febd8e59-417f-4190-9814-9115abef99f9
# ╟─49313d24-84e6-43a8-9e31-040d84e6bf62
# ╟─1ccaf9c4-c972-4877-bfa8-a49cc126ca6a
# ╟─a414e917-e746-434f-b26e-3dfff16bd9a1
# ╟─6bd27e4a-0f32-45ca-9b2a-4e2eecb22071
# ╟─f35219aa-0dc5-4e92-8ce9-85b1bfa72998
# ╠═f9e5a05d-1f88-4579-9d28-596f3bd672e0
# ╠═ff46bc55-750c-4ea9-a934-3b01cf046a8d
# ╠═a4e3d715-8e01-48de-8127-3edd6bd278c0
# ╠═4877135b-3d4b-43c2-a34e-f1ed68955406
# ╠═1feff701-2a76-494e-a822-935bb436986f
# ╠═bf22ae24-4cdd-460b-8664-ffbd62568e15
# ╟─ab42d6ff-6926-410d-993d-cd4e1cd99a21
# ╟─89cbc406-e188-4e59-98ed-1fd255d9a260
# ╟─437c44ae-bb54-4b31-975b-9924eb1e30cc
# ╠═9fa87191-7c90-4738-a45a-acd929c8bd1b
# ╟─a385a0ae-d2e0-4b4e-862c-e69ec5bd6843
# ╟─dde9a9f6-0013-401e-9081-8ef5d599d8ca
# ╟─e12d354f-3e41-4925-8ac7-e0b9f2203d27
# ╟─24dcd4c4-8655-4c1a-b86f-580c28c2ac49
# ╟─1f9c7f64-bd8d-4d26-89ea-bce5bf697247
# ╟─991002ef-4999-43eb-9370-dccc77eabea0
# ╟─4e75e662-f1af-43f0-ac1e-30459c1d0814
# ╟─32326d0c-7be1-40e5-aac8-ee60ab34e418
# ╟─be6cccff-4731-4eeb-9134-1f98b5942cc0
# ╟─59014736-a141-423b-8f27-243aadbc08b6
# ╟─fd131773-e508-4586-a6dc-1e22c8b6fe4f
# ╟─910927a2-47ae-40ff-b8cd-73ef2b5a93aa
# ╟─6274bc02-6c47-4a52-9b02-669ded01960d
# ╟─c6aea9b9-8cb2-4ccf-bd3c-034a702585e4
# ╟─25ada4af-7a6c-47ec-87b6-facd3ffd3e64
# ╟─9fe70f93-faca-4ea9-917b-8e594d78cdc3
# ╟─1eb1551d-491d-4955-9d2f-853a0971fb0c
# ╟─6cc8c3bd-5619-480e-9454-e9c64bad8689
# ╟─6d001dc9-5977-4b02-bcc2-1a2106ede495
# ╟─335c550f-fbd9-44e2-bc69-c13b54250a45
# ╟─b5b58aae-1a82-44bd-a9ca-31559ebbbe5e
# ╟─04421307-25ad-4bb3-a686-caeedc56dd61
# ╟─3ecd4946-8bee-4ed1-84dd-1f172d3adef4
# ╟─2807f3bd-4b64-437e-9e79-bfcbe9723e2a
# ╟─3c166b5a-11bf-4d40-a55e-6bf3f0f5e67d
# ╟─561b005d-6c30-47a3-8643-1aff26b907d8
# ╟─f906a80e-947e-4480-85f8-e4776ef9ea23
# ╟─48d62487-3673-499c-9a48-16b3be47b1e2
# ╟─bb95ec43-80db-408f-9b2d-954e43a6de02
# ╟─fb3975d0-da4d-4bc6-a413-753cf07f146e
# ╟─4de4ea24-606e-4110-b73e-b7ddce215ba1
# ╟─00000000-0000-0000-0000-000000000001
# ╟─00000000-0000-0000-0000-000000000002
