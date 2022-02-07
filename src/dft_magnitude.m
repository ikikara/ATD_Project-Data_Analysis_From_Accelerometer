function X = dft_magnitude(x)
X = abs(fftshift(fft(x)));
end