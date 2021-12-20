%% Código dos Efeitos - PDS - Daniel Abreu Macedo da Silva:
clear all;close all;clc
%% Carregar .wav gravado e ver o espectro do sinal:
%[x,fs] = audioread('Mkop.wav'); %% Carregando musica MK (mais curta)
% [x,fs] = audioread('uirapuruViolao.wav'); %% Carregando musica Uirapuru (mais longa)
[x,fs] = audioread('GuitarHeroW.wav');%% Carregando musica de Guitarra da internet
figure(1),
espectro(x,fs),grid on;legend('Sinal Original')
%% configuração das séries de tempo.
fa= 16000; %frequencia de amostragem
Ta=1/fa; %periodo de amostragem
t = [0:Ta:0.5]; %eixo do tempo, discretizado, total: 0.5 s
filterBWInHz=80; %em Hz
windowShiftInms=10; %deslocamento da janela em ms
thresholdIndB=120; %limiar, abaixo disso, nao mostra
figure(2)
ak_specgram(x,filterBWInHz,fa,windowShiftInms,thresholdIndB)
colorbar
figure(3)
title('Sinal Original');
plot(x),grid on;
%soundsc(x,fs) %% Tocar a música em si
%% Criação do menu para escolha do efeito
c=menu('tipo','Delay','Echo','Distorção','Flanger','Reverberação','Wah Wah');
%% Delay:
if(c == 1) 
d = 100000
xdelay = [zeros(d,1); x]; %% ver na workspace
figure(4)
espectro(xdelay,fs),grid on;legend('Sinal com Delay')
figure(5)
ak_specgram(xdelay,filterBWInHz,fa,windowShiftInms,thresholdIndB)
colorbar
figure(6)
title('Sinal Original e Sinal com Delay');
plot(x,'r')
hold
plot(xdelay,'b'),grid on, legend('Sinal Original','Sinal com Delay')
soundsc(xdelayzado,fs)
end
%% Echo:
if(c == 2) 
atraso = 10000;
z_eco=zeros(1,atraso);
x_deslocado=[z_eco x(1:end-atraso)'];
alpha_eco = 0.3; %atenuacao do eco
x_com_eco = x + alpha_eco * x_deslocado';
figure(7)
espectro(x_com_eco,fs),grid on;
figure(8)
ak_specgram(x_com_eco,filterBWInHz,fa,windowShiftInms,thresholdIndB)
colorbar
figure(9)
title('Sinal Original e Sinal com Echo');
plot(x,'r')
hold
plot(x_com_eco,'b'),grid on,legend('Sinal Original','Sinal com Echo')
soundsc(x_com_eco,fs)
end
%% Distorção:
if(c == 3) 
a=0.9;
kdist = 2*a/(1-a);
xdist = (1+kdist)*(x)./(1+kdist*abs(x));
figure(10)
espectro(xdist,fs),grid on;
figure(11)
ak_specgram(xdist,filterBWInHz,fa,windowShiftInms,thresholdIndB)
colorbar
figure(12)
title('Sinal Original e Sinal Distorcido');
plot(x,'r')
hold
plot(xdist,'b'),grid on, legend('Sinal Original','Sinal Distorcido')
soundsc(xdist,fs)
end
%% Flanger:
if(c == 4) 
% Parametros para variar o efeito
delayMinimo=0.010; % 10ms de delay minimo
delayMaximo=0.025; % 25ms de delay maximo
rate=0.1; %aumento do flange em Hz
index=1:length(x);
% senoide:
sin_ref = (sin(2*pi*index*(rate/fs)))';    % sin(2pi*fa/fs);
min_samp_delay=round(delayMinimo*fs); % amostrar o minimo de delays
max_samp_delay=round(delayMaximo*fs); % amostrar o maximo de delays
xflanger = zeros(length(x),1);       % vetor do som após o efieto
xflanger(1:max_samp_delay)=x(1:max_samp_delay); 
amp=0.7;
for i = (max_samp_delay+1):length(x)
    cur_sin=abs(sin_ref(i));    %modulo do valor do seno 0-1
    cur_delay=ceil(cur_sin*max_samp_delay);  % gerar o delay
    xflanger(i) = (amp*x(i)) + amp*(x(i-cur_delay));   % adicionar as amostras atrasadas
end
figure(13)
plot(x,'r')
hold
plot(xflanger,'b');legend('Sinal Original','Flanger')
title('Sinal Original e Flanger');
figure(14)
ak_specgram(xflanger,filterBWInHz,fa,windowShiftInms,thresholdIndB)
colorbar
soundsc(xflanger,fs)
figure(20),
espectro(xflanger,fs),grid on;legend('Sinal com Flanger')

end
%% Reverberação:
if(c==5)
R = 5000;
%Implementação da equação a diferenças do filtro: y[n]=x[n]+ax[n-R]
%Equivalente a função de transferência discreta H(z)=1+az^(-R)
num=[1,zeros(1,R-1),0.8];
den=[1];
%The output of the FIR filter is computed using the function 'filter'
x_reverb = filter(num,den,x);
soundsc(x_reverb,fs);
figure(20)
plot(x,'r')
hold
plot(x_reverb,'b');legend('Sinal Original','Reverberação')
title('Sinal Original e Reverberação');
figure(21)
ak_specgram(x_reverb,filterBWInHz,fa,windowShiftInms,thresholdIndB)
colorbar
figure(22),
espectro(x_reverb,fs),grid on;legend('Sinal com Reverberação')
end
if(c==6)
% Parametros do filtro:
M = 20;
damp = 0.001;
Fmin = 100;
Fmax = 10000;
Fw = 1000;
% Valor do incremento que será usado para indicar o fim entre o filtro passabanda
Finc = (Fmax-Fmin)/M;
% M é o número de filtros passabandas criados para o sistema
for i = 1:M
    % Saída do filtro 
    yb(:,i) = bandpass(x, fs, damp, Fmin, Fmin +Finc, Fw);
    Fmin = Fmin + Finc; % incrementa Fmin para o próximo filtro
end
x_wah = sum(yb,2);
max_y_out = max(abs(x_wah));
x_wah = x_wah./max_y_out;
sound(x_wah, fs);
figure(23)
plot(x,'r')
hold
plot(x_wah,'b');legend('Sinal Original','Wah Wah')
title('Sinal Original e Wah Wah');
figure(24)
ak_specgram(x_wah,filterBWInHz,fa,windowShiftInms,thresholdIndB)
colorbar
figure(22),
espectro(x_wah,fs),grid on;legend('Sinal com Wah Wah')
end