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

# ╔═╡ b72215bb-8e3a-46e2-8817-271befe1178c
begin
	using PlotlyBase, HypertextLiteral, PlutoUI, PlutoPlotly
	using LinearAlgebra, NLsolve
	using Dates, PeriodicalDates , DataFrames, CSV, Statistics
	import PlotlyJS: savefig
end

# ╔═╡ 82090c38-1ecd-43eb-aeca-135d996b8e72
md"""
# Week 1 - Welcome to Pluto Notebooks

## Introduction to Pluto

**Macroeconomics, ISCTE-IUL**
"""

# ╔═╡ 76164b77-2e0b-4deb-8ef8-1b2263260e7a
md"""
**Vivaldo Mendes, Ricardo Gouveia-Mendes, Luís Casinhas**

**September 2023**
"""

# ╔═╡ 694d78c7-4762-4d40-8f9a-6c3d16916d4e
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

# ╔═╡ 554b2cc5-99e1-4eda-b080-67ab2eddac16
md"""
### Packages used in this notebook
"""

# ╔═╡ 31023dd0-f304-471e-a292-2a40915ebcbf
md"""
## 1. What is a notebook?
"""

# ╔═╡ 7afb249a-ee89-4874-91fa-6da606948b2a
md"""
A notebook is a document with two types of cells (see image below): 
- code cells
- markdown cells 

The first type of cells includes computational code, comments, and Pluto's "begin-end" blocks. Code cells produce an output which usually takes the form of a plot, a table, numbers, or symbols.

The second type of cell (markdown) serves to write standard text, mathematics, illustrate computational code, insert an image or a video, among other functionalities. 

The versatility that arises from the combination of markdown cells with code cells renders notebooks a remarkable tool in computational work in general and teaching in particular.  
"""

# ╔═╡ 072b3431-0b22-4801-a75e-25cd77a7d70d
Resource("https://vivaldomendes.org/images/depot/Pluto_cells.png", :width=>850)

# ╔═╡ 86f1359d-3637-4892-9720-e042fae6543a
md"""
____________________________________________________________________________________________________________
"""

# ╔═╡ 0fc80d2d-6519-4f17-83c4-25ab9b26d8ce
md"""
## 2. Pluto basic tips
"""

# ╔═╡ 16ecc97b-a401-4172-bcbb-b0baa156b53c
md"""
#### Opening a new cell
"""

# ╔═╡ df155c1a-ca04-4bb9-954f-e5684aef683c
md"""
řeřicha
"""

# ╔═╡ 9dc454b2-9d5d-4ab1-aa0b-75ddefb6960d
md"""
ddasdas
"""

# ╔═╡ 564ff460-aa1f-4b9d-abf3-a024a13d96a3
md"""

Put the mouse on top of any opened cell. You will see a $+$ sign on the top left corner, and also on the bottom left corner. Click on the $+$ sign where you want the new cell to be placed.
"""

# ╔═╡ 6307472b-3a3e-4d9a-82fd-25d295abaae1
md"""
#### How to run a cell?

- Click on the small circle-arrow on the bottom right hand-side of each cell (▶)
- Or, just click simultaneosly on `shift` and `enter`
"""

# ╔═╡ 638ac59a-6fb2-447f-8856-0c6f74494e7b
md"""
#### How to save a notebook?

- Click simultaneosly on `Ctrl` and `S`

"""

# ╔═╡ 98f18fc3-0748-4ec7-a6a0-955e2ea22e19
md"""
#### Turn a new cell into markdown

"""

# ╔═╡ e81d6184-2b39-4205-83a8-9e2d7e5d41dd
md"""
Put the cursor inside the cell you want to be in markdown. Press simultaneously the following: `Ctrl` and `M`. That is all. You can start typing text or mathematics as you like.

"""

# ╔═╡ 70af87bd-81b5-4aa0-b1f7-0639d1f09d0a
md"""
!!! tip
	To write text in bold, italics, or mathematical symbols do the following: 
	- type: `**This is bold**` to get: **This is bold**
	- type: `_This is italics_` to get: _This is italics_
	- type: `**_This is bold and italics_**` to get: **_This is bold and italics_**
	- type: `$y=2x^2$` to get a mathematical expression: $y=2x^2$
"""

# ╔═╡ 2da4b605-2d9e-494a-810f-5d153dee7096
md"""
$x+y = 10$
$10x+1y = 15$
"""

# ╔═╡ 8c3253f4-86c2-4b88-9850-f7daed87774d
md"""
This is **bold**

This is _italics_

This is **_bold and italics_**

"""

# ╔═╡ 40139e5d-3069-4a48-ab37-48849eac8ec6
md"""
#### Lists
"""

# ╔═╡ 939053b1-5c6b-4246-9102-d845e37c70a0
md"""
- This is my first item

- This is my second item

  - Two tabs give my first sub-item

  - My second

    - Four tabs give first sub-sub-item

    - Very easy

- My final item

1. My first numbered item

2. Whau, this is easy

"""

# ╔═╡ a1e2ea1a-8ffb-49e8-a22e-8be913a5074f
md"""
#### Writting with mathematical symbols
"""

# ╔═╡ cab5fa24-d103-4ce6-b979-80901b9a01a0
md"""

To write mathematical expressions in markdown, we only need to use the `$`. Start an expression with a `$` and end it with another `$`.

This is inline mathematics: $y=2x$.

This is displayed mathematics:

$$y=2x$$

This is mathematics using the power syntax: $y = 2x^3$

This is mathematics using the fraction syntax: $h = \dfrac{3}{4n}$

This is more elaborate mathematics: $z = \int_{a}^{b} x^2 dx$

This is ... lack of imagination, using greek symbols:

$$\lambda = \sum_{i=0}^{\infty} \alpha^i x_{i-1}$$
"""

# ╔═╡ f6162891-de97-4522-a919-4942158cb2a0
md"""
#### Tables
"""

# ╔═╡ b3c16511-06d5-476d-b1ce-b8b35d038819
md"""

| variable           | mean        | min       | median   | max      | standard dev. |
|:--------------:    |:-------:    |:--------: |:---------:|:--------:|:-------:     |            
| Students passed          | 14.9389     | 3.0       | 15.0     | 20       | 3.00          |
| Midterm test   | 14.6172     | 8.85      | 14.8     | 19.7     | 2.59          |
|         | 15.8715     | 8.1       | 16.3     | 19.85    | 2.69          |
"""

# ╔═╡ dca08890-c8af-4a31-b7cd-bf27e9bd91b7
md"""
!!! note "Exercise 1"
 
	- Open a new cell and turn it into markdown mode. Write in this cell the following text: `Today is a sunny day!`
	- Open another cell, turn it into markdown mode, and write the same text but in bold, and also in italics.
	- Open a new cell, turn it into markdown mode, and write the following: This is text and mathematics with a funny equation $y = xz/2$
	- Open a new cell, turn it into markdown mode, and write the following equation: $y = 3x^2$
	
"""

# ╔═╡ 74859869-a180-49ec-92aa-c8a5084fa019
md"""
Today is a sunny day!
"""

# ╔═╡ 18b4d9f4-a871-42bd-8668-2a51532f2199
md"""
**Today is a sunny day!**

_Today is a sunny day!_
"""

# ╔═╡ 992e5c74-8892-4e07-93b2-138f33cd7982
md"""
This is text and mathematics with a funny equation
$y=xz/2$

$y=\dfrac{yx}{2}$
"""

# ╔═╡ 47aef155-bb60-4076-9156-e5aa1f52516f
md"""
$y=3x^2$
"""

# ╔═╡ a0280f97-cf3d-4aaf-a013-45d957bd5700
md"""
!!! tip "Answer"

	Insert it below	 this cell	 

"""

# ╔═╡ dfc08cee-92a3-43dd-a4be-e66a7a3ae4d9
md"""
____________________________________________________________________________________________________________
"""

# ╔═╡ 847ceec0-33cc-4cf4-a27f-ab7b85944529
md"""
## 3. Arithmetic operators
"""

# ╔═╡ 8f1bb867-1fa7-45e1-9806-70055ae22403
md"""

	+x	    unary plus	        the identity operation

	-x	    unary minus	      	maps values to their additive inverses

	x + y	binary plus	    	performs addition

	x - y	binary minus		performs subtraction

	x * y	times	        	performs multiplication

	x / y	divide	        	performs division

	x ÷ y	integer divide		x / y, truncated to an integer

	x \ y	inverse divide		equivalent to y / x

	x ^ y	power				raises x to the yth power

	x % y	remainder			equivalent to rem(x,y)'

"""

# ╔═╡ 4e908c09-f7eb-4698-9e9a-af1b7f7e5dc0
2+3

# ╔═╡ eea51a0b-cbe8-4fec-baec-ebc0601374d5
10^4

# ╔═╡ 731a0394-6dc6-44af-ada7-164fe8ed0c20
pepe = 10

# ╔═╡ 697cac78-ee49-48b7-9e7e-e6eace68cab9
rock = 20

# ╔═╡ abf827e7-0a9f-45e0-b89e-4b7ebaece273
mary = pepe * rock

# ╔═╡ b26522be-2c5e-4cd0-bfa2-eb20ff1f8070
md"""
`fiona = `$(@bind fiona Slider(-5.0:0.5:5.0, default=1.0, show_value=true))
"""

# ╔═╡ f01ee3cf-674b-41e2-8615-aebacb9ba384
paty = (fiona * mary , fiona^2 , fiona*mary , 10*fiona,60)

# ╔═╡ b92ca7c0-de44-4f39-9195-9d292b955885
paty[5]

# ╔═╡ 26c4d01b-729e-4629-90a8-1e91247d0dff
md"""
!!! note "Exercise 2"
 
	What is the value of a variable called "zazu", given the following equation?

	$$zazu = 10 + rock^2 + \frac{pepe}{2}$$
"""

# ╔═╡ 44eadb1a-e4e2-4e62-a2b5-c29d11e9dc40


# ╔═╡ 9d6a33a0-72c5-4c36-b1be-fa17996ceda9
md"""
!!! tip "Answer"

	Here 	 	 

"""

# ╔═╡ b0ef4ed2-8236-4809-a508-74fee43f4bb2
md"""
____________________________________________________________________________________________________________
"""

# ╔═╡ 9b622087-ad34-4f19-9929-cbdf0256eae0
md"""
## 4. Magic things we can do with Pluto
"""

# ╔═╡ 3bfc160d-f239-4cf4-8bec-29357a6f4a02
md"""
#### Write normal text and sophisticated mathematics
"""

# ╔═╡ 0e16393b-949b-4224-91bc-9935d1296b19
md"""
Consider now an optimization problem where the constraints are defined in terms of inequalities. This can be solved by using the famous Karush-Kuhn–Tucker conditions, which require too much space to be explained here. Ax encellent place to look at is Chapter 6 of the textbook: Rangarajan K. Sundaram  (1996). A First Course in Optimization Theory, Cambridge University Press.

Using two packages of Julia (JuMP and GLPK), the syntax to solve this problem can be found below. In particular, look how close the Julia syntax is to the mathematical syntax.
"""

# ╔═╡ ccaa821b-9ab9-4f00-8b87-daca8b6fa220
md"""
$$\max \quad x_{1}+2 x_{2}+5 x_{3}
$$

subject to

$$
\begin{aligned}
-x_{1}+x_{2}+3 x_{3} & \leq-5 \\
x_{1}+3 x_{2}-7 x_{3} & \leq 10 \\
0 \leq x_{1} & \leq 10 \\
x_{2} & \geq 0 \\
x_{3} & \geq 0
\end{aligned}$$

And then, blaa blaa blaa ....
"""

# ╔═╡ d62edf2a-4d96-4efe-b67d-936e952d2598
md"""
____________________________________________________________________________________________________________
"""

# ╔═╡ 61c1d067-42b9-40ec-94f5-c489009d4750
md"""
#### Use fancy symbols for writing text and doing computation
"""

# ╔═╡ 994ce847-6ecb-4bb4-9c87-1cb8d2ab7aac
md"""
I have a 😺 that loves the 🌚, but not 🍍. And I can do write simple text or do computations with these adorable objects. 
"""

# ╔═╡ 36062508-ca75-4e49-9761-63bcd2192c50
md"""
!!! tip
	To write special characters (like beta, for example) do the following: 
	- type: `\beta` followed by `Tab`
	- The firt time you do it, you have to click more than one time on the `Tab` key. After that, clicking only once will be enough.
"""

# ╔═╡ 514e835f-ae81-4ab1-b6fb-516f27dc9b80
β = 2 

# ╔═╡ 87c3c9a3-c644-4bf5-8f45-23aef698aed8
α = 10 * β

# ╔═╡ 115a327d-e2cb-4dba-88e2-1b0772efcf97
β^2

# ╔═╡ 57fffe2f-d145-4b51-93cf-9d7c47251f7d
begin # whenever a code cell contains more than 1 line, use the block begin ... end
	🍏 = 100
	😃 = 500
end

# ╔═╡ 209ec182-69a5-45ee-a08d-cbdc38b8c13d
🍏*🍏 / (2*😃)

# ╔═╡ 5ed34817-3a39-47c0-af02-e40b112fc97f
md"""
!!! note "Exercise 3"
 
	- Open a new cell and turn it into markdown mode. 
	- Write in this cell the following symbols (beta, psi, theta): β ψ θ
"""

# ╔═╡ f2ebc1b2-aedb-49a1-8e7f-4c1ed253dfd2
md"""
β
ψ
θ
"""

# ╔═╡ 96c4c032-7444-496d-98df-88b297b02930
md"""
____________________________________________________________________________________________________________
"""

# ╔═╡ 05377a5f-a2d8-49a9-a1db-d34165539350
md"""
#### Play with sliders
"""

# ╔═╡ 88302f04-9d37-4435-859b-5ce58c510c21
md"""
!!! note "Exercise 4"
 
	Move the two sliders above (one slide at a time), and see what happens to the equilibrium in the plot above.
"""

# ╔═╡ 07919360-2d5b-43f4-ad37-303447e97fff
md"""
!!! tip "Answer"

	Here 	 	 

"""

# ╔═╡ dd818b37-14bc-4864-b781-f4fe5f284f5e
md"""
____________________________________________________________________________________________________________
"""

# ╔═╡ 89024599-24b2-4a2f-bc2e-2390a240ef73
md"""
#### Playing with questions & answers 
"""

# ╔═╡ 75334264-9046-40aa-8976-c51a184c7f20
md"""
!!! note "Exercise 5"
 
	Table 1 shows some important macroeconomic aggregates, measured in **real terms**, for the US economy in 2013. The data in this table has been inserted into the notebook (see cell below). Answer the questions 👉 **a)** and 👉 **b)**
"""

# ╔═╡ 90dee13e-ae43-41c9-8b2f-477a99b8970c
md"""
$$\begin{aligned}
& \text {Table 1. Expenditure in the USA in 2013}\\
&\begin{array}{cllr}
\hline \hline \text {  } & \text{Code} & \text {Headings} & \text {Billions of dollars} \\
\hline  
1 & con & \text{Private Consumption Expenditures} & 11400 &  \\
2 & invest & \text{Investment in Equipment and Structures} & 2600 &  \\
3 & vs & \text{Inventories} & 80 &  \\
4 & pe & \text{Public Expenditures} & 3120 &  \\
5 & exp & \text{Exports} & 2250 &  \\
6 & imp & \text{Imports} & 3000 &  \\

\hline
\end{array}
\end{aligned}$$

"""

# ╔═╡ 87c3c15c-eaff-4ecf-9e22-5153f82105b8
# values passed into the notebook
con = 11400 ; invest = 2600 ; vs = 80 ; pe = 3120 ; exp = 2250 ; imp = 3000 ;

# ╔═╡ f79c7ca4-2d33-4cb6-80d6-769fc35a786e
md"""
👉 **a)** Using Table 1, calculate GDP by the expenditure method. 
"""

# ╔═╡ 95c1b74f-8455-4b29-8d5a-10caeb08eac0
md"""
!!! hint

	According to the usual definition of GDP by the expenditure method, GDP is equal to the sum of  private consumption, plus public expenditure on goods and services, plus investment and inventories, plus exports minus imports.
"""

# ╔═╡ 3d5525e4-a4e7-402b-a059-4a2a68c6007b
md"""
wirpt
cig
"""

# ╔═╡ acb697d5-7740-4288-a315-011bba9a4d3e
GDP = con + invest + vs + pe + exp - imp

# ╔═╡ 5591342f-66c4-41d6-a6e4-77860ca51ddb
md"""
!!! tip "Answer (a) "

	Here 

"""

# ╔═╡ 9287b718-facc-4fc5-bdad-5db78d9cbb95
md"""
👉 **b)** In a market economy, such as the one we live in, do you have any suggestion about the main macroeconomic variables that explain the behavior of private investment?
"""

# ╔═╡ fdab4b6d-10c2-4e66-8084-08ac3cb85a19
md"""
!!! tip "Answer (b) "

	Here

"""

# ╔═╡ b3742612-ebb6-495d-add9-f3287ce11b8d
md"""
____________________________________________________________________________________________________________
"""

# ╔═╡ d816ec4a-6478-4508-b7e3-22466a75c5cb
md"""
## 5. Ploting functions
"""

# ╔═╡ 4bd7ab99-9b66-4e54-97a1-9026554fb57f
begin
	x =  0.0 : 0.01 : 20.0
	#Ana = 2 * x.^0.5
	Ana = 2 * sin.(x)
end;

# ╔═╡ 69e7ab97-6177-4bce-90b4-dea49addf5fd
begin
	fig1 = Plot(x, Ana)
	#relayout!(fig1, Layout(hovermode="x", title_text="My fancy plot", title_x = 0.5, titlefont_size="17"))
	#fig1
end

# ╔═╡ 8fa56fa5-0e74-4340-98bf-de3870eeb4a1
noise = randn(500);

# ╔═╡ 12a07415-1077-4d6d-a414-897265ffe641
begin
	fig3 = Plot(histogram(x=noise, opacity=0.75, nbins=60), Layout(bargap= 0.05))
end

# ╔═╡ 8d10cf9f-424d-4a6b-b039-c65ce4e9160f
md"""
!!! note "Exercise 6"
 
	In the following cell, produce a simple plot of the following function: 5*Ana
"""

# ╔═╡ 2b62cfeb-0117-4710-9641-bf9e4c52d6b7


# ╔═╡ bd1ec1d2-a5ab-4000-a111-273f82f22f24
md"""
!!! note "Exercise 6A"
 
	In the next cell, we hide the code that plots three functions together. To run the cell, click on the little eye to bring the cell back to the surface, delete the `;` found in the last line, and finally run the cell (`Ctrl` and `Enter`, or click on the `run cell` button). The plot will then be produced.
"""

# ╔═╡ 5acf6f98-6dd8-4255-8a87-a96420aceb6f
begin
	x2 = LinRange(0, 3*π, 100)
	
	trace1 = scatter(x = x2, y = cos.(x2), line_width = 2, line_color = "blue", name = "Shrek")
	
	trace2 = scatter(x = x2, y = sin.(x2), line_dash = "dashdot", line_color="BlueViolet", name="Fiona")
	
	trace3 = scatter(x = x2, y = cos.(x2).^2 .- 1/2, mode = "markers+lines", marker_symbol = "circle-open",
	 	 			marker_size = "6", marker_color = "red", name = "Donkey", line_width = 0.5)
	
	layout1 = Layout(#font_size = 13, 
				hovermode="x",	
			   	title_text="My fancy plot with different lines & marker styles", title_x =0.5,
			   	titlefont_size="17")
	
	fig4 = Plot([trace1, trace2, trace3],layout1)
end;

# ╔═╡ c2e708fd-57d9-4059-a126-d094a205bffd
md"""
____________________________________________________________________________________________________________
"""

# ╔═╡ 4109af60-6178-4148-8efe-890245077188
md"""
## 6. Using linear algebra 
"""

# ╔═╡ 3a6c700f-148b-4fff-aa3e-7d20f3bc714a
A = [1 2 3 ; 4 1 6 ; 7 8 1]

# ╔═╡ c582f490-048b-4ecc-b3fe-918d623eaeae
inv(A) # the inverse of A

# ╔═╡ 09d8edd6-9d23-4af9-b8eb-3ded6c961621
transpose(A) # the transpose of A

# ╔═╡ d93094ca-4912-406a-a573-83887ec40848
det(A) # the determinant of Bia

# ╔═╡ 38851f55-d1af-40f7-a660-62bceec4093a
A' 

# ╔═╡ eaf75283-c222-46ef-a5ef-9bf9a6a94b75
A^2

# ╔═╡ a4f98b1b-cbb9-4dab-9e84-eba5fcd25c42
Zak = randn(3, 3)

# ╔═╡ 3850481f-94b1-4e34-ac43-a346ec70b038
aple = A * Zak


# ╔═╡ 291bfa24-a5f1-4505-83c1-b03f838b74de
md"""
!!! note "Exercise 7"
 
	Let us create a matrix of dimension (100x100), with all its elements as randomly generated numbers. Give this matrix a funny name Shrek: `Shrek = randn(100,100)`

	Calculate the inverse of Shrek. How long does it take your computer to calculate such an inverse matrix?
"""

# ╔═╡ 183d31a2-781a-4fb3-b6e8-c5f9f24ae8d8
md"""
!!! tip "Answer"

	Here

"""

# ╔═╡ 24236c6d-64cd-48be-bed8-8c149d1848a3
md"""
____________________________________________________________________________________________________________
"""

# ╔═╡ f2956bed-9534-4c57-bfaa-fbef3c4af810
md"""
## 7. Downloading and plotting data
"""

# ╔═╡ 2471cee6-6016-4067-81ec-42ed1a5969a4
md"""
###### Students are not expected to know *_how to do_* the plots below, but they must know *_how to use them_* if asked.
"""

# ╔═╡ 99a9f4f2-9920-42eb-b3a1-a93a3917c58a
md"""
To download the data file attached to this notebook -- its name is _EZ _ inf.csv_ -- we should do as exemplified below. A CSV file is the most used format to deal with data and it means "comma separated values". This data file contains the inflation rate for the EuroZone as a whole and four individual countries. This data was obtained from [here](https://ec.europa.eu/eurostat/databrowser/view/prc_hicp_manr/default/table?lang=en).

```julia
my_data = CSV.read("EZ_inf.csv", delim=";", DataFrame) 		# delim=";" or delim=","
```
"""

# ╔═╡ 8458c44a-fa6a-47a6-aa40-5c058ea1adca
inflation = CSV.read("EZ_inf.csv" , delim=';' , DataFrame)

# ╔═╡ 4d0908c7-97e1-40b2-b5e4-94e674dca992
md"""
To pass information about the dates in our data, we should do:
"""

# ╔═╡ 2b30d104-5649-4ff4-87ad-8befc60b97b4
period_1 = MonthlyDate(1997,1) : Month(1) : MonthlyDate(2022,8) ;

# ╔═╡ f48c4024-f727-4916-a241-f78ae00ba840
md"""
To summarize the data we downloaded, we should do:

```julia
describe(my_data)
```
"""

# ╔═╡ 1fcc5b55-ec11-408b-913c-9e3117921372
describe(inflation)

# ╔═╡ dd302ba2-66e7-4792-a39b-424f6fe0e065
md"""
To plot a single column of `inflation` we can do:
"""

# ╔═╡ bfc230e5-72cc-4ec3-ad08-0d847664069d
begin
	fig5 = Plot(Date.(period_1), inflation.Portugal)
end

# ╔═╡ 8b505a74-55ba-42c6-bd5a-e92ab73896ed
md"""
To plot more than one column, we can create a vector `[...]` with as many columns has we wish. In the case below we plot the columns associated with Germany and Portugal.
"""

# ╔═╡ 474d1ca9-be98-490c-ae27-2eeb24ce0422
begin
	fig6 = Plot(Date.(period_1), [inflation.Germany  inflation.Portugal])
end

# ╔═╡ f3ed22c3-6aae-4a10-b888-27ecd259bb01
md"""
We can add a title, the names of the variables (columns), a label to both axis, and a hover functionality into our previous plot. It will look like this (the code is hidden: to show the code click on the little eye button on the left):
"""

# ╔═╡ 3cef878f-9c7c-4150-8277-79b6ca75ceb1
begin
	restyle!(fig6, 1:2, name = ["Germany", "Portugal"]) # names Germany and Portugal on variables 1 and 2
	
	relayout!(fig6, Layout(
		title_text = "Inflation in Germany and Portugal", title_x = 0.5, 
		hovermode = "x", yaxis_title = "Percentage points", 
		xaxis_title = "Monthly observations")) # introduces a title, y-axis label, and the hover-mode
	
	fig6 # Updates the plot
end

# ╔═╡ 7a75bae4-dc0a-4e73-942d-60475fa2ce51
md"""
!!! note "Exercise 8"
 
	We can also save one plot as a "png" file or an "svg" file (among many other formats). These files can be inserted later into another document (like a PowerPoint or a Word file). Their graphical quality will be much higher than by using the archaic "screen-capture" functionality. In the next cell, save "fig6" as a svg file by doing `savefig(fig6, "inflation.svg")`. It will be automatically saved in the same folder where this notebook is.

"""

# ╔═╡ 65f3959c-779f-4ac2-8ba0-2c008a532ce1


# ╔═╡ 563f3087-85fd-4998-93a5-0121019a5827
begin
	trace1_1 = scatter(;x = Date.(period_1), y = inflation[:,2], 
				name = "EuroZone", mode="markers+lines",
				marker_symbol="circle", marker_size="4",line_width= 0.3, 
            	marker_color = "Blue")
	
	trace1_2 = scatter(;x = Date.(period_1), y = inflation[:,6], 
				name = "Portugal", mode="markers+lines",
				marker_symbol="circle", marker_size="4",line_width= 0.3,
            	marker_color = "Red")

	trace1_3 = scatter(;x = Date.(period_1), y = inflation[:,3], 
				name = "Germany", mode="markers+lines",
				marker_symbol="circle", marker_size="4",line_width= 0.3,
            	marker_color = "Gray")

	trace1_4 = scatter(;x = Date.(period_1), y = inflation[:,3], 
				name = "Spain", mode="markers+lines",
				marker_symbol="circle", marker_size="4",line_width= 0.3,
            	marker_color = "Purple")

	trace1_5 = scatter(;x = Date.(period_1), y = inflation[:,5], 
				name = "France", mode="markers+lines",
				marker_symbol="circle", marker_size="4",line_width= 0.3,
            	marker_color = "Orange")

	layout1_2 = Layout(;#font_size = 16,
					
			title_text = "Inflation in the EuroZone and Portugal", title_x=0.5,
		
			hovermode="x",		
		
            xaxis = attr(
               title = "Monthly obervations",
               tickformat = "%Y",
               hoverformat = "%Y-M%m",
               tick0 = "1997/01/01",
               dtick = "M60" ),
		
        	xaxis_range = [Date.(1997), Date.(2023)],
        	yaxis_title = "Percentage points",
        	#yaxis_range=[-2, 2], 
        	titlefont_size = 16)

	fig7 = Plot([trace1_1, trace1_2, trace1_3, trace1_4, trace1_5], layout1_2)
end

# ╔═╡ 3baa2ab2-3007-42c7-82fa-dbf59ac53d5b
md"""
!!! note "Exercise 8A"
 
	Create a simple plot of the following variable `inflation.EuroZone .- 2` (that is, Eurozone inflation minus 2% inflation). To achieve that apply the following code `Plot(Date.(period_1), inflation.EuroZone .- 2)` . The level of inflation that the European Central Bank wants to see in the Euro Zone is 2%. Check whether the wishes of the ECB have been accomplished in the EU.
"""

# ╔═╡ 5d96001b-861a-47ec-bab3-242d1d7c5ce1
md"""
!!! tip "Answer"

	Here 

"""

# ╔═╡ 839efccb-0a96-4cd1-b98f-981017eb2de2
md"""
____________________________________________________________________________________________________________
"""

# ╔═╡ 6460431a-c536-4a0b-8da5-c9e855bddd5a
md"""
## 8. Solving a complicated model
"""

# ╔═╡ fbac12bb-3a2f-4767-ba4d-5786b2285a25
md"""
!!! note "Exercise 9"
 
	Consider the following prototype of a macroeconomic model:

	$\begin{aligned}
	& y_{1} = a + 0.5 y_{2} - 2.5 y_{3} \\
	& y_{2} = -2 y_{1} + 5 y_{3} + b \\
	& y_{3} = 10 y_{1} + 2 c \\
	& a = 10 \ , \ b=2 \ , \ c=5
	\end{aligned}$

	Let us solve this model using the package `NLsolve`. The first thing we should do is to pass the values of the variables with known values to the notebook: $a=10,b=2,c=5$: 

"""

# ╔═╡ ee99589f-9794-49e8-bccd-0a580f489860
a = 10 ; b = 2 ; c = 5;

# ╔═╡ 3af336b8-decb-4608-bdfe-5ba43e0e3b43
md"""
The first thing we have to is to write our model as an homegeneous system (zeros on its left hand side)

$$\begin{aligned}
&0=a+0.5 y_2-2.5 y_3 -y_1 \\
&0=-2 y_1+5 y_3+b -y_2 \\
&0=10 y_1+2 c - y_3
\end{aligned}$$
"""

# ╔═╡ e99f49c6-8ecf-4519-868d-5b76ee13e658
md"""
Then we have to have to write down our problem according to the syntax of NLsolve: 

- give a name to our problem: let us name it as _king _ julien_

- define the variables in our problem: v[1], v[2], v[3] 

- define the equations in our problem: F[1], F[2], F[3] 
"""

# ╔═╡ 7b2a274a-ee89-4bd7-a61a-eb9c97c7b548
begin
	function neco!(F, v)
		
		y1 = v[1] 
        y2 = v[2] 
		y3 = v[3] 

        F[1] = a + 0.5y2 - 2.5y3 - y1
        F[2] = -2y1 + 5y3 + b - y2
		F[3] = 10y1 + 2c - y3 
			
	end
end

# ╔═╡ 59988d03-8580-4597-81da-225379f0298f
md"""
Finally, we should compute the solution to our problem according to the syntax of NLsolve: 

- give a name to the solution to our problem: let us name it as _my _ solution_

- call the NLsolve function that will solve the problem: _nlsolve_ 

- pass the problem to be solved (in this case is _king _ julien_), and give three initial guesses for the package to start the computation. For linear problems $[0.0 ; 0.0 ; 0.0]$ always works. The number of initial guesses must equal the number of unknowns in the model.
"""

# ╔═╡ 4852e7c0-6bdd-4f7e-8def-587db2fffd75
begin
	my_solution = nlsolve(neco!, [0 ; 0.0 ; 0.0])		# provides the solution
	my_solution.zero   		 									# simplifies (rounds up) the solution
end

# ╔═╡ cb87898f-2999-4d9c-aee1-dd4100c9eaac
my_solution

# ╔═╡ a0468b27-1df3-4661-baec-e7adb42f281e
md"""
!!! tip "Answer"

	Here

"""

# ╔═╡ 02738dfd-8dc3-4396-be73-6242df0f5234
md"""
____________________________________________________________________________________________________________
"""

# ╔═╡ edbd2b1c-1452-41a6-962c-3434bd420020
md"""
## Auxiliary cells (please do not change them)
"""

# ╔═╡ c7190cc0-08d8-45c8-b5de-e5630e0ff00e
html"""<style>
main {
    max-width: 900px;
    align-self: flex-start;
    margin-left: 100px;
}
"""

# ╔═╡ d9672a6f-97af-43d1-9a30-50495204fec8
 TableOfContents()

# ╔═╡ 37e34e48-c2a7-4ffd-ac97-1a6ecb44ea92
begin	
	# Demand	
	Ā3 = 8.0
	λ3 = 0.5
	m3 = 2.0
	ϕ3 = 0.2
	r̄3 = 2.0	
	# Supply	
	γ3  = 2.8
	Yᴾ3 = 14.8
	πᵉ3 = 2.0
	ρ3  = 0.0	
	# Intercepts (useful to simplify notation)	
	πd_max3 = (Ā3 / (λ3 * ϕ3)) - r̄3/λ3        # The AD curve y-axis' intercept
	πs_min3 = πᵉ3 - γ3 * Yᴾ3 + ρ3             # The AS curve y-axis' intercept
end;

# ╔═╡ 1bf47443-0ee4-482a-b637-8081620c144b
begin
	π_ZL3= -r̄3 / (1+λ3)
	πd_min3 = - Ā3 / ϕ3
	Y_ZL3 = Ā3 * m3 - (m3 *  ϕ3 * r̄3) / (1+λ3)
	ρ4 = -3.15
end;

# ╔═╡ 756b03e3-f745-48f6-bf5b-7c0f0d5d7c2f
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

# ╔═╡ f3d1f71c-5108-4394-a98d-dc670f1091ae
TwoColumns(
md"""

`ΔĀ = `$(@bind ΔĀ Slider(-1.0:0.05:1.0, default=0.0, show_value=true))

""",
	
md"""

`ΔYᴾ = `$(@bind ΔYᴾ Slider(-1.0:0.05:1.0, default=0.0, show_value=true))

"""
)

# ╔═╡ 6db02201-bbe3-4ca8-a36b-7a5ac9e6385e
begin
	Y3 = 13.8:0.01:15.6
	
	πd3 = πd_max3 .- ((1 ./(m3 .* ϕ3 .* λ3)) .* Y3) # AD function
	πs3 = πs_min3 .+ γ3 .*Y3             # AS function
	
	trace9_0 = scatter(; x = [14.8 .+ ΔYᴾ , 14.8 .+ ΔYᴾ] , y = [-5,10] , 
			mode = "line", line_width = "4", name = "Yp", line_color = "Orange")
	
	trace9_1 = scatter(; x = Y3, y = πd3, mode="lines" , line_color = "Blue", line_width = "3",
			name  = "AD")
	
	trace9_2 = scatter(; x = Y3, y = πs3, mode="lines" , line_color = "Red", line_width = "3",
					name  = "AS")
	
	trace9_3 = scatter(; x = [14.8], y = [2.0], text =["1"], 
					textposition = "top center", name ="Eq1", mode="markers+text", marker_size= "12",
					marker_color="Blue", textcolor = "Black",
	 				textfont = attr(family="sans serif", size=18, color="black"))


	πd_max3_ΔĀ = ((Ā3 .+ ΔĀ) ./ (λ3 .* ϕ3)) .- r̄3 ./ λ3 # New max value of the AD function
	
	πd3_ΔĀ = πd_max3_ΔĀ .- ((1 ./(m3 .* ϕ3 .* λ3)) .* Y3) # AD function
	
	
	trace9_4 = scatter(; x = Y3, y = πd3_ΔĀ, mode="lines" , line_color = "Magenta", 
					 line_width = "3", name  = "AD2")
		
	#trace9_5 = scatter(; x = [14.21], y = [2.947], text =["2"], 
	#				textposition = "top center", name ="Eq2", mode="markers+text", 
	#				marker_size= "12", marker_color="Magenta",
	#				textfont = attr(family="sans serif", size=16, color="black"))
	
	
	layout9_5 = Layout(;
					title_text ="Initial long-term equilibrium",
					title_x = 0.5,
					hovermode = "x",
                    xaxis=attr(title=" GDP trillion dollars (Y)", showgrid=true, zeroline=false),
                    xaxis_range = [14.2, 15.4],	
                    yaxis=attr(title="Rate of inflation (π)", zeroline = false),
					yaxis_range=[-0.8 , 5])

   fig0 = Plot([trace9_0, trace9_1, trace9_2, trace9_4, trace9_3], layout9_5)
	
	
end

# ╔═╡ 00000000-0000-0000-0000-000000000001
PLUTO_PROJECT_TOML_CONTENTS = """
[deps]
CSV = "336ed68f-0bac-5ca0-87d4-7b16caf5d00b"
DataFrames = "a93c6f00-e57d-5684-b7b6-d8193f3e46c0"
Dates = "ade2ca70-3891-5945-98fb-dc099432e06a"
HypertextLiteral = "ac1192a8-f4b3-4bfe-ba22-af5b92cd3ab2"
LinearAlgebra = "37e2e46d-f89d-539d-b4ee-838fcccc9c8e"
NLsolve = "2774e3e8-f4cf-5e23-947b-6d7e65073b56"
PeriodicalDates = "276e7ca9-e0d7-440b-97bc-a6ae82f545b1"
PlotlyBase = "a03496cd-edff-5a9b-9e67-9cda94a718b5"
PlotlyJS = "f0f68f2c-4968-5e81-91da-67840de0976a"
PlutoPlotly = "8e989ff0-3d88-8e9f-f020-2b208a939ff0"
PlutoUI = "7f904dfe-b85e-4ff6-b463-dae2292396a8"
Statistics = "10745b16-79ce-11e8-11f9-7d13ad32a3b2"

[compat]
CSV = "~0.10.11"
DataFrames = "~1.6.1"
HypertextLiteral = "~0.9.4"
NLsolve = "~4.5.1"
PeriodicalDates = "~2.0.0"
PlotlyBase = "~0.8.19"
PlotlyJS = "~0.18.10"
PlutoPlotly = "~0.3.9"
PlutoUI = "~0.7.52"
"""

# ╔═╡ 00000000-0000-0000-0000-000000000002
PLUTO_MANIFEST_TOML_CONTENTS = """
# This file is machine-generated - editing it directly is not advised

julia_version = "1.9.3"
manifest_format = "2.0"
project_hash = "078712a8c308ee1a2c17d0d995ad2efc1c3d8731"

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

[[deps.AssetRegistry]]
deps = ["Distributed", "JSON", "Pidfile", "SHA", "Test"]
git-tree-sha1 = "b25e88db7944f98789130d7b503276bc34bc098e"
uuid = "bf4720bc-e11a-5d0c-854e-bdca1663c893"
version = "0.1.0"

[[deps.Base64]]
uuid = "2a0f44e3-6c83-55bd-87e4-b1978d98bd5f"

[[deps.BitFlags]]
git-tree-sha1 = "43b1a4a8f797c1cddadf60499a8a077d4af2cd2d"
uuid = "d1d4a3ce-64b1-5f1a-9ba4-7e7e69966f35"
version = "0.1.7"

[[deps.Blink]]
deps = ["Base64", "Distributed", "HTTP", "JSExpr", "JSON", "Lazy", "Logging", "MacroTools", "Mustache", "Mux", "Pkg", "Reexport", "Sockets", "WebIO"]
git-tree-sha1 = "b1c61fd7e757c7e5ca6521ef41df8d929f41e3af"
uuid = "ad839575-38b3-5650-b840-f874b8c74a25"
version = "0.12.8"

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
weakdeps = ["SpecialFunctions"]

    [deps.ColorVectorSpace.extensions]
    SpecialFunctionsExt = "SpecialFunctions"

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

[[deps.ConcurrentUtilities]]
deps = ["Serialization", "Sockets"]
git-tree-sha1 = "5372dbbf8f0bdb8c700db5367132925c0771ef7e"
uuid = "f0e56b4a-5159-44fe-b623-3e5288b988bb"
version = "2.2.1"

[[deps.ConstructionBase]]
deps = ["LinearAlgebra"]
git-tree-sha1 = "c53fc348ca4d40d7b371e71fd52251839080cbc9"
uuid = "187b0558-2788-49d3-abe0-74a17ed4e7c9"
version = "1.5.4"

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

[[deps.ExceptionUnwrapping]]
deps = ["Test"]
git-tree-sha1 = "e90caa41f5a86296e014e148ee061bd6c3edec96"
uuid = "460bff9d-24e4-43bc-9d9f-a8973cb893f4"
version = "0.1.9"

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

[[deps.ForwardDiff]]
deps = ["CommonSubexpressions", "DiffResults", "DiffRules", "LinearAlgebra", "LogExpFunctions", "NaNMath", "Preferences", "Printf", "Random", "SpecialFunctions"]
git-tree-sha1 = "cf0fe81336da9fb90944683b8c41984b08793dad"
uuid = "f6369f11-7733-5829-9624-2563aa707210"
version = "0.10.36"

    [deps.ForwardDiff.extensions]
    ForwardDiffStaticArraysExt = "StaticArrays"

    [deps.ForwardDiff.weakdeps]
    StaticArrays = "90137ffa-7385-5640-81b9-e52037218182"

[[deps.FunctionalCollections]]
deps = ["Test"]
git-tree-sha1 = "04cb9cfaa6ba5311973994fe3496ddec19b6292a"
uuid = "de31a74c-ac4f-5751-b3fd-e18cd04993ca"
version = "0.5.0"

[[deps.Future]]
deps = ["Random"]
uuid = "9fa8497b-333b-5362-9e8d-4d0656e87820"

[[deps.HTTP]]
deps = ["Base64", "CodecZlib", "ConcurrentUtilities", "Dates", "ExceptionUnwrapping", "Logging", "LoggingExtras", "MbedTLS", "NetworkOptions", "OpenSSL", "Random", "SimpleBufferStream", "Sockets", "URIs", "UUIDs"]
git-tree-sha1 = "19e974eced1768fb46fd6020171f2cec06b1edb5"
uuid = "cd3eb016-35fb-5094-929b-558a96fad6f3"
version = "1.9.15"

[[deps.Hiccup]]
deps = ["MacroTools", "Test"]
git-tree-sha1 = "6187bb2d5fcbb2007c39e7ac53308b0d371124bd"
uuid = "9fb69e20-1954-56bb-a84f-559cc56a8ff7"
version = "0.2.2"

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

[[deps.JSExpr]]
deps = ["JSON", "MacroTools", "Observables", "WebIO"]
git-tree-sha1 = "b413a73785b98474d8af24fd4c8a975e31df3658"
uuid = "97c1335a-c9c5-57fe-bc5d-ec35cebe8660"
version = "0.5.4"

[[deps.JSON]]
deps = ["Dates", "Mmap", "Parsers", "Unicode"]
git-tree-sha1 = "31e996f0a15c7b280ba9f76636b3ff9e2ae58c9a"
uuid = "682c06a0-de6a-54ab-a142-c8b1cf79cde6"
version = "0.21.4"

[[deps.Kaleido_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "43032da5832754f58d14a91ffbe86d5f176acda9"
uuid = "f7e6163d-2fa5-5f23-b69c-1db539e41963"
version = "0.2.1+0"

[[deps.LaTeXStrings]]
git-tree-sha1 = "f2355693d6778a178ade15952b7ac47a4ff97996"
uuid = "b964fa9f-0449-5b57-a5c2-d3ea65f4040f"
version = "1.3.0"

[[deps.Lazy]]
deps = ["MacroTools"]
git-tree-sha1 = "1370f8202dac30758f3c345f9909b97f53d87d3f"
uuid = "50d2b5c4-7a5e-59d5-8109-a42b560f39c0"
version = "0.15.1"

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

[[deps.LoggingExtras]]
deps = ["Dates", "Logging"]
git-tree-sha1 = "0d097476b6c381ab7906460ef1ef1638fbce1d91"
uuid = "e6f89c97-d47a-5376-807f-9c37f3926c36"
version = "1.0.2"

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

[[deps.MbedTLS]]
deps = ["Dates", "MbedTLS_jll", "MozillaCACerts_jll", "Random", "Sockets"]
git-tree-sha1 = "03a9b9718f5682ecb107ac9f7308991db4ce395b"
uuid = "739be429-bea8-5141-9913-cc70e7f3736d"
version = "1.1.7"

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

[[deps.Mustache]]
deps = ["Printf", "Tables"]
git-tree-sha1 = "821e918c170ead5298ff84bffee41dd28929a681"
uuid = "ffc61752-8dc7-55ee-8c37-f3e9cdd09e70"
version = "1.0.17"

[[deps.Mux]]
deps = ["AssetRegistry", "Base64", "HTTP", "Hiccup", "MbedTLS", "Pkg", "Sockets"]
git-tree-sha1 = "0bdaa479939d2a1f85e2f93e38fbccfcb73175a5"
uuid = "a975b10e-0019-58db-a62f-e48ff68538c9"
version = "1.0.1"

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

[[deps.Observables]]
git-tree-sha1 = "6862738f9796b3edc1c09d0890afce4eca9e7e93"
uuid = "510215fc-4207-5dde-b226-833fc4488ee2"
version = "0.5.4"

[[deps.OpenBLAS_jll]]
deps = ["Artifacts", "CompilerSupportLibraries_jll", "Libdl"]
uuid = "4536629a-c528-5b80-bd46-f80d51c5b363"
version = "0.3.21+4"

[[deps.OpenLibm_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "05823500-19ac-5b8b-9628-191a04bc5112"
version = "0.8.1+0"

[[deps.OpenSSL]]
deps = ["BitFlags", "Dates", "MozillaCACerts_jll", "OpenSSL_jll", "Sockets"]
git-tree-sha1 = "51901a49222b09e3743c65b8847687ae5fc78eb2"
uuid = "4d8831e6-92b7-49fb-bdf8-b643e874388c"
version = "1.4.1"

[[deps.OpenSSL_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl"]
git-tree-sha1 = "e78db7bd5c26fc5a6911b50a47ee302219157ea8"
uuid = "458c3c95-2e84-50aa-8efc-19380b2a3a95"
version = "3.0.10+0"

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

[[deps.Pidfile]]
deps = ["FileWatching", "Test"]
git-tree-sha1 = "2d8aaf8ee10df53d0dfb9b8ee44ae7c04ced2b03"
uuid = "fa939f87-e72e-5be4-a000-7fc836dbe307"
version = "1.3.0"

[[deps.Pkg]]
deps = ["Artifacts", "Dates", "Downloads", "FileWatching", "LibGit2", "Libdl", "Logging", "Markdown", "Printf", "REPL", "Random", "SHA", "Serialization", "TOML", "Tar", "UUIDs", "p7zip_jll"]
uuid = "44cfe95a-1eb2-52ea-b672-e2afdf69b78f"
version = "1.9.2"

[[deps.PlotlyBase]]
deps = ["ColorSchemes", "Dates", "DelimitedFiles", "DocStringExtensions", "JSON", "LaTeXStrings", "Logging", "Parameters", "Pkg", "REPL", "Requires", "Statistics", "UUIDs"]
git-tree-sha1 = "56baf69781fc5e61607c3e46227ab17f7040ffa2"
uuid = "a03496cd-edff-5a9b-9e67-9cda94a718b5"
version = "0.8.19"

[[deps.PlotlyJS]]
deps = ["Base64", "Blink", "DelimitedFiles", "JSExpr", "JSON", "Kaleido_jll", "Markdown", "Pkg", "PlotlyBase", "REPL", "Reexport", "Requires", "WebIO"]
git-tree-sha1 = "7452869933cd5af22f59557390674e8679ab2338"
uuid = "f0f68f2c-4968-5e81-91da-67840de0976a"
version = "0.18.10"

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

[[deps.Setfield]]
deps = ["ConstructionBase", "Future", "MacroTools", "StaticArraysCore"]
git-tree-sha1 = "e2cc6d8c88613c05e1defb55170bf5ff211fbeac"
uuid = "efcf1570-3423-57d1-acb7-fd33fddbac46"
version = "1.1.1"

[[deps.SimpleBufferStream]]
git-tree-sha1 = "874e8867b33a00e784c8a7e4b60afe9e037b74e1"
uuid = "777ac1f9-54b0-4bf8-805c-2214025038e7"
version = "1.1.0"

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

[[deps.StringManipulation]]
deps = ["PrecompileTools"]
git-tree-sha1 = "a04cabe79c5f01f4d723cc6704070ada0b9d46d5"
uuid = "892a3eda-7b42-436c-8928-eab12a02cf0e"
version = "0.3.4"

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

[[deps.WebIO]]
deps = ["AssetRegistry", "Base64", "Distributed", "FunctionalCollections", "JSON", "Logging", "Observables", "Pkg", "Random", "Requires", "Sockets", "UUIDs", "WebSockets", "Widgets"]
git-tree-sha1 = "0eef0765186f7452e52236fa42ca8c9b3c11c6e3"
uuid = "0f1e0344-ec1d-5b48-a673-e5cf874b6c29"
version = "0.8.21"

[[deps.WebSockets]]
deps = ["Base64", "Dates", "HTTP", "Logging", "Sockets"]
git-tree-sha1 = "4162e95e05e79922e44b9952ccbc262832e4ad07"
uuid = "104b5d7c-a370-577a-8038-80a2059c5097"
version = "1.6.0"

[[deps.Widgets]]
deps = ["Colors", "Dates", "Observables", "OrderedCollections"]
git-tree-sha1 = "fcdae142c1cfc7d89de2d11e08721d0f2f86c98a"
uuid = "cc8bc4a8-27d6-5769-a93b-9d913e69aa62"
version = "0.6.6"

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
# ╟─82090c38-1ecd-43eb-aeca-135d996b8e72
# ╟─76164b77-2e0b-4deb-8ef8-1b2263260e7a
# ╟─694d78c7-4762-4d40-8f9a-6c3d16916d4e
# ╟─554b2cc5-99e1-4eda-b080-67ab2eddac16
# ╠═b72215bb-8e3a-46e2-8817-271befe1178c
# ╟─31023dd0-f304-471e-a292-2a40915ebcbf
# ╟─7afb249a-ee89-4874-91fa-6da606948b2a
# ╟─072b3431-0b22-4801-a75e-25cd77a7d70d
# ╟─86f1359d-3637-4892-9720-e042fae6543a
# ╟─0fc80d2d-6519-4f17-83c4-25ab9b26d8ce
# ╟─16ecc97b-a401-4172-bcbb-b0baa156b53c
# ╟─df155c1a-ca04-4bb9-954f-e5684aef683c
# ╟─9dc454b2-9d5d-4ab1-aa0b-75ddefb6960d
# ╠═2e4b767f-45e2-47b4-b793-fe553f53bfad
# ╟─564ff460-aa1f-4b9d-abf3-a024a13d96a3
# ╟─6307472b-3a3e-4d9a-82fd-25d295abaae1
# ╟─638ac59a-6fb2-447f-8856-0c6f74494e7b
# ╟─98f18fc3-0748-4ec7-a6a0-955e2ea22e19
# ╟─e81d6184-2b39-4205-83a8-9e2d7e5d41dd
# ╟─70af87bd-81b5-4aa0-b1f7-0639d1f09d0a
# ╠═2da4b605-2d9e-494a-810f-5d153dee7096
# ╟─8c3253f4-86c2-4b88-9850-f7daed87774d
# ╟─40139e5d-3069-4a48-ab37-48849eac8ec6
# ╟─939053b1-5c6b-4246-9102-d845e37c70a0
# ╟─a1e2ea1a-8ffb-49e8-a22e-8be913a5074f
# ╟─cab5fa24-d103-4ce6-b979-80901b9a01a0
# ╟─f6162891-de97-4522-a919-4942158cb2a0
# ╟─b3c16511-06d5-476d-b1ce-b8b35d038819
# ╟─dca08890-c8af-4a31-b7cd-bf27e9bd91b7
# ╟─74859869-a180-49ec-92aa-c8a5084fa019
# ╟─18b4d9f4-a871-42bd-8668-2a51532f2199
# ╟─992e5c74-8892-4e07-93b2-138f33cd7982
# ╟─47aef155-bb60-4076-9156-e5aa1f52516f
# ╟─a0280f97-cf3d-4aaf-a013-45d957bd5700
# ╟─dfc08cee-92a3-43dd-a4be-e66a7a3ae4d9
# ╟─847ceec0-33cc-4cf4-a27f-ab7b85944529
# ╟─8f1bb867-1fa7-45e1-9806-70055ae22403
# ╠═4e908c09-f7eb-4698-9e9a-af1b7f7e5dc0
# ╠═eea51a0b-cbe8-4fec-baec-ebc0601374d5
# ╠═731a0394-6dc6-44af-ada7-164fe8ed0c20
# ╠═697cac78-ee49-48b7-9e7e-e6eace68cab9
# ╠═abf827e7-0a9f-45e0-b89e-4b7ebaece273
# ╟─b26522be-2c5e-4cd0-bfa2-eb20ff1f8070
# ╠═f01ee3cf-674b-41e2-8615-aebacb9ba384
# ╠═b92ca7c0-de44-4f39-9195-9d292b955885
# ╟─26c4d01b-729e-4629-90a8-1e91247d0dff
# ╠═44eadb1a-e4e2-4e62-a2b5-c29d11e9dc40
# ╟─9d6a33a0-72c5-4c36-b1be-fa17996ceda9
# ╟─b0ef4ed2-8236-4809-a508-74fee43f4bb2
# ╟─9b622087-ad34-4f19-9929-cbdf0256eae0
# ╟─3bfc160d-f239-4cf4-8bec-29357a6f4a02
# ╟─0e16393b-949b-4224-91bc-9935d1296b19
# ╟─ccaa821b-9ab9-4f00-8b87-daca8b6fa220
# ╟─d62edf2a-4d96-4efe-b67d-936e952d2598
# ╟─61c1d067-42b9-40ec-94f5-c489009d4750
# ╟─994ce847-6ecb-4bb4-9c87-1cb8d2ab7aac
# ╟─36062508-ca75-4e49-9761-63bcd2192c50
# ╠═514e835f-ae81-4ab1-b6fb-516f27dc9b80
# ╠═87c3c9a3-c644-4bf5-8f45-23aef698aed8
# ╠═115a327d-e2cb-4dba-88e2-1b0772efcf97
# ╠═57fffe2f-d145-4b51-93cf-9d7c47251f7d
# ╠═209ec182-69a5-45ee-a08d-cbdc38b8c13d
# ╟─5ed34817-3a39-47c0-af02-e40b112fc97f
# ╟─f2ebc1b2-aedb-49a1-8e7f-4c1ed253dfd2
# ╟─96c4c032-7444-496d-98df-88b297b02930
# ╟─05377a5f-a2d8-49a9-a1db-d34165539350
# ╟─f3d1f71c-5108-4394-a98d-dc670f1091ae
# ╟─6db02201-bbe3-4ca8-a36b-7a5ac9e6385e
# ╟─88302f04-9d37-4435-859b-5ce58c510c21
# ╟─07919360-2d5b-43f4-ad37-303447e97fff
# ╟─dd818b37-14bc-4864-b781-f4fe5f284f5e
# ╟─89024599-24b2-4a2f-bc2e-2390a240ef73
# ╟─75334264-9046-40aa-8976-c51a184c7f20
# ╠═90dee13e-ae43-41c9-8b2f-477a99b8970c
# ╠═87c3c15c-eaff-4ecf-9e22-5153f82105b8
# ╟─f79c7ca4-2d33-4cb6-80d6-769fc35a786e
# ╟─95c1b74f-8455-4b29-8d5a-10caeb08eac0
# ╟─3d5525e4-a4e7-402b-a059-4a2a68c6007b
# ╠═acb697d5-7740-4288-a315-011bba9a4d3e
# ╟─5591342f-66c4-41d6-a6e4-77860ca51ddb
# ╟─9287b718-facc-4fc5-bdad-5db78d9cbb95
# ╟─fdab4b6d-10c2-4e66-8084-08ac3cb85a19
# ╟─b3742612-ebb6-495d-add9-f3287ce11b8d
# ╟─d816ec4a-6478-4508-b7e3-22466a75c5cb
# ╠═4bd7ab99-9b66-4e54-97a1-9026554fb57f
# ╠═69e7ab97-6177-4bce-90b4-dea49addf5fd
# ╠═8fa56fa5-0e74-4340-98bf-de3870eeb4a1
# ╠═12a07415-1077-4d6d-a414-897265ffe641
# ╟─8d10cf9f-424d-4a6b-b039-c65ce4e9160f
# ╠═2b62cfeb-0117-4710-9641-bf9e4c52d6b7
# ╟─bd1ec1d2-a5ab-4000-a111-273f82f22f24
# ╟─5acf6f98-6dd8-4255-8a87-a96420aceb6f
# ╟─c2e708fd-57d9-4059-a126-d094a205bffd
# ╟─4109af60-6178-4148-8efe-890245077188
# ╠═3a6c700f-148b-4fff-aa3e-7d20f3bc714a
# ╠═c582f490-048b-4ecc-b3fe-918d623eaeae
# ╠═09d8edd6-9d23-4af9-b8eb-3ded6c961621
# ╠═d93094ca-4912-406a-a573-83887ec40848
# ╠═38851f55-d1af-40f7-a660-62bceec4093a
# ╠═eaf75283-c222-46ef-a5ef-9bf9a6a94b75
# ╠═a4f98b1b-cbb9-4dab-9e84-eba5fcd25c42
# ╠═3850481f-94b1-4e34-ac43-a346ec70b038
# ╟─291bfa24-a5f1-4505-83c1-b03f838b74de
# ╟─183d31a2-781a-4fb3-b6e8-c5f9f24ae8d8
# ╟─24236c6d-64cd-48be-bed8-8c149d1848a3
# ╟─f2956bed-9534-4c57-bfaa-fbef3c4af810
# ╟─2471cee6-6016-4067-81ec-42ed1a5969a4
# ╟─99a9f4f2-9920-42eb-b3a1-a93a3917c58a
# ╠═8458c44a-fa6a-47a6-aa40-5c058ea1adca
# ╟─4d0908c7-97e1-40b2-b5e4-94e674dca992
# ╠═2b30d104-5649-4ff4-87ad-8befc60b97b4
# ╟─f48c4024-f727-4916-a241-f78ae00ba840
# ╠═1fcc5b55-ec11-408b-913c-9e3117921372
# ╟─dd302ba2-66e7-4792-a39b-424f6fe0e065
# ╠═bfc230e5-72cc-4ec3-ad08-0d847664069d
# ╟─8b505a74-55ba-42c6-bd5a-e92ab73896ed
# ╠═474d1ca9-be98-490c-ae27-2eeb24ce0422
# ╟─f3ed22c3-6aae-4a10-b888-27ecd259bb01
# ╟─3cef878f-9c7c-4150-8277-79b6ca75ceb1
# ╟─7a75bae4-dc0a-4e73-942d-60475fa2ce51
# ╠═65f3959c-779f-4ac2-8ba0-2c008a532ce1
# ╠═563f3087-85fd-4998-93a5-0121019a5827
# ╟─3baa2ab2-3007-42c7-82fa-dbf59ac53d5b
# ╟─5d96001b-861a-47ec-bab3-242d1d7c5ce1
# ╟─839efccb-0a96-4cd1-b98f-981017eb2de2
# ╟─6460431a-c536-4a0b-8da5-c9e855bddd5a
# ╟─fbac12bb-3a2f-4767-ba4d-5786b2285a25
# ╠═ee99589f-9794-49e8-bccd-0a580f489860
# ╟─3af336b8-decb-4608-bdfe-5ba43e0e3b43
# ╟─e99f49c6-8ecf-4519-868d-5b76ee13e658
# ╠═7b2a274a-ee89-4bd7-a61a-eb9c97c7b548
# ╟─59988d03-8580-4597-81da-225379f0298f
# ╠═4852e7c0-6bdd-4f7e-8def-587db2fffd75
# ╠═cb87898f-2999-4d9c-aee1-dd4100c9eaac
# ╟─a0468b27-1df3-4661-baec-e7adb42f281e
# ╟─02738dfd-8dc3-4396-be73-6242df0f5234
# ╟─edbd2b1c-1452-41a6-962c-3434bd420020
# ╟─c7190cc0-08d8-45c8-b5de-e5630e0ff00e
# ╟─d9672a6f-97af-43d1-9a30-50495204fec8
# ╟─37e34e48-c2a7-4ffd-ac97-1a6ecb44ea92
# ╟─1bf47443-0ee4-482a-b637-8081620c144b
# ╟─756b03e3-f745-48f6-bf5b-7c0f0d5d7c2f
# ╟─00000000-0000-0000-0000-000000000001
# ╟─00000000-0000-0000-0000-000000000002
