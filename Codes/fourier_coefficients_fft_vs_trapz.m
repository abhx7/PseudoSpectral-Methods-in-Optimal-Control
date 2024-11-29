% Number of sample points
N = 20;
% Time vector
T = 2*pi;  % Total time period
x = linspace(0, T, N);  % N points in [0, 2*pi]

% Define the original function: sin(x)
func = sin(x);

% Perform FFT
F = fft(func);

% Normalize FFT coefficients and modify for proper scaling
F_mag = abs(F/N);  % Normalize by N to get proper magnitude
F_phase = angle(F);  % Get phase

% To obtain the Fourier series coefficients from FFT
a0_fft = F_mag(1);  % The DC term (k=0)

% Now get a_k and b_k from FFT results
n = N/2;  % Number of Fourier terms to consider

a_k_fft = 2*real(F(2:n+1))/N;  % Cosine coefficients from FFT (real part)
b_k_fft = -2*imag(F(2:n+1))/N; % Sine coefficients from FFT (negative of imaginary part)

% Manually calculate a_k and b_k using numerical integration (trapz)
a_k_trapz = zeros(1, n);
b_k_trapz = zeros(1, n);

for k = 1:n
    a_k_trapz(k) = (2/T) * trapz(x, func .* cos(k*x));  % Cosine coefficients
    b_k_trapz(k) = (2/T) * trapz(x, func .* sin(k*x));  % Sine coefficients
end

% Calculate a0 (the DC component) using trapz
a0_trapz = (2/T) * trapz(x, func);


% Reconstruct the function from both FFT and trapz coefficients
f_fft = a0_fft / 2 * ones(1, length(x));  % Initialize with the DC term
f_trapz = a0_trapz / 2 * ones(1, length(x));  % Initialize with the DC term

% Add terms to the reconstruction
for k = 1:n
    f_fft = f_fft + a_k_fft(k) * cos(k*x) + b_k_fft(k) * sin(k*x);
    f_trapz = f_trapz + a_k_trapz(k) * cos(k*x) + b_k_trapz(k) * sin(k*x);
end

% Now interpolate the function using piecewise linear interpolation
Ni = 10; % for interecpt1
x_interp = linspace(0, T, Ni);  % More points for smoothness
func_interp = interp1(x, func, x_interp, 'linear');

% Plot original function and reconstructed functions
figure;
subplot(2,1,1);
plot(x, func, 'r-', 'LineWidth', 2); hold on;
plot(x, f_fft, 'b--', 'LineWidth', 2);  % FFT-based reconstruction
plot(x, f_trapz, 'g:', 'LineWidth', 2);  % Trapz-based reconstruction
title('Function Reconstruction Comparison');
legend('Original', 'FFT Reconstruction', 'Trapz Reconstruction');
xlabel('x');
ylabel('f(x)');
grid on;

% Plot the interpolated piecewise linear function
subplot(2,1,2);
plot(x_interp, func_interp, 'k-', 'LineWidth', 2);
title('Piecewise Linear Interpolation');
xlabel('x');
ylabel('Interpolated f(x)');
grid on;

% Plot comparison of coefficients a_k and b_k from FFT and Trapz
figure;
subplot(2,1,1);
stem(0:n, [a0_fft, a_k_fft], 'b', 'LineWidth', 2); hold on;
stem(0:n, [a0_trapz, a_k_trapz], 'g--', 'LineWidth', 2);
title('Comparison of a_k Coefficients');
legend('FFT Coefficients', 'Trapz Coefficients');
xlabel('k');
ylabel('a_k');
grid on;

subplot(2,1,2);
stem(1:n, b_k_fft, 'b', 'LineWidth', 2); hold on;
stem(1:n, b_k_trapz, 'g--', 'LineWidth', 2);
title('Comparison of b_k Coefficients');
legend('FFT Coefficients', 'Trapz Coefficients');
xlabel('k');
ylabel('b_k');
grid on;