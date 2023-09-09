# Parameters
s = 0.25     # Saving rate
n = 0.02     # Population growth rate
d = 0.03     # Depreciation rate
A = 1.0      # Total factor productivity
L = 100.0    # Initial labor force
global K = 200.0    # Initial capital stock (declare as global)
global Y = A * K^0.5 * L^0.5  # Initial total output (declare as global)

# Time parameters
t0 = 0.0
t_final = 50.0
Δt = 1.0

# Time loop
for t in t0:Δt:t_final
    dKdt = s * Y - (n + d) * K
    global K += dKdt * Δt  # Update K as a global variable
    global Y = A * K^0.5 * L^0.5  # Update Y as a global variable
    
    # Print results at specific time points
    if t % 10 == 0
        println("Time: $t, Output (Y): $Y, Capital (K): $K")
    end
end
