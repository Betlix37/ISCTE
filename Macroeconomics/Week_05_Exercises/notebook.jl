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
	using PlotlyBase, HypertextLiteral, PlutoUI, PlutoPlotly
	using CSV, DataFrames , StatsBase
	using Dates, PeriodicalDates
	#import PlotlyJS:savefig
end

# ╔═╡ 943edb36-acc8-4b2a-94ab-c544f9eb279b
md"""
# Week 4 - The IS Curve

# Exercises

**Macroeconomics, ISCTE-IUL**
"""

# ╔═╡ 1245aef9-18ce-42f5-af82-c2e6cce70798
md"""
**Vivaldo Mendes, Ricardo Gouveia-Mendes, Luís Clemente-Casinhas; October 2023**
"""

# ╔═╡ 4618a663-f77e-4ccc-9b00-e84dbd5beb34
md"""
### Packages
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

# ╔═╡ 752abe33-497b-4c02-beca-dfc35ac81ea8
md"""
____________________________________________________________________________________________________________
"""

# ╔═╡ 9e05bc6e-a423-41c2-a236-41432276af88
md"""
## Exercise 1. Aggregate demand: basic concepts
"""

# ╔═╡ 72e235dd-e402-483b-9567-28fb05c364f8
md"""

*From the textbook.*

The Bureau of Economic Analysis valued nominal U.S. gross domestic product (i.e.,actual expenditure) at \$16,420 billion at the end of 2012. Suppose that consumption expenditure was \$12,210 billion, planned investment spending was \$1,680 billion, and government spending was \$2,970 billion.

"""

# ╔═╡ b8e14e1f-53ee-4851-9cc7-8e3f78c158f1
md"""
Answer the following questions, bu firstly, let us pass the available information into the noteboook. The number 1 in every single variable is used as an index to represent "exercise 1".
"""

# ╔═╡ 47e9dd59-a6f0-47b5-a31e-5c8967495c31
Y1 = 16420 ; C1 = 12210 ; I1 = 1680 ; G1 = 2970 ; IMP1 = 2100 ;

# ╔═╡ b261449d-7c48-4129-8414-1700e50d88a8
md"""

👉   **(a)** Assuming the goods market is in equilibrium, calculate spending on net exports.

"""

# ╔═╡ 899f66c9-ad44-4b61-8e4c-f6b49b79cf6d
md"""
!!! hint

	We know that, by definition:

	$$\begin{array}{c}
			Y=C+I+G+N X
	\end{array}$$

	- So: $$16420 = 12210 +1680 + 2970 +NX$$

	- Also by definition: $NX = EXP-IMP.$

"""

# ╔═╡ 6006d430-c3df-405f-be79-44a03ac65dd0


# ╔═╡ 37ad3e59-d32e-4847-81e6-09841da39c60
md"""
!!! answer "Answer (a)"

	Here

"""

# ╔═╡ 613f432c-b790-4ccd-b75e-0b54c2a39d05
md"""
👉   **(b)** If U.S. imports are valued at \$2,100 billion, calculate spending on U.S. exports.
"""

# ╔═╡ 4ee5dd86-7fbe-437d-bed0-25aa4cd9d9d4


# ╔═╡ 4b3dd41a-e572-4845-80d7-c1170e50c339
md"""
!!! answer "Answer (b)"

	Here

"""

# ╔═╡ 68f968cd-e8ea-48f1-aa99-e39b48edc2d8
md"""
____________________________________________________________________________________________________________
"""

# ╔═╡ adb106a5-23f6-4a1c-b4f0-2f7d26b51709
md"""
## Exercise 2. Marginal propensity to consume
"""

# ╔═╡ fc16caae-1e78-4eb3-9e51-c3ea56063d92
md"""
*From the textbook. This question in the textbook is a bit confusing; we changed it slightly. We ask to calculate the marginal propensity to consume, not the level of consumption, which we can not find because `r` and `b` are not known.*

Assume the following estimates: 
- Autonomous consumption is \$1,625 billion 
- Disposable income is equal \$11,500 billion. 

Using the consumption function in Equation 2 (textbook/slides), calculate the value of the marginal propensity to consume if an increase of \$1,000 in disposable income leads to an increase of \$750 in consumption expenditure.
"""

# ╔═╡ bbe3a73c-0ad6-4cc4-b534-93e0b35eed23
md"""
!!! hint

	Equation (2) in the textbook and in the slides is given by:


	$$\tag{2} C=\overline{C}+c \cdot \underbrace{(Y-T)}_{=Y_{D}}-b \cdot r$$

	$$C= 1625+c \times 11500 -b \cdot r$$

	In eq. (2), we can calculate the derivative/variation of $C$ with respect to $Y_D$, which is:


	$$\Delta C = c \cdot \Delta Y_D ~~~~ \Rightarrow ~~~~  c = \dfrac{\Delta C}{ \Delta Y_D}.$$
	
"""

# ╔═╡ 538f4c82-462e-4dc5-bc1c-64fbbca61fec
md"""
---
"""

# ╔═╡ 4b1fc2ea-2567-4251-bbff-8baaa3a2b501
md"""
Firstly, let us pass the available information into the noteboook. The number 2 in every single variable/parameter is used as an index to represent "exercise 2".
"""

# ╔═╡ e7855303-9f77-4652-b114-ba2a8a5944cc
ΔC2 = 750 ;	ΔYD2 = 1000 ;

# ╔═╡ e0d3a306-aa91-421d-afc6-b38558501404


# ╔═╡ 54ecdc3d-c5b4-4156-833f-2065f53cbe4e
md"""
!!! answer

	Here

"""

# ╔═╡ 640a35be-f498-444d-8e92-1a7d54aa92b7
md"""
____________________________________________________________________________________________________________
"""

# ╔═╡ bf613949-c5ce-41f9-bd04-a60ba34a6fe7
md"""
## Exercise 3. The Consumption function
"""

# ╔═╡ 1ce71c7c-02f2-4e1f-93c9-51c8f34832fb
md"""
*From the textbook.*

Calculate consumption expenditure using the consumption function (as described by Equation 2) and the following estimates:
- Autonomous consumption: \$1,450 billion
- Income: \$14,000 billion
- Income taxes: \$3,000 billion
- Marginal propensity to consume: 0.8
"""

# ╔═╡ 21d2f552-02e8-4d2e-9f0b-75708a57491e
md"""
---
"""

# ╔═╡ bf64fdf6-3ebd-443e-bf25-b5026fc7f165
md"""
Firstly, let us pass the available information into the noteboook. The number 3 in every single variable/parameter is used as an index to represent "exercise 3".
"""

# ╔═╡ 9c44fc21-3344-42eb-9ca7-e4d65bdcd323
C̄3 = 1450 ;  Y3 = 14000  ;  T̄3 = 3000 ;	c3 = 0.8 ;    

# ╔═╡ 143d4cff-51c2-47e8-be12-64538858f0fe
md"""
!!! answer

	Here

"""

# ╔═╡ 7a669ff0-763d-4aa3-8025-8b6ac31210a6
md"""
____________________________________________________________________________________________________________
"""

# ╔═╡ c7c471f8-6b5b-42e2-9849-b96e64300e29
md"""
## Exercise 4. The IS Curve: ingredients
"""

# ╔═╡ 597807a4-bc36-4601-ba1c-7e3b7b10d118
md"""

In the slides, the IS curve was defined as follows:
		
"""

# ╔═╡ 1f2404d3-24e8-4e90-b9ab-3e7f71ab0253
md"""
!!! note "IS definition" 
	For a given set of parameters $\{c,b,d,x\}$, the level of aggregate demand and GDP $(D,Y)$ is positively affected by the level of autonomous aggregate demand $(\overline{A})$, and negatively by the level of the real interest rate $(r)$:
		
	$Y=m \cdot \overline{A}-m\cdot \phi \cdot r$

	Notice that, _**to simplify things**_, we define:

	$$\frac{1}{1-c}=m>1$$
	$b+d+x=\phi>0$	
	$\overline{A} = \overline{C}+\overline{I}-d \cdot \overline{f}+\overline{G}+\overline{N X}-c \cdot \overline{T}$
"""

# ╔═╡ 03995206-5c4d-4097-b219-9f9e032d033d
md"""

👉  **(a)** Which are the exogenous macroeconomic variables in the IS curve? Why are they exogenous?

"""

# ╔═╡ 711ede14-cbfa-4aba-9ac4-c8f8148d49bc
md"""
!!! answer "Answer (a)"

	- the exogenous variables are inside the autonumenous aggreagte demnand are $\overline{C}, \overline{I} , \overline{f}, \overline{G} , \overline{N X} , \overline{T}$ the values are given to us They are the inputs of the model

"""

# ╔═╡ d2a47771-4796-4648-a1e6-e1ab7a641b99
md"""

👉  **(b)** Which are the endogenous macroeconomic variables in the IS curve? Why are they endogenous?

"""

# ╔═╡ fbc6f533-7dbf-411f-861b-532126bcf234
md"""
!!! answer "Answer (b)"

	- The endogenous variables in the model are  Y and D, so they are the outputs if the model

"""

# ╔═╡ b1022d7a-9f93-48bc-b126-d73a83fbf031
md"""

👉  **(c)** Why are $\{c,b,d,x\}$ parameters in this curve?

"""

# ╔═╡ c6d87ab1-f781-47ff-b3a1-9ca79190b348
md"""
!!! answer "Answer (c)"

	- because they represent the structure of the model, since they transform inputs (exogenous variables) into ouputs (endogenous variables)

"""

# ╔═╡ bc25345d-3a45-48b9-87c5-aa5176e4aa8a
md"""
____________________________________________________________________________________________________________
"""

# ╔═╡ dcd13560-0f73-4aaa-b59a-b7961d8cdc63
md"""
## Exercise 5. The IS Curve: numerical exercise
"""

# ╔═╡ df9417d2-ebe1-498c-b299-f2b8fdee1084
md"""
*Numerical example included in Chapter 9 of the textbook (in the main text, not in the problems section).*

We can better understand the IS curve with the following numerical example, in which we attribute specific values for the exogenous variables and the parameters in Equation 13 (slides/textbook). The exogenous variables and parameters are as follows:

| Exogenous variables |    |    | Exogenous variables| 	    |	  | Parameters|
|:----                |--- |--- |:---                | ---  | --- |:---       |
|
|$$\overline{C}= \$1.3 \text { trillion }$$| | |$$\overline{T}= \$3.0 \text { trillion }$$ | | |$c=0.6$   |
|$$\overline{I}= \$1.2 \text { trillion }$$| | |$$\overline{N X}= \$1.3 \text {trillion}$$ | | |$b = 0.1$ |
|$$\overline{G}= \$3.0 \text { trillion }$$| | |$\overline{f}=1$                           | | |$d = 0.2$ |
|                                          | | |                                           | | |$x = 0.1$ |

Answer the following questions, but firstly, let us pass the available information into the notebook. The number 5 in every variable/parameter is used as an index to represent "exercise 5".

"""

# ╔═╡ 0339ac3a-f9ca-4f43-83ce-4939ab3fb87a
C̄5 = 1.3 ; Ī5 = 1.2 ; Ḡ5 = 3.0 ; T̄5 = 3.0 ; N̄X̄5 = 1.3 ; f̄5 = 1.0 ; c5 = 0.6 ; b5 = 0.1 ; d5 = 0.2 ; x5 = 0.1;

# ╔═╡ 6436fa87-7ff6-437a-a7e6-08f4626fa4b6
md"""
---
"""

# ╔═╡ 74fdd365-dd4a-4fa5-b24c-881a01f2750e
md"""

👉  **(a)** Obtain the expression of the IS curve (equation 13 in the slides/textbook).
"""

# ╔═╡ 3c3a03e3-31c7-4e46-8ff3-1b8de8fb5f4b
md"""
!!! hint

	**(a)** To obtain the expression of the IS curve we have to recall the main parts of this curve. We know that:


	$$\tag{IS}	Y=m \cdot \overline{A}-m\cdot \phi \cdot r$$

	where

	-  $\overline{A} = \overline{C}+\overline{I}-d \cdot \overline{f}+\overline{G}+\overline{N X}-c \cdot \overline{T} \qquad \qquad \text{(Autonomous Aggregate Demand)}$



	-  $m=\frac{1}{1-c} \qquad \qquad \qquad \text{(multiplier)}$



	-  $\phi=b+d+x \qquad \qquad \text{(to simplify notation)}$

"""

# ╔═╡ b7b9272e-b740-47e8-907f-8ed890125449
md"""
Therefore, we need to pass the following information to the notebook (students are not expected to perform this task):
"""

# ╔═╡ 123a09ff-d1a2-463b-a74e-06769090c613
begin	
	Ā5 = C̄5 + Ī5 - d5*f̄5 + Ḡ5 + N̄X̄5 - c5*T̄5
	m5 = 1/(1-c5)
	ϕ5 = b5 + d5 + x5
	Print("Ā5 = $(Ā5) ,  m5 = $(m5) , ϕ5 = $(ϕ5)")
end

# ╔═╡ 36c9c29f-2de5-4793-900c-c2c9cf09be7a
md"""
!!! answer "Answer (a)"

	$Y=mV-mϕr=2.5*4.8 - 2.5*0.4*r$

"""

# ╔═╡ 21f4ce30-19d0-47be-9804-e63c2fca6d67
md"""
👉   **(b)** The IS curve is represented on the plane $(Y,r)$ in the figure below. At a real interest rate $r = 4\%$, equilibrium GDP will be equal to? *To answer the questions in this exercise, consider that $r$ is expressed in terms of percentage points. This means that if $r=4\%$, it means $r=4$*.

"""

# ╔═╡ 1c207ed6-e4d8-4cc3-82b2-0d4848d1ba77
begin
	Y5 = 0.0:0.025:12.0
	
	r5 = (Ā5 ./ ϕ5) .- (1. /(m5 .* ϕ5)).*Y5
	
	trace4_0 = scatter(; x=Y5, y = r5, mode="lines" , line_color = "Blue", line_width = "3",
					name  = "IS")
	
	layout4_0 = Layout(;
					title_text ="IS curve", 
					title_x = 0.5,
					hovermode="x",
                    xaxis=attr(title="GDP in trillion dollars (Y)", showgrid=true, zeroline=false),
                    xaxis_range = [1.9, 12.0],
					yaxis_range = [0.0, 10.1],
                    yaxis=attr(title="Real interest rate (r)", zeroline = false))

   p4_0 = Plot([trace4_0], layout4_0)
	
end

# ╔═╡ 97490413-87c2-42b0-a71c-416b79ce3805
GDP=2.5*4.8-2.5*0.4*6

# ╔═╡ 2dcc94b4-7398-4b47-8313-30ff12ff759b
md"""
!!! answer "Answer (b)"

	An increase in the real investment rate from 4 to 6 will lead to decline of gdp . this appens because of conspumtion, investmen and net export decrease due to rise of invesment rate


"""

# ╔═╡ 307d2ead-ad27-46cf-b69a-0151886bf8e1
md"""

👉 **(c)** Using the following figure, "A movement along the IS curve", what happens to equilibrium GDP if the real interest rate increases to $r = 6\%$? 

"""

# ╔═╡ 163c9a2e-ef0a-4936-b315-394fd23c44e2
begin
	
	trace4_1 = scatter(; x=Y5, y = r5, mode="lines" , line_color = "Blue", line_width = "3",
					name  = "IS")
	
	trace4_2 = scatter(; x = [8, 6], y = [4, 6], text =["1", "2"], textposition = "top center", 
                    name ="Eq.", mode="markers+text", marker_size= "12", marker_color="Blue", 
					textfont = attr(family="sans serif", size=16, color="black"))
	
	layout4_2 = Layout(;
					title_text = "A movement along the IS curve", 
					title_x = 0.5,
					hovermode="x",
                    xaxis=attr(title="GDP in trillion dollars (Y)", showgrid=true, zeroline=false),
                    xaxis_range = [1.9, 12.0],
					yaxis_range = [0.0, 10.1],
                    yaxis=attr(title="Real interest rate (r)", zeroline = false))

   p4_2 = Plot([trace4_1, trace4_2], layout4_2)
	
end

# ╔═╡ 537cd939-662d-4aed-8221-673c6eb4977b
md"""
!!! answer "Answer (c)"

	Here

"""

# ╔═╡ d8685092-2196-433c-b69e-b95aac1d405b
md"""

👉 **(d)** What happens to equilibrium GDP if $\overline{G}$ increases to \$3.8 trillion? Using the slider below, represent the new situation graphically and compare it with the initial case. 

"""

# ╔═╡ aca25060-e7d7-418c-8a71-794825f681f7
md"""
`ΔḠ5 = ` $(@bind ΔḠ5 Slider(-1.0:0.2:1.0, default=0.0, show_value=true))     
"""

# ╔═╡ e13b51c9-566f-40e9-b06d-451f7fa3f501
begin
	
	r5_ΔḠ5 = ((Ā5 .+ ΔḠ5) ./ ϕ5) .- (1. /(m5 .* ϕ5)).*Y5
	
	trace4_3 = scatter(; x=Y5, y = r5_ΔḠ5, mode="lines" , line_color = "Red", line_width = "3",
			name  = "IS")
	
	trace4_4 = scatter(; x = [10, 8], y = [4, 6], text =["1'", "2'"], textposition = "top center", 
                    name ="Eq.", mode="markers+text", marker_size= "12", marker_color="Red", 
					textfont = attr(family="sans serif", size=16, color="black"))
	

	
	layout4_4 = Layout(;
		title_text="IS curve with an increase in Public Spending of \$0.8 trillion",
					title_x = 0.5,
					hovermode="x",
                    xaxis=attr(title="GDP in trillion dollars (Y)", showgrid=true, zeroline=false),
                    xaxis_range = [5.0, 11.0],
					yaxis_range = [1.0, 8.0],
                    yaxis=attr(title="Real interest rate (r)", zeroline = false))

	p4_4 = Plot([trace4_3, trace4_4, trace4_1, trace4_2], layout4_4)
end

# ╔═╡ 1b2f491d-3294-44f2-b76b-e8151cd4a949
md"""
!!! answer "Answer (d)"
- 
	

"""

# ╔═╡ 8ad50d7b-4774-4605-8d2f-9ac1e4f17db6
md"""
👉 **(e)** What happens to equilibrium GDP if $\overline{NX}$ goes down to \$0.7 trillion? Using the corresponding slider, represent the new situation graphically and compare it with the initial case. 
"""

# ╔═╡ 86100b9e-dc20-4132-9b25-db5dba5d581a
md"""
`ΔN̄X̄5= ` $(@bind ΔN̄X̄5 Slider(-2.0:0.2:2.0, default=0.0, show_value=true))
"""

# ╔═╡ cd45cc86-a5fc-4805-82ea-ab8f806594ac
begin
	
	r5_ΔN̄X̄5 = ((Ā5 .+ ΔN̄X̄5) ./ ϕ5) .- (1 ./ (m5 .* ϕ5)).*Y5
	
	trace4_5 = scatter(; x=Y5, y = r5_ΔN̄X̄5, mode="lines" , line_color = "Gray", line_width = "3",
					name  = "IS")
	
	trace4_6 = scatter(; x = [6.5 , 4.5], y = [4.0, 6.0], text =["1'", "2'"], textposition = "top center", 
                    name ="Eq.", mode="markers+text", marker_size= "12", marker_color="Gray", 
					textfont = attr(family="sans serif", size=16, color="black"))
	

	
	layout4_6 = Layout(;
					title_text ="IS curve with a decline in Net Exports of \$0.6 trillion", 
					title_x = 0.5,
					hovermode="x",
                    xaxis=attr(title="GDP in trillion dollars (Y)", showgrid=true, zeroline=false),
                    xaxis_range = [3.0, 10.0],
					yaxis_range = [2.0, 9.0],
                    yaxis=attr(title="Real interest rate (r)", zeroline = false))

	p4_6 = Plot([trace4_5, trace4_6, trace4_1, trace4_2], layout4_6)
end

# ╔═╡ aa831869-4167-4b38-a198-a0fa777cc02e
md"""
!!! answer "Answer (e)"

	-With a decrease in autonomous net exports, net export will decrease and so GDP/Aggregate demand will decrease as well

"""

# ╔═╡ b5016460-c0cf-46bc-bbd9-5eb77456d613
md"""
____________________________________________________________________________________________________________
"""

# ╔═╡ 781d8783-f530-4859-b531-7e1495c53cc4
md"""
## Exercise 6. Exports and the IS curve
"""

# ╔═╡ 8b753d01-766e-437b-8c45-80a8444564ca
md"""
*From the textbook*

Suppose the U.S. Congress declares China a “currency manipulator” and legislates a tariff on Chinese goods. These tariffs lead to a decrease in imports of 0.8 trillion dollars:

👉 **(a)** What is the impact of such a measure on the level of GDP in the US?

"""

# ╔═╡ c762d4c2-c5eb-4872-bd2e-f979ccaf7f75
md"""
!!! hint

	Do not forget that the textbook considers the US as the domestic economy. All other countries are treated as foreign economies. Therefore, we should answer these questions from the US point of view.

"""

# ╔═╡ 8c62ae55-2221-417f-b0ef-42702f13bf8a
md"""
!!! answer "Answer (a)"

	- GDP should increase, because import decreases with the intruduction of the tariff.
	- if import goes down and export stays the same, then net export (NX) will increase

"""

# ╔═╡ 765f295f-fa46-4496-87ee-5c96c5e3865a
md"""
👉 **(b)** Using the figure below, manipulate the slider `ΔN̄X̄6` to show your answer graphically.
"""

# ╔═╡ 5959d384-47fd-4cc7-b038-61bda4566224
md"""
`ΔN̄X̄6= ` $(@bind ΔN̄X̄6 Slider(-2.0:0.2:2.0, default=0.0, show_value=true))
"""

# ╔═╡ 78b89710-40fa-4aca-a940-a8fa69b5e23f
begin
	
	r6_ΔN̄X̄6 = ((Ā5 .+ ΔN̄X̄6) ./ ϕ5) .- (1 ./(m5 .* ϕ5)).*Y5
	
	trace4_7 = scatter(; x=Y5, y = r6_ΔN̄X̄6, mode="lines" , line_color = "Gray", line_width = "3",
			name  = "IS")
	
	trace4_8 = scatter(; x = [10.0 , 8.0], y = [4.0, 6.0], text =["1'", "2'"], textposition = "top center", 
                    name ="Eq.", mode="markers+text", marker_size= "12", marker_color="Gray", 
					textfont = attr(family="sans serif", size=16, color="black"))
	
	
	layout4_8 = Layout(;
					title_text="IS curve with an increase in Net Exports of \$0.8 trillion",
					title_x = 0.5,
					hovermode="x",
                    xaxis=attr(title="GDP in trillion dollars (Y)", showgrid=true, zeroline=false),
                    xaxis_range = [4.0, 11.0],
					yaxis_range = [1.0, 8.0],
                    yaxis=attr(title="Real interest rate (r)", zeroline = false))

	p4_8 = Plot([trace4_7, trace4_8, trace4_1, trace4_2], layout4_8)
end

# ╔═╡ 086e9172-be56-47fb-93dd-21ab3093123f
md"""
!!! answer "Answer (b)"

	- THe IS curve will shift to the right due to the increase in net export 

"""

# ╔═╡ efd31f4e-42d5-4220-a9a0-be9d9450813f
md"""
____________________________________________________________________________________________________________
"""

# ╔═╡ 222d28df-5bf6-483a-8326-d72df4396faa
md"""
## Exercise 7. Stock prices & a stronger dollar
"""

# ╔═╡ 41ed8c14-0455-4af3-bb91-e197bb43af34
md"""
*From the textbook*

Suppose you read in the newspaper that prospects for stronger future economic growth will lead the dollar to strengthen and stock prices to increase.

(a) Comment only on the effect of the strengthened dollar on the IS curve.

(b) Comment only on the effect of the increase in stock prices on the IS curve.
"""

# ╔═╡ fb8275c0-1607-4b67-8de2-40904a4a88de
md"""
!!! answer "Answer (a)"

	- With stronger $ imports will increase ($ alows us to buy more for less from other countries), but export will decrease because it would be more expensive for others to buy something from us

"""

# ╔═╡ bdd4a3a3-155a-411d-88f6-6c0dacd5b8b7
md"""
!!! answer "Answer (b)"

	- increase of stock prices will lead to increas of autonomous investment, hence increase of GDP and aggregate demand

"""

# ╔═╡ 82ba0774-1769-41db-a7f9-f82a7b51dacb
md"""
____________________________________________________________________________________________________________
"""

# ╔═╡ c166d2d5-83ec-4c58-96d1-477830123974
md"""
## Exercise 8. Recessions and GDP components
"""

# ╔═╡ 8928367b-1e90-4e18-86cb-a93861353562
md"""

The figures below plot quarterly data for the USA concerning the four basic components of GDP (consumption, investment, government expenditures, and net exports) between 2000-2020. The recession that became known as "The Great Recession" is represented by the shaded area.

👉 **(a)**  Why did government expenditures (as a percentage of GDP) increase during the Great Recession? And what happened during 2020?

"""

# ╔═╡ 819f415c-c365-401f-b1f1-a80c02cf7eb7
GDP_shares = CSV.read("GDP_shares.csv", delim = ';' , DataFrame);

# ╔═╡ d9d1a6ec-b527-41c0-a2ef-6ea417c6a341
md"""
!!! answer "Answer (a)"

	- govermne expenditure in % of GDP increases because goverment was baling out the economy, especial of the financial system. in 2020 it was due to covid that govermnets expenditure went up

"""

# ╔═╡ 5c0b7b83-6ad8-4869-b5f7-3345923685ce
md"""
👉 **(b)**  Despite a deep recession, consumption expenditures as a percentage of GDP did not decline during the "Great Recession". What may explain this behavior?

"""

# ╔═╡ d65481f4-93b8-4e93-8782-bba9d25abd3d
md"""
!!! answer "Answer (b)"

	- Goverment expenditure helped in maintaining consuption expendritures of families


"""

# ╔═╡ 1bc51762-4da9-411e-ac47-de720bad5237
md"""

👉 **(c)**  Why do you think net exports suffered a sharp increase during this recession?

"""

# ╔═╡ ded345ca-71fb-4762-b6b2-2326992fb315
md"""
!!! answer "Answer (c)"

	- during the great recession, the value of $ decreased, so imports went down and exports went up

"""

# ╔═╡ c3a2dc55-de22-4df7-b39f-55cf77586852
md"""
👉 **(d)**  What happened to investment during this recession?
"""

# ╔═╡ 31ce73f0-73d5-4b4d-a1c7-23438f5861ac
md"""
!!! answer "Answer (d)"

	Here

"""

# ╔═╡ 9896c06d-b468-4858-9e42-56336abfd772
md"""
____________________________________________________________________________________________________________
"""

# ╔═╡ 640dd806-873f-4868-b5a8-0db0992e113d
md"""
## Exercise 9. The financial friction & investment
"""

# ╔═╡ 2c910e16-e262-4ee8-91eb-9cfc2ab8ba82
md"""

We saw in the previous week that in the USA, the real interest rate reached substantial negative values when the "Great Recession" of 2007 hit the economy. With negative real interest rates, we would expect investment to increase significantly. However, as we witnessed in the previous exercise (exercise 8), investment collapsed in that same period. Why did this happen? This week's theory explains the demand for investment goods based on the real interest rate, exogenous forces, and the **financial friction**.

Below, we present evidence for the USA about the evolution of three significant variables: 
- the Federal Funds Rate (FFR), 
- the Moody's Seasoned Baa Corporate Bond Yield Relative to Yield on 10-Year Treasury Constant Maturity (BAA10Y), which is a good indicator of the financial friction in the economy.
- The rate of growth of investment demand (INV_g).

👉 **(a)** Do you consider that the financial friction as an element of the theory of investment demand is supported (or refuted) by the evidence below? 

"""

# ╔═╡ d9ecf62d-0282-438f-a71a-711064af2322
md"""
!!! tip "Answer (a)"

	Here

"""

# ╔═╡ 88878aa5-1a55-4fb7-abf9-ff41b79dd235
md"""
👉 **(b)** How do you translate this dramatic increase in the financial friction during the "Great Recession" into the IS curve? 

"""

# ╔═╡ 9a75abbf-1ead-4dde-b697-a4073b527143
md"""
!!! tip "Answer (b)"

	Here

"""

# ╔═╡ f3945e89-1b31-4b5e-a323-658d84ea8755
md"""
____________________________________________________________________________________________________________
"""

# ╔═╡ 05d56d6f-28c2-4447-895e-a914748db979
md"""
## Exercise 10. Inventories
"""

# ╔═╡ 860d5f1b-a79d-4ff6-a9a3-e1665f9bc021
md"""
*From the textbook.*

Suppose that Dell Corporation has 20,000 computers in its warehouses on December 31, 2016, ready to be shipped to merchants (each computer is valued at \$500). By December 31, 2017, Dell Corporation has 25,000 computers ready to be shipped, each valued at \$450.


👉   **(a)** Calculate Dell’s inventory on December 31, 2016.

"""

# ╔═╡ ffd522e6-83f7-4a06-8a0b-c3f92828b53f


# ╔═╡ 4759ccf1-1aa4-4e9d-9829-7de8cf5682e0
md"""
!!! answer "Answer (a)"

	Here

"""

# ╔═╡ 6320078f-b23f-4021-9b5a-c08feabae0f9
md"""
👉   **(b)** Calculate Dell’s inventory investment in 2017.

"""

# ╔═╡ 5e618e51-8e5a-4962-8f25-ce3077b3a0a7
md"""
!!! hint
	Dell’s inventory investment in 2017 is the **change in inventories** between 31 December 2016 and 31 December 2017.
"""

# ╔═╡ 7a0edd1c-1d1d-441d-be8b-c4ebe1f39922


# ╔═╡ 6679dfc6-af9a-4837-aed1-f3c8e8879a21
md"""
!!! answer "Answer (b)"

	Here

"""

# ╔═╡ c8478442-b7b3-484d-828f-119c32d2e092
md"""
👉   **(c)** What happens to inventory spending during the early stages of an economic recession?
"""

# ╔═╡ 3e54e4b7-3ea6-4189-9375-e9f59c97ad20
md"""
!!! answer "Answer (c)"

	Here

"""

# ╔═╡ 62274a3f-f551-4788-b517-35aa14a3999d
md"""
____________________________________________________________________________________________________________
"""

# ╔═╡ 97a85466-47ff-4869-ba43-a36dea571284
md"""
## Exercise 11. Public spending vs Investment
"""

# ╔═╡ 839c6baf-dad8-4a97-97ea-d5da508c4263
md"""
*From the textbook*

Part of the US 2009 stimulus package was paid out in the form of tax credits. However, even though interest rates did not change significantly during that year, aggregate output did not increase. Using the same parameters as in our exercise 5 above:

👉 **(a)**  Suppose the amount of tax credits is $0.5 trillion. Calculate the decrease in autonomous investment expenditure necessary to offset that cut.

"""

# ╔═╡ 3f931ada-557a-4ad2-b005-581d380851a9
md"""
	!!! hint

		A tax credit is an amount of money taxpayers can subtract directly from the taxes they were supposed to pay. In practical terms, this means that the level of taxes paid will go down $(\downarrow \overline{T})$.

		To answer this problem we have to bring back the IS equation:

		$$\tag{IS} Y=m \cdot \overline{A}-m\cdot \phi \cdot r$$

		where

		-  $\overline{A} = \overline{C}+\overline{I}-d \cdot \overline{f}+\overline{G}+\overline{N X}-c \cdot \overline{T} \qquad \qquad \text{(Autonomous Aggregate Demand)}$



		-  $m=\frac{1}{1-c} \qquad \qquad \text{(multiplier)}$



		-  $\phi=b+d+x \qquad \text{(to simplify notation)}$

		If we look at the expression of the Autonomous Aggregate Demand, it will be easy to answer the question. Tax credits in the value of \$0.5 trillion mean that income taxes ($\overline{T}$) goes down by that amount. So


		$$\Delta \overline{A} = - c \cdot \Delta \overline{T}$$
		$$\Delta \overline{A} = - 0.6 \times (-$0.5 \ \text{trillion})$$
		$$\Delta \overline{A} = + $0.3 \ \text{trillion}$$

	"""

# ╔═╡ 616ae819-635d-45aa-aad5-ea5b0c54ef55
md"""
	!!! answer "Answer (a)"

		Here

	"""

# ╔═╡ b7dea42e-f049-4ae2-86dc-c389109a59a9
md"""
👉 **(b)**  Show your answer graphically. To answer this question, use the two sliders below: one for reducing taxation and the other for a reduction in autonomous investment.
"""

# ╔═╡ e8248d50-9964-47b5-8a11-672449608cc6
md"""
`ΔT̄7= ` $(@bind ΔT̄7 Slider(-2.0:0.1:1.0, default=0.0, show_value=true)) , ...........
`ΔĪ7= ` $(@bind ΔĪ7 Slider(-1.0:0.1:1.0, default=0.0, show_value=true))
"""

# ╔═╡ 1711b826-e878-4205-baf6-2a4119093d4a
begin
	
	r7 = ((Ā5 .- (c5 .* ΔT̄7) .+ ΔĪ7 ) ./ ϕ5) .- (1.0 ./ (m5 .* ϕ5)) .* Y5
	
	trace4_9 = scatter(; x = Y5, y = r7, mode="lines" , line_color = "Gray", line_width = "3",
			name  = "IS")
	
	trace4_10 = scatter(; x = [8.75 , 6.75], y = [4.0, 6.0], text =["1'", "2'"], textposition = "top center", 
                    name ="Eq.", mode="markers+text", marker_size= "12", marker_color="Gray", 
					textfont = attr(family="sans serif", size=16, color="black"))	

	
	layout4_10 = Layout(;
					title_text ="Tax Creditis offset by a reduction in Autonomous Investment", 
					title_x = 0.5,
					hovermode="x",
                    xaxis=attr(title="GDP in trillion dollars (Y)", showgrid=true, zeroline=false),
                    xaxis_range = [5.0, 10.0],
                    yaxis=attr(title="Real interest rate (r)", zeroline = false),
					yaxis_range = [2.0, 8.0])

	p4_10 = Plot([trace4_9, trace4_10, trace4_1, trace4_2], layout4_10)
end

# ╔═╡ 3e09446a-994e-4d45-9270-276fa3df28b8
md"""
!!! answer "Answer (b)"

	Here

"""

# ╔═╡ ea997c11-a1f4-4646-9487-8c989aa29e2e
md"""

👉 **(c)**  By how much would GDP increase due to the single impact of the tax credit measure?

"""

# ╔═╡ 43098c32-09ab-4d0e-86ac-c1a5184deb3f
md"""
!!! answer "Answer (c)"

	Here

"""

# ╔═╡ 9fa23f31-0453-410e-871a-7e2df8296fa2
md"""
____________________________________________________________________________________________________________
"""

# ╔═╡ e20914be-1103-4775-b76b-8d955cee41f6
md"""
## Exercise 12. The crowding-out effect (controversies)
"""

# ╔═╡ e0aa5b5f-ba86-47c8-918d-b541aa01932d
md"""

Using the data of exercise 8, we can analyze a huge controversy in macroeconomics: the crowding-out effect of public expenditures on private investment expenditures. In the following figure, we present a cross plot of the behavior of these two aggregates for the USA economy between 2000 and 2022. By inspecting this figure, what can we say about this crowding-out effect? 

"""

# ╔═╡ 53f55255-64db-45bf-96ae-744823094f07
md"""
!!! answer "Answer"

	Here

"""

# ╔═╡ 854730cc-3079-44e2-aa7b-766bf8c3e668
md"""
____________________________________________________________________________________________________________
"""

# ╔═╡ c7206167-7a0e-48bc-a44e-76160c8c29fd
md"""
## Exercise 13. Yield curve and short-term interest rates
"""

# ╔═╡ 2848d640-fe6e-40ed-98c1-640965aee73f
md"""
###### The yield curve is a concept that most students do not master at this stage. They are advised to skip this exercise.
"""

# ╔═╡ 08c9a722-76ef-462b-814e-bfb945fce34f
md"""
*From the textbook.*

After the press conference that followed the Federal Open Market Committee meeting on June 19, 2013, there were reports in the media that Chairman Bernanke’s comments were a signal that the Fed would raise interest rates sooner than expected. As a result, the yield on 10-year U.S. Treasury notes rose to almost 2.6%, the highest level since August 2011.

(a) Comment on how this would affect the IS curve.

(b) Show your answer graphically.
"""

# ╔═╡ 012e23be-0aff-4a4e-8efa-75b347df4cfe
md"""
!!! hint
	"A yield curve is a line that plots yields (interest rates) of bonds having equal credit quality but differing maturity dates. The slope of the yield curve gives an idea of future interest rate changes and economic activity.", from [here](https://www.investopedia.com/terms/y/yieldcurve.asp)
"""

# ╔═╡ beb874d4-baa3-4ff7-b4a3-4d003eb5d879
md"""
	!!! answer "Answers"
		**(a)** If the yield on the 10-year Treasury notes (or bills) goes up, this means that short-term interest rates should go up as well. If nominal interest rates go up --- and inflation does not follow it one-on-one, which rarely occurs --- real interest rates will increase. Such an increase in real interest rates will negatively impact private consumption, investment, and net-exports expenditures, leading to a slowdown in demand and GDP. This impact represents a movement **along** the IS curve, as we saw in Exercise 5, question (c). 

		**(b)** For a graphical representation, consult answer (c) of Exercise 5. 
	"""

# ╔═╡ 597ac0df-b2b2-4295-9e74-fd063b7bd3fb
md"""
____________________________________________________________________________________________________________
"""

# ╔═╡ 09297bfc-8edf-475a-9769-a12a101614e2
md"""
# Auxiliary cells (do not delete)
"""

# ╔═╡ 9fa87191-7c90-4738-a45a-acd929c8bd1b
  TableOfContents()

# ╔═╡ a385a0ae-d2e0-4b4e-862c-e69ec5bd6843
html"""<style>
main {
    max-width: 950px;
    align-self: flex-start;
    margin-left: 100px;
}
"""


# ╔═╡ b1b6ead9-0f26-496c-9ea3-f4d16217c5c9
md"""
##### Auxiliary cells: exercise 8
"""

# ╔═╡ 35a15574-499e-4fb9-98ce-c450c92c00c8
begin
	period8_1 = QuarterlyDate(2000,1): Quarter(1) : QuarterlyDate(2022,2);
	my_strings = GDP_shares[!,:Quarters] = string.(GDP_shares[:,:Quarters]);
	shape8_1 = rect(["2007-07-01"], ["2009-07-01"],
                0, 1; fillcolor = "red", opacity = 0.1, line_width = 0,
                xref = my_strings, yref = "paper")
end;

# ╔═╡ e67d5def-0e70-4f8f-92d7-da8d273c705d
begin
	fig8_1 = Plot(Layout(Subplots(rows=1, cols=2, subplot_titles=["Government as % GDP" "Consumption as % GDP"])))
	add_trace!(fig8_1, scatter(;x = Date.(period8_1), y = GDP_shares[213:302,4], 
						name = "G/GDP", line_color = "DarkRed", mode = "markers+lines", 
						marker_size = 5, marker_symbol = "circle", line_width = 0.3),  row=1, col=1)
	add_trace!(fig8_1, scatter(;x = Date.(period8_1), y = GDP_shares[213:302,2], name = "C/GDP", 
						line_color = "Blue", mode="markers+lines", marker_size=5, 
						marker_symbol="circle", line_width=0.3), row=1, col=2)
	relayout!(fig8_1, hovermode="x", xaxis_title="Quarters", xaxis2_title="Quarters")
	add_vrect!(fig8_1, "2007-07-01", "2009-07-01",  fillcolor = "red", opacity = 0.2, line_width = 0; row=1, col=1)
	add_vrect!(fig8_1,  "2007-07-01", "2009-07-01",  fillcolor = "salmon", opacity = 0.2, line_width = 0; row=1, col=2)
	#Plot(figx) # This need to be the `plot` function from PlutoPlotly, not from PlotlyJS
	fig8_1
end

# ╔═╡ 7a82da97-6686-47a2-a96b-11b27b0b25d5
begin
	fig8 = Plot(Layout(Subplots(rows=1, cols=2, 
						subplot_titles=["Investment as % GDP" "Net Exports as % GDP"])))
	add_trace!(fig8, scatter(;x = Date.(period8_1), y = GDP_shares[213:302,3], 
						name = "I/GDP", line_color = "darkchocolate", mode = "markers+lines", 
						marker_size = 5, marker_symbol = "circle", line_width = 0.3),  row=1, col=1)
	add_trace!(fig8, scatter(;x = Date.(period8_1), y = GDP_shares[213:302,5]-GDP_shares[213:302,6], 
						name = "NX/GDP", line_color = "Purple", mode="markers+lines", marker_size=5, 
						marker_symbol="circle", line_width=0.3), row=1, col=2)
	relayout!(fig8, hovermode="x", xaxis_title="Quarters", xaxis2_title="Quarters")
	add_vrect!(fig8, "2007-07-01", "2009-07-01", fillcolor = "red", opacity = 0.2, line_width = 0; row=1, col=1)
	add_vrect!(fig8, "2007-07-01", "2009-07-01", fillcolor = "salmon", opacity = 0.2, line_width = 0; row=1, col=2)
	#Plot(figx) # This need to be the `plot` function from PlutoPlotly, not from PlotlyJS
	fig8
end

# ╔═╡ ba37884f-1064-485f-a68b-086ff1eaa129
begin
	fig8_4=Plot(GDP_shares.GOV[213:302],GDP_shares.INV[213:302], mode="markers+lines", line_color = "blue", line_width = 0.3, text=period8_1)
	relayout!(fig8_4, Layout(title_text = "Government vs Investment (as % GDP) in the USA: 2000-2022", 
						title_x = 0.5,
						#hovermode = "x",
        				yaxis_title = "Investment expenditures",
						xaxis_title = "Government expenditures" ))
	fig8_4
end


# ╔═╡ 8aeac732-e962-4f7b-a9ea-c29213596ca1
begin
	function gov()
		trace8_5 = scatter(;x = Date.(period8_1), y = GDP_shares[213:302,4], 
						name = "G/GDP", line_color = "DarkRed", mode = "markers+lines", 
						marker_size = 6, marker_symbol = "circle", line_width = 0.3)

		layout8_5 = Layout(;
						shapes = shape8_1,
						title_text = "Government as % GDP", 
						title_x = 0.5,
						hovermode = "x",
        				yaxis_title = "% points",
        				#yaxis_range=[17.2, 21.5], 
        				titlefont_size = 16)

		fig8_5 = Plot(trace8_5, layout8_5)
	end
	#gov()
end;

# ╔═╡ 354c1f9b-e5cf-463a-a3b0-5d1d57b50e3e
begin
	function cons()
	trace8_2 = scatter(;x = Date.(period8_1), y = GDP_shares[213:302,2], name = "C/GDP", 
						line_color = "Blue", mode="markers+lines", marker_size=6, 
						marker_symbol="circle", line_width=0.3)

	layout8_2 = Layout(;
					shapes = shape8_1,
					title_text = "Consumption as % GDP", 
					title_x = 0.5,
					hovermode="x",
        			#xaxis_title = "Years",
        			#xaxis_range = [1999.8, 2020.2],
        			yaxis_title = "% points",
        			#yaxis_range=[17.2, 21.5], 
        			titlefont_size = 16)

	fig8_2 = Plot(trace8_2, layout8_2)	
	end
	#cons()
end;

# ╔═╡ cb10e510-eb37-47c1-a489-16c359c37065
begin
	function invest()
	trace8_3 = scatter(;x = Date.(period8_1), y = GDP_shares[213:302,3], name = "I/GDP", line_color = "gray",
         mode="markers+lines", marker_size=6, marker_symbol="circle", line_width=0.3)

	layout8_3 = Layout(;
					shapes = shape8_1,
					title_text = "Investment as % GDP", 
					title_x = 0.5,
					hovermode="x",
        			#xaxis_title = "Years",
        			#xaxis_range = [1999.8, 2020.2],
        			yaxis_title = "% points",
        			#yaxis_range=[17.2, 21.5], 
        			titlefont_size = 16)

	fig8_3 = Plot(trace8_3, layout8_3)	
	end
	#invest()
end;

# ╔═╡ d302c0ce-b7f1-4f37-8078-a515838a198e
begin
	function netexp()
	trace8_4 = scatter(;x = Date.(period8_1), y = (GDP_shares[213:302, 5] - GDP_shares[213:302, 6]), name = "NX/GDP", line_color = "Purple",
         mode="markers+lines", marker_size=6, marker_symbol="circle", line_width=0.3)

	layout8_4 = Layout(;
					shapes = shape8_1,
					title_text = "Net Exports as % GDP", 
					title_x = 0.5,
					hovermode="x",
        			#xaxis_title = "Years",
        			#xaxis_range = [1999.8, 2020.2],
        			yaxis_title = "% points",
        			#yaxis_range=[17.2, 21.5], 
        			titlefont_size = 16)

	fig8_4 = Plot([trace8_4], layout8_4)	
	end
	#netexp()
end;

# ╔═╡ 1ed0dbb2-5a3d-4912-b452-ca75050fae8b
md"""
#### Auxiliary cells: exercise 9
"""

# ╔═╡ 20b8cdab-4c63-42ff-8efa-afd78fc0e5d0
spread_inv = CSV.read("Spread_FFR_Investment.csv", DataFrame);

# ╔═╡ 87d3e73f-0be5-4d30-a9c5-3649c5c25820
period4_2 = QuarterlyDate(2001, 3):Quarter(1):QuarterlyDate(2020, 4);

# ╔═╡ e71ff73f-5b86-49cd-8038-d9471550f1d7
begin
	trace4_17 = scatter(;x = Date.(period4_2), y = spread_inv[:,2], name = "BAA10Y", 
					line_color = "Blue", mode = "markers+lines", line_width="0.5", marker_size ="6")
	
	trace4_18 = scatter(;x = Date.(period4_2), y = spread_inv[:,3], name = "FFR", line_color = "Red", 
					mode = "markers+lines", line_width="0.5", marker_size ="6")
	

	layout4_18 = Layout(;
		
					title_text = "BAA10Y vs FFR  for the USA: (2001.Q3--2020.Q4)",
					title_x = 0.5,
		
					hovermode="x",
		
            		xaxis = attr(
                	title = "Quarterly obervations",
                	tickformat = "%Y",
                	hoverformat = "%Y-Q%q",
                	tick0 = "2001/10/01",
                	dtick = "M24"),
		
        			#xaxis_range = [1960, 2020],
        			yaxis_title = "Percentage points",
        			#yaxis_range=[-2, 2], 
        			titlefont_size = 16,
					xaxis_range = [Date.(2001), Date.(2021)]
						)

	p4_18 = Plot([trace4_17 , trace4_18], layout4_18)
end

# ╔═╡ 8d76adfb-0633-4d89-8fbe-f2548a5bd222
begin
	trace4_20 = scatter(;x = Date.(period4_2), y = spread_inv[:,2], name = "BAA10Y", line_color = "Blue", 
						mode = "markers+lines", line_width="0.5", marker_size ="5.5")
	
	
	trace4_21 = scatter(;x = Date.(period4_2), y = spread_inv[:,4], name = "INV_g", line_color = "red", 
						mode = "markers+lines", line_width="0.5", marker_size ="5.5", 
						yaxis = "y2")
	
	
	layout4_21 = Layout(
		
			title_text = "BAA10Y and Investment growth USA: (2001.Q3--2020.Q4)", 
			title_x = 0.5,
		
			hovermode="x",
		
			xaxis = attr(
                		title = "Quarterly obervations",
                		tickformat = "%Y",
                		hoverformat = "%Y-Q%q",
                		tick0 = "2001/10/01",
                		dtick = "M24"				
        				),
		
			yaxis1 = attr(
						title = "BAA10Y",
						#titlefont_color=  "rgb(148, 103, 189)",
						#tickfont_color = "rgb(148, 103, 189)",
						#overlaying = "y",
						#side = "right",
						#yaxis1_tickvals = [1.5, 2.5, 3.5, 5.5],
						showgrid= false,
						zeroline=false,
						yaxis1_range=[1.5 , 5.5],
    					dtick = 5.6 / 7
						),
	

	  		yaxis2 = attr(
						title = "Investment growth",
						titlefont_color=  "red",
						tickfont_color = "red",
						overlaying = "y",
						side = "right",
						showgrid= false,
						zeroline=false,
						yaxis2_range=[-27 , 27],
    					dtick = 27 / 3
						),
		
			xaxis_range = [Date.(2001), Date.(2021)]
		
						)

	p4_21= Plot([trace4_20,trace4_21],layout4_21)
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
StatsBase = "2913bbd2-ae8a-5f71-8c99-4fb6c76f3a91"

[compat]
CSV = "~0.10.4"
DataFrames = "~1.3.5"
HypertextLiteral = "~0.9.4"
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
project_hash = "56975246686fed71051c0f997fcc9cde86529e57"

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

[[deps.Formatting]]
deps = ["Printf"]
git-tree-sha1 = "8339d61043228fdd3eb658d86c926cb282ae72a8"
uuid = "59287772-0a20-5a39-b81b-1366585eb4c0"
version = "0.4.2"

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
# ╟─4618a663-f77e-4ccc-9b00-e84dbd5beb34
# ╠═a145e2fe-a903-11eb-160f-df7ea83fa3e6
# ╟─74de9f66-d5b4-4e0f-a75d-5177b1842191
# ╟─752abe33-497b-4c02-beca-dfc35ac81ea8
# ╟─9e05bc6e-a423-41c2-a236-41432276af88
# ╟─72e235dd-e402-483b-9567-28fb05c364f8
# ╟─b8e14e1f-53ee-4851-9cc7-8e3f78c158f1
# ╠═47e9dd59-a6f0-47b5-a31e-5c8967495c31
# ╟─b261449d-7c48-4129-8414-1700e50d88a8
# ╟─899f66c9-ad44-4b61-8e4c-f6b49b79cf6d
# ╠═6006d430-c3df-405f-be79-44a03ac65dd0
# ╟─37ad3e59-d32e-4847-81e6-09841da39c60
# ╟─613f432c-b790-4ccd-b75e-0b54c2a39d05
# ╠═4ee5dd86-7fbe-437d-bed0-25aa4cd9d9d4
# ╟─4b3dd41a-e572-4845-80d7-c1170e50c339
# ╟─68f968cd-e8ea-48f1-aa99-e39b48edc2d8
# ╟─adb106a5-23f6-4a1c-b4f0-2f7d26b51709
# ╟─fc16caae-1e78-4eb3-9e51-c3ea56063d92
# ╟─bbe3a73c-0ad6-4cc4-b534-93e0b35eed23
# ╟─538f4c82-462e-4dc5-bc1c-64fbbca61fec
# ╟─4b1fc2ea-2567-4251-bbff-8baaa3a2b501
# ╠═e7855303-9f77-4652-b114-ba2a8a5944cc
# ╠═e0d3a306-aa91-421d-afc6-b38558501404
# ╟─54ecdc3d-c5b4-4156-833f-2065f53cbe4e
# ╟─640a35be-f498-444d-8e92-1a7d54aa92b7
# ╟─bf613949-c5ce-41f9-bd04-a60ba34a6fe7
# ╟─1ce71c7c-02f2-4e1f-93c9-51c8f34832fb
# ╟─21d2f552-02e8-4d2e-9f0b-75708a57491e
# ╟─bf64fdf6-3ebd-443e-bf25-b5026fc7f165
# ╠═9c44fc21-3344-42eb-9ca7-e4d65bdcd323
# ╟─143d4cff-51c2-47e8-be12-64538858f0fe
# ╟─7a669ff0-763d-4aa3-8025-8b6ac31210a6
# ╟─c7c471f8-6b5b-42e2-9849-b96e64300e29
# ╟─597807a4-bc36-4601-ba1c-7e3b7b10d118
# ╟─1f2404d3-24e8-4e90-b9ab-3e7f71ab0253
# ╟─03995206-5c4d-4097-b219-9f9e032d033d
# ╟─711ede14-cbfa-4aba-9ac4-c8f8148d49bc
# ╟─d2a47771-4796-4648-a1e6-e1ab7a641b99
# ╟─fbc6f533-7dbf-411f-861b-532126bcf234
# ╟─b1022d7a-9f93-48bc-b126-d73a83fbf031
# ╟─c6d87ab1-f781-47ff-b3a1-9ca79190b348
# ╟─bc25345d-3a45-48b9-87c5-aa5176e4aa8a
# ╟─dcd13560-0f73-4aaa-b59a-b7961d8cdc63
# ╟─df9417d2-ebe1-498c-b299-f2b8fdee1084
# ╠═0339ac3a-f9ca-4f43-83ce-4939ab3fb87a
# ╟─6436fa87-7ff6-437a-a7e6-08f4626fa4b6
# ╟─74fdd365-dd4a-4fa5-b24c-881a01f2750e
# ╟─3c3a03e3-31c7-4e46-8ff3-1b8de8fb5f4b
# ╟─b7b9272e-b740-47e8-907f-8ed890125449
# ╠═123a09ff-d1a2-463b-a74e-06769090c613
# ╟─36c9c29f-2de5-4793-900c-c2c9cf09be7a
# ╟─21f4ce30-19d0-47be-9804-e63c2fca6d67
# ╟─1c207ed6-e4d8-4cc3-82b2-0d4848d1ba77
# ╠═97490413-87c2-42b0-a71c-416b79ce3805
# ╟─2dcc94b4-7398-4b47-8313-30ff12ff759b
# ╟─307d2ead-ad27-46cf-b69a-0151886bf8e1
# ╟─163c9a2e-ef0a-4936-b315-394fd23c44e2
# ╟─537cd939-662d-4aed-8221-673c6eb4977b
# ╟─d8685092-2196-433c-b69e-b95aac1d405b
# ╟─aca25060-e7d7-418c-8a71-794825f681f7
# ╟─e13b51c9-566f-40e9-b06d-451f7fa3f501
# ╠═1b2f491d-3294-44f2-b76b-e8151cd4a949
# ╟─8ad50d7b-4774-4605-8d2f-9ac1e4f17db6
# ╟─86100b9e-dc20-4132-9b25-db5dba5d581a
# ╟─cd45cc86-a5fc-4805-82ea-ab8f806594ac
# ╟─aa831869-4167-4b38-a198-a0fa777cc02e
# ╟─b5016460-c0cf-46bc-bbd9-5eb77456d613
# ╟─781d8783-f530-4859-b531-7e1495c53cc4
# ╟─8b753d01-766e-437b-8c45-80a8444564ca
# ╟─c762d4c2-c5eb-4872-bd2e-f979ccaf7f75
# ╟─8c62ae55-2221-417f-b0ef-42702f13bf8a
# ╟─765f295f-fa46-4496-87ee-5c96c5e3865a
# ╟─5959d384-47fd-4cc7-b038-61bda4566224
# ╟─78b89710-40fa-4aca-a940-a8fa69b5e23f
# ╠═086e9172-be56-47fb-93dd-21ab3093123f
# ╟─efd31f4e-42d5-4220-a9a0-be9d9450813f
# ╟─222d28df-5bf6-483a-8326-d72df4396faa
# ╟─41ed8c14-0455-4af3-bb91-e197bb43af34
# ╟─fb8275c0-1607-4b67-8de2-40904a4a88de
# ╟─bdd4a3a3-155a-411d-88f6-6c0dacd5b8b7
# ╟─82ba0774-1769-41db-a7f9-f82a7b51dacb
# ╟─c166d2d5-83ec-4c58-96d1-477830123974
# ╟─8928367b-1e90-4e18-86cb-a93861353562
# ╟─819f415c-c365-401f-b1f1-a80c02cf7eb7
# ╟─e67d5def-0e70-4f8f-92d7-da8d273c705d
# ╟─7a82da97-6686-47a2-a96b-11b27b0b25d5
# ╟─d9d1a6ec-b527-41c0-a2ef-6ea417c6a341
# ╟─5c0b7b83-6ad8-4869-b5f7-3345923685ce
# ╟─d65481f4-93b8-4e93-8782-bba9d25abd3d
# ╟─1bc51762-4da9-411e-ac47-de720bad5237
# ╟─ded345ca-71fb-4762-b6b2-2326992fb315
# ╟─c3a2dc55-de22-4df7-b39f-55cf77586852
# ╠═31ce73f0-73d5-4b4d-a1c7-23438f5861ac
# ╟─9896c06d-b468-4858-9e42-56336abfd772
# ╟─640dd806-873f-4868-b5a8-0db0992e113d
# ╟─2c910e16-e262-4ee8-91eb-9cfc2ab8ba82
# ╟─e71ff73f-5b86-49cd-8038-d9471550f1d7
# ╟─8d76adfb-0633-4d89-8fbe-f2548a5bd222
# ╟─d9ecf62d-0282-438f-a71a-711064af2322
# ╟─88878aa5-1a55-4fb7-abf9-ff41b79dd235
# ╟─9a75abbf-1ead-4dde-b697-a4073b527143
# ╟─f3945e89-1b31-4b5e-a323-658d84ea8755
# ╟─05d56d6f-28c2-4447-895e-a914748db979
# ╟─860d5f1b-a79d-4ff6-a9a3-e1665f9bc021
# ╠═ffd522e6-83f7-4a06-8a0b-c3f92828b53f
# ╟─4759ccf1-1aa4-4e9d-9829-7de8cf5682e0
# ╟─6320078f-b23f-4021-9b5a-c08feabae0f9
# ╟─5e618e51-8e5a-4962-8f25-ce3077b3a0a7
# ╠═7a0edd1c-1d1d-441d-be8b-c4ebe1f39922
# ╟─6679dfc6-af9a-4837-aed1-f3c8e8879a21
# ╟─c8478442-b7b3-484d-828f-119c32d2e092
# ╟─3e54e4b7-3ea6-4189-9375-e9f59c97ad20
# ╟─62274a3f-f551-4788-b517-35aa14a3999d
# ╟─97a85466-47ff-4869-ba43-a36dea571284
# ╟─839c6baf-dad8-4a97-97ea-d5da508c4263
# ╟─3f931ada-557a-4ad2-b005-581d380851a9
# ╠═616ae819-635d-45aa-aad5-ea5b0c54ef55
# ╟─b7dea42e-f049-4ae2-86dc-c389109a59a9
# ╟─e8248d50-9964-47b5-8a11-672449608cc6
# ╟─1711b826-e878-4205-baf6-2a4119093d4a
# ╟─3e09446a-994e-4d45-9270-276fa3df28b8
# ╟─ea997c11-a1f4-4646-9487-8c989aa29e2e
# ╟─43098c32-09ab-4d0e-86ac-c1a5184deb3f
# ╟─9fa23f31-0453-410e-871a-7e2df8296fa2
# ╟─e20914be-1103-4775-b76b-8d955cee41f6
# ╟─e0aa5b5f-ba86-47c8-918d-b541aa01932d
# ╟─ba37884f-1064-485f-a68b-086ff1eaa129
# ╟─53f55255-64db-45bf-96ae-744823094f07
# ╟─854730cc-3079-44e2-aa7b-766bf8c3e668
# ╟─c7206167-7a0e-48bc-a44e-76160c8c29fd
# ╟─2848d640-fe6e-40ed-98c1-640965aee73f
# ╟─08c9a722-76ef-462b-814e-bfb945fce34f
# ╟─012e23be-0aff-4a4e-8efa-75b347df4cfe
# ╟─beb874d4-baa3-4ff7-b4a3-4d003eb5d879
# ╟─597ac0df-b2b2-4295-9e74-fd063b7bd3fb
# ╟─09297bfc-8edf-475a-9769-a12a101614e2
# ╠═9fa87191-7c90-4738-a45a-acd929c8bd1b
# ╠═a385a0ae-d2e0-4b4e-862c-e69ec5bd6843
# ╟─b1b6ead9-0f26-496c-9ea3-f4d16217c5c9
# ╟─35a15574-499e-4fb9-98ce-c450c92c00c8
# ╟─8aeac732-e962-4f7b-a9ea-c29213596ca1
# ╟─354c1f9b-e5cf-463a-a3b0-5d1d57b50e3e
# ╟─cb10e510-eb37-47c1-a489-16c359c37065
# ╟─d302c0ce-b7f1-4f37-8078-a515838a198e
# ╟─1ed0dbb2-5a3d-4912-b452-ca75050fae8b
# ╟─20b8cdab-4c63-42ff-8efa-afd78fc0e5d0
# ╟─87d3e73f-0be5-4d30-a9c5-3649c5c25820
# ╟─00000000-0000-0000-0000-000000000001
# ╟─00000000-0000-0000-0000-000000000002
