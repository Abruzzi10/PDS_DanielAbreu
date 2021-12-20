function espectro(x,fs)
% trecho 1 de sinal1
N = length(x);
ind = 1:N;
t = (ind-1)/fs;
x1 = x(ind);
X1 = abs(fft(x1));
% eixo da DFT em Hz
f = (0:N-1)/N*fs;
ind = 1:floor(N/2);
plot(f(ind), X1(ind)/N),
axis tight, grid
title('Espectro do Sinal'),
xlabel('f, Hz');
hold on;

% figure; plot(f(ind), X1(ind)/N);
