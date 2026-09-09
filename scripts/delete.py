# Second Order Butterworth Low Pass Filter

# Filter coefficients
b0 = 0.00094469
b1 = 0.00188938
b2 = 0.00094469

a1 = -1.911197
a2 = 0.914976

# Input samples
x = [12544, 12544]

# Initial previous values
x_1 = 0.0
x_2 = 0.0
y_1 = 0.0
y_2 = 0.0

# Calculate y[0]
y0 = b0 * x[0] + b1 * x_1 + b2 * x_2 - a1 * y_1 - a2 * y_2

# Update previous values
x_2 = x_1
x_1 = x[0]

y_2 = y_1
y_1 = y0

# Calculate y[1]
y1 = b0 * x[1] + b1 * x_1 + b2 * x_2 - a1 * y_1 - a2 * y_2

print("y[0] =", y0)
print("y[1] =", y1)
