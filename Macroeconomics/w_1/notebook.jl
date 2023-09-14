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
#### Bold and Italics
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
paty = (fiona * mary , fiona^2 , fiona*mary , 10*fiona)

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
	function king_julien!(F, v)
		
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
	my_solution = nlsolve(king_julien!, [0.0 ; 0.0 ; 0.0])		# provides the solution
	my_solution.zero   		 									# simplifies (rounds up) the solution
end

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
# ╟─564ff460-aa1f-4b9d-abf3-a024a13d96a3
# ╟─6307472b-3a3e-4d9a-82fd-25d295abaae1
# ╟─638ac59a-6fb2-447f-8856-0c6f74494e7b
# ╟─98f18fc3-0748-4ec7-a6a0-955e2ea22e19
# ╟─e81d6184-2b39-4205-83a8-9e2d7e5d41dd
# ╟─70af87bd-81b5-4aa0-b1f7-0639d1f09d0a
# ╟─2da4b605-2d9e-494a-810f-5d153dee7096
# ╟─8c3253f4-86c2-4b88-9850-f7daed87774d
# ╟─40139e5d-3069-4a48-ab37-48849eac8ec6
# ╟─939053b1-5c6b-4246-9102-d845e37c70a0
# ╟─a1e2ea1a-8ffb-49e8-a22e-8be913a5074f
# ╟─cab5fa24-d103-4ce6-b979-80901b9a01a0
# ╟─f6162891-de97-4522-a919-4942158cb2a0
# ╟─b3c16511-06d5-476d-b1ce-b8b35d038819
# ╟─dca08890-c8af-4a31-b7cd-bf27e9bd91b7
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
# ╟─96c4c032-7444-496d-98df-88b297b02930
# ╟─05377a5f-a2d8-49a9-a1db-d34165539350
# ╟─f3d1f71c-5108-4394-a98d-dc670f1091ae
# ╟─6db02201-bbe3-4ca8-a36b-7a5ac9e6385e
# ╟─88302f04-9d37-4435-859b-5ce58c510c21
# ╟─07919360-2d5b-43f4-ad37-303447e97fff
# ╟─dd818b37-14bc-4864-b781-f4fe5f284f5e
# ╟─89024599-24b2-4a2f-bc2e-2390a240ef73
# ╟─75334264-9046-40aa-8976-c51a184c7f20
# ╟─90dee13e-ae43-41c9-8b2f-477a99b8970c
# ╠═87c3c15c-eaff-4ecf-9e22-5153f82105b8
# ╟─f79c7ca4-2d33-4cb6-80d6-769fc35a786e
# ╟─95c1b74f-8455-4b29-8d5a-10caeb08eac0
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
# ╟─563f3087-85fd-4998-93a5-0121019a5827
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
# ╟─a0468b27-1df3-4661-baec-e7adb42f281e
# ╟─02738dfd-8dc3-4396-be73-6242df0f5234
# ╟─edbd2b1c-1452-41a6-962c-3434bd420020
# ╟─c7190cc0-08d8-45c8-b5de-e5630e0ff00e
# ╟─d9672a6f-97af-43d1-9a30-50495204fec8
# ╟─37e34e48-c2a7-4ffd-ac97-1a6ecb44ea92
# ╟─1bf47443-0ee4-482a-b637-8081620c144b
# ╟─756b03e3-f745-48f6-bf5b-7c0f0d5d7c2f
