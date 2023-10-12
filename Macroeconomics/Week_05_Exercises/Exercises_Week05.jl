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

# ╔═╡ feb39810-13bf-4383-8184-9338111248cf
begin
	using PlotlyBase, HypertextLiteral, PlutoUI, PlutoPlotly
	using CSV, DataFrames, PeriodicalDates, Dates
	#import PlotlyJS:savefig
end

# ╔═╡ 15112ba0-cddf-11eb-07a3-2bcd9257c8d0
md"""
# Week 5 - Monetary Policy & Aggregate Demand
# Exercises

**Macroeconomics, ISCTE-IUL**

"""

# ╔═╡ 3cdf6437-0705-410c-8b0b-e8fc657897ed
md"""
**Vivaldo Mendes, Ricardo Gouveia-Mendes, Luís Clemente-Casinhas, October 2023**
"""

# ╔═╡ 409f9114-3fe1-4abe-8beb-ab279e9031b2
md"""
### Packages
"""

# ╔═╡ 6937b9af-1f25-4b10-8820-86f5db2f84e9
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

# ╔═╡ ced63ea2-60c8-4913-a5d4-9e1b5ff47223
md"""
____________________________________________________________________________________________________________
"""

# ╔═╡ 6571612f-00ad-4179-bb93-a48cc9804352
md"""
## Exercise 1. The Monetary Policy curve
"""

# ╔═╡ dac7fb80-10f7-4806-af0c-088637b79b69
md"""

Assume the monetary policy curve is given by:  $\quad r = 1.5 + 0.75 \pi$.

👉   **(a)** Calculate the real interest rate when the inflation rate is at 0%, 2%, and 4%.

👉   **(b)** The figure "MP Curve" presented below plots the monetary policy curve. What do the three dotted points tell us?

"""

# ╔═╡ f1a259ac-e3c3-457a-9111-5eab394f452f
md"""
---
"""

# ╔═╡ 0ba1252d-d891-4835-b81a-d63210f5c87b
md"""
Firstly, let us insert the values of $\bar{r}$ and $\lambda$ into the notebook (1 is used as an index to refer the exercise 1). 
"""

# ╔═╡ 3ced63a3-0e7a-4a7a-ae26-5e4edae88cac
r̄1 = 1.5 ;	λ1 = 0.75 ;

# ╔═╡ 6ea4d683-6825-4baa-bfe5-d8784f46420e
md"""
To answer question **(a)**, we can use a traditional calculator because the operations are extremely simple. However, it is much easier and faster to use a simple function inside the notebook, as we illustrate next:
"""

# ╔═╡ f1acdec8-d55b-4b12-9b67-84c47be9378e
begin
	r(π) = r̄1 .+ λ1 .* π 			# This function looks the same as in its mathematical form
	π = [0 , 2 , 4] 				# Attributing values to π
	r(π) 							# Asking for the output 
end

# ╔═╡ ce89db42-eabe-4d30-8d0a-4b06ad04145a
md"""
!!! answer "Answer (a)"

	- For inflation rate of 0%, 2% and 4% the real interest name will be equal to 1,5%, 3% and 4,5%. Hence as infaltion goes up the real interest rate will also go up

"""

# ╔═╡ d38d5d7e-ef45-40e7-90c0-441fa4d30a24
begin
	r1 = 0.0:0.01:6.0
	
	π1 = - (r̄1 ./ λ1) .+  r1 ./ λ1 
	
	trace5_0 = scatter(; x = r1, y = π1, mode="lines" , line_color = "Brown", line_width = "3",
					name  = "MP")
	
	trace5_1 = scatter(; x = [1.5, 3.0, 4.5], y = [0.0, 2.0, 4.0], text =["1", "2" , "3"], 
					textposition = "top center", name ="Eq.", mode="markers+text", marker_size= "12",
					marker_color="Brown", textfont = attr(family="sans serif", size=16, color="black"))
	
	layout5_1 = Layout(;
					title_text ="MP curve", 
					title_x = 0.5,
					hovermode ="x",
                    xaxis=attr(title=" Real interest rate (r)", showgrid=true, zeroline=false),
                    xaxis_range = [-0.1, 6.0],
					yaxis_range = [-2.0, 6.0],
                    yaxis=attr(title="Rate of inflation (π)", zeroline = false))

   p5_1 = Plot([trace5_0, trace5_1], layout5_1)
end

# ╔═╡ 0120645b-0386-4fdd-b7fd-ace3f58c2d4d
md"""
!!! answer "Answer (b)"

	- as infaltion goes up the real interest rate will also go up. 

"""

# ╔═╡ 9690a57f-245b-4c2b-8ddc-0c9ef6b33ee8
md"""
____________________________________________________________________________________________________________
"""

# ╔═╡ 1b35a949-7c83-4d64-aa69-90b42c5dfbfb
md"""
## Exercise 2. A shift in the Monetary Policy curve
"""

# ╔═╡ 5235a517-8947-4d57-a436-c48eb3de87c6
md"""
Refer to the monetary policy curve described in Problem 1. Assume now that the monetary policy curve is given by $r = 2.5 + 0.75 \pi$.

👉   **(a)** In the current exercise, does the central bank dislike inflation more or less than in the previous exercise?

👉   **(b)** Using the slider below, plot the new monetary policy curve on the graph created in Problem 1.

👉   **(c)** Does the new monetary policy curve represent an autonomous tightening or loosening of monetary policy?

"""

# ╔═╡ aa6e1a71-1cc4-4ddc-b080-11de86462656
md"""
!!! answer "Answer (a)"

	- Since the value for lambda didnt change (0,75) the central bank dislike of inflation stays the same

"""

# ╔═╡ 6bf1aae8-5d3a-4aa2-b01c-d633602f3c55
md"""
`r̄2 = ` $(@bind r̄2 Slider(0.0:0.5:3.0, default=1.5, show_value=true))     
"""

# ╔═╡ 0fd242c3-a99f-41b3-a5ed-1c92f6d3b600
begin	
	π2_Δr̄2 = - (r̄2 ./  λ1) .+  r1 ./ λ1 
			
	trace5_2 = scatter(; x = r1, y = π2_Δr̄2, mode="lines" , line_color = "Purple", line_width = "3",
					 name  = "MP2")
	
	trace5_3 = scatter(; x = [1.5, 3.0, 4.5], y = [-4/3, 2/3, 8/3], text =["1''", "2''" , "3'"], 
					 textposition = "top center", name ="Eq.", mode="markers+text", 
					 marker_size= "12", marker_color="Purple", 
					 textfont = attr(family="sans serif", size=16, color="black"))
	
	trace5_4 = scatter(; x = [2.5, 4.0, 5.5], y = [0.0, 2.0, 4.0], text =["1'", "2'" , "3'"], 
					 textposition = "top center", name ="Eq.", mode="markers+text", 
					 marker_size= "12", marker_color="Purple", 
					 textfont = attr(family="sans serif", size=16, color="black"))
	
	layout5_4 = Layout(;
					title_text ="MP curve", 
					title_x = 0.5,
					hovermode = "x",
                    xaxis=attr(title=" Real interest rate (r)", showgrid=true, zeroline=false),
                    xaxis_range = [-0.1, 6.0],
					yaxis_range = [-2.0, 6.0],
                    yaxis=attr(title="Rate of inflation (π)", zeroline = false))

	p5_4 = Plot([trace5_2, trace5_4, trace5_0, trace5_1], layout5_4)
end

# ╔═╡ 4c2622b9-191f-4e38-b5f4-c0eece8cb7af
md"""
!!! answer "Answer (b)"

	- r̄ increases from 1,5 to 2,5 and the MP curve shifts to the right. For any level of inflation rate the real interest rate will be higher by 1 percentage point (p.p.)

"""

# ╔═╡ 559be550-e0b0-4cd4-bd16-f7757bb190cb
md"""
!!! answer "Answer (c)"

	- for  any level of inflation rate, the real interest rate is now higher, becasue the central bank is more agresive in the fight with infaltion

"""

# ╔═╡ 39562a1b-7a97-4ccd-b57c-9fb4bb15ba65
md"""
____________________________________________________________________________________________________________
"""

# ╔═╡ 85981e5d-1519-4dca-8739-4023e58a0176
md"""
## Exercise 3. A comprehensive exercise
"""

# ╔═╡ b9a1a968-24f3-4a92-8341-614bf5a7e0ca
md"""
The following information is known about the aggregate demand and the central bank's behavior:
- Autonomous aggregate demand: $\overline{A} = 7.6$
- The multiplier: $m= 2.0$
- The impact of $r$ upon aggregate demand: $\phi=0.2$
- The MP curve is given by: 

$$r=\overline{r}+\lambda \pi$$
with $\overline{r}=2\%$ and $\lambda = 0.5$. Take into account that the value $2\%$ is expressed in percentage points, so that $2\%$ is just $2$. Answer the questions below, but firstly, let us insert the values of the parameters and exogenous variables into the notebook:

"""

# ╔═╡ 22e8290e-c39f-41e2-94e5-d9c3b1585d88
Ā3 = 7.6 ;	λ3 = 0.5 ;	m3 = 2.0 ;	ϕ3 = 0.2 ;	r̄3 = 2.0 ;	

# ╔═╡ 677c0bcf-d948-4576-b401-85800ddcdf45
md"""
👉   **(a)** In the MP curve above, which macroeconomic variables are endogenous? And exogenous? What is λ?

"""

# ╔═╡ 9dac47b5-9c11-40b0-8dba-427f264b43d6


# ╔═╡ 0a6c8121-db33-45cb-8e99-35091d20ed96
md"""
!!! answer "Answer (a)"

	- endogenous: $\phi$ and r, because they are computed insed the model, they depend on the functioning of the economy
	- exogenous: variable is $\overline{r}$ becasue we can not control it, the value is given to us. $\lambda$ i a parametr, higher then 0 that represents the dislike of central bank for inflation 

"""

# ╔═╡ cb3af05d-f5ee-4313-8cd8-959930cf2749
md"""
👉   **(b)** Obtain the expression of the AD curve.
"""

# ╔═╡ 3556cde6-e9b0-4dab-a8ae-dbc24f524b22
md"""
!!! hint

	Recall the IS curve:

	$$\tag{IS} Y=m \cdot \overline{A}-m \cdot \phi \cdot r$$

	Recall the MP curve: 

	$$\tag{MP} r=\overline{r}+\lambda \pi$$

	The AD curve is obtained by inserting the MP curve into the IS curve.

"""

# ╔═╡ ebb43969-4b22-4e8e-8694-6b47a8726b86
md"""
!!! answer "Answer (b)"

	- we need to get IS = MP
	- Y = m$\overline{A}$ - m$\phi$( $\overline{r}$+$\lambda\phi$ )
	- Y = 2 * 7,6 - 2 * 0,2 * (2 + 0,5$\phi$)

"""

# ╔═╡ b20800ee-7d04-4e15-9aa0-d86aca961461
md"""
👉   **(c)** The MP and the AD curves are represented graphically below. If inflation is $2\%$, what is the level of aggregate demand and the real interest rate set by the central bank?

"""

# ╔═╡ 280f3cc5-0a2b-4cd3-bcfb-cba536877019
md"""
!!! answer "Answer (c)"

	Here

"""

# ╔═╡ 91a1906c-f969-4265-911c-2dfab3bf35bf
md"""

👉   **(d)** The figure below presents two points: 1 and 2. How do you explain the movement from points 1 to 2?
"""

# ╔═╡ 5bbebe42-69cd-474a-ad1a-8599fed108be
md"""
!!! answer "Answer (d)"

	Here

"""

# ╔═╡ 4cd62077-945d-4b33-af50-739612c29410
md"""

👉   **(e)** What is the value of the nominal interest rate at both points above? Is the Taylor principle satisfied in this exercise?

"""

# ╔═╡ fd292c9b-ed3e-4f91-aea6-4142e429163a
md"""
!!! answer "Answer (e)"

	Here

"""

# ╔═╡ 5c2e6ae3-cfda-4653-8e47-b6dc018129b5
md"""
👉   **(f)** Consider the central bank is losing control of the inflationary pressures in the economy. It takes a drastic measure by increasing $\overline{r}%$ to $3\%$. What happens to the MP and AD curves? Using the slider `Δr̄3` below, represent graphically.
"""

# ╔═╡ 1fb6c731-ff80-41fd-b866-0db9ad4ec361
md"""
`Δr̄3 = ` $(@bind Δr̄3 Slider(-2.0:0.25:2.0, default=0.0, show_value=true))     
"""

# ╔═╡ 5fe68e9d-3ff2-495e-b844-649e273ce758
md"""
!!! answer "Answer (f)"

	Here

"""

# ╔═╡ 0f86d6fa-bdd4-4018-b3af-39e0bb1288f7
md"""
____________________________________________________________________________________________________________
"""

# ╔═╡ 96c81523-b9b1-46a5-9880-a4152e097a58
md"""
## Exercise 4. Interest rates & the ECB
"""

# ╔═╡ 6cdba781-6a44-496f-869a-f6c83208b49b
md"""
Below, we can find an extract of the speech by Christine Lagarde (the President of the European Central Bank: ECB), delivered at a Press Conference on 2 February 2023 [link here], where she announced the decisions made by the Board regarding big increases in short term interest rates.(https://www.ecb.europa.eu/press/pr/date/2023/html/ecb.mp230202~08a972ac76.en.html)

"""

# ╔═╡ a5de4a7b-5768-49d7-b273-97b929f38d95
md"""
>“The Governing Council will stay the course in raising interest rates significantly at a steady pace and in keeping them at levels that are sufficiently restrictive to ensure a timely return of inflation to our two per cent medium-term target. Accordingly, the Governing Council today decided to raise the three key ECB interest rates by 50 basis points and we expect to raise them further. In view of the underlying inflation pressures, we intend to raise interest rates by another 50 basis points at our next monetary policy meeting in March and we will then evaluate the subsequent path of our monetary policy." 
👉 In your opinion, why is the President of the ECB so committed to raising interest rates by a significant amount?
"""

# ╔═╡ b7708560-0101-447d-9a31-0aae4ede8310
md"""
!!! tip "Answer"

	Here

"""

# ╔═╡ 6537fb39-c597-41ca-8b65-2d2912b0234a
md"""
## Exercise 5. Increases in aggregate demand
"""

# ╔═╡ a1dc0363-8871-49d9-afc8-16a2660ae5c3
md"""
*Fom the textbook*

What would be the effect on the aggregate demand curve of a large increase in U.S. net exports, or in public expenditures? Would any of those increases affect the monetary policy curve? Explain why or why not.
"""

# ╔═╡ 4cc6e64e-4858-4f2a-b363-e7619c060bf8
md"""
!!! answer

	Here
"""

# ╔═╡ b99a4854-6671-4296-99b9-977af285812b
md"""
____________________________________________________________________________________________________________
"""

# ╔═╡ e2bd0872-89de-4532-9be1-4b39c241133b
md"""
## Exercise 6. Monetary policy and employment
"""

# ╔═╡ 51b3a17c-2454-4cff-a1cc-a2f27d047f91
md"""

*From the textbook.*


Suppose U.S. aggregate output is still below potential by 2018, when a new Fed chair is appointed. Suppose his/her approach to monetary policy can be summarized by the following statement: “I care only about increasing employment; inflation has been at very low levels for quite some time; my priority is to ease monetary policy to promote employment.”

👉   **(a)** Would you expect the monetary policy curve to shift upward or downward?

👉   **(b)** What would be the effect on the aggregate demand curve?
"""

# ╔═╡ c7aea695-1c23-4abd-86a7-bcefce643898
md"""
!!! tip "Answer (a)"

	Here

"""

# ╔═╡ 20b428c4-f680-45b0-af4d-f05fc5aea5bf
md"""
!!! tip "Answer (b)"

	Here

"""

# ╔═╡ a71621ac-f4f6-4b54-8486-b7bdaa8d29ef
md"""
____________________________________________________________________________________________________________
"""

# ╔═╡ 747b89f4-fd33-4fc6-bd24-83b8860a5a5e
md"""
## Exercise 7. The twin goals of monetary policy
"""

# ╔═╡ b293a9cc-6c2e-4e8d-9445-9d377b83f676
md"""
*From the textbook "Macroeconomics", Fourth Edition, by Charles I. Jones, 2018, Pearson.*

Your day as chair of the Fed (I): Suppose you are appointed to chair the Federal Reserve. Your twin goals are to maintain low inflation and to stabilize economic activity — that is, to keep GDP at potential. Why are these appropriate goals for monetary policy? (Hint: What happens if the economy booms? Or in a deep recession?)

"""

# ╔═╡ b8c26c04-3448-4e47-8fb6-9ba6f13ab210
md"""
!!! answer

	Here

"""

# ╔═╡ 4ae438b1-0752-411f-ae55-52479f518c57
md"""
____________________________________________________________________________________________________________
"""

# ╔═╡ d04e8abb-ae8e-4297-9734-533d9274274e
md"""
## Exercise 8. Large shocks and monetary policy
"""

# ╔═╡ 94b9b913-2a22-4960-992a-699f18954be2
md"""
*Adapted from the textbook "Macroeconomics", Fourth Edition, by Charles I. Jones, 2018, Pearson.*

Your day as chair of the Fed (II): With the goal of **stabilizing output**, explain how and why you would change the real interest rate in response to the following large shocks. Describe what happens in the short run using the AD-MP diagram (no need to use numerical simulations)

👉   **(a)** Consumers become extremely pessimistic about the state of the economy and future productivity growth.

"""

# ╔═╡ fa4ae288-aa26-4cc8-9edd-f0ed9bdf71e4
md"""
!!! tip "Answer (a)"

	Here

"""

# ╔═╡ 3fceb728-e48e-41c5-8c26-ad158aa484d2
md"""
👉   **(b)** Improvements in information technology increase productivity and therefore increase the marginal product of capital (MPK).

"""

# ╔═╡ c6adfe92-4021-4b79-a480-5a5f490fd7e7
md"""
!!! tip "Answer (b)"

	Here

"""

# ╔═╡ 74385e49-c758-4a82-8c66-220c2f39902d
md"""

👉   **(c)** A booming economy in Europe leads to an unexpected increase in the demand for U.S. goods by European consumers.

"""

# ╔═╡ 35867d12-4044-4097-9dc9-55abdc8dcea8
md"""
!!! tip "Answer (c)"

	Here

"""

# ╔═╡ 0b1c0b50-c54f-4603-8868-196990c92e0e
md"""
👉   **(d)** A housing bubble bursts, so that housing prices fall by 20% and new home sales drop sharply.
"""

# ╔═╡ 9f57850a-d036-42e2-815f-c6935826fbb2
md"""
!!! tip "Answer (d)"

	Here

"""

# ╔═╡ 7a82dcaf-b775-479a-94be-23a957ff0d9d
md"""
## Exercise 9. UK Mini-Budget & Budget Responsability
"""

# ╔═╡ 97a132ae-a371-4449-a4bd-e2ce469cffca
md"""
Illustration by Chris Riddell
"""

# ╔═╡ 48a35af0-ab1d-4e6b-a195-0d3d885b5652
Resource("https://vivaldomendes.org/images/depot/tax_cuts.webp", :width=>600)

# ╔═╡ 8b8bdbd0-6148-4a9d-b2e1-d6625cb84ac4
md"""
With an inflation rate of 9.9% (the highest in more than forty years), a long and brutal war in Europe, and energy markets in turmoil, last September the UK government promised “a new approach for a new era”. On 23 September 2022, the government announced the highest unfunded tax cuts and massive increases in public spending in more than half a century. The reaction of markets, international institutions, and commentators was dismayed.

>"The IMF said fiscal stimulus is inappropriate given the inflation pressures in the UK economy, and the package risks making life harder for the Bank of England. Moody’s forecast that it will lower economic growth -- contradicting the view from Chancellor of the Exchequer Kwasi Kwarteng -- by pushing up interest rates. ", Bloomberg, 27 September 2022

Using the concepts of aggregate demand (AD curve) and the MP curve, why does the plan by the UK government look "on a course of sheer madness", as Ambrose Evans-Pritchard has put in The Telegraph, 29 September 2022?

"""

# ╔═╡ cef3ec74-5394-494c-af80-a29f469abe8e
md"""
!!! answer "Suggested answer"

	Before the fiscal stimulus package was announced, the Bank of England (BoE) had already aggressively raised interest rates. It was expected to continue to do so for the time coming because inflation was very high and displaying an upward trend. That package will put more inflationary pressures on the economy, forcing the central bank to raise rates much more than expected. 

	The UK government is forcing the AD curve to take a big jump to the right, increasing demand and GDP. However, because inflation was very high, the BoE had already aggressively raised interest rates, so the MP curve moved to the right to reduce aggregate demand and inflation. By this action, the BoE is trying to force the AD curve to shift to the left, and now they have to do it even more aggressively than initially expected. 

	There was also an extremely adverse reaction by the markets: the pound hit a record low against the dollar after the sweeping tax cuts were announced, and the yields on the UK public debt suffered a dramatic increase forcing the BoE to intervene. Both reactions will force the BoE to raise interest rates much higher than would otherwise be required. Instead of GDP growth, a recession should be the outcome.

"""

# ╔═╡ d4b320e8-b03a-4f44-b842-f7f6bc4724b9
md"""
____________________________________________________________________________________________________________
"""

# ╔═╡ 2c7c6904-52cd-459b-b459-daf6bdb4f91d
md"""
## Exercise 10. A very simple problem
"""

# ╔═╡ 40979b66-ab86-45ac-8102-64704d8bd613
md"""

*From the textbook.*

Suppose the monetary policy curve is given by $r = 1.5 + 0.75 \pi$, and the IS curve is given by $Y = 13 - r$.

(a) Find the expression for the aggregate demand curve.

(b) Calculate aggregate output when the inflation rate is at 2%, 3%, and 4%.

"""

# ╔═╡ 602a7f0f-6b1b-445c-8d3c-0887f858b1e0
md"""
!!! answers

    **(a)** From a numerical point of view, this is a very easy problem to solve. AD:  $Y = 11.5 - 0.75 \pi$.

	**(b)** This is extremely easy, so ... (if you want to use Julia, see Exercise 1)

	"""

# ╔═╡ 81c00071-63c2-48ff-96a9-b3ebcf8cc44f
md"""
____________________________________________________________________________________________________________
"""

# ╔═╡ fd4a0888-c180-4f68-98e2-40061bc27354
md"""
## Auxiliary cells (do not delete)
"""

# ╔═╡ e0a35f3d-82d5-4315-ae83-27329529cf15
html"""<style>
main {
    max-width: 950px;
    align-self: flex-start;
    margin-left: 100px;
}
"""

# ╔═╡ 18195c33-8d9e-431f-936b-b439a8b840a8
TableOfContents()

# ╔═╡ 31068d0a-0945-49a3-8c72-7a5ebb288db2
md"""
##### Exercise 4: supporting cells
"""

# ╔═╡ 1d1f906f-a672-4a0f-a35c-db1dfb0763fc
begin

	function fig_3b1()
		
		r3 = 1.5:0.01:7.0
	
		π3 = - (r̄3 ./ λ3) .+  r3 ./ λ3
	
		trace5_5 = scatter(; x = r3, y = π3, mode="lines" , line_color = "Brown", line_width = "3",
					name  = "MP")
	
		layout5_5 = Layout(;
					title_text ="MP curve", 
					title_x = 0.5,
					hovermode = "x",
                    xaxis=attr(title=" Real interest rate (r)", showgrid=true, zeroline=false),
                    xaxis_range = [1.5, 6.5],
                    yaxis=attr(title="Rate of inflation (π)", zeroline = false),
					yaxis_range=[-1 ,9])

   		p5_5 = Plot([trace5_5], layout5_5)
		
	end
	#fig_3b1()
end

# ╔═╡ 89be032b-c88d-4de8-9f66-4acbdd3dec3d
begin
	function fig_3b2()
		
		Y3 = 12.0:0.01:14.6
		πdmax3 = (Ā3 / (λ3 * ϕ3)) - r̄3/λ3 		# The AD curve y-axis intercept 
	
		πd3 = πdmax3 .- ((1 ./(m3 .* ϕ3 .* λ3)) .* Y3)
	
		trace5_6 = scatter(; x = Y3, y = πd3, mode="lines" , line_color = "Blue", line_width = "3",
					name  = "AD")
	
	
		layout5_6 = Layout(;
					title_text ="AD curve", 
					title_x = 0.5,
					hovermode = "x",
                    xaxis=attr(title=" GDP (Y)", showgrid=true, zeroline=false),
                    xaxis_range = [12.6, 14.6],
                    yaxis=attr(title="Rate of inflation (π)", zeroline = false),
					yaxis_range=[-1 ,9])

   		p5_6 = Plot([trace5_6], layout5_6)
	end
	#fig_3b2()
		
end

# ╔═╡ 4e65d2d8-c706-4a65-92ad-477e17ad39cb
begin
	p5_6A = [fig_3b1() fig_3b2()]
	relayout!(p5_6A, hovermode = "y")
	p5_6A
end

# ╔═╡ 0d3c51a2-892b-4db1-a2af-fcddb75ef635
begin
	
	function fig_3c1()
		
		r3 = 1.5:0.01:7.0
		π3 = - (r̄3 ./ λ3) .+  r3 ./ λ3
	
		trace5_7 = scatter(; x = r3, y = π3, mode="lines" , line_color = "Brown", line_width = "3",
					name  = "MP")
	
		trace5_8 = scatter(; x = [3.0 , 4.0], y = [2.0 , 4.0], text =["1", "2"], 
					textposition = "top center", name ="Eq.", mode="markers+text", marker_size= "12",
					marker_color="Brown", textfont = attr(family="sans serif", size=16, color="black"))
	
	
		layout5_8 = Layout(;
					title_text ="MP curve", 
					title_x = 0.5,
					hovermode = "x",
                    xaxis=attr(title=" Real interest rate (r)", showgrid=true, zeroline=false),
                    xaxis_range = [1.5, 6.5],
                    yaxis=attr(title="Rate of inflation (π)", zeroline = false),
					yaxis_range=[-1 ,9])

   		p5_8 = Plot([trace5_7, trace5_8], layout5_8)
	end
	#fig_3c1()
end

# ╔═╡ 1a055e0b-d23e-4d85-89bf-5813127e88ec
begin

	function fig_3c2()
		
		Y3 = 12.0:0.01:14.6

		πdmax3 = (Ā3 / (λ3 * ϕ3)) - r̄3/λ3 		# The AD curve y-axis intercept 

		πd3 = πdmax3 .- ((1 ./(m3 .* ϕ3 .* λ3)) .* Y3)
	
		trace5_9 = scatter(; x = Y3, y = πd3, mode="lines" , line_color = "Blue", line_width = "3",
					name  = "AD")
	
		trace5_10 = scatter(; x = [14.0 , 13.6], y = [2.0 , 4.0], text =["1", "2"], 
					textposition = "top center", name ="Eq.", mode="markers+text", marker_size= "12",
					marker_color="Blue", textfont = attr(family="sans serif", size=16, color="black"))
	
	
		layout5_10 = Layout(;
					title_text ="AD curve", 
					title_x = 0.5,
					hovermode = "x",
                    xaxis=attr(title=" GDP (Y)", showgrid=true, zeroline=false),
                    xaxis_range = [12.6, 14.6],
                    yaxis=attr(title="Rate of inflation (π)", zeroline = false),
					yaxis_range=[-1 ,9])

   		p5_10 = Plot([trace5_9, trace5_10], layout5_10)
	end

	#fig_3c2()
		
end

# ╔═╡ bb50e179-3e60-4fab-9be4-3b56f254c710
begin
	p5_10A = [fig_3c1() fig_3c2()]
	relayout!(p5_10A, hovermode = "x")
	p5_10A
end

# ╔═╡ 4a4d51cb-8626-4d97-91aa-c4ce37b0a210
begin
	
	function fig_3e1()
		
		r3 = 1.5:0.01:7.0
		π3 = - (r̄3 ./ λ3) .+  r3 ./ λ3
		r3_Δr̄3 = 1.5:0.01:7.0
		π3_Δr̄3 = - ((r̄3 .+ Δr̄3) ./ λ3) .+  r3 ./ λ3

		trace5_7 = scatter(; x = r3, y = π3, mode="lines" , line_color = "Brown", line_width = "3",
					name  = "MP")
		
		trace5_8 = scatter(; x = [3.0 , 4.0], y = [2.0 , 4.0], text =["1", "2"], 
					textposition = "top center", name ="Eq.", mode="markers+text", marker_size= "12",
					marker_color="Brown", textfont = attr(family="sans serif", size=16, color="black"))
	
		trace5_11 = scatter(; x = r3_Δr̄3, y = π3_Δr̄3, mode="lines" , line_color = "Purple", 
					line_width = "3", name  = "MP1")
	
		trace5_11A = scatter(; x = [4.0 , 5.0], y = [2.0 , 4.0], text =["1'", "2'"], 
					textposition = "top center", name ="Eq.", mode="markers+text", marker_size= "12",
					marker_color="Purple", textfont = attr(family="sans serif", size=16, color="black"))
	
		layout5_11 = Layout(;
					title_text ="MP curve", 
					title_x = 0.5,
					hovermode = "x",
                    xaxis=attr(title=" Real interest rate (r)", showgrid=true, zeroline=false),
                    xaxis_range = [1.5, 6.5],
                    yaxis=attr(title="Rate of inflation (π)", zeroline = false),
					yaxis_range=[-1 ,9])

   		p5_11 = Plot([trace5_11, trace5_7, trace5_11A, trace5_8], layout5_11)
		
	end
	
	#fig_3e1()
end

# ╔═╡ f091ac64-be2c-4cc8-a7d3-34abde9fd5d4
begin
	function fig_3e2()
		
		Y3_Δr̄3 = 12.0:0.01:14.6

		πdmax3 = (Ā3 / (λ3 * ϕ3)) - r̄3/λ3 		# The AD curve y-axis intercept
	
		Y3 = 12.0:0.01:14.6

		πd3 = πdmax3 .- ((1 ./(m3 .* ϕ3 .* λ3)) .* Y3)

		πdmax3_Δr̄3 = (Ā3 / (λ3 * ϕ3)) - (r̄3 + Δr̄3) / λ3
		
		πd3_Δr̄3 = πdmax3_Δr̄3 .- ((1 ./(m3 .* ϕ3 .* λ3)) .* Y3_Δr̄3)

		trace5_9 = scatter(; x = Y3, y = πd3, mode="lines" , line_color = "Blue", line_width = "3",
					name  = "AD")

		trace5_10 = scatter(; x = [14.0 , 13.6], y = [2.0 , 4.0], text =["1", "2"], 
					textposition = "top center", name ="Eq.", mode="markers+text", marker_size= "12",
					marker_color="Blue", textfont = attr(family="sans serif", size=16, color="black"))
	
		trace5_12 = scatter(; x = Y3_Δr̄3 , y = πd3_Δr̄3, mode="lines" , line_color = "Violet", 
					line_width = "3", name  = "AD2")
	
		trace5_12A = scatter(; x = [13.6 , 13.2], y = [2.0 , 4.0], text =["1'", "2'"], 
					textposition = "top center", name ="Eq.", mode="markers+text", marker_size= "12",
					marker_color="Violet", textfont = attr(family="sans serif", size=16, color="black"))
		
		layout5_12 = Layout(;
					title_text ="AD curve", 
					title_x = 0.5,
					hovermode = "x",
                    xaxis=attr(title=" GDP (Y)", showgrid=true, zeroline=false),
                    xaxis_range = [12.6, 14.6],
                    yaxis=attr(title="Rate of inflation (π)", zeroline = false),
					yaxis_range=[-1 , 9])

   		p5_12 = Plot([trace5_12, trace5_9, trace5_12A, trace5_10], layout5_12)

	end

	#fig_3e2()
	
end

# ╔═╡ 51818620-e43c-4db4-813b-ed5c4562b62c
begin
	p5_12A = [fig_3e1() fig_3e2()]
	relayout!(p5_12A, hovermode = "x")
	p5_12A
end


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

[compat]
CSV = "~0.10.11"
DataFrames = "~1.6.1"
HypertextLiteral = "~0.9.4"
PeriodicalDates = "~2.0.0"
PlotlyBase = "~0.8.19"
PlutoPlotly = "~0.3.9"
PlutoUI = "~0.7.52"
"""

# ╔═╡ 00000000-0000-0000-0000-000000000002
PLUTO_MANIFEST_TOML_CONTENTS = """
# This file is machine-generated - editing it directly is not advised

julia_version = "1.9.3"
manifest_format = "2.0"
project_hash = "2cdf7dd086942bb33ef3c73e190cb54b783bfcf5"

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
git-tree-sha1 = "67c1f244b991cad9b0aa4b7540fb758c2488b129"
uuid = "35d6a980-a343-548e-a6ea-1d62b119f2f4"
version = "3.24.0"

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
git-tree-sha1 = "8a62af3e248a8c4bad6b32cbbe663ae02275e32c"
uuid = "34da2185-b29b-5c13-b0c7-acf172513d20"
version = "4.10.0"
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
deps = ["Compat", "DataAPI", "DataStructures", "Future", "InlineStrings", "InvertedIndices", "IteratorInterfaceExtensions", "LinearAlgebra", "Markdown", "Missings", "PooledArrays", "PrecompileTools", "PrettyTables", "Printf", "REPL", "Random", "Reexport", "SentinelArrays", "SortingAlgorithms", "Statistics", "TableTraits", "Tables", "Unicode"]
git-tree-sha1 = "04c738083f29f86e62c8afc341f0967d8717bdb8"
uuid = "a93c6f00-e57d-5684-b7b6-d8193f3e46c0"
version = "1.6.1"

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
git-tree-sha1 = "fb28e33b8a95c4cee25ce296c817d89cc2e53518"
uuid = "65ce6f38-6b18-4e1d-a461-8949797d7930"
version = "1.0.2"
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
git-tree-sha1 = "36d8b4b899628fb92c2749eb488d884a926614d3"
uuid = "2dfb63ee-cc39-5dd5-95bd-886bf059d720"
version = "1.4.3"

[[deps.PrecompileTools]]
deps = ["Preferences"]
git-tree-sha1 = "03b4c25b43cb84cee5c90aa9b5ea0a78fd848d2f"
uuid = "aea7be01-6a6a-4083-8856-8a6e6704d82a"
version = "1.2.0"

[[deps.Preferences]]
deps = ["TOML"]
git-tree-sha1 = "00805cd429dcb4870060ff49ef443486c262e38e"
uuid = "21216c6a-2e73-6563-6e65-726566657250"
version = "1.4.1"

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

[[deps.StringManipulation]]
deps = ["PrecompileTools"]
git-tree-sha1 = "a04cabe79c5f01f4d723cc6704070ada0b9d46d5"
uuid = "892a3eda-7b42-436c-8928-eab12a02cf0e"
version = "0.3.4"

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
deps = ["DataAPI", "DataValueInterfaces", "IteratorInterfaceExtensions", "LinearAlgebra", "OrderedCollections", "TableTraits"]
git-tree-sha1 = "a1f34829d5ac0ef499f6d84428bd6b4c71f02ead"
uuid = "bd369af6-aec1-5ad0-b16a-f7cc5008161c"
version = "1.11.0"

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
# ╟─15112ba0-cddf-11eb-07a3-2bcd9257c8d0
# ╟─3cdf6437-0705-410c-8b0b-e8fc657897ed
# ╟─409f9114-3fe1-4abe-8beb-ab279e9031b2
# ╠═feb39810-13bf-4383-8184-9338111248cf
# ╟─6937b9af-1f25-4b10-8820-86f5db2f84e9
# ╟─ced63ea2-60c8-4913-a5d4-9e1b5ff47223
# ╟─6571612f-00ad-4179-bb93-a48cc9804352
# ╟─dac7fb80-10f7-4806-af0c-088637b79b69
# ╟─f1a259ac-e3c3-457a-9111-5eab394f452f
# ╟─0ba1252d-d891-4835-b81a-d63210f5c87b
# ╠═3ced63a3-0e7a-4a7a-ae26-5e4edae88cac
# ╟─6ea4d683-6825-4baa-bfe5-d8784f46420e
# ╠═f1acdec8-d55b-4b12-9b67-84c47be9378e
# ╟─ce89db42-eabe-4d30-8d0a-4b06ad04145a
# ╟─d38d5d7e-ef45-40e7-90c0-441fa4d30a24
# ╟─0120645b-0386-4fdd-b7fd-ace3f58c2d4d
# ╟─9690a57f-245b-4c2b-8ddc-0c9ef6b33ee8
# ╟─1b35a949-7c83-4d64-aa69-90b42c5dfbfb
# ╟─5235a517-8947-4d57-a436-c48eb3de87c6
# ╟─aa6e1a71-1cc4-4ddc-b080-11de86462656
# ╟─6bf1aae8-5d3a-4aa2-b01c-d633602f3c55
# ╟─0fd242c3-a99f-41b3-a5ed-1c92f6d3b600
# ╟─4c2622b9-191f-4e38-b5f4-c0eece8cb7af
# ╠═559be550-e0b0-4cd4-bd16-f7757bb190cb
# ╟─39562a1b-7a97-4ccd-b57c-9fb4bb15ba65
# ╟─85981e5d-1519-4dca-8739-4023e58a0176
# ╠═b9a1a968-24f3-4a92-8341-614bf5a7e0ca
# ╠═22e8290e-c39f-41e2-94e5-d9c3b1585d88
# ╟─677c0bcf-d948-4576-b401-85800ddcdf45
# ╠═9dac47b5-9c11-40b0-8dba-427f264b43d6
# ╠═0a6c8121-db33-45cb-8e99-35091d20ed96
# ╟─cb3af05d-f5ee-4313-8cd8-959930cf2749
# ╟─3556cde6-e9b0-4dab-a8ae-dbc24f524b22
# ╟─ebb43969-4b22-4e8e-8694-6b47a8726b86
# ╟─b20800ee-7d04-4e15-9aa0-d86aca961461
# ╟─4e65d2d8-c706-4a65-92ad-477e17ad39cb
# ╟─280f3cc5-0a2b-4cd3-bcfb-cba536877019
# ╟─91a1906c-f969-4265-911c-2dfab3bf35bf
# ╟─bb50e179-3e60-4fab-9be4-3b56f254c710
# ╟─5bbebe42-69cd-474a-ad1a-8599fed108be
# ╟─4cd62077-945d-4b33-af50-739612c29410
# ╟─fd292c9b-ed3e-4f91-aea6-4142e429163a
# ╟─5c2e6ae3-cfda-4653-8e47-b6dc018129b5
# ╟─1fb6c731-ff80-41fd-b866-0db9ad4ec361
# ╟─51818620-e43c-4db4-813b-ed5c4562b62c
# ╟─5fe68e9d-3ff2-495e-b844-649e273ce758
# ╟─0f86d6fa-bdd4-4018-b3af-39e0bb1288f7
# ╟─96c81523-b9b1-46a5-9880-a4152e097a58
# ╟─6cdba781-6a44-496f-869a-f6c83208b49b
# ╟─a5de4a7b-5768-49d7-b273-97b929f38d95
# ╟─b7708560-0101-447d-9a31-0aae4ede8310
# ╟─6537fb39-c597-41ca-8b65-2d2912b0234a
# ╟─a1dc0363-8871-49d9-afc8-16a2660ae5c3
# ╟─4cc6e64e-4858-4f2a-b363-e7619c060bf8
# ╟─b99a4854-6671-4296-99b9-977af285812b
# ╟─e2bd0872-89de-4532-9be1-4b39c241133b
# ╟─51b3a17c-2454-4cff-a1cc-a2f27d047f91
# ╟─c7aea695-1c23-4abd-86a7-bcefce643898
# ╟─20b428c4-f680-45b0-af4d-f05fc5aea5bf
# ╟─a71621ac-f4f6-4b54-8486-b7bdaa8d29ef
# ╟─747b89f4-fd33-4fc6-bd24-83b8860a5a5e
# ╟─b293a9cc-6c2e-4e8d-9445-9d377b83f676
# ╟─b8c26c04-3448-4e47-8fb6-9ba6f13ab210
# ╟─4ae438b1-0752-411f-ae55-52479f518c57
# ╟─d04e8abb-ae8e-4297-9734-533d9274274e
# ╟─94b9b913-2a22-4960-992a-699f18954be2
# ╟─fa4ae288-aa26-4cc8-9edd-f0ed9bdf71e4
# ╟─3fceb728-e48e-41c5-8c26-ad158aa484d2
# ╟─c6adfe92-4021-4b79-a480-5a5f490fd7e7
# ╟─74385e49-c758-4a82-8c66-220c2f39902d
# ╟─35867d12-4044-4097-9dc9-55abdc8dcea8
# ╟─0b1c0b50-c54f-4603-8868-196990c92e0e
# ╟─9f57850a-d036-42e2-815f-c6935826fbb2
# ╟─7a82dcaf-b775-479a-94be-23a957ff0d9d
# ╟─97a132ae-a371-4449-a4bd-e2ce469cffca
# ╟─48a35af0-ab1d-4e6b-a195-0d3d885b5652
# ╟─8b8bdbd0-6148-4a9d-b2e1-d6625cb84ac4
# ╟─cef3ec74-5394-494c-af80-a29f469abe8e
# ╟─d4b320e8-b03a-4f44-b842-f7f6bc4724b9
# ╟─2c7c6904-52cd-459b-b459-daf6bdb4f91d
# ╟─40979b66-ab86-45ac-8102-64704d8bd613
# ╟─602a7f0f-6b1b-445c-8d3c-0887f858b1e0
# ╟─81c00071-63c2-48ff-96a9-b3ebcf8cc44f
# ╟─fd4a0888-c180-4f68-98e2-40061bc27354
# ╠═e0a35f3d-82d5-4315-ae83-27329529cf15
# ╠═18195c33-8d9e-431f-936b-b439a8b840a8
# ╟─31068d0a-0945-49a3-8c72-7a5ebb288db2
# ╟─1d1f906f-a672-4a0f-a35c-db1dfb0763fc
# ╟─89be032b-c88d-4de8-9f66-4acbdd3dec3d
# ╟─0d3c51a2-892b-4db1-a2af-fcddb75ef635
# ╟─1a055e0b-d23e-4d85-89bf-5813127e88ec
# ╟─4a4d51cb-8626-4d97-91aa-c4ce37b0a210
# ╟─f091ac64-be2c-4cc8-a7d3-34abde9fd5d4
# ╟─00000000-0000-0000-0000-000000000001
# ╟─00000000-0000-0000-0000-000000000002
